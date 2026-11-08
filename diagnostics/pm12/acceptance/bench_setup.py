"""Render a declarative bench diagram. Configuration never controls hardware."""
import argparse
from decimal import Decimal,InvalidOperation
import json
import math
from pathlib import Path
import string
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch,FancyArrowPatch

DEFAULT_CONFIG=Path(__file__).with_suffix('.json')


def load_config(path=None):
    """A small override can change parameters while retaining the reviewed layout."""
    fields={'schema','parameters','canvas','colors','title','nodes','links','annotations'}
    if path is None or Path(path).resolve()==DEFAULT_CONFIG.resolve():return json.loads(DEFAULT_CONFIG.read_text())
    override=json.loads(Path(path).read_text())
    if not isinstance(override,dict) or set(override)-fields:raise ValueError('Unknown diagram configuration keys')
    # Materialized report configurations must not depend on future defaults.
    if set(override)==fields:return override
    base=json.loads(DEFAULT_CONFIG.read_text())
    for key,value in override.items():
        if key in ('parameters','canvas','colors','title'):
            if not isinstance(value,dict):raise ValueError('Expected object for '+key)
            base[key].update(value)
        else:base[key]=value
    return base


def parameters(config):
    values=dict(config['parameters'])
    try:
        reference=Decimal(str(values['lhc_mhz']))
        multiplier=values['multiplier']
        if not reference.is_finite() or reference<=0 or type(multiplier) is not int or multiplier<1:
            raise ValueError('Positive reference and integer multiplier required')
    except (KeyError,InvalidOperation) as e:raise ValueError('Invalid clock parameters') from e
    values['lhc_mhz']=format(reference,'f')
    values['kasli_mhz']=format(reference*multiplier,'f')
    return values


def label(text,values):
    for _,field,_,_ in string.Formatter().parse(text):
        if field is not None and field not in values:raise ValueError('Unknown diagram parameter: '+field)
    return text.format_map(values)


def resolve(config):
    if config.get('schema')!=1:raise ValueError('Unsupported diagram schema')
    values=parameters(config);nodes={}
    for n in config['nodes']:
        if n['id'] in nodes:raise ValueError('Duplicate node: '+n['id'])
        nodes[n['id']]=dict(n)
    positions={}
    def position(name,visiting=()):
        if name not in nodes:raise ValueError('Unknown node: '+name)
        if name in visiting:raise ValueError('Cyclic node containment')
        if name in positions:return positions[name]
        n=nodes[name];x,y=n['xy'];w,h=n['size']
        if not all(math.isfinite(v) for v in [x,y,w,h]) or min(w,h)<=0:raise ValueError('Invalid node geometry')
        if n.get('parent'):
            px,py=position(n['parent'],visiting+(name,));pw,ph=nodes[n['parent']]['size']
            if abs(x)+w/2>pw/2+1e-9 or abs(y)+h/2>ph/2+1e-9:raise ValueError('Child outside parent: '+name)
            x+=px;y+=py
        positions[name]=(x,y);return x,y
    for name in nodes:position(name)
    def endpoint(spec):
        x,y=position(spec['node']);w,h=nodes[spec['node']]['size']
        if 'at' in spec:
            dx,dy=spec['at'];return x+dx,y+dy
        side=spec['side'];offset=spec.get('offset',0)
        if side not in ('left','right','top','bottom'):raise ValueError('Unknown anchor side')
        if abs(offset)>(h/2 if side in ('left','right') else w/2)+1e-9:raise ValueError('Anchor outside node')
        return {'left':(x-w/2,y+offset),'right':(x+w/2,y+offset),'top':(x+offset,y+h/2),'bottom':(x+offset,y-h/2)}[side]
    links=[]
    for link in config['links']:
        if link['kind'] not in config['colors']:raise ValueError('Unknown cable kind')
        if link.get('direction','both') not in ('both','forward','none'):raise ValueError('Invalid direction')
        points=[endpoint(link['start']),*link.get('via',[]),endpoint(link['end'])]
        if any(not all(math.isfinite(v) for v in pt) for pt in points):raise ValueError('Nonfinite cable geometry')
        if any(tuple(a)==tuple(b) for a,b in zip(points,points[1:])):raise ValueError('Zero-length cable segment')
        links.append(dict(link,points=points))
        if 'label' in link:label(link['label'],values)
    for n in nodes.values():label(n['label'],values)
    for a in config['annotations']:
        label(a['text'],values)
        if a.get('parent') and a['parent'] not in nodes:raise ValueError('Unknown annotation parent')
    label(config['title']['text'],values)
    return values,nodes,positions,links


def wiring(out,config_path=None):
    out=Path(out);config=load_config(config_path)
    values,nodes,positions,links=resolve(config)
    canvas=config['canvas'];colors=config['colors']
    fig,ax=plt.subplots(figsize=canvas['size']);fig.subplots_adjust(left=.025,right=.985,top=.91,bottom=.045)
    ax.set(xlim=canvas['xlim'],ylim=canvas['ylim']);ax.axis('off')
    try:
        for name,n in nodes.items():
            x,y=positions[name];w,h=n['size']
            ax.add_patch(FancyBboxPatch((x-w/2,y-h/2),w,h,boxstyle='round,pad=.06,rounding_size=.12',facecolor=n['color'],edgecolor='#34516c',lw=1.5,zorder=4))
            ax.text(x,y,label(n['label'],values),ha='center',va='center',fontsize=18,fontweight='bold',zorder=5)
        for link in links:
            color=colors[link['kind']];points=link['points'];layer=link.get('layer',2)
            for a,b in zip(points,points[1:]):ax.plot([a[0],b[0]],[a[1],b[1]],color=color,lw=2,zorder=layer)
            def head(point,near):
                dx,dy=near[0]-point[0],near[1]-point[1];scale=min(.18,math.hypot(dx,dy))/math.hypot(dx,dy)
                ax.add_patch(FancyArrowPatch((point[0]+dx*scale,point[1]+dy*scale),point,arrowstyle='-|>',mutation_scale=13,color=color,lw=2,zorder=layer+1))
            if link.get('direction','both')!='none':head(points[-1],points[-2])
            if link.get('direction','both')=='both':head(points[0],points[1])
            if link.get('label'):
                xy=link.get('label_xy',[(points[0][i]+points[-1][i])/2 for i in (0,1)])
                ax.text(*xy,label(link['label'],values),color=color,ha='center',va='center',fontsize=14,bbox=dict(facecolor='white',edgecolor='none',pad=2),zorder=6)
        for a in config['annotations']:
            opts={k:v for k,v in a.items() if k not in ('xy','text','parent','coordinates')}
            if str(opts.get('color','')).startswith('@'):opts['color']=colors[opts['color'][1:]]
            x,y=a['xy']
            if a.get('parent'):px,py=positions[a['parent']];x+=px;y+=py
            target=fig.text if a.get('coordinates')=='figure' else ax.text
            target(x,y,label(a['text'],values),**opts)
        title=dict(config['title']);title['text']=label(title['text'],values)
        fig.suptitle(title.pop('text'),**title)
        for ext in ['png','pdf','svg']:fig.savefig(out/('bench.'+ext),dpi=170)
        svg=out/'bench.svg';svg.write_text('\n'.join(line.rstrip() for line in svg.read_text().splitlines())+'\n')
        (out/'bench-configuration.json').write_text(json.dumps(config,indent=2,ensure_ascii=False)+'\n')
        (out/'bench-parameters.json').write_text(json.dumps(values,indent=2,ensure_ascii=False)+'\n')
    finally:plt.close(fig)
    return values


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);p.add_argument('--config',type=Path,default=DEFAULT_CONFIG);a=p.parse_args()
    # Reject invalid configuration before creating output artifacts.
    resolve(load_config(a.config))
    a.out.mkdir(parents=True,exist_ok=False);wiring(a.out,a.config)

"""User-reviewed PM12 bench wiring, rendered as editable vector graphics."""
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch,FancyArrowPatch


def wiring(out):
    out=Path(out)
    fig,ax=plt.subplots(figsize=(16,9));fig.subplots_adjust(left=.025,right=.985,top=.91,bottom=.045)
    ax.set(xlim=(-.8,15.3),ylim=(-2.1,7.3));ax.axis('off')
    colors=dict(analog='#c46a14',lvds='#17679c',clock='#8849a4',sfp='#2b8261',control='#6e7782')
    boxes={}
    def box(key,label,x,y,w=2.2,h=1,color='#eaf1f8'):
     p=FancyBboxPatch((x-w/2,y-h/2),w,h,boxstyle='round,pad=.06,rounding_size=.12',facecolor=color,edgecolor='#34516c',lw=1.5,zorder=4)
     ax.add_patch(p);ax.text(x,y,label,ha='center',va='center',fontsize=18,fontweight='bold',zorder=5);boxes[key]=(x,y,w,h)
    def link(points,kind,label=None,labelxy=None,bidir=True):
     color=colors[kind]
     for a,b in zip(points,points[1:]):ax.plot([a[0],b[0]],[a[1],b[1]],color=color,lw=2,zorder=2)
     # Heads at endpoints, following the local cable direction.
     def head(endpoint,near):
      dx,dy=near[0]-endpoint[0],near[1]-endpoint[1];scale=.18/(dx*dx+dy*dy)**.5
      ax.add_patch(FancyArrowPatch((endpoint[0]+dx*scale,endpoint[1]+dy*scale),endpoint,arrowstyle='-|>',mutation_scale=13,color=color,lw=2,zorder=3))
     head(points[-1],points[-2])
     if bidir:head(points[0],points[1])
     if label:ax.text(*labelxy,label,color=color,ha='center',va='center',fontsize=14,bbox=dict(facecolor='white',edgecolor='none',pad=2),zorder=6)
    box('dac','MOD-DAC-28',1.5,6,color='#fff1de')
    box('cfd','CFD_SIM',3.9,6,color='#fff1de')
    box('dio7','DIO-LVDS\nslot 7',8.3,6,w=2,color='#e5f2ff')
    box('pm','PM12',3.9,2.8,color='#eef1f5')
    box('adapter','LVDS–HDMI\nadapter',7,2.8,w=2,color='#e5f2ff')
    box('dio6','DIO-LVDS\nslot 6',9.7,2.8,w=1.8,color='#e5f2ff')
    box('kasli','Kasli-DIOT\n\nDIOT\nbackplane',12.7,4.5,w=2.8,h=4.4,color='#e5f2ff')
    # Both clock outputs belong to one physical generator.
    box('clock','',8.3,.55,w=5.1,h=1.2,color='#f3eafa')
    ax.text(7.3,.72,'LHC generator',ha='center',va='center',fontsize=18,fontweight='bold',zorder=5)
    ax.text(7.3,.30,'40.0787 MHz',ha='center',va='center',fontsize=14,zorder=5)
    box('x3','×3',10,.55,w=.85,h=.65,color='#eadcf4')
    ax.text(10,.08,'internal',ha='center',va='center',fontsize=11,color=colors['clock'],zorder=5)
    ax.add_patch(FancyArrowPatch((8.8,.55),(9.53,.55),arrowstyle='-|>',mutation_scale=13,color=colors['clock'],lw=2,zorder=5))
    ax.plot([10.425,10.85],[.55,.55],color=colors['clock'],lw=2,zorder=5)
    box('host','Test-bench\ncontroller',1.5,-1.5,w=2.4,color='#f0f1f3')
    link([(2.6,6),(2.8,6)],'analog',bidir=False)
    ax.text(2.7,6.82,'USB: analog DAC outputs',ha='center',fontsize=14,color=colors['analog'])
    link([(3.9,5.5),(3.9,3.3)],'analog','Daughtercard\non channel under test',(3.9,4.4))
    link([(5,6),(7.3,6)],'lvds','RJ45\nCFD pulses /\ngate strobes',(6.15,6.15))
    link([(9.3,6),(11.3,6)],'lvds','DIOT backplane',(10.3,6.35))
    link([(5,2.8),(6,2.8)],'lvds','HDMI',(5.5,3.55))
    link([(8,2.8),(8.8,2.8)],'lvds','2 × RJ45',(8.4,3.55))
    link([(10.6,2.8),(11.3,2.8)],'lvds')
    link([(7,1.15),(7,2.3)],'clock','LHC clock',(7,1.65),bidir=False)
    link([(10.85,.55),(12.1,.55),(12.1,2.3)],'clock','120.2361 MHz',(12.1,1.35),bidir=False)
    link([(3.9,2.3),(3.9,-.55),(13.6,-.55),(13.6,2.3)],'sfp','PM ↔ Kasli private link: SFP1',(8.6,-.33))
    link([(.3,-1.5),(-.1,-1.5),(-.1,6),(.4,6)],'control')
    ax.text(-.42,2.2,'Ethernet / SCPI',rotation=90,ha='center',va='center',fontsize=14,color=colors['control'])
    link([(2.7,-1.5),(14.8,-1.5),(14.8,4.5),(14.1,4.5)],'control','Ethernet / IPbus: SFP0 control, SFP2 PM bridge',(8.6,-1.3))
    fig.suptitle('FIT PM12 — test-bench connections',fontsize=24,fontweight='bold',color='#173b62',y=.98)
    fig.text(.5,.92,'Both clock outputs come from the LHC generator; ×3 multiplication is internal.',ha='center',fontsize=14,color='#34516c')
    fig.text(.5,.015,'Main measurement paths and Ethernet control. UART/JTAG service cables and the DMM are omitted for clarity.',ha='center',fontsize=11,color='#5c6570')
    for ext in ['png','pdf','svg']:fig.savefig(out/('bench.'+ext),dpi=170)
    svg=out/'bench.svg'
    svg.write_text('\n'.join(line.rstrip() for line in svg.read_text().splitlines())+'\n')
    plt.close(fig)


if __name__=='__main__':
    import argparse
    p=argparse.ArgumentParser();p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    a.out.mkdir(parents=True,exist_ok=False);wiring(a.out)

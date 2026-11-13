#!/usr/bin/env python3
"""Editable twelve-channel campaign report from sealed evidence; offline only."""
import argparse
from collections import defaultdict
import json
from pathlib import Path
import shutil
import subprocess
from campaign import Campaign, read, write, inventory, digest


def tex(value):
    substitutions={'\\':r'\textbackslash{}','_':r'\_','%':r'\%','&':r'\&','#':r'\#','$':r'\$','{':r'\{','}':r'\}'}
    output=[];run=0
    for c in str(value):
        output.append(substitutions.get(c,c))
        run=run+1 if c.isalnum() else 0
        if c in '_/-,' or run>=6:
            output.append(r'\allowbreak{}');run=0
    return ''.join(output)


def table(headers, rows):
    width=.86/len(headers)
    spec=''.join(r'>{\raggedright\arraybackslash}p{'+f'{width:.4f}'+r'\linewidth}' for _ in headers)
    text='\\begingroup\\setlength{\\tabcolsep}{3pt}\\begin{longtable}{'+spec+'}\\toprule\n'
    text+=' & '.join(tex(h) for h in headers)+r'\\\midrule\endhead'+'\n'
    for row in rows:text+=' & '.join(tex(v) for v in row)+r'\\'+'\n'
    return text+r'\bottomrule\end{longtable}\endgroup'+'\n'


def generate(root, output, latex=None):
    root=Path(root).resolve();output=Path(output).resolve()
    if output.is_relative_to(root):
        raise ValueError('Report must be outside the live campaign directory')
    output.mkdir(parents=True,exist_ok=False)
    c=Campaign(root)
    with c.locked():
        snap=output/'inputs';snap.mkdir()
        for name in ['campaign.json','protocol.json']:
            shutil.copy2(root/name,snap/name)
        if (root/'batches').exists():shutil.copytree(root/'batches',snap/'batches')
    summary=Campaign(snap).summary()
    protocol=read(snap/'protocol.json')
    write(output/'coverage.json',{k:v for k,v in summary.items() if k!='records'})
    (output/'figures').mkdir()
    text=r'\section{Scope and recorded coverage}'+'\n'
    text+='Board '+tex(summary['board_uid'])+'. Campaign '+tex(summary['campaign_id'])+'.\n\n'
    text+='Recorded status: '+tex(summary['status'])+'. Missing tests are NOT MEASURED. '
    text+='Complete selected-protocol coverage is not a calibrated whole-board release.\n\n'
    channel_tests=[t for t in protocol['tests'] if t['scope']=='channel']
    lookup={(r['test'],r['channel']):r['status'] for r in summary['cases']}
    short={'NOT_MEASURED':'NM','INCOMPLETE':'INC','ERROR':'ERR','PASS':'PASS','FAIL':'FAIL'}
    text+=table(['Channel']+[t['id'] for t in channel_tests],
                [[ch]+[short[lookup[t['id'],ch]] for t in channel_tests] for ch in range(1,13)])
    text+='NM = not measured; INC = incomplete; ERR = acquisition error. No missing series is invented.\n'
    text+=r'\subsection{Board-level tests}'+'\n'
    text+=table(['Test','Status'],[(t['title'],lookup[t['id'],None]) for t in protocol['tests'] if t['scope']=='board'])
    text+=r'\section{Fitted batches and fixture provenance}'+'\n'
    rows=[]
    for b in summary['batches']:
        batch=read(snap/b['path']/'batch.json')
        fitting=snap/b['path']/'fitting.json'
        for channel,fixture in batch['assignments'].items():
            route=batch['connections'][channel]
            rows.append([b['id'],channel,fixture,f"slot {route['slot']}, RJ45 {route['rj45_port']}",'Identity/fitting confirmed' if fitting.exists() else 'NOT CONFIRMED'])
    text+=table(['Batch attempt','PM channel','CFD label','Declared connection','Fitting'],rows) if rows else 'No fitted group has been declared yet.\n\n'
    text+='Fixture labels CFD01--CFD04 are provisional bench labels. Factory identities and photos remain unknown until supplied; a label is not proof of module identity. Declared cable routes must be checked physically.\n\n'
    text+='Raw inputs and selected result IDs are retained in inputs/. Repeated measurements are never silently substituted.\n'
    metrics=[];curves=defaultdict(list);scalars=defaultdict(list)
    for record in summary['records'].values():
        result=record['result'];channel=result.get('channel')
        # Failures stay in coverage and raw data, never in the successful overlay.
        if result['status']!='PASS':continue
        for m in result.get('metrics',[]):
            metrics.append((result['test'],channel or 'board',m.get('bank',''),m['name'],m['value'],m['unit']))
            scalars[(result['test'],m['name'],m.get('bank',''),m['unit'])].append((channel,m['value']))
        for curve in result.get('curves',[]):
            curves[(result['test'],curve['name'],curve.get('bank',''),curve['x_unit'],curve['y_unit'])].append((channel,curve))
    text+=r'\section{Retained attempts and explicit selection}'+'\n'
    registry=read(snap/'campaign.json');attempts=[]
    for entry in registry['results']:
        record=read(snap/entry['path']/'record.json');result=record['result']
        attempts.append((entry['id'][:15],result['test'],result.get('channel') or 'board',record['batch_id'],result['status'],'yes' if registry['selected'].get(entry['case'])==entry['id'] else 'no'))
    text+=table(['Result ID prefix','Test','Channel','Fitting','Status','Selected'],attempts) if attempts else 'No tests have been recorded yet.\n\n'
    text+='All attempts, including failures and rejected repeats, remain in the archived inputs. The coverage matrix uses only the explicitly selected attempt.\n'
    photos=set();(output/'photos').mkdir()
    for record in summary['records'].values():
        entry=next(r for r in registry['results'] if r['id']==record['id'])
        raw=snap/entry['path']/'raw'
        for name in record['result'].get('photos',[]):
            photo=raw/name;checksum=digest(photo)
            if checksum in photos:continue
            photos.add(checksum);target=output/'photos'/(checksum[:16]+photo.suffix.lower());shutil.copy2(photo,target)
            text+=r'\begin{center}\includegraphics[width=.7\textwidth]{photos/'+target.name+r'}\end{center}'+'\n'
            text+=tex('Photograph: '+name+'; test '+record['result']['test']+'; channel '+str(record['result'].get('channel','board')))+'.\n'
    text+=r'\section{Selected measurement conditions and limits}'+'\n'
    conditions=[];limits=set();methods={}
    for record in summary['records'].values():
        result=record['result']
        conditions.append([result['test'],result.get('channel','board'),json.dumps(result.get('connections',{}),sort_keys=True)])
        if result.get('limits'):limits.add(str(result['limits']))
        methods[result['test']]=result.get('protocol',{})
    if conditions:text+=table(['Test','Physical channel','Confirmed stimulus connection'],conditions)
    hardware={json.dumps(settings.get('hardware_configuration',{}),sort_keys=True) for settings in methods.values()}
    def flatten(value,prefix=''):
        rows=[]
        for key,item in value.items():
            name=prefix+key
            if isinstance(item,dict):rows.extend(flatten(item,name+'.'))
            else:rows.append((name,str(item)))
        return rows
    if len(hardware)==1:
        text+=r'\subsection{Common hardware configuration}'+'\n'
        text+=table(['Setting','Recorded value'],flatten(json.loads(next(iter(hardware)))))
    for method,settings in sorted(methods.items()):
        text+=r'\subsection{'+tex(method)+r'}'+'\n'
        text+=table(['Setting','Recorded value'],[(key,json.dumps(value,sort_keys=True)) for key,value in settings.items() if key!='hardware_configuration' or len(hardware)!=1])
    for limit in sorted(limits):text+=tex(limit)+'.\n\n'
    for record in summary['records'].values():
        result=record['result']
        for note in result.get('notes',[]):
            text+=tex(str(result['test'])+'; physical channel '+str(result.get('channel','board'))+': '+note)+'.\n\n'
    text+='ADC total RMS includes the complete connected chain and periodic gate feedthrough. The four-phase-removed RMS removes the mean of each sample phase; it is a residual statistic, not an intrinsic ADC noise specification. FFT and time axes use the declared clock frequency, not an independent frequency measurement.\n\n'
    text+=r'\section{Measurements and common channel plots}'+'\n'
    if metrics:text+=table(['Test','Channel','Bank','Observable','Value','Unit'],metrics)
    if not metrics and not curves:text+='No live channel data have been imported. This is a coverage scaffold, not a measured report.\n'
    if curves or scalars:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt
        figure_index=0
        for key,series in curves.items():
            test,name,bank,xunit,yunit=key
            fig,ax=plt.subplots(figsize=(10,5),layout='constrained')
            for ch,curve in sorted(series,key=lambda pair:pair[0] or 0):
                ax.plot(curve['x'],curve['y'],'.-',ms=2,label=f'Channel {ch:02d}' if ch else 'Board',color=plt.get_cmap('tab20')((ch or 1)-1))
            ax.set(title=f'{test}: {name} {bank}',xlabel=xunit,ylabel=yunit);ax.grid(alpha=.3);ax.legend(ncol=3)
            stem=f'figure-{figure_index:03d}';figure_index+=1
            for ext in ['png','pdf']:fig.savefig(output/'figures'/f'{stem}.{ext}',dpi=160)
            plt.close(fig);text+=r'\begin{center}\includegraphics[width=\textwidth]{figures/'+stem+r'.pdf}\end{center}'+'\n'
        for key,series in scalars.items():
            test,name,bank,unit=key;series=[(ch,v) for ch,v in series if ch is not None]
            if not series:continue
            series.sort();fig,ax=plt.subplots(figsize=(10,4),layout='constrained')
            ax.plot([ch for ch,v in series],[v for ch,v in series],'o');ax.set_xticks(range(1,13));ax.set(xlim=(.5,12.5),title=f'{test}: {name} {bank}',xlabel='Physical PM channel',ylabel=unit);ax.grid(alpha=.3)
            stem=f'figure-{figure_index:03d}';figure_index+=1
            for ext in ['png','pdf']:fig.savefig(output/'figures'/f'{stem}.{ext}',dpi=160)
            plt.close(fig);text+=r'\begin{center}\includegraphics[width=\textwidth]{figures/'+stem+r'.pdf}\end{center}'+'\n'
    (output/'content.tex').write_text(text)
    shutil.copy2(Path(__file__).parent/'templates/campaign.tex',output/'report.tex')
    if latex:
        with (output/'latex-build.txt').open('w') as log:
            subprocess.run([str(latex),'--outdir',str(output),str(output/'report.tex')],stdout=log,stderr=subprocess.STDOUT,check=True)
    write(output/'files.sha256.json',inventory(output))
    return summary


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,required=True);p.add_argument('--out',type=Path,required=True);p.add_argument('--latex',type=Path);a=p.parse_args()
    s=generate(a.root,a.out,a.latex);print(s['board_uid'],s['status'],a.out/'report.tex')
if __name__=='__main__':main()

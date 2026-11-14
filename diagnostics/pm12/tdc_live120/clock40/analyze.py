#!/usr/bin/env python3
"""Independently verify raw clock40 captures and plot English phase responses."""
import argparse,json,math,struct,csv
from pathlib import Path
from collections import Counter

def circular(hist,mod):
 n=sum(hist.values());a=sum(v*math.cos(k*2*math.pi/mod) for k,v in hist.items());b=sum(v*math.sin(k*2*math.pi/mod) for k,v in hist.items());m=math.atan2(b,a)*mod/(2*math.pi)%mod
 return m,math.sqrt(sum(v*((k-m+mod/2)%mod-mod/2)**2 for k,v in hist.items())/n)
def unwrap(values,mod):
 out=[]
 for v in values:out.append(v if not out else out[-1]+(v-out[-1]+mod/2)%mod-mod/2)
 return [v-out[0] for v in out]
def fit(xs,ys):
 xm=sum(xs)/len(xs);ym=sum(ys)/len(ys);m=sum((x-xm)*(y-ym) for x,y in zip(xs,ys))/sum((x-xm)**2 for x in xs);b=ym-m*xm
 return m,max(abs(y-(m*x+b)) for x,y in zip(xs,ys))
def load_words(base,row,ch):
 b=(base/row['label']/f'tdc{ch:02d}.bin').read_bytes();assert len(b)%2==0
 return list(struct.unpack('<%dH'%(len(b)//2),b))
def curves(path,legacy=False):
 r=json.loads(path.read_text());base=path.parent;result={}
 for ch in [9,10,11,12]:
  points=sorted([x for x in r['statistics'] if x['channel']==ch],key=lambda x:x['phase_bin']);assert len(points)==25
  raw=[load_words(base,row,ch) for row in points];assert all(len(w)==128 and all(v<8192 for v in w) for w in raw)
  occupied=sorted(set(w>>7 for words in raw for w in words));_,cut=max((b-a if b>a else b+64-a,b) for a,b in zip(occupied,occupied[1:]+occupied[:1]));span=max((x-cut)%64 for x in occupied)
  fine=[circular(Counter(w&127 for w in words),128) for words in raw];coarse=[]
  for words in raw:
   h=Counter(((w>>7)-cut)%64%10 for w in words);coarse.append(circular(h,10))
  fx=unwrap([x[0] for x in fine],128);cx=unwrap([x[0] for x in coarse],10);x=[p['phase_bin']-24 for p in points];ns=[v/(40.0787e6*24)*1e9 for v in x];fm,fr=fit(ns,fx);cm,cr=fit(x,cx)
  if not legacy:assert abs(cm-1.25)<.15 and cr<1.5 and max(x[1] for x in fine)<8 and abs(fm)>10,(ch,cm,cr,fm)
  result[ch]={'points':points,'delay_ns':ns,'fine_relative':fx,'coarse_fold10_relative':cx,'fine':fine,'coarse_fold10':coarse,'coarse_cut':cut,'coarse_raw_span':span,'fine_slope_codes_per_ns':fm,'fine_max_fit_residual':fr,'coarse_slope_codes_per_phase_bin':cm,'coarse_max_fit_residual':cr,'max_fine_std':max(x[1] for x in fine)}
 return result

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--status',type=Path,required=True);p.add_argument('--legacy',type=Path);p.add_argument('--out',type=Path,required=True);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=True);r=json.loads(a.status.read_text());assert r['pass'];events=0;quiet=0;lastgen=None
 for row in r['captures']:
  expected=[0]*12;ch=row['expected_channel'];count=0 if ch is None else (128 if 'phase' in row['label'] else (16 if 'discover' in row['label'] else int(row['label'].split('count')[1])))
  if ch is not None:expected[ch-1]=count;assert row['tx']['repetitions']==count
  else:quiet+=1
  actual=[]
  for channel in range(1,13):
   words=load_words(a.status.parent,row,channel);assert all(w<8192 for w in words);actual.append(len(words))
  assert actual==row['counts']==expected
  if lastgen is not None:assert row['generation']==(lastgen+1)&0xffffffff
  lastgen=row['generation'];events+=sum(actual)
 assert len(r['captures'])==128 and events==19268 and quiet==8
 new=curves(a.status);old=curves(a.legacy,True) if a.legacy else {}
 summary={'pass':True,'captures':128,'total_events':events,'phase_events':12800,'quiet_windows':quiet,'channels':{},'coarse_normalization':'Raw6-bit coarse codes are unwrapped across the largest empty arc, then folded modulo10 (one Kasli word at4*300.59025MHz). This removes whole-word/LHC-slot start branches; it is not absolute LHC trigger alignment.'}
 with (a.out/'phase.csv').open('w',newline='') as f:
  w=csv.writer(f,lineterminator="\n");w.writerow(['channel','phase_bin','programmed_delay_ns','fine_mean_mod128','fine_std','fine_relative_unwrapped','coarse_mean_fold10','coarse_relative_unwrapped','coarse_cut'])
  for ch,row in new.items():
   summary['channels'][ch]={k:v for k,v in row.items() if k not in ['points','delay_ns','fine_relative','coarse_fold10_relative','fine','coarse_fold10']};summary['channels'][ch]['pass']=True
   for i,point in enumerate(row['points']):w.writerow([ch,point['phase_bin'],row['delay_ns'][i],*row['fine'][i],row['fine_relative'][i],row['coarse_fold10'][i][0],row['coarse_fold10_relative'][i],row['coarse_cut']])
 (a.out/'validation.json').write_text(json.dumps(summary,indent=2)+'\n')
 import matplotlib
 matplotlib.use('Agg')
 import matplotlib.pyplot as plt
 from matplotlib.lines import Line2D
 fig,ax=plt.subplots(2,1,figsize=(10,8),layout='constrained');colors=['#1971c2','#e67700','#2b8a3e','#9c36b5']
 for color,ch in zip(colors,[9,10,11,12]):
  row=new[ch];ax[0].plot(row['delay_ns'],row['fine_relative'],'o-',ms=3,color=color,label=f'PM {ch}')
  if ch in old:ax[0].plot(old[ch]['delay_ns'],old[ch]['fine_relative'],'--',color=color,alpha=.55)
  ax[1].plot(row['delay_ns'],row['coarse_fold10_relative'],'o-',ms=3,color=color,label=f'PM {ch}')
 x=new[9]['delay_ns'];ax[1].plot(x,[v*1.202361 for v in x],':',color='black',label='Clock-ratio prediction')
 for aa in ax:aa.grid(alpha=.25);aa.set_xlabel('Programmed relative delay (ns; nominal 961.8888 MS/s)');aa.legend(loc='best',ncol=3)
 handles,labels=ax[0].get_legend_handles_labels();handles += [Line2D([0],[0],color='grey',ls='-'),Line2D([0],[0],color='grey',ls='--')];labels+=['c7531465 / MCLK40','c7c42d28 / historical'];ax[0].legend(handles,labels,ncol=3)
 ax[0].set(title='TDC fine response: corrected-clock repeat and historical captures',ylabel='Relative fine code (unwrapped modulo 128)');ax[1].set(title='FPGA coarse response, folded modulo one Kasli word',ylabel='Relative coarse code (unwrapped after fold10)')
 for ext in ['png','pdf']:fig.savefig(a.out/f'tdc-clock40-phase.{ext}',dpi=180)
 plt.close(fig)
 fig,ax=plt.subplots(figsize=(8,4),layout='constrained');xx=list(range(4));ax.bar([x-.2 for x in xx],[old[ch]['coarse_raw_span'] for ch in [9,10,11,12]],width=.4,label='c7c42d28 historical',color='#adb5bd');ax.bar([x+.2 for x in xx],[new[ch]['coarse_raw_span'] for ch in [9,10,11,12]],width=.4,label='c7531465 MCLK40',color='#1971c2');ax.set(xticks=xx,xticklabels=[9,10,11,12],xlabel='Physical PM channel',ylabel='Observed raw coarse-code arc span',title='Raw coarse spread across the phase sweep');ax.legend();ax.grid(axis='y',alpha=.2)
 for ext in ['png','pdf']:fig.savefig(a.out/f'tdc-coarse-span.{ext}',dpi=180)
 print(json.dumps(summary,indent=2))
if __name__=='__main__':main()

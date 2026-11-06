"""Plot a saved fine-step CFD/TDC scan, retaining both raw timestamp fields."""
import argparse,csv,json,math,statistics,struct
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def main():
 p=argparse.ArgumentParser();p.add_argument('--input',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
 r=json.loads((a.input/'status.json').read_text());assert r['pass']
 a.out.mkdir(parents=True,exist_ok=False);(a.out/'acquisition.json').write_text(json.dumps(r,indent=2)+'\n')
 points=[];records=[]
 for row in r['captures']:
  if not row['tx']:continue
  words=[w[0] for w in struct.iter_unpack('<H',(a.input/row['label']/'tdc12.bin').read_bytes())]
  assert len(words)==128 and row['counts']==[0]*11+[128] and all(w<=8191 for w in words)
  fine=[w&127 for w in words];coarse=[w>>7 for w in words]
  angle=math.atan2(sum(math.sin(math.tau*n/128) for n in fine),sum(math.cos(math.tau*n/128) for n in fine))
  center=(angle*128/math.tau)%128
  local=[center+((n-center+64)%128-64) for n in fine]
  point=dict(phase_bin=row['phase_bin'],delay_ns=(row['phase_bin']-24)/961888800*1e9,
    fine_circular_mean=statistics.mean(local)%128,fine_std=statistics.stdev(local),coarse_median=statistics.median(coarse),count=len(words))
  points.append(point)
  records.extend(dict(phase_bin=row['phase_bin'],index=i,raw13=w,coarse6=w>>7,fine7=w&127) for i,w in enumerate(words))
 with (a.out/'raw.csv').open('w',newline='') as f:
  writer=csv.DictWriter(f,fieldnames=list(records[0]),lineterminator='\n');writer.writeheader();writer.writerows(records)
 (a.out/'statistics.json').write_text(json.dumps(dict(sample_rate_assumed_hz=961888800,points=points),indent=2)+'\n')
 plt.rcParams.update({'font.size':10,'axes.spines.top':False,'axes.spines.right':False})
 fig,(fine_ax,coarse_ax)=plt.subplots(2,1,figsize=(10,7.6),sharex=True,layout='constrained')
 xs=[v['delay_ns'] for v in points]
 for point in points:
  data=[v for v in records if v['phase_bin']==point['phase_bin']]
  fine_ax.scatter([point['delay_ns']]*len(data),[v['fine7'] for v in data],s=9,color='#868e96',alpha=.3,zorder=2)
  coarse_ax.scatter([point['delay_ns']]*len(data),[v['coarse6'] for v in data],s=10,color='#868e96',alpha=.35,zorder=2)
 fine_ax.errorbar(xs,[v['fine_circular_mean'] for v in points],yerr=[v['fine_std'] for v in points],fmt='o',ms=4,capsize=3,color='#1864ab',label='Circular mean ± standard deviation')
 coarse_ax.plot(xs,[v['coarse_median'] for v in points],'o',ms=4,color='#d9480f',label='Median of raw coarse field')
 fine_ax.set(ylabel='Raw fine code (modulo 128)',ylim=(-5,134));fine_ax.set_yticks([0,32,64,96,128],['0','32','64','96','128 ≡ 0'])
 coarse_ax.set(ylabel='Raw coarse field (unsigned)',xlabel='Programmed delay relative to the first point [ns]',ylim=(-3,66),xlim=(-.7,25.7));coarse_ax.set_yticks([0,8,16,32,48,63]);coarse_ax.set_xticks([0,5,10,15,20,xs[-1]],[0,5,10,15,20,f'{xs[-1]:.3f}'])
 for ax in (fine_ax,coarse_ax):ax.grid(alpha=.2);ax.legend(loc='upper right',frameon=False)
 fig.suptitle('PM12 channel 12 — TDC response to pulse phase\n25 phase points · 1.040 ns steps · 128 events per point',fontweight='bold',fontsize=14)
 fig.get_layout_engine().set(rect=(0,.1,1,.9))
 fig.text(.1,.025,'Dots: recorded events. Fine-code wrapping is retained; no global phase unwrapping is assumed.\nTiming axis assumes a 40.0787 MHz LHC clock. Raw coarse values are uncorrected; no TDC time calibration.',fontsize=9,color='#495057')
 for ext in ['png','svg','pdf']:fig.savefig(a.out/f'phase-response-1slot.{ext}',dpi=180)
 print('PASS',len(points),'points',len(records),'events',xs[-1],'ns range')
if __name__=='__main__':main()

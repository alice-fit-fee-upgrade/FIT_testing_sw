"""Unwrap measured fine codes by nearest-neighbour continuity, not coarse repair."""
from pathlib import Path
import json
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
root=Path(__file__).resolve().parent/'evidence-phase-1slot-20261106'
r=json.loads((root/'statistics.json').read_text());points=r['points'];unwrapped=[]
for p in points:
 value=p['fine_circular_mean']
 if unwrapped:value+=128*round((unwrapped[-1]-value)/128)
 unwrapped.append(value)
origin=unwrapped[0]
for p,u in zip(points,unwrapped):p['unwrapped_fine_mean']=u;p['relative_phase_codes']=origin-u
(root/'statistics-unwrapped.json').write_text(json.dumps(dict(points=points,method='Nearest-neighbour modulo128 unwrapping; assumes adjacent change below64 codes. Sign inverted and first point subtracted. Coarse field not used. No time calibration.'),indent=2)+'\n')
plt.rcParams.update({'font.size':11,'axes.spines.top':False,'axes.spines.right':False})
fig,ax=plt.subplots(figsize=(9,5.5),layout='constrained')
x=[p['delay_ns'] for p in points];y=[p['relative_phase_codes'] for p in points]
ax.errorbar(x,y,yerr=[p['fine_std'] for p in points],fmt='o-',color='#1864ab',lw=1.5,ms=4,capsize=2,label='Mean ± standard deviation; 128 events / point')
ax.set(xlabel='Programmed delay relative to the first point [ns]',ylabel='TDC fine phase change [unwrapped codes]',xlim=(-.5,25.7),ylim=(-30,1220))
ax.set_xticks([0,5,10,15,20,x[-1]],[0,5,10,15,20,f'{x[-1]:.3f}']);ax.grid(alpha=.2);ax.legend(loc='upper left',frameon=False,fontsize=9)
ax.set_title('PM12 channel 12 — unwrapped TDC phase response\n1.040 ns steps across one LHC clock period',fontweight='bold',pad=15)
fig.get_layout_engine().set(rect=(0,.14,1,.86))
fig.text(.1,.035,'Modulo-128 unwrapping assumes adjacent phase changes below 64 codes.\nSign chosen to increase with input delay; first point set to zero. No TDC time calibration.',fontsize=9,color='#495057')
for ext in ['png','svg','pdf']:fig.savefig(root/f'phase-response-unwrapped.{ext}',dpi=180)
print('Phase span:',y[-1],'codes')

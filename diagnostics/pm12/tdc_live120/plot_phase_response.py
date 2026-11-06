"""Plot measured128-event phase points; no new acquisition or TDC calibration."""
from pathlib import Path
import collections,csv,json,math,statistics
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
root=Path(__file__).resolve().parent/'evidence-20261106'
raw=collections.defaultdict(list)
for row in csv.DictReader((root/'raw-tdc.csv').open()):
    if row['channel_1based']=='12':raw[row['capture']].append(int(row['fine7']))
points=[]
for phase in [24,30,36,42]:
    label=f'burst-128-phase-{phase}';v=raw[label];assert len(v)==128
    angle=math.atan2(sum(math.sin(2*math.pi*n/128) for n in v),sum(math.cos(2*math.pi*n/128) for n in v))
    center=(angle*128/(2*math.pi))%128
    unwrapped=[center+((n-center+64)%128-64) for n in v]
    # Keep the first point near127 rather than splitting its0/127 bins.
    if phase==24 and statistics.mean(unwrapped)<64:unwrapped=[n+128 for n in unwrapped]
    points.append(dict(phase_bin=phase,relative_delay_ns=(phase-24)/961888800*1e9,
                       fine_mean=statistics.mean(unwrapped),fine_std=statistics.stdev(unwrapped),count=len(v)))
(root/'phase-response.json').write_text(json.dumps(dict(sample_rate_assumed_hz=961888800,points=points,notes='Relative programmed delay, not absolute BC phase. Fine modulo128 unwrapped locally; no TDC time calibration.'),indent=2)+'\n')
plt.rcParams.update({'font.size':11,'axes.spines.top':False,'axes.spines.right':False})
fig,ax=plt.subplots(figsize=(9,5.4),layout='constrained')
x=[p['relative_delay_ns'] for p in points];y=[p['fine_mean'] for p in points]
ax.errorbar(x,y,yerr=[p['fine_std'] for p in points],fmt='o-',color='#1864ab',lw=1.6,ms=7,capsize=5,label='Średnia ± odchylenie standardowe')
for p in points:ax.annotate(f"{p['fine_mean']:.2f}",(p['relative_delay_ns'],p['fine_mean']),xytext=(8,8),textcoords='offset points',fontsize=10)
ax.set(xlabel='Przesunięcie w tablicy generatora względem pierwszego punktu [ns]',ylabel='Odpowiedź fine TDC [kod]',xlim=(-1,21),ylim=(15,140))
ax.set_xticks(x,[f'{n:.3f}' for n in x]);ax.set_yticks([32,64,96,128],['32','64','96','128 ≡ 0'])
ax.grid(alpha=.2);ax.legend(loc='upper right',frameon=False)
ax.set_title('PM12, kanał 12: faza impulsu → odpowiedź TDC\n128 zdarzeń na punkt',fontweight='bold',pad=15)
fig.get_layout_engine().set(rect=(0,.12,1,.88))
fig.text(.1,.035,'Zawijanie fine 127→0 uwzględnione w statystyce. Linie łączą punkty pomiarowe.\nOś czasu z zegara LHC 40,0787 MHz; kalibracja czasu TDC i absolutnej fazy BC nie była wykonana.',fontsize=9,color='#495057')
for ext in ['png','svg','pdf']:fig.savefig(root/f'phase-response.{ext}',dpi=180)
print(json.dumps(points,indent=2))

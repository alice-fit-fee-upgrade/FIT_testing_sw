#!/usr/bin/env python3
import argparse,json
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
p=argparse.ArgumentParser();p.add_argument('--summary',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();s=json.loads(a.summary.read_text());csvfile=a.summary.with_name('events.csv')
import csv
allrows=list(csv.DictReader(csvfile.open()));fig,axes=plt.subplots(3,1,figsize=(11,10));chosen=[r for r in s['rows']if r['reset_states']]
for i,r in enumerate(chosen):
 es=[{k:(v if k=='label'else float(v)if k=='nominal_ms'else v=='True'if k=='spi_stable'else int(v))for k,v in row.items()}for row in allrows if row['label']==r['label']]
 reset=r['reset_states'][0];rt=reset['tick'];end=rt-reset['since_sel_low_nominal_us']*40078700/1e6;label=r['label'].replace('div601-','');color=f'C{i}'
 axes[0].step([(e['tick']-end)/40078700*1e6 for e in es],[e['bit_count']for e in es],where='post',color=color,label=label,alpha=.8)
 axes[1].plot([0,reset['since_sel_low_nominal_us']/1000],[i,i],color=color);axes[1].plot(reset['since_sel_low_nominal_us']/1000,i,'x',color=color,ms=10)
 # No further change records occur within the programmed1024-tick post-reset tail.
 z=es+[dict(es[-1],tick=rt+900)]
 for off,key in [(0,'mmcm_rst'),(0,'mmcm_powerdown'),(1,'sys_reset'),(2,'fixed_lock'),(3,'cap_lock'),(3,'gt_lock')]:
  axes[2].step([(e['tick']-rt)/40078700*1e6 for e in z],[off+.65*e[key]for e in z],where='post',color=color,alpha=.7)
axes[0].set_xlim(-340,10);axes[0].set_ylim(-1,33);axes[0].set_ylabel('SPI bit count');axes[0].set_xlabel('Time relative to SEL deassertion (us)');axes[0].set_title('All four reset captures: normal SPI frame, then parser returns to idle');axes[0].legend(ncol=2)
axes[1].set_yticks(range(len(chosen)),[r['label'].replace('div601-','')for r in chosen]);axes[1].set_xlim(-.2,10.7);axes[1].set_xlabel('Nominal running-clock time after SEL deassertion (ms)');axes[1].set_title('SYS restarts 9.608–10.219 ms after frame end; parser remains IDLE')
axes[2].set_xlim(-4,15);axes[2].set_yticks([0,1,2,3],['MMCM RST/PWRDWN','SYS reset','SYS MMCM LOCK','CAP/GTX LOCK']);axes[2].set_xlabel('Nominal time relative to observed SYS reset assertion (us)');axes[2].set_title('Reset event overlay: SYS MMCM loses LOCK; its control inputs stay low')
for ax in axes:ax.grid(alpha=.2)
fig.tight_layout();a.out.mkdir(parents=True,exist_ok=True);fig.savefig(a.out/'spi-reset-state.png',dpi=160);fig.savefig(a.out/'spi-reset-state.pdf')

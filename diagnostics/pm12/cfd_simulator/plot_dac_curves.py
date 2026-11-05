"""Export transfer curves and fit residuals using matplotlib; no hardware access."""
import argparse,json
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

p=argparse.ArgumentParser();p.add_argument('report',type=Path);p.add_argument('--out',type=Path,required=True)
a=p.parse_args();data=json.loads(a.report.read_text());fig,axes=plt.subplots(2,3,figsize=(13,7),layout='constrained')
for column,output in enumerate('BCD'):
    row=data['curves'][output];codes=row['codes'];volts=row['volts'];fit=[row['interior_intercept_volts']+row['interior_slope_volts_per_code']*code for code in codes]
    ax=axes[0,column];ax.plot(codes,volts,'.',label='Mean of 3 readings');ax.plot(codes,fit,'-',linewidth=.8,label='Fit to5–95% span')
    ax.set_title(f"DAC {output}: {row['signal']}");ax.set_ylabel('Voltage (V)');ax.legend(fontsize=8)
    ax=axes[1,column];ax.axhline(0,color='gray',linewidth=.8);ax.plot(codes,[(v-f)*1e6 for v,f in zip(volts,fit)],'.-')
    ax.set_ylabel('Residual from fit (µV)');ax.set_xlabel('DAC code');ax.set_title(f"Gain vs nominal: {row['interior_gain_error_percent']:+.3f}%",fontsize=10)
    for ax in axes[:,column]:ax.grid(alpha=.25);ax.set_xlim(0,65535)
fig.suptitle('PM12 channel 12 — DAC B/C/D, 65 points, DMM7510 at 5 PLC\nWhole-chain functional scan; residuals are not calibrated DAC INL',fontsize=12)
a.out.mkdir(parents=True,exist_ok=True)
for extension in ('png','svg'):fig.savefig(a.out/f'dac-curves.{extension}',dpi=180)

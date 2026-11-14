#!/usr/bin/env python3
"""Add editable assembly findings and one168-link connection table to a report."""
import argparse,json,statistics,subprocess,shutil
from pathlib import Path
from campaign import read,write,inventory
from campaign_report import tex,table


def append(report,work,latex=None):
 import matplotlib
 matplotlib.use('Agg')
 import matplotlib.pyplot as plt
 from campaign_monitor_adapter import WINDOWS
 monitor=read(work/'monitor-scan/scan-report.json');channels=monitor['connected_modules'];rows=[]
 fig,axes=plt.subplots(2,4,figsize=(14,7),layout='constrained')
 names=['CFD_OFFSET','CFD_CMP_OFFSET','BUFFER_OFFSET','DRV_OFFSET','DRV_VOCM','N5V5 divided','P1V3','P5V5 divided']
 for mux,ax in enumerate(axes.flat):
  scale=53/33 if mux in (5,7) else 1;lo,hi=WINDOWS[mux];ax.axhspan(lo/scale,hi/scale,color='#2b8a3e',alpha=.12)
  for ch in channels:
   entry=next(r for r in monitor['readings'] if r['physical_channel']==ch and r['mux_channel']==mux);values=[s['volts'] for s in entry['samples']];mean=statistics.mean(values);ok=lo<=mean*scale<=hi;ax.errorbar(ch,mean,yerr=statistics.stdev(values),fmt='o' if ok else 'x',color='#1864ab' if ok else '#c92a2a',capsize=3)
   rows.append([ch,mux,names[mux],f'{mean:.6f}',f'{mean*scale:.6f}','within window' if ok else 'OUTSIDE WINDOW'])
  ax.set(title=f'MUX{mux}: {names[mux]}',xlabel='Physical PM position',ylabel='Raw MCX voltage (V)');ax.set_xticks(channels);ax.grid(alpha=.2)
 fig.suptitle('CFD monitor assembly check — direct readings, nominal screening windows')
 for ext in ['png','pdf']:fig.savefig(report/f'monitor-assembly.{ext}',dpi=170)
 plt.close(fig)
 intro=r'\section{Assembly verification: current fitted group9--12}'+'\n'
 intro+='The present campaign is a functional assembly check. Unmeasured fixtures or missing stimuli do not receive PASS. The current group has two observed discrepancies; this document is not an unconditional board release.\n\n'
 intro+=table(['Case','Observed result','Disposition'],[
 ['CFD monitor9/10/12','All eight inputs pass','PASS'],['CFD monitor11','Raw MUX7=5.479V; other modules about3.41V','FAIL: fixture branch/variant'],['JTAG/static links','168/168 in each independent path','PASS: scoped static check'],['CPU/FPGA and peripherals','32walking patterns restored; IDs/PGOOD correct','PASS'],['I2C rails and telemetry','Eight populated rail voltages in nominal windows','PASS; nominal currents'],['Ethernet/IPbus','393216ADC payload bytes checked; stable ADC/TDC transfers','PASS: functional transport'],['HDMI data lanes','Walking, slow/fast PRBS and idle frames correct','Data checks PASS'],['HDMI shared SPI release','SYS resets after pad release following reads0/1/2','Overall HDMI FAIL'],['Analog channel9','USB remains on10','NOT MEASURED; owner move pending']])
 intro+=r'\subsection{CFD monitor discrepancy is on the tester}'+'\n'
 intro+='The emulator at PM position11 (provisional CFD02) gives about5.479V directly at MUX7. Independent revisits reproduce it; position12 gives about3.410V. Check CFD SIM R3=33kOhm to ground, R4=20kOhm from P5V5 and their joints, or confirm an intended assembly variant. The nominal53/33 correction would yield8.80V, but that is not a measured8.80V PM supply. The independent PM INA bus reading is5.496V.\n\n'
 intro+=r'\begin{center}\includegraphics[width=\textwidth]{monitor-assembly.pdf}\end{center}'+'\n'
 intro+=table(['PM position','Mux','Signal','Raw MCX(V)','Nominal equivalent(V)','Screen'],rows)
 intro+='Nominal equivalent uses53/33 only for the divided rails. On the failed branch that assumption is suspect; use the direct reading for diagnosis. This is an assembly window check, not traceable calibration or a measurement of analog off-resistance.\n\n'
 intro+=r'\subsection{HDMI reset isolation and restored operating state}'+'\n'
 intro+='Both full integrated runs retain the unexpected reset. Controlled isolation observes no reset during an idle-only enable/release or during the signature reads themselves. The counter clears when FPGA pads are released after SPI reads, before the DIO direction restoration. The exact electrical/MCU interaction remains unresolved; it must not be called a PM assembly defect solely from this test. Full HDMI remains FAIL until resolved. No arbitrary SPI writes were used.\n\n'
 trace=read(work/'hdmi-reset-isolation/status.json')['trace'];intro+=table(['Isolation event','Raw64-bit SYS uptime'],[[r['label'],r['uptime'][0]+(r['uptime'][1]<<32)] for r in trace])
 intro+='After isolation, fresh ADC and TDC transport checks passed with no SYS reset. The JTAG wrapper retains its ERROR from the combined HDMI guard; JTAG PASS here comes from independently rebuilt static vectors and checksum-verified restored SRAM followed by those stable checks. The separate HDMI failure remains visible.\n\n'
 intro+='Firmware still prints the old R15-not-fitted label for P3V8. The owner confirmed R15 fitted; the schematic specifies1mOhm. Host conversion of the retained signed shunt code at40uV/LSB gives about3.12A, uncalibrated. The original firmware text is retained. No MCU firmware was changed; route6/channel3 is unpopulated and excluded. Power-sequence fault injection is not performed.\n\n'
 intro+='Final state: qualified c7c42d28 diagnostic in FPGA SRAM, private PM bridge active, HDMI/CFD outputs released, DIO cards input, ADC bankA physical capture and frozen quiet TDC. SMU OFF/HIZ at0A, all four monitor muxes inhibited and TCA masks0. USB cables stay on10. Prior analog measurements retain their own acquisition settings; they are not silently remeasured after reconfiguration.\n'
 (report/'assembly-findings.tex').write_text(intro)
 diag=read(work/'board-boundary01/diagnostic/report.json');boundary={r['signal']:r for r in diag['boundary']['connections']};connections=diag['gateware']['connections']
 def key(r):
  import re
  m=re.fullmatch(r'DI(\d+)\[(\d+)\]',r['signal'])
  return (int(m[1]),int(m[2])) if m else (int(r['signal'][3:]),13)
 text=r'\section{Static CPLD--FPGA connection discovery}'+'\n'
 text+='Each path independently used338walking-one/zero vectors. All168expected sources match; one common table avoids repeated descriptions. This checks static connectivity, not at-speed margin or unconnected analog inputs.\n\n'
 text+=r'\small'+'\n'+table(['PM channel','Signal','CPLD pin','FPGA ball','Gateware','Boundary'],[[r['cpld_channel'],r['signal'],r['cpld_pin'],r['fpga_ball'],'PASS' if r['passed'] else 'FAIL','PASS' if boundary[r['signal']]['passed'] else 'FAIL'] for r in sorted(connections,key=key)])+r'\normalsize'+'\n'
 (report/'assembly-connections.tex').write_text(text)
 template=(report/'report.tex').read_text();assert 'assembly-findings.tex' not in template
 template=template.replace(r'\input{content.tex}',r'\input{assembly-findings.tex}'+'\n'+r'\input{content.tex}'+'\n'+r'\input{assembly-connections.tex}')
 (report/'report.tex').write_text(template);shutil.copy2(Path(__file__),report/'executed-assembly-appendix.py')
 if latex:
  with (report/'assembly-latex-build.txt').open('w') as log:subprocess.run([str(latex),'--outdir',str(report),str(report/'report.tex')],stdout=log,stderr=subprocess.STDOUT,check=True)
 write(report/'files.sha256.json',inventory(report))


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--report',type=Path,required=True);p.add_argument('--work',type=Path,required=True);p.add_argument('--latex',type=Path);a=p.parse_args();append(a.report,a.work,a.latex)
if __name__=='__main__':main()

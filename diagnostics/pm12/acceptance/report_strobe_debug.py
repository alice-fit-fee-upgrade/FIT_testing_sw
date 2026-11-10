#!/usr/bin/env python3
"""Editable LaTeX engineering note for the independently repeated STR diagnosis."""
import argparse,collections,json,shutil
from pathlib import Path
from report import tex,table,compile_pdf
from suite import utc,write,files_manifest
HERE=Path(__file__).resolve().parent

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for name in ['phase-analysis','resident-run','reload-run','final-system','out']:
        p.add_argument('--'+name,type=Path,required=True)
    p.add_argument('--latex');a=p.parse_args()
    read=lambda p:json.loads(p.read_text())
    phase=read(a.phase_analysis/'raw-analysis.json');run=read(a.resident_run/'run.json')
    reload=read(a.reload_run/'result.json');final=read(a.final_system/'result.json')
    uid=run['board_uid']
    if {phase['identity']['uid'],reload['identity']['uid'],final['identity']['uid'],uid}!={uid}:raise ValueError('Different hardware identities')
    if not phase['all_unique'] or not phase['all_selected_words_stable']:raise ValueError('Unqualified phase dataset')
    if any(r['status']!='PASS' for r in [run,reload,final]):raise ValueError('Qualification did not pass')
    raw=read(a.resident_run/'adc-lines-ch12/data/raw-validation.json')
    lines=read(a.resident_run/'adc-lines-ch12/data/line-test.json')
    a.out.mkdir(parents=True,exist_ok=False);(a.out/'figures').mkdir();(a.out/'inputs').mkdir()
    for path,name in [(a.phase_analysis/'raw-analysis.json','phase.json'),(a.resident_run/'run.json','resident.json'),
                      (a.reload_run/'result.json','reload.json'),(a.final_system/'result.json','final-system.json'),
                      (a.resident_run/'adc-lines-ch12/data/raw-validation.json','raw-validation.json'),
                      (a.resident_run/'adc-lines-ch12/data/line-test.json','line-test.json')]:
        shutil.copy2(path,a.out/'inputs'/name)
    for ext in ['png','pdf']:shutil.copy2(a.phase_analysis/('strobe-phase-diagnosis.'+ext),a.out/'figures'/('strobe-phase-diagnosis.'+ext))
    shutil.copy2(HERE/'templates/report.tex',a.out/'report.tex')
    meta={'ReportUID':uid,'ReportMode':'Engineering diagnosis','ReportDate':utc(),'ReportVerdict':'Sampling case resolved','ReportScope':'Controlled phase sweeps and identical FPGA-only SRAM reloads. Functional capture qualification; complete board acceptance remains separate.'}
    (a.out/'metadata.tex').write_text(''.join('\\newcommand{\\'+k+'}{'+tex(v)+'}\n' for k,v in meta.items()))
    text='\\section{Finding and cause}\n'+tex('The all4-tick STR interval requirement was invalid for asynchronous4x oversampling at a sampling boundary. STR and data use separate two-stage synchronizers. A small edge-position uncertainty produces intervals3/5 around the nominal4, without losing clock cycles. The clock trace alone does not measure physical jitter in picoseconds.')+'\n\n'
    text+=tex('The same FPGA image was reloaded twice, with no CPLD EXTEST, CPLD programming, MCU reset, flash write or PLL profile change. Different channels then fell at the sampling boundary. The ADC word used for each measurement must remain equal across two consecutive raw samples.')+'\n'
    text+='\\section{Controlled phase repeat}\n'+table(['Property','Observation'],[
        ('Unique retained raw buffers',phase['unique_raw_captures']),('ALIGNED',phase['status_counts']['ALIGNED']),
        ('EDGE QUANTIZED',phase['status_counts']['EDGE_QUANTIZED']),('Maximum observed edge phase span',str(phase['max_edge_phase_span_samples'])+' capture sample'),('Selected complete ADC words','All stable across two consecutive raw samples')])
    text+='\\Figure{figures/strobe-phase-diagnosis.pdf}{'+tex('DAC-A phase controls, ADC A/B; error bars show observed range across captures. No interpolation between measured settings. The lower panel displays the first120edges; the entire buffer has phase span1 sample.')+'}\n'
    text+='\\clearpage\\section{FPGA-only reload control}\n'
    rows=[]
    for stage in ['before','reload0','reload1']:
        group=[v for v in reload['rows'] if v['stage']==stage];counts=collections.Counter(v['status'] for v in group)
        rows.append((stage,len(group),counts['ALIGNED'],counts['EDGE_QUANTIZED'],','.join(map(str,sorted({v['channel'] for v in group if v['status']=='EDGE_QUANTIZED'})))))
    text+=table(['Context','Buffers','Aligned','Quantized','Channels'],rows,['.18\\linewidth','.15\\linewidth','.15\\linewidth','.15\\linewidth','.18\\linewidth'])
    text+=tex('Both banks and all12 digital ADC paths were captured three times per context. Every raw capture passed edge counts, bounded rising/falling phase, pulse-width and selected-word stability checks. CPLDs were not driven into EXTEST in this control.')+'\n'
    text+='\\section{Revised validity model}\n'+table(['Check','Required condition'],[
        ('Capture framing','4096 words; correct EV tag; reserved bits zero'),('Edge count','1023 or1024 rising and falling edges'),('Edge spacing','Only3/4/5; cumulative phase spans at most1 sample on both polarities'),('Sampled pulse width','1..3 capture ticks'),('Data coherency','Selected pre-STR word equals its preceding full ADC-data sample'),('Strict alignment mode','Retained as a separate diagnostic; original strict FAIL evidence not changed')])
    text+='\\section{Full resident sequence repeated}\n'+table(['Stage','Result'],[(s['title'],s['status']) for s in run['steps']])
    text+=table(['ADC raw validation','Result'],[(k,v) for k,v in raw.items() if k!='strobe_interval_counts'])
    text+=table(['ADC','Visited codes','Non-rail samples','Bit/pair result'],[(b,d['visited_codes'],d['interior_samples'],'12bits /11pairs PASS') for b,d in lines['banks'].items()],['.12\\linewidth','.20\\linewidth','.24\\linewidth','.28\\linewidth'])
    text+=tex('The257-point ADC A/B scan includes369quantized and145aligned captures. All514 histograms and EV tags match the raw buffers; generations are contiguous. After the two FPGA-only reloads, the final HDMI/ADC/TDC system test also passed without an unexpected SYS reset.')+'\n'
    text+='\\section{Limits and retained state}\n'+tex('This diagnoses the sampling/validation case. It is not electrical jitter, clock spectral purity, source-synchronous timing-margin or complete ADC INL/DNL certification. Missing analog channels remain unmeasured. The same integrated image remains in SRAM; DAC-A raw0000, external DAC pair1V/1V, monitor inhibited, DIO outputs released, ADC bankA valid and TDC quiet/frozen. No configuration-flash or MCU/CPLD image writes.')+'\n'
    (a.out/'content.tex').write_text(text)
    if a.latex:compile_pdf(a.out,a.latex)
    write(a.out/'files.sha256.json',files_manifest(a.out))

if __name__=='__main__':main()

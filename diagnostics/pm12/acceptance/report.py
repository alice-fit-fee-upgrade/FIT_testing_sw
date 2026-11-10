#!/usr/bin/env python3
"""Offline LaTeX chapters and complete reports from immutable PM12 test batches."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
from suite import sha,write,utc,files_manifest
from history import create as historical
from plots import build as build_plots,read,failures as plot_failures

HERE=Path(__file__).resolve().parent


def tex(value):
    value=str(value)
    replacements={'\\':r'\textbackslash{}','&':r'\&','%':r'\%','$':r'\$','#':r'\#','_':r'\_','{':r'\{','}':r'\}','~':r'\textasciitilde{}','^':r'\textasciicircum{}',
                  '−':'-','–':'--','—':'---','→':r'$\rightarrow$','↔':r'$\leftrightarrow$','×':r'$\times$','≤':r'$\leq$','≥':r'$\geq$','µ':r'$\mu$','²':r'$^2$','…':'...'}
    return ''.join(replacements.get(c,c) for c in value)


def table(headers,rows,widths=None):
    cols=widths or [f'{.88/len(headers):.4f}\\linewidth']*len(headers)
    spec=''.join(r'>{\raggedright\arraybackslash}p{'+v+'}' for v in cols)
    text='\\begin{longtable}{'+spec+'}\n\\toprule\n'+' & '.join(map(tex,headers))+r'\\\midrule'+'\n\\endhead\n'
    for row in rows:text+=' & '.join('{'+tex(v)+'}' for v in row)+r'\\'+'\n'
    return text+'\\bottomrule\n\\end{longtable}\n'


def connection_table(gate,boundary,pinmap):
    """One row per measured net; common method/provenance appears only once."""
    gate_rows=gate['connections'];boundary_rows=boundary['connections']
    gmap={r['signal']:r for r in gate_rows};bmap={r['signal']:r for r in boundary_rows}
    if len(gmap)!=168 or len(bmap)!=168 or len(gate_rows)!=168 or len(boundary_rows)!=168 or set(gmap)!=set(bmap):
        raise ValueError('Expected168 unique matching gateware/boundary nets')
    def endpoint(row):
        channel,pin=row.get('cpld_channel'),row.get('cpld_pin')
        return f'{channel} / {pin}' if channel is not None and pin is not None else 'Unresolved'
    rows=[]
    for g in sorted(gate_rows,key=lambda r:(12-r['expected_source']//14,r['expected_source']%14)):
        b=bmap[g['signal']];source=g['expected_source']
        expected=f"{12-source//14} / {pinmap['cpld'][source%14]['pin']}"
        rows.append((g['signal'],g['fpga_ball'],expected,endpoint(g),endpoint(b),
                     'PASS' if g['passed'] else 'FAIL','PASS' if b['passed'] else 'FAIL'))
    result=tex('CPLD endpoints are physical channel / package pin. Each result includes walking-one, walking-zero, all-zero/all-one baselines and agreement with the schematic. Vector indices, boundary cells and full per-vector observations remain in the archived JSON/logs.')+'\n\n'
    result+=r'\begingroup\small\setlength{\tabcolsep}{3pt}'+'\n'
    result+=table(['Signal','FPGA ball','Expected CPLD','Gateware CPLD','Boundary CPLD','Gateware','Boundary'],rows,
                  ['.14\\linewidth','.08\\linewidth','.16\\linewidth','.16\\linewidth','.16\\linewidth','.09\\linewidth','.09\\linewidth'])
    result+=r'\endgroup'+'\n'
    result+=table(['Common test condition','Recorded value'],[
        ('Discovery vectors per receive path',gate['vectors']),
        ('Functional CPLD restoration',bool(gate['restored'] and boundary['restored']))])
    result+=tex('Schematic SHA256: '+pinmap['schematic_sha256'])+'\n'
    return result


def verify(directory,allow_edited_tex=False):
    manifest=read(directory/'files.sha256.json')
    for name,item in manifest.items():
        p=(directory/name).resolve()
        if not p.is_relative_to(directory.resolve()) or not p.is_file() or sha(p)!=item['sha256'] or p.stat().st_size!=item['bytes']:
            if not (allow_edited_tex and Path(name).suffix=='.tex' and 'inputs' not in Path(name).parts and p.is_file()):
                raise ValueError('Evidence integrity failure: '+str(p))
    return read(directory/('run.json' if (directory/'run.json').exists() else 'chapter.json'))


def gather(runs):
    loaded=[(p,verify(p)) for p in runs]
    if not loaded:raise ValueError('At least one batch is required')
    uids={r['board_uid'] for _,r in loaded}
    if len(uids)!=1:raise ValueError('Cannot merge different hardware identities')
    modes={r['mode'] for _,r in loaded}
    if len(modes)!=1:raise ValueError('Cannot merge historical and fresh evidence into acceptance results')
    configurations={json.dumps(r.get('configuration',{}),sort_keys=True) for _,r in loaded}
    if len(configurations)!=1:raise ValueError('Incompatible measurement configurations; select separate report revisions')
    sources={r.get('source_fingerprint') for _,r in loaded}
    if len(sources)!=1:raise ValueError('Different executed source versions; do not silently combine')
    seen={};datasets=[]
    for root,r in loaded:
        if r['mode']=='HISTORICAL':
            datasets.append(dict(channel=12,adc_scan=str(root/'adc-lines/acquisition.json'),raw_archive=str(root/'adc-lines/raw-captures.tar.gz'),phase_csv=str(root/'gate-phase/phase.csv')))
            continue
        for step in r['steps']:
            if step.get('channel') is None:continue
            key=(step['id'],step['channel'])
            if key in seen:raise ValueError(f'Duplicate measurement {key}; explicitly select which batch to publish')
            seen[key]=root
            # Never include failed/partial captures in the successful overlay.
            if step['status']!='PASS':continue
            dest=root/step['instance']/'data'
            if step['id']=='adc-lines':datasets.append(dict(channel=step['channel'],adc_scan=str(dest/'scan/status.json')))
            if step['id']=='gate-phase':datasets.append(dict(channel=step['channel'],phase_csv=str(dest/'phase.csv')))
    return loaded,datasets


def flatten_json(value,prefix='',limit=120):
    rows=[]
    def visit(obj,key):
        if len(rows)>=limit:return
        if isinstance(obj,dict):
            for k,v in obj.items():visit(v,key+'.'+k if key else k)
        elif isinstance(obj,list):
            if len(obj)<=8 and not any(isinstance(v,(dict,list)) for v in obj):rows.append((key,str(obj)))
            else:rows.append((key,f'{len(obj)} entries; see archived JSON/raw files'))
        else:rows.append((key,str(obj)))
    visit(value,prefix)
    return rows


def content(loaded,summary,inventory,extended,chapter):
    root,run=loaded[0];historical_mode=run['mode']=='HISTORICAL'
    out=[]
    def section(title):out.append('\\clearpage\n\\section{'+tex(title)+'}\n')
    def text(value):out.append(tex(value)+'\n\n')
    def fig(name,caption):out.append('\\Figure{figures/'+name+'.pdf}{'+tex(caption)+'}\n')
    section('Scope, identity and disposition')
    text('This dossier records evidence and test coverage. A long report is not proof of compliance: incomplete channels, unknown configuration, absent raw data and failed restoration remain visible.')
    text(run.get('provenance_warning','Live batches collected under hardware leases. A batch PASS applies only to its selected tests and channels.'))
    out.append(table(['Field','Recorded value'],[
        ('Hardware identity',run['board_uid']),('MCU EEPROM label',run['board_serial']),('Evidence mode',run['mode']),
        ('Merged batches',len(loaded)),('Analog channels measured',', '.join(ch for ch,e in summary['channels'].items() if 'adc' in e) or 'none'),
        ('Final acceptance','NOT RELEASED — requires complete required coverage, frozen limits and reviewer disposition'),
        ('Missing channels',', '.join(str(i) for i in range(1,13) if 'adc' not in summary['channels'].get(str(i),{})) or 'none')]))
    if run.get('identity'):out.append(table(['Identity field','Value'],flatten_json(run['identity'],limit=20)))
    text('Canonical new board label: PM12-K7-<full FPGA factory DNA>. Preserve leading zeroes. JTAG IDCODE identifies chip type, not the individual device. EEPROM serial and debugger cable serial are secondary labels. Replacing the FPGA changes this hardware identity and requires an explicit board genealogy record.')
    text('Historical evidence predating factory-DNA reads is never assigned to a newly enrolled DNA automatically. No chip or EEPROM is programmed to assign this number; the printed asset label and registry use the hardware value.')
    section('Bench inventory and wiring')
    fig('bench','User-reviewed bench wiring, updated2026-11-08; not a pin-level schematic. Historical wiring and configuration are retained with each acquisition snapshot.')
    bench=summary['bench_parameters']
    text('Diagram parameters describe the illustrated bench; they do not configure hardware. Recorded signal assignments retain the acquisition mapping and are not rewritten by diagram edits.')
    out.append(table(['Connection','Physical assignment / observation'],[
        ('Analog stimulus',f"{bench['dac']} analog USB outputs feed {bench['cfd']}, then the selected {bench['dut']} ADC input"),
        ('HDMI cabling',f"{bench['dut']} HDMI to LVDS-HDMI adapter, then2RJ45 cables to DIO-LVDS slot{bench['hdmi_slot']} and {bench['controller']} backplane"),
        ('Recorded HDMI data mapping','Kasli slot6 channels0..3 are inputs; observed PM lane order3,1,2,0'),
        ('Recorded HDMI SPI mapping','Slot6:SELECT4,CLOCK5,MISO6,MOSI7; only4/5/7 may drive; mask0x00b0'),
        ('Recorded CFD wiring and phase mapping','CFD_SIM RJ45 to DIO-LVDS slot7 and Kasli backplane; channel0:CFD stimulus; phase RX8/9:channels1/3'),
        ('PM SFP','Private cable to Kasli SFP1, line rate1.202361Gb/s; not standard switch-facing1000BASE-X'),
        ('Kasli Ethernet','SFP0:control IPbus; SFP2:optical PM bridge to LAN; SFP3 unused'),
        ('Common reference',f"{bench['lhc_mhz']}MHz enters the LVDS-HDMI adapter and reaches {bench['dut']} via HDMI; the generator internal x{bench['multiplier']} output supplies {bench['controller']} at {bench['kasli_mhz']}MHz. Declared settings, no frequency-counter calibration")]))
    rows=[]
    for module in inventory.get('modules',[]):rows.append((module.get('role',''),module.get('type',''),module.get('hardware_uid') or module.get('label') or module.get('eeprom_serial') or 'NOT READ'))
    out.append(table(['Role','Module','Identity'],rows,['.22\\linewidth','.36\\linewidth','.34\\linewidth']))
    text('Photographs supplement, but never replace, hardware identity. Each photo is associated with the identified module and its file hash. Missing photos or unread device IDs are left explicit.')
    for i,module in enumerate(inventory.get('modules',[])):
        out.append('\\subsection*{'+tex(module.get('type','Module'))+'}\n')
        if module.get('_photo'):
            out.append('\\Figure{'+module['_photo']+'}{'+tex('Photo SHA256 '+module['_photo_sha256'])+'}\n')
        else:out.append('\\PhotoMissing{'+tex(module.get('role',''))+'}\n')
    section('Test coverage and acceptance rules')
    if historical_mode:
        rows=[('JTAG chain / 168 static links','HISTORICAL PASS','2026-10-13; exact reduced measured logs retained'),('CPU–FPGA SPI / peripherals','HISTORICAL PASS','2026-10-15; original diagnostic image'),('Configuration flash read / ownership','HISTORICAL PASS','Read-only ownership sequence; stored-image boot NOT CONFIRMED'),('Power startup / timeout fault injection','NOT RUN','Static PGOOD cannot substitute for fault testing'),('GTX PRBS / Ethernet loopback','HISTORICAL PASS','Old exact 40 MHz setup, not current LHC private link'),('I2C mux / power monitors','HISTORICAL PASS','2026-10-14; uncalibrated currents; P3V8 shunt absent at that historical measurement'),('HDMI / digital ADC / TDC','HISTORICAL PASS','2026-11-06; all digital ADC channels, stimulated TDC only channel 12'),('CFD monitor and B/C/D DAC curves','HISTORICAL','Channel 12 only; restored-code correction retained'),('Gate phase and DAC-A','HISTORICAL PASS','Channel 12,20 settings; nominal sample time units'),('ADC transfer / adjacent bits','HISTORICAL PASS','2026-11-07 channel 12, A/B; 257 levels, raw revalidated')]
    else:
        rows=[(s['title'],s['status'],s.get('reason',s.get('error','channel '+str(s.get('channel'))))) for _,r in loaded for s in r['steps']]
    out.append(table(['Test','Result','Scope / deviation'],rows,['.34\\linewidth','.19\\linewidth','.39\\linewidth']))
    text('PASS requires the configured process to finish successfully AND every declared result check to match. NOT_RUN, BLOCKED, ERROR and INCONCLUSIVE cannot become PASS. Failed cleanup is a failure. Repeated runs do not overwrite earlier evidence.')
    section('Test procedure and criteria')
    plan=read(HERE/'profiles/full-coverage.json')
    for spec in plan['steps']:
        out.append('\\subsection{'+tex(spec['title'])+'}\n')
        text(spec['procedure']);text('Limits: '+spec['limits'])
    if chapter=='full':
        section('Digital link and peripheral evidence')
        if historical_mode:
            for label,path in [('MCU / SPI',root/'mcu/fpga-spi-hardware.json'),('Flash ownership',root/'mcu/config-flash-hardware.json'),('Ethernet / PRBS',root/'ethernet/validation-2026-10-13.json'),('I2C topology',root/'i2c/validation.json')]:
                out.append('\\subsection{'+tex(label)+'}\n');out.append(table(['Recorded field','Result'],flatten_json(read(path),limit=28)))
            out.append('\\subsection{Power rail observations}\n')
            rail=read(root/'i2c/telemetry-repeat-2026-10-14.json')
            rows=[]
            for monitor in rail['telemetry']['monitors']:
                for ch in monitor['channels']:rows.append((ch['rail'],ch.get('bus_V_mean'),ch.get('current_A_mean'),'Uncalibrated; inspect shunt/clipping metadata'))
            out.append(table(['Rail','Bus [V]','Current [A]','Note'],rows,['.25\\linewidth','.17\\linewidth','.17\\linewidth','.33\\linewidth']))
            text('The historical P3V8 measurement above was taken without its shunt, so its current is excluded. The owner confirms current readout is available as of2026-11-08; subsequent captures record it normally. Historical clipping observations are retained.')
        else:
            for path,r in loaded:
                for s in r['steps']:
                    if s.get('channel') is not None or s['status']!='PASS':continue
                    out.append('\\subsection{'+tex(s['title'])+'}\n')
                    p=path/s['instance']/'data/result.json'
                    if p.exists():out.append(table(['Recorded field','Result'],flatten_json(read(p),limit=35)))
    section('CFD and ADC — channel comparison')
    text('All measured channels share one overlay per observable, with a fixed channel color and common axes. ADC A/B occupy separate panels. No line is invented for an unmeasured channel. The twelve-channel requirement is independent of the number of connected simulators in a batch.')
    for name in summary['figures']:
        captions={'transfer':'Requested DAC voltage, not a calibrated voltage measurement.','waveform':'One sample per STR edge; time origins are local to sequential captures. Fs inferred as 80.1574 MHz.','fft':'DC removed, Hann window, one-sided PSD. Fs inferred from stated LHC reference, not measured by a frequency counter. No ENOB/SINAD acceptance from a DC capture.','histogram':'Stepped DC code density; unvisited codes are not automatically ADC missing-code/DNL faults.','phase':'Nominal sampled-centroid units; original 20 MHz gate divider. Curves use the same reported sample metadata.'}
        fig(name,captions[name])
    rows=[]
    for ch in range(1,13):
        entry=summary['channels'].get(str(ch),{})
        for bank in 'AB':
            a=entry.get('adc',{}).get('banks',{}).get(bank)
            rows.append((ch,bank,'PASS' if a and a['pass_'] else 'NOT MEASURED',a['visited_codes'] if a else '-',a['interior_samples'] if a else '-'))
    out.append(table(['Channel','ADC','Line exercise','Visited codes','Interior samples'],rows,['.12\\linewidth','.10\\linewidth','.25\\linewidth','.18\\linewidth','.23\\linewidth']))
    out.append(table(['ADC','Channel','Max deviation [codes]','RMS deviation [codes]'],
        [(bank,ch,f"{v['max_abs_deviation_from_channel_median_codes']:.6g}",f"{v['rms_deviation_from_channel_median_codes']:.6g}")
         for bank,d in summary.get('dispersion',{}).items() for ch,v in d.get('channels',{}).items()],['.12\\linewidth','.15\\linewidth','.30\\linewidth','.30\\linewidth']))
    text('Deviation is relative to the median of measured channels at common requested stimulus settings, without interpolation. With fewer than two channels this comparison is NOT COMPARABLE, rather than zero dispersion. Values are descriptive, not a calibrated gain/error acceptance limit.')
    text('Bit decisions exclude rail codes 0/4095. Both values of every bit and all four states of each neighboring pair must be populated: at least 64 samples and 2% of all interior samples per state, plus at least 8 samples at each of 3 distinct settings. At least 16 settings, 4096 interior samples and 3000-code mean span are required for PASS.')
    text('ADC strobe validation uses the4x sampled clock model:1023 or1024 rising and falling edges, intervals3/4/5 only, cumulative rising and falling phase spans at most one sample, and pulse widths1..3 samples. The ADC word selected immediately before STR must equal its preceding sample. EDGE QUANTIZED is reported separately from ALIGNED; neither is a calibrated jitter result. A strict all4-interval check is a separate phase-alignment diagnostic.')
    text('This excludes sampled persistent stuck/tied signatures under these conditions. It does not establish electrical resistance, bit order, timing margin, ADC INL/DNL or full missing-code compliance. A sine histogram is arcsine-shaped; a calibrated continuous ramp is a separate density test.')
    if chapter=='full' and historical_mode:
        section('TDC phase response')
        import csv
        import numpy as np
        import matplotlib.pyplot as plt
        from plots import save
        with (root/'tdc/raw.csv').open() as f:raw=list(csv.DictReader(f))
        phases=sorted({int(v['phase_bin']) for v in raw});means=[];counts=[]
        for phase in phases:
            fine=np.array([int(r['fine7']) for r in raw if int(r['phase_bin'])==phase]);z=np.exp(2j*np.pi*fine/128).mean();means.append(np.angle(z)%(2*np.pi)*128/(2*np.pi));counts.append(len(fine))
        figu,ax=plt.subplots(figsize=(10,5),layout='constrained');delay=(np.array(phases)-phases[0])*1e9/961888800
        ax.plot(delay,means,'.-');ax.set(xlabel='Applied phase [ns, inferred reference]',ylabel='Circular mean fine code [0..128)',title='Channel 12 TDC response — raw records, wrapped phase');ax.grid(alpha=.2)
        # Destination is supplied by caller via inventory private field.
        save(figu,Path(inventory['_figures'])/'tdc-phase')
        fig('tdc-phase','Recomputed circular means from raw 13-bit TDC records. Response and event counting, not calibrated picosecond accuracy.')
        out.append(table(['Applied slot','Applied delay [ns]','Fine circular mean','Events'],[(p,f'{d:.6g}',f'{m:.6g}',c) for p,d,m,c in zip(phases,delay,means,counts)],['.21\\linewidth']*4))
    if historical_mode:
        section('Internal CFD DAC B/C/D characteristics')
        data=read(root/'cfd-dacs/analysis.json')
        text('Physical channel 12 only. First attempted restoration using computed STORED parameters was rejected; explicit active-code 0000 restoration then reproduced initial voltages. The original failed attempt remains in the source evidence.')
        out.append(table(['DAC','Signal','Start [V]','End [V]'],[(k,v['signal'],v['volts'][0],v['volts'][-1]) for k,v in data['curves'].items()],['.12\\linewidth','.35\\linewidth','.21\\linewidth','.21\\linewidth']))
    if chapter=='full':
        if historical_mode:
            section('Static connection results')
            text('Results follow the static connection procedure in the test-procedure chapter. All rows below share one discovery and schematic revision; at-speed and analog tests are documented separately.')
            out.append(connection_table(read(root/'jtag/gateware-decoded.json'),read(root/'jtag/boundary-decoded.json'),read(root/'pinmap.json')))
        else:
            for batch,record in loaded:
                for step in record['steps']:
                    path=batch/step.get('instance','')/'data/diagnostic/report.json'
                    if step['id']!='jtag-boundary' or not path.exists():continue
                    report=read(path)
                    if not all(k in report for k in ['gateware','boundary']):continue
                    pinmap=read(HERE.parent/'pinmap.json')
                    if report.get('schematic_sha256')!=pinmap['schematic_sha256']:
                        raise ValueError('Connection table schematic does not match acquisition provenance')
                    section('Static connection results — '+batch.name)
                    out.append(connection_table(report['gateware'],report['boundary'],pinmap))
    if extended:
        section('Per-channel ADC test cards')
        # One card per physical channel and ADC; missing analog coverage stays explicit.
        digital=read(root/'system/safe-cli-03.json')['suites']['adc']['tests'] if historical_mode and chapter=='full' else []
        for ch in range(1,13):
            for bi,bank in enumerate('AB'):
                out.append('\\clearpage\n\\subsection*{'+tex(f'Physical channel {ch:02d} — ADC {bank}')+'}\n')
                entry=summary['channels'].get(str(ch),{});a=entry.get('adc',{}).get('banks',{}).get(bank)
                if digital:
                    out.append(table(['Digital capture','Recorded result'],[(('Synthetic' if t['synthetic'] else 'Physical')+' bank'+str(t['bank']),'; '.join(f'{k}={v}' for k,v in next(c for c in t['channels'] if c['channel']==ch).items() if k in ('kind','samples','strobe_edges','strobe_period_samples','minimum','maximum','ev_tag'))) for t in digital if t['bank']==bi]))
                if not a:
                    text('Analog characterization NOT MEASURED. No CFD analog acceptance is inferred from synthetic transport or a free-running physical ADC buffer. Fit/route the simulator and collect this channel in a later batch.')
                    continue
                out.append(table(['Analog line exercise','Observed'],[(k,a[k]) for k in ['pass_','distinct_settings','interior_samples','visited_codes','stimulus_adequate']]))
                out.append(table(['Bit','Zero samples','One samples','Result'],[(b['bit'],*b['counts'],b['status']) for b in a['bits']],['.12\\linewidth','.25\\linewidth','.25\\linewidth','.25\\linewidth']))
                out.append(table(['Pair','00 / 01 / 10 / 11 counts','Result'],[(str(p['bits']),str(p['counts']),p['status']) for p in a['adjacent_pairs']],['.18\\linewidth','.50\\linewidth','.21\\linewidth']))
                text('Every displayed statistic was regenerated from the scan report and independently checked against retained raw STR-decoded buffers. Raw input hashes are in the evidence manifest. Missing finite-grid codes alone do not fail this test.')
    if summary.get('failed_captures'):
        section('Rejected raw captures and open findings')
        for failed in summary['failed_captures']:
            out.append(table(['Captured field','Observed'],flatten_json(failed)))
            if failed.get('figure'):fig(failed['figure'],'Rejected buffer retained without relaxing the acceptance guard. A sampled timing failure alone does not identify a physical component fault.')
    section('Raw data, reproducibility and review')
    out.append(table(['Batch','Mode / original status'],[(p.name,r['mode']+' / '+r['status']) for p,r in loaded]))
    text('The inputs directory retains complete evidence bundles. files.sha256.json lists every file hash and size. Generated figures retain their offline analysis JSON. Edit report.tex for typography and content.tex for this report; edit the source template for future reports. Rebuilding figures does not contact instruments.')
    text('Review checklist: verify factory UID and photographs; confirm pin-level cabling; approve numerical acceptance limits and calibration status; review every failure and deviation; confirm channel coverage and cleanup; retain raw records with this signed PDF.')
    text('No result is an assertion that the hardware is free of every possible defect. The evidence defines tested behavior, test conditions and observed limitations. This dossier is not a substitute for the separate CERN-equivalent detector validation bench.')
    return ''.join(out)


def compile_pdf(out,engine):
    exe=Path(engine).name
    if exe.startswith('tectonic'):
        command=[engine,'--keep-logs','--keep-intermediates','report.tex']
        times=1
    else:
        command=[engine,'-interaction=nonstopmode','-halt-on-error','-file-line-error','report.tex'];times=2
    with (out/'latex-console.log').open('w') as log:
        for _ in range(times):subprocess.run(command,cwd=out,stdout=log,stderr=subprocess.STDOUT,check=True,timeout=240)
    if not (out/'report.pdf').is_file():raise RuntimeError('LaTeX did not produce PDF')


def generate(runs,out,inventory_path=None,engine=None,extended=False,chapter='full',bench_config=None):
    loaded,_=gather(runs) # Reject mismatches before copying anything.
    out.mkdir(parents=True,exist_ok=False)
    inputs=out/'inputs';inputs.mkdir()
    copied=[]
    for i,(p,_) in enumerate(loaded):
        dest=inputs/f'{i:02d}-{p.name}';shutil.copytree(p,dest);copied.append(dest)
    loaded,datasets=gather(copied)
    summary=build_plots(datasets,out/'figures',bench_config)
    summary['failed_captures']=plot_failures(loaded,out/'figures')
    inventory=read(inventory_path) if inventory_path else loaded[0][1].get('station',read(HERE/'profiles/optiplex.example.json'))
    (out/'photos').mkdir()
    for i,module in enumerate(inventory.get('modules',[])):
        if module.get('photo'):
            p=Path(module['photo'])
            if not p.is_absolute():p=(inventory_path.parent if inventory_path else Path.cwd())/p
            if not p.is_file():raise ValueError('Missing declared photo: '+str(p))
            if p.suffix.lower() not in ('.jpg','.jpeg','.png','.pdf'):raise ValueError('Photo must be PNG/JPEG/PDF')
            dest=out/'photos'/f'module-{i:02d}{p.suffix.lower()}';shutil.copy2(p,dest)
            module['_photo']=str(dest.relative_to(out));module['_photo_sha256']=sha(dest)
    inventory['_figures']=str(out/'figures')
    uid=loaded[0][1]['board_uid'];mode=loaded[0][1]['mode']
    values={'ReportUID':uid,'ReportMode':mode+' — '+chapter+' dossier','ReportDate':utc(),'ReportVerdict':('FAIL / NOT RELEASED' if any(r['status']=='FAIL' for _,r in loaded) else 'INCOMPLETE / NOT RELEASED'),'ReportScope':('Historical multi-date engineering evidence. Factory DNA was not recorded during these measurements. This is not a new batch acceptance certificate.' if mode=='HISTORICAL' else 'Selected live evidence. Unmeasured channels and unqualified tests remain explicit. Final acceptance requires complete reviewed coverage.')}
    (out/'metadata.tex').write_text(''.join('\\newcommand{\\'+k+'}{'+tex(v)+'}\n' for k,v in values.items()))
    shutil.copy2(HERE/'templates/report.tex',out/'report.tex')
    (out/'content.tex').write_text(content(loaded,summary,inventory,extended,chapter).rstrip()+'\n')
    write(out/'chapter.json',dict(schema=1,name=chapter,board_uid=uid,mode=mode,input_runs=[str(p.relative_to(out)) for p in copied],extended=extended))
    if engine:compile_pdf(out,engine)
    write(out/'files.sha256.json',files_manifest(out))
    return out


def compose(chapters,out,engine=None,allow_edited_tex=False):
    # Include the editable chapter sources, not freshly regenerated substitutes.
    runs=[];seen=set();edits=[]
    for chapter in chapters:
        verify(chapter,allow_edited_tex)
        manifest=read(chapter/'files.sha256.json')
        for name,item in manifest.items():
            p=chapter/name
            if p.is_file() and sha(p)!=item['sha256']:
                edits.append(dict(chapter=str(chapter),file=name,original_sha256=item['sha256'],edited_sha256=sha(p)))
        meta=read(chapter/'chapter.json')
        for name in meta['input_runs']:
            p=chapter/name
            key=sha(p/'files.sha256.json')
            if key not in seen:runs.append(p);seen.add(key)
    loaded,_=gather(runs)
    uid=loaded[0][1]['board_uid'];mode=loaded[0][1]['mode']
    out.mkdir(parents=True,exist_ok=False)
    parts=out/'chapters';parts.mkdir()
    included=[];inputs=[]
    for i,chapter in enumerate(chapters):
        target=parts/f'{i:02d}'
        shutil.copytree(chapter,target)
        included.append(r'\subimport{chapters/'+f'{i:02d}'+r'/}{content.tex}')
        inputs.extend(str((target/name).relative_to(out)) for name in read(target/'chapter.json')['input_runs'])
    shutil.copy2(HERE/'templates/report.tex',out/'report.tex')
    values={'ReportUID':uid,'ReportMode':mode+' — assembled chapters','ReportDate':utc(),'ReportVerdict':('FAIL / NOT RELEASED' if any(r['status']=='FAIL' for _,r in loaded) else 'INCOMPLETE / NOT RELEASED'),'ReportScope':'Editable chapters included verbatim. Integrity-checked source measurements remain separate from editorial changes.'}
    (out/'metadata.tex').write_text(''.join('\\newcommand{\\'+k+'}{'+tex(v)+'}\n' for k,v in values.items()))
    (out/'content.tex').write_text('\\section{Assembled chapters}\n'+table(['Chapter','Source'],[(read(p/'chapter.json')['name'],p.name) for p in chapters])+'\n'.join(included)+'\n')
    write(out/'editorial-changes.json',edits)
    write(out/'chapter.json',dict(schema=1,name='assembled',board_uid=uid,mode=mode,input_runs=inputs))
    if engine:compile_pdf(out,engine)
    write(out/'files.sha256.json',files_manifest(out))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    sub=p.add_subparsers(dest='action',required=True)
    h=sub.add_parser('historical');h.add_argument('--out',type=Path,required=True)
    for name in ('chapter','report'):
        c=sub.add_parser(name);c.add_argument('--runs',nargs='+',type=Path)
        c.add_argument('--chapters',nargs='+',type=Path)
        c.add_argument('--out',type=Path,required=True);c.add_argument('--inventory',type=Path)
        c.add_argument('--bench-config',type=Path,help='Declarative diagram JSON; archived with generated figures')
        c.add_argument('--latex',help='pdflatex or tectonic executable; omit to generate editable sources only')
        c.add_argument('--allow-edited-tex',action='store_true',help='Accept and record editorial .tex changes; raw inputs must remain exact')
        c.add_argument('--extended',action='store_true',help='Individual ADC channel cards; connections always use one consolidated table')
        if name=='chapter':c.add_argument('--name',choices=['cfd','full'],default='cfd')
    a=p.parse_args()
    if a.action=='historical':historical(a.out);print(a.out);return
    if a.action=='report' and a.chapters:
        if a.bench_config:p.error('--bench-config applies when generating from --runs; assembled chapters retain their own diagrams')
        if a.runs:p.error('Use either --runs to regenerate or --chapters to preserve edited chapter sources')
        compose([v.resolve() for v in a.chapters],a.out.resolve(),a.latex,a.allow_edited_tex)
        print(a.out);return
    runs=a.runs or []
    for chapter in a.chapters or []:
        verify(chapter)
        meta=read(chapter/'chapter.json')
        runs.extend(chapter/v for v in meta['input_runs'])
    if not runs:p.error('Supply --runs or --chapters')
    generate([v.resolve() for v in runs],a.out.resolve(),a.inventory,a.latex,a.extended,a.name if a.action=='chapter' else 'full',a.bench_config)
    print(a.out)

if __name__=='__main__':main()

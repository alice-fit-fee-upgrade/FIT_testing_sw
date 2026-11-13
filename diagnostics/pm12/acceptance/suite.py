#!/usr/bin/env python3
"""Collect sequential PM12 evidence; render separately after any number of batches."""
import argparse
import contextlib
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import signal
import subprocess
import sys
import time
from lease import acquire, ENV
from identity import register

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]


def utc():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024*1024), b''): h.update(block)
    return h.hexdigest()


def write(path, value):
    path = Path(path)
    temp = path.with_suffix(path.suffix+'.tmp')
    temp.write_text(json.dumps(value, indent=2, allow_nan=False)+'\n')
    os.replace(temp, path)


def files_manifest(directory):
    return {str(p.relative_to(directory)):dict(bytes=p.stat().st_size, sha256=sha(p))
            for p in sorted(directory.rglob('*')) if p.is_file() and p.name != 'files.sha256.json'}


def lookup(obj, path):
    for key in path.split('.'):
        obj = obj[int(key)] if isinstance(obj, list) else obj[key]
    return obj


def verdict(directory, checks):
    """A process exit of zero is insufficient: every explicit result check must pass."""
    if not checks: raise ValueError('No result checks configured')
    for check in checks:
        path = (directory/check['file']).resolve()
        if not path.is_relative_to(directory.resolve()): raise ValueError('Result path escapes output')
        value = lookup(json.loads(path.read_text()), check['key'])
        if type(value) is not type(check['equals']) or value != check['equals']:
            return 'FAIL', f"{check['file']}:{check['key']}={value!r}; expected {check['equals']!r}"
    return 'PASS', None


def expand(value, variables):
    # Literal token replacement, argv only, never a shell. Unresolved tokens are errors.
    for key, val in variables.items(): value = value.replace('{'+key+'}', str(val))
    if re.search(r'\{[a-z_]+\}', value): raise ValueError('Unresolved command token: '+value)
    return value


def execute_step(step, directory, variables, fds):
    command = [expand(arg, variables) for arg in step['command']]
    record = dict(id=step['id'], title=step['title'], started_utc=utc(), command=command,
                  channel=variables.get('channel'), status='ERROR', checks=step['checks'],
                  procedure=step['procedure'], limits=step['limits'])
    directory.mkdir(parents=True)
    try:
        with (directory/'console.log').open('w') as log:
            child = subprocess.Popen(command, cwd=REPO, stdout=log, stderr=subprocess.STDOUT,
                                     pass_fds=fds)
            record['pid']=child.pid
            write(directory/'step.json',record)
            try:
                record['returncode'] = child.wait(timeout=step.get('timeout_s', 1800))
            except (subprocess.TimeoutExpired, KeyboardInterrupt):
                # SIGINT permits Python test cleanup. Never automatically SIGKILL a board test.
                child.send_signal(signal.SIGINT)
                try: child.wait(timeout=60)
                except subprocess.TimeoutExpired:
                    record['cleanup_status'] = 'UNKNOWN; process still alive, leases retained by child'
                    raise RuntimeError('Test did not stop after SIGINT; inspect hardware before any next test')
                raise
        if record['returncode'] != 0:
            record['status'], record['error'] = 'ERROR', 'Test process exited nonzero'
        else:
            record['status'], error = verdict(directory, step['checks'])
            if error: record['error'] = error
    except (Exception, KeyboardInterrupt) as error:
        record['error'] = repr(error)
    record['finished_utc'] = utc()
    write(directory/'step.json', record)
    return record


def collect(station_path, plan_path, output, channels):
    cfg = json.loads(station_path.read_text())
    plan = json.loads(plan_path.read_text())
    if not cfg.get('board_uid'): raise ValueError('Enroll hardware DNA first; EEPROM/cable serial is insufficient')
    if not channels or len(set(channels)) != len(channels) or len(channels)>4 or any(x not in range(1,13) for x in channels):
        raise ValueError('A CFD acquisition batch contains 1..4 distinct channels in 1..12')
    output = output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    shutil.copy2(station_path, output/'station.json')
    shutil.copy2(plan_path, output/'plan.json')
    (output/'sources').mkdir()
    # Retain exact sources across local station dependencies, not just Git HEAD.
    for label, root in [('acceptance', HERE), ('cfd', HERE.parent/'cfd_simulator'),
                        ('ipbus', HERE.parent/'ipbus_adc'), ('kasli-host', Path(cfg['kasli_root'])/'host'),
                        ('mcu-host', Path(cfg['console_tools']))]:
        dest = output/'sources'/label
        dest.mkdir()
        for source in sorted(root.glob('*.py'))+sorted(root.glob('*.tcl')):
            shutil.copy2(source, dest/source.name)
    result = dict(schema=1, mode='LIVE', run_id=output.name, board_uid=cfg['board_uid'],
                  board_serial=str(cfg['board_serial']), channels=channels, started_utc=utc(),
                  status='INCOMPLETE', steps=[], plan=plan, station=cfg,
                  configuration=dict(cfg['measurement_configuration'],per_channel_protocols=[s for s in plan['steps'] if s.get('per_channel')]),
                  source_fingerprint=hashlib.sha256(json.dumps(files_manifest(output/'sources'),sort_keys=True).encode()).hexdigest())
    write(output/'run.json', result)
    variables = dict(repo=REPO, python=cfg['python'], station=output/'station.json',
                     board_serial=cfg['board_serial'], kasli_root=cfg['kasli_root'])
    failed = False
    # Own the actual hardware locks for the entire sequential run; children inherit
    # their open descriptions. Independently started threads see these as busy.
    try:
        with contextlib.ExitStack() as st:
            leases = [st.enter_context(acquire(Path.home()/'.cache'/(name+'.lock')))
                      for name in sorted(cfg['run_leases'])]
            os.environ[ENV] = json.dumps({str((Path.home()/'.cache'/(name+'.lock')).resolve()):f.fileno()
                                        for name,f in zip(sorted(cfg['run_leases']),leases)})
            st.callback(os.environ.pop, ENV, None)
            fds = tuple(f.fileno() for f in leases)
            for spec in plan['steps']:
                targets = channels if spec.get('per_channel') else [None]
                for channel in targets:
                    step = dict(spec)
                    sid = spec['id']+(f'-ch{channel:02d}' if channel else '')
                    variables.update(channel=channel, output=output/sid/'data')
                    reason = spec.get('blocked')
                    wiring = cfg.get('channels', {}).get(str(channel), {}) if channel else {}
                    if channel:
                        variables['dac_positive'],variables['dac_negative']=wiring.get('dac_channels',[0,1])
                        variables['lanes'] = ','.join(map(str,wiring.get('phase_lanes', [])))
                        if spec['id'] == 'adc-lines' and not wiring.get('analog_connected'):
                            reason = 'External DAC pair not declared connected to this channel'
                        if spec['id'] == 'gate-phase' and not wiring.get('phase_lanes'):
                            reason = 'No confirmed phase-input mapping for this channel'
                    if failed: reason = 'Earlier failure; later hardware tests inhibited'
                    if reason:
                        row = dict(id=spec['id'], instance=sid, title=spec['title'], channel=channel,
                                   status='BLOCKED' if failed else 'NOT_RUN', reason=reason,
                                   procedure=spec['procedure'], limits=spec['limits'])
                    else:
                        print('START', sid, flush=True)
                        row = execute_step(step, output/sid, variables, fds)
                        row['instance'] = sid
                        print(sid, row['status'], flush=True)
                        if spec['id'] == 'identity' and row['status'] == 'PASS':
                            identity = json.loads((output/sid/'data/result.json').read_text())['identity']
                            result['identity'] = identity
                            if identity['uid'] != cfg['board_uid']:
                                row['status'] = 'ERROR'; row['error'] = 'Wrong physical DNA'
                        failed |= row['status'] != 'PASS'
                    result['steps'].append(row)
                    write(output/'run.json', result)
    except (Exception,KeyboardInterrupt) as error:
        failed=True
        result['error']=repr(error)
        done={row['instance'] for row in result['steps']}
        for spec in plan['steps']:
            for channel in (channels if spec.get('per_channel') else [None]):
                sid=spec['id']+(f'-ch{channel:02d}' if channel else '')
                if sid not in done:
                    result['steps'].append(dict(id=spec['id'],instance=sid,title=spec['title'],channel=channel,
                                                status='BLOCKED',reason='Run interrupted or hardware lease unavailable'))
    all_pass = all(s['status']=='PASS' for s in result['steps'])
    result['status'] = 'PASS' if all_pass else ('FAIL' if failed else 'INCOMPLETE')
    result['finished_utc'] = utc()
    # PASS here is only the selected batch/plan, never whole-board acceptance.
    result['scope'] = 'Selected plan and fitted channels only; final report checks required coverage separately'
    write(output/'run.json', result)
    write(output/'files.sha256.json', files_manifest(output))
    return result


def main():
    p = argparse.ArgumentParser(description=__doc__)
    sub = p.add_subparsers(dest='action', required=True)
    c = sub.add_parser('collect')
    c.add_argument('--station',type=Path,required=True)
    c.add_argument('--plan',type=Path,default=HERE/'profiles/resident.json')
    c.add_argument('--channels',type=int,nargs='+',required=True)
    c.add_argument('--out',type=Path,required=True)
    e = sub.add_parser('enroll')
    e.add_argument('--station',type=Path,required=True)
    e.add_argument('--out',type=Path,required=True)
    e.add_argument('--registry',type=Path,required=True)
    a=p.parse_args()
    if a.action=='collect':
        result=collect(a.station,a.plan,a.out,a.channels)
        print(result['status'],a.out/'run.json')
        return 0 if result['status']=='PASS' else 1
    cfg=json.loads(a.station.read_text())
    cfg.pop('board_uid',None)
    a.out.mkdir(parents=True,exist_ok=False)
    write(a.out/'station-input.json',cfg)
    subprocess.run([cfg['python'],str(HERE/'station.py'),'identity','--station',str(a.out/'station-input.json'),
                    '--out',str(a.out/'identity')],check=True)
    row=json.loads((a.out/'identity/result.json').read_text())
    uid=register(a.registry,row['identity'])
    cfg['board_uid']=uid
    cfg['board_serial']=row['identity']['mcu_eeprom_serial']
    cfg['asset_label']=cfg.get('asset_label') or uid
    for module in cfg.get('modules',[]):
        if module.get('role')=='DUT':
            module['hardware_uid']=uid
            module['eeprom_serial']=cfg['board_serial']
            module['identity_source']='Factory FPGA DNA observed during this enrollment'
    write(a.out/'station-enrolled.json',cfg)
    print(uid,a.out/'station-enrolled.json')
    return 0

if __name__=='__main__':
    raise SystemExit(main())

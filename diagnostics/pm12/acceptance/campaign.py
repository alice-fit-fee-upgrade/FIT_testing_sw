#!/usr/bin/env python3
"""Offline registry for three four-CFD batches and immutable test evidence.

This module never opens a board or instrument. Hardware runners keep their
existing leases; a fresh identity receipt binds each fitted batch to the board.
"""
import argparse
import contextlib
import datetime as dt
import fcntl
import hashlib
import json
import math
import os
from pathlib import Path
import shutil
import uuid

HERE = Path(__file__).resolve().parent


def utc():
    return dt.datetime.now(dt.timezone.utc).isoformat()


def read(path):
    return json.loads(Path(path).read_text())


def write(path, obj):
    path = Path(path)
    tmp = path.with_suffix(path.suffix + '.tmp')
    tmp.write_text(json.dumps(obj, indent=2, allow_nan=False) + '\n')
    os.replace(tmp, path)


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def fingerprint(obj):
    return hashlib.sha256(json.dumps(obj, sort_keys=True, allow_nan=False).encode()).hexdigest()


def inventory(root):
    result = {}
    for p in sorted(root.rglob('*')):
        if p.is_symlink():
            raise ValueError('Evidence may not contain symlinks')
        if p.is_file() and p != root/'files.sha256.json':
            result[str(p.relative_to(root))] = digest(p)
    return result


def verify(root):
    expected = read(root / 'files.sha256.json')
    if inventory(root) != expected:
        raise ValueError('Evidence integrity mismatch: ' + str(root))


def consecutive(channels):
    return channels in ([1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12])


def initialize(root, board_uid, serial, protocol=None):
    from identity import canonical_dna
    prefix = 'PM12-K7-'
    if not board_uid.startswith(prefix) or prefix + canonical_dna(board_uid[len(prefix):]) != board_uid:
        raise ValueError('Canonical factory-DNA board UID required')
    spec = read(protocol or HERE / 'profiles/campaign-four-cfd.json')
    tests = spec['tests']
    if not tests or not any(t.get('required',True) for t in tests):
        raise ValueError('A campaign needs a nonempty required test scope')
    if len({t['id'] for t in tests}) != len(tests) or any(t['scope'] not in ('board', 'channel') for t in tests):
        raise ValueError('Invalid test matrix')
    root.mkdir(parents=True, exist_ok=False)
    write(root / 'protocol.json', spec)
    data = dict(schema=1, campaign_id=str(uuid.uuid4()), board_uid=board_uid,
                board_serial=str(serial), created_utc=utc(), protocol_sha256=digest(root/'protocol.json'),
                fixtures=[dict(id=f'CFD{i+1:02d}', slot=7, port=i, physical_uid=None,
                               identity_status='PROVISIONAL bench label; confirm attachment at each fitting') for i in range(4)],
                batches=[], results=[], selected={}, contracts={})
    write(root/'campaign.json', data)
    return data


class Campaign:
    def __init__(self, root):
        self.root = Path(root).resolve()

    @contextlib.contextmanager
    def locked(self):
        with (self.root/'.campaign.lock').open('a+') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self.data = read(self.root/'campaign.json')
            if digest(self.root/'protocol.json') != self.data['protocol_sha256']:
                raise ValueError('Frozen protocol changed; create a new campaign revision')
            self.protocol = read(self.root/'protocol.json')
            yield

    def save(self):
        write(self.root/'campaign.json', self.data)

    def batch(self, batch_id):
        row = next((b for b in self.data['batches'] if b['id'] == batch_id), None)
        if row is None:
            raise ValueError('Unknown fitted batch')
        directory = self.root/row['path']
        if digest(directory/'batch.json') != row['sha256']:
            raise ValueError('Batch mapping changed')
        return directory, read(directory/'batch.json')

    def prepare(self, start, mapping=None, station=None):
        channels = list(range(start, start+4))
        if not consecutive(channels):
            raise ValueError('Allowed fitted groups: 1-4, 5-8, 9-12')
        with self.locked():
            assignments = mapping or {str(ch): f'CFD{i+1:02d}' for i, ch in enumerate(channels)}
            if set(assignments) != set(map(str, channels)) or set(assignments.values()) != {f['id'] for f in self.data['fixtures']}:
                raise ValueError('Map exactly these four channels to four distinct CFD fixtures')
            previous = [b for b in self.data['batches'] if b['start'] == start]
            bid = f'ch{start:02d}-{start+3:02d}-attempt{len(previous)+1:03d}'
            cfg=read(station) if station else None
            if cfg and cfg.get('board_uid') != self.data['board_uid']:
                raise ValueError('Station must be enrolled for this board')
            directory = self.root/'batches'/bid
            directory.mkdir(parents=True, exist_ok=False)
            row = dict(schema=1, id=bid, campaign_id=self.data['campaign_id'], board_uid=self.data['board_uid'],
                       channels=channels, assignments=assignments, prepared_utc=utc(),
                       identity_status='UNVERIFIED; fitting and live identity required',
                       connections={str(ch): self.fixture_route(assignments[str(ch)]) for ch in channels})
            write(directory/'batch.json', row)
            if cfg is not None:
                cfg['channels'] = {str(ch): dict(phase_lanes=row['connections'][str(ch)]['phase_lanes'],
                                               dac_channels=[0,1], analog_connected=False,
                                               fixture_id=assignments[str(ch)]) for ch in channels}
                cfg['stimulated_channel'] = channels[0]
                cfg['campaign_id'] = self.data['campaign_id']
                cfg['batch_id'] = bid
                write(directory/'station.json', cfg)
            self.data['batches'].append(dict(id=bid, start=start, path=str(directory.relative_to(self.root)),
                                            sha256=digest(directory/'batch.json')))
            self.save()
            return row

    def fixture_route(self, fixture):
        f = next(f for f in self.data['fixtures'] if f['id'] == fixture)
        return dict(fixture_id=fixture, slot=f['slot'], rj45_port=f['port'],
                    stimulus_pair=4*f['port'], phase_lanes=[8+2*f['port'],9+2*f['port']],
                    route_status='DECLARED; verify physically before enabling outputs',
                    physical_fixture_uid=f['physical_uid'])

    def bind_identity(self, bid, identity_file, fitting_note, mapping=None):
        with self.locked():
            directory, batch = self.batch(bid)
            if (directory/'identity.json').exists():
                raise ValueError('Identity is immutable; prepare a new fitting attempt')
            receipt = read(identity_file)
            identity = receipt.get('identity', {})
            if receipt.get('status') != 'PASS' or identity.get('uid') != self.data['board_uid']:
                raise ValueError('Fresh successful identity for this board required')
            if str(identity.get('mcu_eeprom_serial')) != self.data['board_serial']:
                raise ValueError('Wrong MCU serial')
            observed = dt.datetime.fromisoformat(identity['observed_utc'].replace('Z','+00:00'))
            prepared = dt.datetime.fromisoformat(batch['prepared_utc'])
            if observed.tzinfo is None or observed < prepared:
                raise ValueError('Identity predates this fitting')
            if not fitting_note.strip():
                raise ValueError('Record owner fitting declaration and actual cable mapping')
            if mapping is not None:
                if set(mapping)!=set(map(str,batch['channels'])) or set(mapping.values())!={f['id'] for f in self.data['fixtures']}:
                    raise ValueError('Discovered mapping must cover the four fitted channels and fixtures exactly')
                write(directory/'mapping-declared.json',batch)
                batch['assignments']=mapping
                batch['connections']={ch:self.fixture_route(fixture) for ch,fixture in mapping.items()}
                batch['mapping_status']='Operator/discovery-confirmed at identity binding'
                write(directory/'batch.json',batch)
                row=next(b for b in self.data['batches'] if b['id']==bid)
                row['sha256']=digest(directory/'batch.json')
                if (directory/'station.json').exists():
                    cfg=read(directory/'station.json')
                    for ch,fixture in mapping.items():
                        cfg['channels'][ch]['fixture_id']=fixture
                        cfg['channels'][ch]['phase_lanes']=batch['connections'][ch]['phase_lanes']
                    write(directory/'station.json',cfg)
            write(directory/'identity.json', receipt)
            write(directory/'fitting.json', dict(confirmed_utc=utc(), note=fitting_note,
                                               identity_sha256=digest(directory/'identity.json')))
            row = next(b for b in self.data['batches'] if b['id'] == bid)
            row['fitting_sha256'] = digest(directory/'fitting.json')
            self.save()

    def check_identity(self, directory, batch):
        row = next(b for b in self.data['batches'] if b['id'] == batch['id'])
        if not row.get('fitting_sha256') or digest(directory/'fitting.json') != row['fitting_sha256']:
            raise ValueError('Fitted batch has no confirmed identity/mapping')
        f = read(directory/'fitting.json')
        if digest(directory/'identity.json') != f['identity_sha256']:
            raise ValueError('Fitting identity integrity mismatch')

    def record(self, bid, source, receipt='campaign-result.json'):
        source = Path(source).resolve()
        receipt_file = (source/receipt).resolve()
        if not receipt_file.is_relative_to(source):
            raise ValueError('Receipt escapes evidence source')
        incoming = read(receipt_file)
        with self.locked():
            directory, batch = self.batch(bid)
            self.check_identity(directory, batch)
            if incoming.get('mode')!='LIVE':
                raise ValueError('Historical evidence belongs in a separate appendix')
            measured=dt.datetime.fromisoformat(incoming['measured_utc'].replace('Z','+00:00'))
            identity_time=dt.datetime.fromisoformat(read(directory/'identity.json')['identity']['observed_utc'].replace('Z','+00:00'))
            if measured.tzinfo is None or measured<identity_time or measured>dt.datetime.now(dt.timezone.utc)+dt.timedelta(minutes=5):
                raise ValueError('Measurement predates identity or has an invalid time')
            spec = next((t for t in self.protocol['tests'] if t['id']==incoming['test']), None)
            if spec is None or incoming['board_uid'] != self.data['board_uid']:
                raise ValueError('Unknown test or wrong board')
            channel = incoming.get('channel')
            if spec['scope']=='board':
                if channel is not None:
                    raise ValueError('Board-wide evidence cannot be relabeled as a channel test')
            elif type(channel) is not int or channel not in batch['channels'] or incoming.get('fixture_id') != batch['assignments'][str(channel)]:
                raise ValueError('Channel/fixture does not belong to fitted batch')
            if incoming['status'] not in ('PASS','FAIL','ERROR','INCOMPLETE'):
                raise ValueError('Invalid evidence status')
            if not incoming.get('source_files') or not incoming.get('protocol'):
                raise ValueError('Executed sources and measurement protocol are required')
            sources={}
            for name in incoming['source_files']:
                p=(source/name).resolve()
                if not p.is_relative_to(source) or p.is_symlink() or not p.is_file():
                    raise ValueError('Invalid executed source snapshot')
                sources[name]=digest(p)
            contract=dict(protocol=incoming['protocol'], sources=sources)
            old=self.data['contracts'].get(incoming['test'])
            if incoming['status']=='PASS':
                hw=incoming['protocol'].get('hardware_configuration',{})
                if any(not hw.get(key) or str(hw[key]).upper()=='UNKNOWN' for key in self.protocol.get('hardware_configuration_fields',[])):
                    raise ValueError('Successful evidence needs explicit hardware/clock configuration')
            if incoming['status']=='PASS' and old is not None and old!=contract:
                raise ValueError('Different protocol or source version; use another campaign revision')
            metrics=incoming.get('metrics',[]);curves=incoming.get('curves',[])
            units={}
            for metric in metrics:
                if not metric.get('unit') or type(metric['value']) not in (int,float) or not math.isfinite(metric['value']):
                    raise ValueError('Metric needs explicit units and a finite value')
                key=('metric',metric['name'],metric.get('bank',''))
                if key in units:
                    raise ValueError('Duplicate scalar metric')
                units[key]=metric['unit']
            for curve in curves:
                if not curve.get('x_unit') or not curve.get('y_unit') or not curve['x'] or len(curve['x'])!=len(curve['y']):
                    raise ValueError('Curve units and matching arrays required')
                if any(type(v) not in (int,float) or not math.isfinite(v) for v in curve['x']+curve['y']):
                    raise ValueError('Nonfinite curve')
                if any(a>=b for a,b in zip(curve['x'],curve['x'][1:])):
                    raise ValueError('Curve stimulus must increase; reduce repeats explicitly')
                key=('curve',curve['name'],curve.get('bank',''))
                if key in units:
                    raise ValueError('Duplicate curve')
                units[key]=(curve['x_unit'],curve['y_unit'])
            new_units={json.dumps([incoming['test'],*key]):list(value) if isinstance(value,tuple) else value for key,value in units.items()}
            for key,value in new_units.items():
                previous=self.data.get('observable_units',{}).get(key)
                if incoming['status']=='PASS' and previous is not None and previous!=value:
                    raise ValueError('Observable units changed across channels')
            for name in incoming.get('photos',[]):
                photo=(source/name).resolve()
                if not photo.is_relative_to(source) or not photo.is_file() or photo.suffix.lower() not in ('.png','.jpg','.jpeg','.pdf'):
                    raise ValueError('Photo must be an evidence-local PNG/JPEG/PDF')
            # Measurement conditions (USB route, DAC pair, epoch) belong to this
            # individual record, never to the frozen comparison contract.
            if incoming['test'] in ('integrator','adc-dc','adc-lines'):
                route=incoming.get('connections',{})
                expected='J6' if incoming['test']=='integrator' else 'J8'
                if route.get('usb_input')!=expected or route.get('stimulus_channel')!=channel:
                    raise ValueError('Analog stimulus routing is not confirmed for this channel')
            if incoming['status']=='PASS':
                if channel is not None:
                    proofs=incoming.get('channel_checks',[])
                    if not proofs:raise ValueError('PASS requires raw channel evidence')
                    for check in proofs:
                        path=(source/check['file']).resolve()
                        if not path.is_relative_to(source):raise ValueError('Channel proof path escapes source')
                        value=read(path)
                        for key in check['key'].split('.'):
                            value=value[int(key)] if isinstance(value,list) else value[key]
                        if not (type(value) is int and value==channel or isinstance(value,list) and any(type(item) is int and item==channel for item in value)):
                            raise ValueError('Raw source belongs to a different channel')
                checks=incoming.get('validation',[])
                if not checks:
                    raise ValueError('PASS requires explicit raw validator checks')
                for check in checks:
                    p=(source/check['file']).resolve()
                    if not p.is_relative_to(source):raise ValueError('Validation path escapes source')
                    val=read(p)
                    for key in check['key'].split('.'):
                        val=val[int(key)] if isinstance(val,list) else val[key]
                    if type(val) is not type(check['equals']) or val!=check['equals']:
                        raise ValueError('PASS contradicts raw validation result')
                for required in spec.get('required_observables',[]):
                    if not any(item['name']==required['name'] and item.get('bank','')==required.get('bank','') for item in metrics+curves):
                        raise ValueError('Required channel/bank observable absent')
            case=f"{incoming['test']}:{channel if channel is not None else 'board'}"
            # Never silently replace an earlier run, including FAIL or INCOMPLETE.
            if case in self.data['selected']:
                select=False
            else:
                select=True
            rid='result-'+uuid.uuid4().hex
            target=directory/'results'/rid
            if self.root.is_relative_to(source):
                raise ValueError('Cannot import the campaign itself')
            initial=inventory(source)  # rejects links before copy
            evidence_sha=fingerprint(initial)
            if any(row.get('evidence_sha256')==evidence_sha for row in self.data['results']):
                raise ValueError('This exact acquisition was already imported; it is not an independent repeat')
            shutil.copytree(source,target/'raw')
            retained=read(target/'raw'/receipt)
            if retained!=incoming:
                shutil.rmtree(target)
                raise ValueError('Source changed while importing')
            # Recheck every copied input against the complete initial snapshot.
            copied=inventory(target/'raw')
            if copied!=initial or inventory(source)!=initial:
                shutil.rmtree(target)
                raise ValueError('Evidence source changed while copying')
            for name,expected in sources.items():
                if digest(target/'raw'/name)!=expected:
                    shutil.rmtree(target)
                    raise ValueError('Executed source changed while importing')
            if incoming['status']=='PASS':
                for check in incoming['validation']:
                    val=read(target/'raw'/check['file'])
                    for key in check['key'].split('.'):
                        val=val[int(key)] if isinstance(val,list) else val[key]
                    if type(val) is not type(check['equals']) or val!=check['equals']:
                        shutil.rmtree(target)
                        raise ValueError('Copied validation contradicts PASS')
                for check in incoming.get('channel_checks',[]):
                    val=read(target/'raw'/check['file'])
                    for key in check['key'].split('.'):
                        val=val[int(key)] if isinstance(val,list) else val[key]
                    if not (type(val) is int and val==channel or isinstance(val,list) and any(type(item) is int and item==channel for item in val)):
                        shutil.rmtree(target)
                        raise ValueError('Copied source belongs to another channel')
            write(target/'record.json',dict(id=rid,batch_id=bid,campaign_id=self.data['campaign_id'],
                  recorded_utc=utc(),case=case,receipt=receipt,result=incoming,
                  comparison_status='COMPARABLE' if incoming['status']=='PASS' else 'FAILED_OR_PARTIAL_NOT_IN_OVERLAY',
                  connections=batch['connections'].get(str(channel),{})))
            write(target/'files.sha256.json',inventory(target))
            row=dict(id=rid,path=str(target.relative_to(self.root)),case=case,evidence_sha256=evidence_sha,manifest_sha256=digest(target/'files.sha256.json'))
            self.data['results'].append(row)
            if incoming['status']=='PASS':
                self.data['contracts'][incoming['test']]=contract
                self.data.setdefault('observable_units',{}).update(new_units)
            if select:self.data['selected'][case]=rid
            self.save()
            return dict(id=rid,selected=select,case=case)

    def select(self, rid):
        with self.locked():
            result=next(r for r in self.data['results'] if r['id']==rid)
            self.data['selected'][result['case']]=rid
            self.data.setdefault('selection_history',[]).append(dict(result_id=rid,utc=utc()))
            self.save()

    def summary(self):
        with self.locked():
            records={}
            for row in self.data['results']:
                root=self.root/row['path']
                if digest(root/'files.sha256.json')!=row['manifest_sha256']:
                    raise ValueError('Result manifest changed')
                verify(root)
                directory,batch=self.batch(read(root/'record.json')['batch_id'])
                self.check_identity(directory,batch)
                if self.data['selected'].get(row['case'])==row['id']:
                    records[row['case']]=read(root/'record.json')
            cases=[]
            for spec in self.protocol['tests']:
                for ch in (range(1,13) if spec['scope']=='channel' else [None]):
                    key=f"{spec['id']}:{ch if ch is not None else 'board'}"
                    record=records.get(key)
                    cases.append(dict(test=spec['id'],channel=ch,required=spec.get('required',True),
                                      status=record['result']['status'] if record else 'NOT_MEASURED',
                                      result_id=record['id'] if record else None))
            return dict(campaign_id=self.data['campaign_id'],board_uid=self.data['board_uid'],
                        status='COMPLETE_SELECTED_PROTOCOL' if all(c['status']=='PASS' for c in cases if c['required']) else 'INCOMPLETE',
                        cases=cases,records=records,fixtures=self.data['fixtures'],batches=self.data['batches'],
                        retained_results=len(self.data['results']))


def main():
    p=argparse.ArgumentParser(description=__doc__);sub=p.add_subparsers(dest='action',required=True)
    init=sub.add_parser('init');init.add_argument('--root',type=Path,required=True);init.add_argument('--board-uid',required=True);init.add_argument('--serial',required=True);init.add_argument('--protocol',type=Path)
    prepare=sub.add_parser('prepare');prepare.add_argument('--start',type=int,choices=[1,5,9],required=True);prepare.add_argument('--mapping',type=Path);prepare.add_argument('--station',type=Path)
    bind=sub.add_parser('bind');bind.add_argument('--mapping',type=Path);bind.add_argument('--batch',required=True);bind.add_argument('--identity',type=Path,required=True);bind.add_argument('--fitting-note',required=True)
    record=sub.add_parser('record');record.add_argument('--batch',required=True);record.add_argument('--source',type=Path,required=True);record.add_argument('--receipt',default='campaign-result.json')
    select=sub.add_parser('select');select.add_argument('--result',required=True)
    sub.add_parser('status')
    for parser in [prepare,bind,record,select,sub.choices['status']]:parser.add_argument('--root',type=Path,required=True)
    a=p.parse_args()
    if a.action=='init':result=initialize(a.root,a.board_uid,a.serial,a.protocol)
    else:
        c=Campaign(a.root)
        if a.action=='prepare':result=c.prepare(a.start,read(a.mapping) if a.mapping else None,a.station)
        elif a.action=='bind':c.bind_identity(a.batch,a.identity,a.fitting_note,read(a.mapping) if a.mapping else None);result={'identity_bound':a.batch}
        elif a.action=='record':result=c.record(a.batch,a.source,a.receipt)
        elif a.action=='select':c.select(a.result);result={'selected':a.result}
        else:result=c.summary();result.pop('records')
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()

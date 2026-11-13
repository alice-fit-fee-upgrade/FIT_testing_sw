"""Read-only connectivity aid for the checked-in Altium schematic records."""
import json
import math
from pathlib import Path
import sys

records = json.loads(Path(sys.argv[1]).read_text())
points = set()
segments = []
pins = []
labels = []
components = {}
parts = {str(i-1): r.get('CurrentPartId', '1') for i,r in enumerate(records) if r.get('RECORD') == '1'}
for i, r in enumerate(records):
    if r.get('RECORD') == '1':
        fields = {c.get('Name'): c.get('Text') for c in records if c.get('OwnerIndex') == str(i-1)}
        components[str(i-1)] = fields.get('Designator', r.get('LibReference'))
    if r.get('RECORD') == '27':
        p = [(int(r['X'+str(n)]), int(r['Y'+str(n)])) for n in range(1, int(r['LocationCount'])+1)]
        points.update(p)
        segments.extend(zip(p, p[1:]))
    if r.get('RECORD') in ('17', '18', '25'):
        p = (int(r['Location.X']), int(r['Location.Y']))
        points.add(p)
        labels.append((p, r.get('Text', r.get('Name'))))
    if r.get('RECORD') == '2' and 'Location.X' in r:
        if r.get('OwnerPartId', '1') != parts.get(r.get('OwnerIndex'), '1'):
            continue
        x, y = int(r['Location.X']), int(r['Location.Y'])
        direction = int(r.get('PinConglomerate', '0')) & 3
        length = int(r.get('PinLength', '0'))
        dx, dy = [(1, 0), (0, 1), (-1, 0), (0, -1)][direction]
        p = (x + length*dx, y + length*dy)
        points.add(p)
        pins.append((p, r))
    if r.get('RECORD') == '16' and 'Location.X' in r:
        p = (int(r['Location.X']), int(r['Location.Y']))
        points.add(p)
        pins.append((p, r))

parent = {p: p for p in points}
def find(p):
    while parent[p] != p:
        parent[p] = parent[parent[p]]
        p = parent[p]
    return p
def union(a, b):
    parent[find(a)] = find(b)
for a,b in segments:
    for p in points:
        if min(a[0],b[0]) <= p[0] <= max(a[0],b[0]) and min(a[1],b[1]) <= p[1] <= max(a[1],b[1]) and (p[0]-a[0])*(b[1]-a[1]) == (p[1]-a[1])*(b[0]-a[0]):
            union(a,p)
names = {}
for p,name in labels:
    if name in names: union(p,names[name])
    names[name] = p
for p,r in pins:
    ref = components.get(r.get('OwnerIndex'), 'SHEET:'+r.get('OwnerIndex','?'))
    net = sorted({name for q,name in labels if find(p)==find(q)})
    if not sys.argv[2:] or ref in sys.argv[2:]:
        print(ref, r.get('Designator', '?'), r.get('Name'), p, net)

"""Minimal VCD reader: returns per-cycle samples (taken at each falling clock edge)."""
import re

def load(path, scope, signals):
    ids, names, cur = {}, {}, []
    vals, changes = {}, []
    with open(path) as f:
        data = f.read()
    hdr, body = data.split('$enddefinitions', 1)
    for tok in re.finditer(r'\$scope \w+ (\S+) \$end|\$upscope|\$var \w+ (\d+) (\S+) (\S+)', hdr):
        if tok.group(1):
            cur.append(tok.group(1))
        elif tok.group(0) == '$upscope':
            cur.pop()
        else:
            path_ = '.'.join(cur[1:]) + '.' + tok.group(4)
            ids.setdefault(tok.group(3), []).append(path_)
    want = {f'{scope}.{s}': s for s in signals + ['clk']}
    idmap = {}
    for i, ps in ids.items():
        for p in ps:
            if p in want:
                idmap.setdefault(i, []).append(want[p])
    state = {s: None for s in want.values()}
    samples, t = [], 0
    lines = body.split('\n')
    for ln in lines:
        ln = ln.strip()
        if not ln or ln.startswith('$'):
            continue
        if ln[0] == '#':
            t = int(ln[1:]); continue
        if ln[0] in 'bB':
            v, i = ln[1:].split()
        else:
            v, i = ln[0], ln[1:]
        if i not in idmap:
            continue
        for s in idmap[i]:
            if s == 'clk' and state['clk'] == '1' and v == '0':
                samples.append(dict(state, _t=t))
            state[s] = v
    return samples

def num(v):
    if v is None or any(c in v for c in 'xXzZ'):
        return None
    return int(v, 2)

"""Tiny RV32I-subset ISS + issue-timing model.

The ISS executes a program to get the dynamic instruction trace and branch outcomes.
The timing model computes total cycles (first fetch -> last WB) for different
hazard-handling policies. Policy 'as_built' must reproduce the measured counters.
"""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
PROG = os.path.join(HERE, '..', '..', '..', 'riscv-processor', 'programs') + os.sep
BENCH = [('Independent', 'processor_independent.hex'),
         ('Dependent', 'processor_dependencies.hex'),
         ('Load-use', 'processor_load_use.hex'),
         ('Branches', 'processor_branches.hex'),
         ('Three ADDI', 'processor_three_addi.hex'),
         ('Long arithmetic', 'processor_long_arithmetic.hex')]

def sx(v, b): return v - (1 << b) if v >> (b - 1) & 1 else v

def decode(w):
    op, rd, f3, rs1, rs2, f7 = w & 0x7f, (w >> 7) & 31, (w >> 12) & 7, (w >> 15) & 31, (w >> 20) & 31, w >> 25
    if op == 0x33: return ('SUB' if f7 == 0x20 else 'ADD', rd, [rs1, rs2], 0)
    if op == 0x13: return ('ADDI', rd, [rs1], sx(w >> 20, 12))
    if op == 0x03: return ('LW', rd, [rs1], sx(w >> 20, 12))
    if op == 0x23: return ('SW', 0, [rs1, rs2], sx(((w >> 25) << 5) | ((w >> 7) & 31), 12))
    if op == 0x63:
        imm = ((w >> 31) << 12) | (((w >> 7) & 1) << 11) | (((w >> 25) & 0x3f) << 5) | (((w >> 8) & 0xf) << 1)
        return ('BNE' if f3 == 1 else 'BEQ', 0, [rs1, rs2], sx(imm, 13))
    raise ValueError(hex(w))

def asm(d):
    m, rd, rs, imm = d
    if m in ('ADD', 'SUB'): return f'{m.lower()} x{rd}, x{rs[0]}, x{rs[1]}'
    if m == 'ADDI': return f'addi x{rd}, x{rs[0]}, {imm}'
    if m == 'LW': return f'lw x{rd}, {imm}(x{rs[0]})'
    if m == 'SW': return f'sw x{rs[1]}, {imm}(x{rs[0]})'
    return f'{m.lower()} x{rs[0]}, x{rs[1]}, {imm:+d}'

def run(path):
    words = [int(l.split()[0], 16) for l in open(path) if l.strip() and not l.startswith('//')]
    x, mem, pc, trace = [0] * 32, {}, 0, []
    while pc // 4 < len(words):
        d = decode(words[pc // 4]); m, rd, rs, imm = d
        taken = False
        if m == 'ADD': v = x[rs[0]] + x[rs[1]]
        elif m == 'SUB': v = x[rs[0]] - x[rs[1]]
        elif m == 'ADDI': v = x[rs[0]] + imm
        elif m == 'LW': v = mem.get(x[rs[0]] + imm, 0)
        elif m == 'SW': mem[x[rs[0]] + imm] = x[rs[1]]
        else: taken = (x[rs[0]] == x[rs[1]]) == (m == 'BEQ')
        if m in ('ADD', 'SUB', 'ADDI', 'LW') and rd: x[rd] = v & 0xffffffff
        trace.append(dict(pc=pc, d=d, taken=taken, asm=asm(d)))
        pc = pc + imm if taken else pc + 4
    return words, trace, x, mem

def cycles(trace, policy):
    t = 0; prod = {}; last = 0
    stalls = br = 0
    pending_branch = 0
    for i, ins in enumerate(trace):
        m, rd, rs, _ = ins['d']
        want = (t + 1 if i else 1) + pending_branch
        br += pending_branch; pending_branch = 0
        need = want
        for r in rs:
            if r == 0 or r not in prod: continue
            tp, ld = prod[r]
            if policy == 'no_forwarding': need = max(need, tp + 3)
            elif ld: need = max(need, tp + 2)
        stalls += need - want; t = need
        if rd and m not in ('SW', 'BEQ', 'BNE'): prod[rd] = (t, m == 'LW')
        if m in ('BEQ', 'BNE') and (ins['taken'] or policy == 'stall_on_branch'):
            pending_branch = 2
    return t + 4, stalls, br   # last ID + EX, MEM, WB, plus the IF cycle of the first

if __name__ == '__main__':
    out = []
    for name, f in BENCH:
        words, tr, x, mem = run(PROG + f)
        row = dict(name=name, file=f, n=len(tr), asm=[(hex(t['pc']), t['asm'], t['taken']) for t in tr],
                   regs={f'x{i}': v for i, v in enumerate(x) if v}, mem=mem)
        for p in ('as_built', 'no_forwarding', 'stall_on_branch'):
            row[p] = cycles(tr, p)
        out.append(row)
        print(name, row['n'], row['as_built'], row['no_forwarding'], row['stall_on_branch'], row['regs'])
        for a in row['asm'][:8]: print('   ', a)
    json.dump(out, open(os.path.join(HERE, 'model_out.json'), 'w'), indent=1)

"""Build every data figure in the report from the real simulation output.

Run from anywhere after `make test` (repository root):
         python3 docs/report/scripts/model.py && python3 docs/report/scripts/figures.py
Inputs : riscv-processor/simulation/processor_tb.vcd  (written by `make test`)
         riscv-processor/simulation/performance.csv
         model_out.json                                 (written by model.py)
Outputs: ../figures/*.pdf
"""
import csv, json, os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, FancyArrowPatch
import vcd, model

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.join(HERE, '..', '..', '..', 'riscv-processor') + os.sep
VCD = REPO + 'simulation/processor_tb.vcd'
OUT = os.path.join(HERE, '..', 'figures')

BLUE, ORANGE, AQUA, YELLOW = '#2a78d6', '#eb6834', '#1baf7a', '#eda100'
INK, INK2, MUTED, GRID = '#1f1f1e', '#55554f', '#8a8a83', '#e4e4e0'
STALL, FLUSH = '#dcdcd7', '#fbd9cc'

plt.rcParams.update({
    'font.family': 'serif', 'font.serif': ['STIXGeneral', 'Times New Roman'],
    'mathtext.fontset': 'stix', 'font.size': 8, 'axes.edgecolor': MUTED,
    'axes.labelcolor': INK, 'xtick.color': INK2, 'ytick.color': INK2,
    'axes.linewidth': 0.6, 'pdf.fonttype': 42,
})

MODEL = {r['name']: r for r in json.load(open(os.path.join(HERE, 'model_out.json')))}
PERF = {r['benchmark']: r for r in csv.DictReader(open(REPO + 'simulation/performance.csv'))}

SIG = ['rst_n', 'pc_current', 'ifid_pc', 'idex_pc', 'exmem_pc_plus4', 'ifid_perf_valid',
       'idex_perf_valid', 'exmem_perf_valid', 'memwb_perf_valid', 'load_use_stall',
       'flush_idex', 'ex_branch_taken', 'forward_a', 'forward_b', 'wb_rd',
       'wb_reg_write', 'wb_write_data']


def samples(inst):
    return [{k: vcd.num(s[k]) for k in SIG} for s in vcd.load(VCD, inst, SIG)]


# ---------------------------------------------------------------- occupancy
def occupancy(inst, model_name, perf_name, fname, title_cycles=None):
    S = samples(inst)
    words = [int(l.split()[0], 16) for l in open(model.PROG + MODEL[model_name]['file'])
             if l.strip() and not l.startswith('//')]
    prog = {4 * i: model.asm(model.decode(w)) for i, w in enumerate(words)}
    plen = max(prog) + 4
    C = int(PERF[perf_name]['cycles'])
    insts, IF, ID, EX, MEM, WB = [], [], [], [], [], []
    squashed = set()
    for k in range(C):
        s, p = S[k], (S[k - 1] if k else None)
        stall = p and p['load_use_stall']
        taken = p and p['ex_branch_taken']
        if k and stall:
            IF.append(IF[-1])
        else:
            insts.append(dict(pc=s['pc_current'], k=k)); IF.append(len(insts) - 1)
        if k == 0:
            ID.append(None); EX.append(None); MEM.append(None); WB.append(None); continue
        if taken:
            squashed.update([IF[k - 1], ID[k - 1]])
            ID.append(None); EX.append(None)
        elif stall:
            ID.append(ID[k - 1]); EX.append(None)
        else:
            ID.append(IF[k - 1]); EX.append(ID[k - 1])
        MEM.append(EX[k - 1]); WB.append(MEM[k - 1])
        # cross-check the reconstruction against the dumped pipeline registers
        for stage, reg, valid in ((ID, 'ifid_pc', 'ifid_perf_valid'), (EX, 'idex_pc', 'idex_perf_valid')):
            i = stage[k]
            if i is not None and insts[i]['pc'] < plen:
                assert s[valid] == 1 and s[reg] == insts[i]['pc'], (inst, k, reg)
        if MEM[k] is not None and insts[MEM[k]]['pc'] < plen:
            assert s['exmem_pc_plus4'] - 4 == insts[MEM[k]]['pc'], (inst, k)
    squashed.discard(None)
    rows = [i for i, x in enumerate(insts) if x['pc'] < plen]
    cells = {}
    for st, arr in (('IF', IF), ('ID', ID), ('EX', EX), ('MEM', MEM), ('WB', WB)):
        for k, i in enumerate(arr):
            if i is None or i not in rows:
                continue
            prev = cells.get((i, k))
            if prev is None:
                rep = (st in ('IF', 'ID') and k and arr[k - 1] == i)
                cells[(i, k)] = (st, rep)
    fwd = []
    for k in range(C):
        for key, opnd in (('forward_a', 'rs1'), ('forward_b', 'rs2')):
            v = S[k][key]
            if v and EX[k] is not None:
                src = MEM[k] if v == 2 else WB[k]
                fwd.append((src, EX[k], k, v))

    n, w = len(rows), C
    L = 5.3  # label column, in cell units
    fig, ax = plt.subplots(figsize=(0.215 * (w + L), 0.2 * n + 0.35))
    ax.set_xlim(-L, w); ax.set_ylim(n, -0.9); ax.axis('off')
    for c in range(w):
        ax.text(c + 0.5, -0.45, str(c + 1), ha='center', va='center', color=INK2, fontsize=7)
    ax.text(-L + 0.05, -0.45, 'cycle', ha='left', va='center', color=INK2, fontsize=7, style='italic')
    rowpos = {i: r for r, i in enumerate(rows)}
    for i in rows:
        r = rowpos[i]
        label = prog[insts[i]['pc']]
        col = MUTED if i in squashed else INK
        ax.text(-L + 0.05, r + 0.5, label, ha='left', va='center', fontsize=6.4, color=col,
                family='monospace')
    for (i, k), (st, rep) in cells.items():
        r = rowpos[i]
        fill = 'white'
        if rep:
            fill = STALL
        if i in squashed and st in ('IF', 'ID'):
            fill = FLUSH
        ax.add_patch(Rectangle((k + 0.04, r + 0.08), 0.92, 0.84, fc=fill, ec=MUTED, lw=0.5))
        txt = {'MEM': 'M', 'WB': 'W'}.get(st, st)
        ax.text(k + 0.5, r + 0.5, txt, ha='center', va='center', fontsize=6.2,
                color=MUTED if i in squashed else INK)
        if i in squashed and st in ('IF', 'ID') and k == max(kk for (ii, kk) in cells if ii == i):
            ax.plot([k + 0.12, k + 0.88], [r + 0.2, r + 0.8], color=ORANGE, lw=0.9)
    for src, dst, k, v in fwd:
        if src not in rowpos or dst not in rowpos:
            continue
        a = FancyArrowPatch((k + 0.5, rowpos[src] + 0.82), (k + 0.5, rowpos[dst] + 0.18),
                            arrowstyle='-|>', mutation_scale=6, color=BLUE, lw=0.9,
                            shrinkA=0, shrinkB=0)
        ax.add_patch(a)
    save(fig, fname)
    plt.close(fig)
    return dict(cycles=C, rows=len(rows), squashed=len(squashed), fwd=len(fwd))


# ---------------------------------------------------------------- waveforms
def waveform(inst, C, rows, fname, bands=(), notes=()):
    S = samples(inst)[:C]
    n = len(rows) + 1
    fig, ax = plt.subplots(figsize=(7.1, 0.235 * n + 0.35))
    ax.set_xlim(-2.9, C); ax.set_ylim(n + 0.1, -0.75); ax.axis('off')
    for c0, c1, color, txt in bands:
        ax.add_patch(Rectangle((c0, -0.25), c1 - c0, n + 0.25, fc=color, ec='none', zorder=0))
        ax.text((c0 + c1) / 2, -0.55, txt, ha='center', va='center', fontsize=6.6, color=INK2)
    for c in range(C + 1):
        ax.plot([c, c], [0, n], color=GRID, lw=0.4, zorder=0.5)
    for c in range(C):
        pass
    h = 0.32
    # clock
    y = 0.5
    ax.text(-2.85, y, 'clk', va='center', fontsize=7, family='monospace', color=INK)
    xs, ys = [], []
    for c in range(C):
        xs += [c, c, c + 0.5, c + 0.5]; ys += [y + h, y - h, y - h, y + h]
    xs.append(C); ys.append(y + h)
    ax.plot(xs, ys, color=INK, lw=0.7, drawstyle='steps-post' if False else 'default')
    for r, (label, key, kind, fmt) in enumerate(rows, start=1):
        y = r + 0.5
        ax.text(-2.85, y, label, va='center', fontsize=7, family='monospace', color=INK)
        vals = [S[c][key] for c in range(C)]
        if kind == 'bit':
            xs, ys = [], []
            for c, v in enumerate(vals):
                yy = y - h if v else y + h
                xs += [c, c + 1]; ys += [yy, yy]
            ax.plot(xs, ys, color=AQUA if any(vals) else INK2, lw=0.9)
        else:
            c = 0
            while c < C:
                d = c
                while d + 1 < C and vals[d + 1] == vals[c]:
                    d += 1
                x0, x1, sl = c, d + 1, 0.12
                poly = [(x0 + sl, y - h), (x1 - sl, y - h), (x1, y), (x1 - sl, y + h),
                        (x0 + sl, y + h), (x0, y), (x0 + sl, y - h)]
                px, py = zip(*poly)
                ax.fill(px, py, fc='white', ec=INK2, lw=0.6)
                if x1 - x0 >= 0.8:
                    ax.text((x0 + x1) / 2, y, fmt(vals[c]), ha='center', va='center', fontsize=6.2,
                            color=INK)
                c = d + 1
    for c in range(C):
        ax.text(c + 0.5, n + 0.02, str(c + 1), ha='center', va='top', fontsize=6.2, color=MUTED)
    for x, yrow, txt in notes:
        ax.annotate(txt, (x, yrow + 0.5), xytext=(x + 0.15, yrow + 0.5), fontsize=6.2,
                    color=BLUE, va='center')
    save(fig, fname)
    plt.close(fig)


def save(fig, fname):
    fig.savefig(os.path.join(OUT, fname), bbox_inches='tight', pad_inches=0.02)
    if os.environ.get('PREVIEW'):
        fig.savefig(os.path.join(os.environ['PREVIEW'], fname[:-4] + '.png'), dpi=220,
                    bbox_inches='tight', pad_inches=0.02)


hx = lambda v: f'{v:02x}' if v is not None else 'x'
dec = lambda v: str(v) if v is not None else 'x'


# ---------------------------------------------------------------- charts
def cpi_chart(fname):
    fig, ax = plt.subplots(figsize=(3.45, 2.1))
    N = list(range(3, 201))
    ax.plot(N, [(n + 4) / n for n in N], color=BLUE, lw=1.6, label='hazard-free stream: $(N+4)/N$')
    ax.plot(N, [(n + 4 + 0.10 * n + 2 * 0.05 * n) / n for n in N], color=ORANGE, lw=1.6,
            label='10% load-use, 5% taken branches')
    ax.axhline(1, color=MUTED, lw=0.8, ls=(0, (3, 2)))
    ax.text(200, 1.02, 'CPI = 1', ha='right', va='bottom', fontsize=6.5, color=INK2)
    for name, key in (('Independent', 'independent'), ('Dependent', 'dependent'), ('Load-use', 'load_use'),
                      ('Branches', 'branches'), ('Three ADDI', 'three_addi'), ('Long arithmetic', 'long_arithmetic')):
        p = PERF[key]; n = int(p['retired']); cpi = int(p['cycles']) / n
        ax.plot(n, cpi, 'o', ms=4.2, mfc=INK, mec='white', mew=0.8, zorder=5)
    ax.annotate('64-instruction stream: CPI 1.06', (64, 68 / 64), xytext=(18, 1.55), fontsize=6.5,
                color=INK2, arrowprops=dict(arrowstyle='-', color=MUTED, lw=0.6))
    ax.annotate('short benchmarks ($N$ = 3 to 7)', (7, 2.14), xytext=(11, 2.4), fontsize=6.5,
                color=INK2, arrowprops=dict(arrowstyle='-', color=MUTED, lw=0.6))
    ax.set_xscale('log'); ax.set_xlim(2.6, 220); ax.set_ylim(0.9, 2.6)
    ax.set_xticks([3, 5, 10, 20, 50, 100, 200]); ax.set_xticklabels(['3', '5', '10', '20', '50', '100', '200'])
    ax.set_xlabel('instructions executed, $N$'); ax.set_ylabel('CPI')
    ax.grid(axis='y', color=GRID, lw=0.5); ax.set_axisbelow(True)
    for s in ('top', 'right'):
        ax.spines[s].set_visible(False)
    ax.legend(frameon=False, fontsize=6.5, loc='center right', bbox_to_anchor=(1.0, 0.6))
    save(fig, fname)
    plt.close(fig)


def policy_chart(fname):
    names = ['Independent', 'Dependent', 'Load-use', 'Branches', 'Three ADDI']
    series = [('as built (measured)', 'as_built', BLUE),
              ('no forwarding', 'no_forwarding', ORANGE),
              ('stall on every branch', 'stall_on_branch', AQUA)]
    fig, ax = plt.subplots(figsize=(3.45, 2.05))
    bw = 0.26
    for j, (lab, key, col) in enumerate(series):
        xs = [i + (j - 1) * (bw + 0.02) for i in range(len(names))]
        vals = [MODEL[n][key][0] for n in names]
        ax.bar(xs, vals, width=bw, color=col, label=lab, zorder=3)
        for x, v in zip(xs, vals):
            ax.text(x, v + 0.25, str(v), ha='center', va='bottom', fontsize=6, color=INK2)
    ax.set_xticks(range(len(names))); ax.set_xticklabels(names, fontsize=7)
    ax.set_ylabel('cycles (first fetch to last WB)'); ax.set_ylim(0, 21)
    ax.grid(axis='y', color=GRID, lw=0.5); ax.set_axisbelow(True)
    for s in ('top', 'right'):
        ax.spines[s].set_visible(False)
    ax.legend(frameon=False, fontsize=6.5, loc='upper left', ncol=1)
    save(fig, fname)
    plt.close(fig)


if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    print('load_use', occupancy('u_load_use', 'Load-use', 'load_use', 'occ_load_use.pdf'))
    print('branches', occupancy('u_branches', 'Branches', 'branches', 'occ_branches.pdf'))
    print('dependent', occupancy('u_dependencies', 'Dependent', 'dependent', 'occ_dependent.pdf'))
    waveform('u_load_use', 9, [
        ('pc (IF)', 'pc_current', 'bus', hx), ('IF/ID.pc', 'ifid_pc', 'bus', hx),
        ('ID/EX.pc', 'idex_pc', 'bus', hx), ('ID/EX valid', 'idex_perf_valid', 'bit', None),
        ('load_use_stall', 'load_use_stall', 'bit', None), ('flush_idex', 'flush_idex', 'bit', None),
        ('forward_a', 'forward_a', 'bus', dec), ('forward_b', 'forward_b', 'bus', dec),
        ('wb_rd', 'wb_rd', 'bus', dec), ('wb_write_data', 'wb_write_data', 'bus', dec)],
        'wave_load_use.pdf',
        bands=[(4, 5, '#eef4fc', 'detect'), (5, 6, STALL, 'stall'), (6, 7, '#eef4fc', 'forward')])
    waveform('u_branches', 15, [
        ('pc (IF)', 'pc_current', 'bus', hx), ('IF/ID.pc', 'ifid_pc', 'bus', hx),
        ('IF/ID valid', 'ifid_perf_valid', 'bit', None), ('ID/EX.pc', 'idex_pc', 'bus', hx),
        ('ID/EX valid', 'idex_perf_valid', 'bit', None), ('branch_taken', 'ex_branch_taken', 'bit', None),
        ('flush_idex', 'flush_idex', 'bit', None), ('wb_rd', 'wb_rd', 'bus', dec),
        ('wb_reg_write', 'wb_reg_write', 'bit', None)],
        'wave_branches.pdf',
        bands=[(3, 4, FLUSH, 'taken'), (7, 8, FLUSH, 'taken'), (11, 12, '#eef4fc', 'not taken')])
    cpi_chart('cpi_vs_n.pdf')
    policy_chart('policy_cycles.pdf')
    print('done')

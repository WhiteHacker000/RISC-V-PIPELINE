# Measured performance results

Generated from `simulation/performance.csv` by `verification/performance.py`.
These are simulation measurements, not hardware timing results.

| Benchmark | Cycles | Retired / WB | Stall cycles | Flush events | Taken branches | Not-taken branches | CPI | IPC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Independent arithmetic | 9 | 5 / 5 | 0 | 0 | 0 | 0 | 1.8 | 0.5556 |
| Dependent arithmetic | 10 | 6 / 6 | 0 | 0 | 0 | 0 | 1.6667 | 0.6 |
| Load-use dependency | 9 | 4 / 4 | 1 | 0 | 0 | 0 | 2.25 | 0.4444 |
| Taken/not-taken branches | 15 | 7 / 7 | 0 | 2 | 2 | 1 | 2.1429 | 0.4667 |
| Three dependent ADDI | 7 | 3 / 3 | 0 | 0 | 0 | 0 | 2.3333 | 0.4286 |
| Long arithmetic (64 ADDI) | 68 | 64 / 64 | 0 | 0 | 0 | 0 | 1.0625 | 0.9412 |
| Independent arithmetic (50 instructions) | 54 | 50 / 50 | 0 | 0 | 0 | 0 | 1.08 | 0.9259 |
| Independent arithmetic (100 instructions) | 104 | 100 / 100 | 0 | 0 | 0 | 0 | 1.04 | 0.9615 |
| Dependent arithmetic (50 instructions) | 54 | 50 / 50 | 0 | 0 | 0 | 0 | 1.08 | 0.9259 |
| Branch-heavy loop | 25 | 13 / 13 | 0 | 4 | 4 | 1 | 1.9231 | 0.52 |

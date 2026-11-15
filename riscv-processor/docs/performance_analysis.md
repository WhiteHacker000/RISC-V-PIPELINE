# Performance analysis

`riscv_top` maintains 64-bit simulation counters beside the datapath. A validity bit follows each of IF/ID, ID/EX, EX/MEM, and MEM/WB. It is cleared by reset, branch flush, or the ID/EX load-use bubble, and held with IF/ID during a stall. Only a valid instruction reaching MEM/WB increments both retirement and WB-completion counts. Stores and branches are counted when they reach WB even though they do not write the register file. Hazard bubbles, flushed younger instructions, and the canonical NOP (`ADDI x0,x0,0`) do not retire.

`perf_total_cycles` counts active benchmark cycles from the first non-NOP fetch through the last valid instruction's WB cycle. It does not include the testbench's idle tail while other benchmark instances finish. `perf_stall_cycles` counts asserted load-use stall cycles. `perf_branch_flushes` and `perf_taken_branches` count taken EX-stage redirects once each; `perf_not_taken_branches` counts resolved not-taken BEQ/BNE instructions.

The integration testbench runs these actual instruction streams:

| Benchmark | Workload |
|---|---|
| `independent` | Five independent ADDI instructions |
| `dependent` | Dependent ADDI/ADD/SUB followed by SW/LW |
| `load_use` | LW followed by dependent arithmetic, with a required interlock |
| `branches` | Taken and not-taken branch cases with wrong-path instructions |
| `three_addi` | Three dependent ADDI instructions |

At the end of `make run` and `make test`, `processor_tb` writes `simulation/performance.csv`; `verification/performance.py` validates the counts and reports CPI and IPC from that file. CPI = active benchmark cycles / retired instructions; IPC = retired instructions / active benchmark cycles. The counters and resulting metrics are simulation measurements. No clock frequency, hardware execution time, speedup, or silicon throughput is inferred because the project has no timing constraints or technology-mapped timing data.

## Observed benchmark results

Measured with the integration testbench and Verilator 5.054. Cycle counts span each finite program's first fetch through its last WB cycle, including stalls and branch penalties.

| Benchmark | Cycles | Retired / WB | Stall cycles | Taken flushes | CPI | IPC |
|---|---:|---:|---:|---:|---:|---:|
| Independent arithmetic | 9 | 5 | 0 | 0 | 1.800 | 0.556 |
| Dependent arithmetic | 10 | 6 | 0 | 0 | 1.667 | 0.600 |
| Load-use dependency | 9 | 4 | 1 | 0 | 2.250 | 0.444 |
| Taken/not-taken branches | 15 | 7 | 0 | 2 | 2.143 | 0.467 |
| Three dependent ADDI | 7 | 3 | 0 | 0 | 2.333 | 0.429 |

The branch workload resolved two taken and one not-taken branch. These results describe only the listed short instruction streams; they are not evidence of a general performance improvement over another processor.

The benchmark has a finite-program convention: an all-zero-immediate ADDI to x0 is treated as the NOP sentinel used by the instruction memory to fill unused locations. Programs that need a literal architectural NOP are not distinguishable from that sentinel in this counter setup. Programs that loop indefinitely naturally do not reach a final-drain point.

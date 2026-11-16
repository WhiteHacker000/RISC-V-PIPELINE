# Performance analysis

## Metrics and counter definitions

The integration testbench measures simulation cycles and retired instructions for each finite instruction stream. CPI (cycles per instruction) is active benchmark cycles divided by retired instructions; IPC (instructions per cycle) is retired instructions divided by active benchmark cycles.

For a given row, CPI and IPC are reciprocals before display rounding. They are counts over the testbench's simulated interval; they are not elapsed time, clock frequency, or hardware throughput.

The counter implementation is in `rtl/riscv_top.sv` and is unchanged by this analysis:

- A validity bit follows each pipeline register. The valid instruction present in MEM/WB increments both `perf_instructions_retired` and `perf_instructions_completed_wb`. Stores and branches retire even though they do not write a register. Invalid bubbles, flushed instructions, and the canonical NOP do not retire.
- `perf_total_cycles` counts active benchmark cycles starting with the first non-NOP instruction fetch and ending when the final valid instruction drains from the pipeline. It excludes the testbench's idle tail after this instance finishes.
- `perf_stall_cycles` counts cycles with the load-use stall asserted.
- `perf_branch_flushes` counts taken EX-stage redirects, once per redirect. It is an event count, not the number of younger instructions invalidated or a separate count of penalty cycles.
- `perf_taken_branches` and `perf_not_taken_branches` count resolved BEQ/BNE decisions in EX. Not-taken branches do not redirect.

`processor_tb` checks that WB completion equals retirement and checks the expected cycle, stall, and redirect counts for the existing cases. `verification/performance.py` reads the generated CSV, validates its columns and basic counter relationships, calculates CPI/IPC, and generates the [measured results table](performance_results.md) and [CPI/IPC graph](performance_analysis.svg). Run `make run` or `make test` from the repository root to regenerate them from the new `simulation/performance.csv`.

## Reading the measurements

The short programs spend a large fraction of their cycles filling and draining the pipeline. In a five-stage pipeline with one instruction entering each cycle and no stalls or redirects, an N-instruction finite stream spans N + 4 active cycles: the first instruction must traverse IF/ID/EX/MEM/WB, and the pipeline must drain after the last fetch. This is four additional cycles total, not four fill cycles plus four more drain cycles.

That fixed cost is proportionally large for small N. The measured three-instruction arithmetic stream takes 7 cycles (CPI 7/3 = 2.333), while the five-instruction independent stream takes 9 cycles (CPI 9/5 = 1.800). The 64-instruction arithmetic stream takes 68 cycles (CPI 68/64 = 1.0625), making the same four-cycle boundary overhead a smaller fraction of its total. These differences follow from finite-stream length; they do not show speedup over another processor.

Forwarding supplies operands for the tested ALU dependencies without inserting load-use stalls: the dependent arithmetic workload reports zero stalls, and the three-ADDI test also observes forwarding. A load-use dependency still requires one interlock cycle because the loaded value is not available in time for the immediately following EX-stage consumer. Its measured 4 retired instructions therefore take 9 cycles rather than the no-stall N + 4 count of 8.

The branch program measures 15 cycles for 7 retired instructions, with two taken redirects and one not-taken decision. A taken branch resolves in EX and flushes younger work, so it increases the cycle count without retiring the wrong-path instructions. The flush counter records each redirect event; it does not directly isolate a branch's cycle penalty. A not-taken branch is counted as a branch decision but causes no redirect.

The long arithmetic workload consists of 64 ADDI instructions, all reading x0 and writing x1–x31 in round-robin order. It has no RAW dependencies, load-use hazards, or branches. It adds no RTL behavior and serves to show how the fixed finite-stream fill/drain overhead is amortized over a longer instruction stream.

## Methodology and limitations

The testbench instantiates each benchmark with its own processor and counters, applies a common clock and reset, and waits for all streams to complete. The current CSV was measured with Verilator 5.055 devel (revision `v5.054-290-ge0ff8e65b`). Results in the CSV come from those simulation counters; the Python script does not estimate or infer measurements. The arithmetic program is a fixed straight-line sequence, not a representative software suite.

These are functional simulation results only. They do not establish clock frequency, critical-path delay, FPGA timing, power, area, hardware execution time, or a speedup versus a baseline. No technology-mapped timing constraints or baseline processor measurements are part of this project. CPI/IPC also depend on this benchmark mix and on the finite-program counter convention: an all-zero-immediate ADDI to x0 is the instruction-memory NOP sentinel, so a literal architectural NOP cannot be distinguished from unused instruction memory by these counters. An infinite loop does not reach the final drain point used by this finite-program measurement.

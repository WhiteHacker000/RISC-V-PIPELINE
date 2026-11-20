# Integration waveform

## Generate and inspect

From the repository root:

```sh
make run
make wave
```

`make run` compiles `processor_tb` with Verilator `--trace`, then the testbench
writes `riscv-processor/simulation/processor_tb.vcd`. `make wave` opens that file
with GTKWave. To open without the Make target:

```sh
gtkwave riscv-processor/simulation/processor_tb.vcd
```

The bench calls `$dumpvars(0, processor_tb)`, so the VCD records the full
hierarchy of its parallel integration programs. In GTKWave, expand `processor_tb`
and select a processor instance such as `u_load_use` or `u_branches`.

## Signals and scenarios

The hierarchical trace includes the available top-level `clk`, `rst_n`,
`pc_current`, `instruction_fetch`, `stall_pc`, `ex_branch_taken`, branch target,
and IF/ID, ID/EX, EX/MEM and MEM/WB state. It also includes `forward_a`,
`forward_b`, `load_use_stall`, EX forwarded operands, ALU result, WB destination
and write data, and per-stage performance-valid bits. Some external names in the
request map to RTL names as follows: `current_pc` → `pc_current`, `instruction`
→ `instruction_fetch`, `stall` → `stall_pc`, `flush` → the branch-driven IF/ID
flush and load-use ID/EX flush, and `branch_taken` → `ex_branch_taken`.

- `u_independent` shows normal overlap across ID/EX, EX/MEM and MEM/WB.
- `u_three_addi` shows forwarding and ordered write-back.
- `u_load_use` shows the PC/IF/ID hold and ID/EX bubble for a load-use hazard.
- `u_branches` shows EX redirection, IF/ID NOP injection and ID/EX bubble for
  wrong-path suppression.
- `u_dependencies` shows WB data and destination register paired at write-back.

The waveform and self-checking assertions establish simulated behavior; they do
not represent a GTKWave screenshot or hardware measurement.

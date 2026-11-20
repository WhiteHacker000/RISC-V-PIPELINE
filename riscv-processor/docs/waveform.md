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

I verified these names in the generated VCD declaration section:

- Clock/reset and fetch: `clk`, `rst_n`, `pc_current`, `instruction_fetch` and
  `instruction_fetch_valid`.
- IF/ID: `ifid_pc`, `ifid_pc_plus4`, `ifid_instruction`.
- ID/EX: `idex_pc`, `idex_rs1_data`, `idex_rs2_data`, `idex_immediate`,
  `idex_rs1`, `idex_rs2` and `idex_rd`.
- EX/MEM and WB: `exmem_alu_result`, `exmem_rd`, `wb_write_data`, `wb_rd` and
  the write-enable controls.
- Hazards and redirects: `forward_a`, `forward_b`, `load_use_stall`,
  `stall_pc`, `stall_ifid`, `flush_idex`, `ex_branch_taken` and
  `branch_target`.

The ID/EX register does not carry the original instruction word, so there is no
`idex_instruction` signal. Use `idex_pc` and the decoded source, destination and
immediate fields to identify the instruction in that stage. Likewise, the
integrated names map to the more generic names in the request as follows:
`current_pc` → `pc_current`, `instruction` → `instruction_fetch`, `stall` →
`stall_pc`/`stall_ifid`, `flush` → the IF/ID branch flush or `flush_idex`, and
`branch_taken` → `ex_branch_taken`.

- `u_independent` shows normal overlap across ID/EX, EX/MEM and MEM/WB.
- `u_three_addi` shows forwarding and ordered write-back.
- `u_load_use` shows the PC/IF/ID hold and ID/EX bubble for a load-use hazard.
- `u_branches` shows EX redirection, IF/ID NOP injection and ID/EX bubble for
  wrong-path suppression.
- `u_dependencies` shows WB data and destination register paired at write-back.

GTKWave 3.4.0 was invoked through `make wave` during the final audit and parsed
the file's time interval, but its GUI failed to initialize in this session
(`Failed to initialize CVDisplayLink` / GDK Quartz error). The declaration
checks above are file-level checks, not visual inspection. To inspect manually,
run `make run`, then `make wave`, expand `processor_tb`, and add the signals
above from the named instances. Compare PC and stage controls for overlap; use
`u_three_addi` for forwarding selector values; use `u_load_use` for the stall,
held PC/IF/ID and bubble; and use `u_branches` for taken redirect, target and
invalid wrong-path slots. No screenshot is claimed.

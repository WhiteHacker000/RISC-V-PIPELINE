# Verification

Run `make test` from the repository root. Each listed testbench is compiled with Verilator and then executed; a compile or simulation failure stops the regression with a nonzero status.

| Area | Testbench |
|---|---|
| ALU | `alu_tb` |
| Register file | `register_file_tb` |
| Immediate generator | `immediate_generator_tb` |
| Instruction/data memories | `instruction_memory_tb`, `data_memory_tb` |
| Decoder/control | `main_decoder_tb`, `control_unit_tb` |
| PC and pipeline registers | `program_counter_tb`, `if_id_tb`, `id_ex_tb`, `ex_mem_tb`, `mem_wb_tb` |
| Forwarding and interlock | `forwarding_unit_tb`, `hazard_detection_unit_tb` |
| Integrated processor | `processor_tb` |

The processor integration test checks RAW dependencies, write ordering and overlap, load-use stalling, and BEQ/BNE redirect/flush behavior. Counter assertions verify exact cycle/retirement/stall/flush counts for independent, dependent, load-use, branch, and three-ADDI benchmarks. They verify that the injected load-use bubble and flushed branch-path instructions do not retire, and that WB-completion equals retirement. The test writes measured counters to `simulation/performance.csv`; the Makefile parses that output to calculate CPI/IPC. A successful compile alone is not a pass; the simulation and CSV validation must both complete successfully. Waveforms are generated under `riscv-processor/simulation/` by traced testbenches.

Useful checks are `make lint` and `make synth`. Yosys `check` reports structural issues; this is not a technology-mapped implementation or timing-closure result. The flow currently uses `-Wno-fatal` for testbench compilation because some existing modules/testbenches emit nonfatal style warnings.

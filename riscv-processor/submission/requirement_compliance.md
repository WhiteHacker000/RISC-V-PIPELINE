# Requirement compliance matrix

| Requirement | Implemented | Tested | Evidence |
|---|:---:|:---:|---|
| Existing 32-bit five-stage IF/ID/EX/MEM/WB processor preserved | Yes | Yes | `architecture.md`; `make test` integration and corner benches |
| ADD, SUB, ADDI, LW, SW, BEQ and BNE | Yes | Yes | `verification.md`; unit and processor integration benches |
| Register file, x0 protection, instruction/data memories, ALU, immediate generator, decoder and PC | Yes | Yes | Unit benches in `../testbench/`; `make test` |
| IF/ID, ID/EX, EX/MEM and MEM/WB state/reset/flush behavior | Yes | Yes | Pipeline register benches; corner reset/invariant checks |
| EX/MEM and MEM/WB forwarding, priority and x0 exclusion | Yes | Yes | `forwarding_unit_tb`; `pipeline_corner_tb`; VCD |
| Load-use detection, PC/IF/ID stalls and ID/EX bubble insertion | Yes | Yes | `hazard_detection_unit_tb`; `processor_tb`; `pipeline_corner_tb` |
| EX branch decision, redirect priority, flushing and wrong-path suppression | Yes | Yes | `processor_tb`; `pipeline_corner_tb`; branch-heavy benchmark; VCD |
| Explicit program termination; literal NOP remains valid; final pipeline drain | Yes | Yes | `termination_tb`; `instruction_memory_tb`; exact retirement/WB assertions |
| No double retirement; bubbles/flushed instructions excluded | Yes | Yes | Per-stage validity and retirement counters; regression counter assertions |
| 50/100 independent and 50 dependent instruction benchmarks | Yes | Yes | `programs/processor_independent_50.hex`, `processor_independent_100.hex`, `processor_dependent_50.hex`; measured `performance.csv` |
| Load-use and branch-heavy benchmarks | Yes | Yes | `programs/processor_load_use.hex`, `processor_branch_heavy.hex`; measured CSV |
| Cycles, retired/WB, stalls, taken flushes, CPI/IPC and CSV | Yes | Yes | `performance.csv`; generated `performance_results.md`; `make run` |
| Useful integration waveform and reproduction instructions | Yes | Yes | `processor_tb.vcd`; `waveform.md`; `make run`, `make wave` |
| README, architecture, implementation, verification and performance documentation | Yes | Reviewed | Reports in this directory; `project_README.md` |
| Verilator lint diagnostics reviewed and classified | Yes | Yes | `lint.log`; classification in `test_results.md` |
| Yosys synthesis structural check | Yes | Yes | `synthesis.log`; no mapping/timing claims |
| Make targets build/run/test/lint/wave/synth/clean/help | Yes | Yes | Root `Makefile`; required commands recorded in `test_results.md` |
| Submission package with source programs, reports, data and evidence | Yes | Yes | This directory |
| FPGA deployment or physical timing measurement | Not performed | N/A | Explicitly excluded from all reports |

# Five-stage RV32I subset processor

This SystemVerilog project implements a 32-bit, single-issue IF/ID/EX/MEM/WB processor for ADD, SUB, ADDI, LW, SW, BEQ, and BNE. The integration top is `rtl/riscv_top.sv`; reusable components are under `rtl/`.

Run from the repository root:

```sh
make help
make build   # compile processor testbench with Verilator
make run     # compile and run integration simulation
make test    # compile and execute all unit and integration testbenches
make lint
make synth
make wave    # opens simulation/processor_tb.vcd after make run
make clean
```

Tool variables may be overridden, for example `make lint VERILATOR=/path/to/verilator`. Simulation programs are loaded from `riscv-processor/programs/`. Build products are placed in `riscv-processor/build/`; waveform output is in `riscv-processor/simulation/`.

See [architecture](docs/architecture.md), [implementation](docs/implementation.md), [verification](docs/verification.md), and [performance analysis](docs/performance_analysis.md). The current processor testbench exercises arithmetic dependencies, load-use stalls, instruction ordering, and taken/not-taken BEQ/BNE paths. `pipeline_corner_tb` adds x0-protection, forwarding-priority, dependency-chain, load-use, branch-flush and reset corner cases; the verification matrix and measured results are in the verification document. Unsupported ISA and memory behavior is listed in the architecture document.

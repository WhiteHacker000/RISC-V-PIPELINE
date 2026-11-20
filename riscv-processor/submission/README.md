# Final submission package

This directory collects the versioned project documentation, executable
benchmark programs, measured CSV and validation evidence for review.

## Contents

- `README.md` — this package index and reproduction commands.
- `project_README.md` — the project's final README.
- `architecture.md`, `implementation.md`, `verification.md`,
  `performance_analysis.md`, `performance_results.md`, `waveform.md` — final
  technical reports copied from `../docs/`.
- `performance.csv` — output produced by the processor testbench counters.
- `programs/` — benchmark and termination regression instruction streams.
- `test_results.md` — executed regression commands and outcomes.
- `build.log`, `test.log` — captured Verilator build and regression transcripts.
- `lint.log` — complete Verilator diagnostics and classification.
- `synthesis.log` — complete Yosys structural-check transcript.
- `requirement_compliance.md` — requirement-by-requirement evidence matrix.

## Reproduce

From the repository root, with Verilator 5.054, Yosys 0.71+, GTKWave 3.4.0 and
Python 3 installed:

```sh
make build
make test
make run
make lint
make synth
make wave
```

`make run` writes `riscv-processor/simulation/performance.csv` and regenerates
the measured results markdown and graph. `make wave` opens the VCD created by
`make run`. The Yosys command performs hierarchy, process lowering and
structural checks only; no technology-mapped timing or physical implementation
is claimed.

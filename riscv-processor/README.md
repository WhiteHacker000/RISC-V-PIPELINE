# Five-stage RV32I subset processor

This SystemVerilog project implements a 32-bit, single-issue IF/ID/EX/MEM/WB processor for ADD, SUB, ADDI, LW, SW, BEQ, and BNE. The integration top is `rtl/riscv_top.sv`; reusable components are under `rtl/`.

## Requirements

- GNU Make.
- Verilator 5.x with `--binary`, `--timing`, and `--trace` support.
- Yosys for the synthesis-structure check.
- Python 3 (standard library only) for performance report generation.
- GTKWave is optional and is only needed to open waveforms.

The existing verification results record Verilator 5.054 and Yosys 0.71. Setup checks in this environment used GNU Make 3.81 and Python 3.12.5 on macOS. These are reference versions, not strict pins; other versions may work if Verilator provides the required options above.

## Install tools

On macOS with [Homebrew](https://brew.sh/):

```sh
xcode-select --install
brew install verilator yosys
```

The Xcode Command Line Tools provide the C++ compiler, standard-library headers, and macOS SDK needed by Verilator's `--binary` builds. Complete the installer if macOS prompts for confirmation.

For waveform viewing, install [MacPorts](https://www.macports.org/install.php) and GTKWave:

```sh
sudo port install gtkwave
```

On Debian or Ubuntu:

```sh
sudo apt-get update
sudo apt-get install build-essential python3 verilator yosys
```

Install `gtkwave` from the same package manager if you want to open waveforms. The exact versions supplied by Linux distributions vary; check that Verilator supports the required options listed above. No RISC-V cross-compiler is needed because the test programs are included as hex files.

Run all commands below from the repository root (the directory containing this Makefile). Override tool commands when they are not on `PATH`, for example `make lint VERILATOR=/path/to/verilator`.

## Build and verification

```sh
make help
make build        # compile the processor integration testbench
make run          # compile, simulate, and generate performance reports
make test         # compile/run all unit and integration testbenches
make lint         # run Verilator lint
make synth        # run Yosys hierarchy/process/check passes
make performance  # regenerate reports from the latest performance CSV
make wave         # open the latest processor waveform in GTKWave
```

`make build` only compiles; it does not run the simulation. `make run` or `make test` must run before `make wave` or `make performance`, because those targets consume generated output. `make run` and `make test` write measured counters to `riscv-processor/simulation/performance.csv`; the performance script updates the checked-in table and chart at `riscv-processor/docs/performance_results.md` and `riscv-processor/docs/performance_analysis.svg`. Waveforms are written under `riscv-processor/simulation/`.

`make clean` removes build directories, the flow's known simulation waveforms, and the generated performance CSV. It does not remove arbitrary VCD files.

## Troubleshooting

- **`verilator` or `yosys` not found:** install the tool and ensure it is on `PATH`, or pass its executable path with `VERILATOR=...` or `YOSYS=...`.
- **C++ compile error such as `cstddef file not found` on macOS:** install or update the Xcode Command Line Tools with `xcode-select --install`, then retry. If the error persists because Verilator's generated build cannot find libc++ headers in the selected SDK, pass the SDK include directory through `CXXFLAGS`:
  ```sh
  CXXFLAGS="-isystem $(xcrun --show-sdk-path)/usr/include/c++/v1" make test
  ```
  Use the same `CXXFLAGS=...` prefix with `make build` or `make run` when running those targets.
- **`No processor waveform found`:** run `make run` or `make test` first.
- **Performance CSV cannot be opened:** run `make run` or `make test` to produce it; `make clean` removes it.
- **`make wave` cannot start GTKWave:** install GTKWave and ensure its launcher is on `PATH`, or use `make wave GTKWAVE=/path/to/gtkwave`. GTKWave requires a graphical desktop session.
- **Programs or reports are not found:** invoke `make` from the repository root; the Makefile changes to `riscv-processor/` for simulation so relative program paths resolve correctly.
- **Lint warnings:** the current RTL emits non-fatal Verilator warnings; `make lint` uses `-Wno-fatal`. Review warnings separately from the command's exit status.

See [architecture](docs/architecture.md), [implementation](docs/implementation.md), [verification](docs/verification.md), and [performance analysis](docs/performance_analysis.md). The current processor testbench exercises arithmetic dependencies, load-use stalls, instruction ordering, and taken/not-taken BEQ/BNE paths. `pipeline_corner_tb` adds x0-protection, forwarding-priority, dependency-chain, load-use, branch-flush and reset corner cases; the verification matrix and measured results are in the verification document. Unsupported ISA and memory behavior is listed in the architecture document.

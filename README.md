# Five-Stage Pipelined RISC-V Processor

**Modern Computer Architecture, Project 3** · Rishihood University · Instructor: Sujit Kumar

A single-issue IF → ID → EX → MEM → WB processor for a seven-instruction RV32I subset (ADD, SUB, ADDI, LW, SW, BEQ, BNE), written in SystemVerilog. It has EX/MEM and MEM/WB forwarding, a write-back-to-decode bypass, a one-cycle load-use interlock and a two-instruction flush on taken branches.

## Project video and report

| | |
|---|---|
| 🎬 **Video** (6½ min) | [Watch on Google Drive](https://drive.google.com/drive/folders/1_Lv2R95_BsK64Xsrql8XuYi4kilvtcWr) |
| 📄 **Report** (IEEE format, 8 pages) | [docs/report/report.pdf](docs/report/report.pdf) · [LaTeX source](docs/report/report.tex) |

## Team

| Name | Enrollment no. |
|---|---|
| Nishant Sharma | 2401010302 |
| Kushal Tyagi | 2401010249 |
| Dev Tyagi | 2401010148 |
| Vansh Khod | 2401010493 |
| Anant Lalwani | 2401020086 |

## Results at a glance

- **Verification:** `make test` runs 16 self-checking testbenches (14 unit, 2 integration), and all pass. Mutation testing injects 14 hazard, flush and reset bugs; the integration suite detects all 14. See [verification.md](riscv-processor/docs/verification.md).
- **Performance:** measured cycles equal *N + 4 + stalls + 2 × taken branches* on every benchmark. CPI is 1.67–2.33 on the short programs and 1.06 on a 64-instruction stream. See [performance_results.md](riscv-processor/docs/performance_results.md) and [performance_analysis.md](riscv-processor/docs/performance_analysis.md).
- **Synthesis:** Yosys `synth_xilinx` estimates about 469 LUTs and 349 flip-flops for a Xilinx 7-series target (details in the report). Maximum clock frequency has not been measured.

## Repository layout

```
riscv-processor/
  rtl/            processor RTL (components, pipeline registers, riscv_top.sv)
  testbench/      unit and integration testbenches
  programs/       benchmark and corner-case programs (.hex)
  verification/   performance script, mutation check, program generator
  docs/           architecture, implementation, verification, performance
docs/report/      project report (PDF, LaTeX source, figure scripts)
Makefile          build, test, run, lint, synth, wave
```

## Quick start

Requires Verilator 5.x and GNU Make (Yosys for `make synth`). Run from the repository root:

```sh
make test     # build and run all 16 testbenches
make run      # integration simulation and CPI/IPC report
make wave     # open the waveform in GTKWave (after make run)
```

Full setup, tool installation and troubleshooting are in [riscv-processor/README.md](riscv-processor/README.md).

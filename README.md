# Five-Stage Pipelined RISC-V Processor

**Modern Computer Architecture, Project 3** · Rishihood University · Instructor: Sujit Kumar

A single-issue IF → ID → EX → MEM → WB processor for a seven-instruction RV32I subset (ADD, SUB, ADDI, LW, SW, BEQ, BNE), written in SystemVerilog. It has EX/MEM and MEM/WB forwarding, a write-back-to-decode bypass, a one-cycle load-use interlock and a two-instruction flush on taken branches.

## Project video and report

| | |
|---|---|
| 🎬 **Video** | [Open the Google Drive folder](https://drive.google.com/drive/folders/1_Lv2R95_BsK64Xsrql8XuYi4kilvtcWr) |
| 📄 **Baseline project report** | [docs/report/report.pdf](docs/report/report.pdf) · [LaTeX source](docs/report/report.tex) |

The IEEE report is a team-authored snapshot from before explicit program-length
termination and the extended benchmarks. Its earlier 16-test count and NOP
handling notes are historical; the current verification and performance
documents linked below are the release results. The report's separate
pre-place-and-route resource estimate was generated separately from the current
`make synth` target, which performs structural checks only.

## Team

| Name | Enrollment no. |
|---|---|
| Nishant Sharma | 2401010302 |
| Kushal Tyagi | 2401010249 |
| Dev Tyagi | 2401010148 |
| Vansh Khod | 2401010493 |
| Anant Lalwani | 2401020086 |

## Results at a glance

- **Verification:** the current `make test` suite has 17 testbenches (14 unit, one termination, two integration); all pass. The earlier mutation check reported all 14 injected bugs detected. See [verification.md](riscv-processor/docs/verification.md).
- **Performance:** the 100-instruction independent stream measured CPI 1.04; the 50-instruction independent and dependent streams each measured CPI 1.08. The CSV includes the short tests, load-use and branch-heavy measurements. See [performance_results.md](riscv-processor/docs/performance_results.md) and [performance_analysis.md](riscv-processor/docs/performance_analysis.md).
- **Synthesis:** current `make synth` completed Yosys hierarchy and structural checks with zero reported problems. It does not perform technology mapping or timing analysis; maximum clock frequency has not been measured.

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
make test     # build and run all 17 testbenches
make run      # integration simulation and CPI/IPC report
make wave     # open the waveform in GTKWave (after make run)
```

Full setup, tool installation and troubleshooting are in [riscv-processor/README.md](riscv-processor/README.md).

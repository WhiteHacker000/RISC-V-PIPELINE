# Performance analysis

No CPI, IPC, throughput, or speedup result is published until actual retired-instruction, cycle, stall, branch-flush, and timing inputs are measured. The old percentage-based CPI estimate was removed because it was not derived from this processor's simulation.

`verification/performance.py` accepts simulation counters and explicit timing inputs:

```sh
python3 riscv-processor/verification/performance.py \
  --instructions N --cycles N --stalls N --branch-flushes N \
  --execution-seconds S --single-cycle-ns NS --pipeline-cycle-ns NS
```

The report separates measured simulation values from timing-assumption estimates. CPI = cycles / instructions; IPC = instructions / cycles; host simulation throughput = instructions / measured host execution seconds. Estimated hardware execution time is instruction count × the assumed cycle period (single-cycle or pipelined), and estimated speedup is the ratio of those two modeled times. It is not a measured silicon speedup. `riscv_top` currently exposes no architectural retirement/performance counters, so users must collect correct counts in a verification harness before invoking the report.

Branch flush input counts redirect events; in this design each taken branch flushes the two younger instruction slots. Use the same definition consistently when comparing implementations. Clock periods must come from a stated critical-path/timing analysis; no timing constraint or technology-mapped timing result is included in this repository yet.

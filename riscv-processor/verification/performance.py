#!/usr/bin/env python3
"""Report performance from explicitly supplied simulation counters and timing."""
import argparse
import json


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--instructions", type=int, required=True, help="retired instructions from simulation")
    parser.add_argument("--cycles", type=int, required=True, help="elapsed clock cycles from simulation")
    parser.add_argument("--stalls", type=int, required=True, help="stall cycles counted by simulation")
    parser.add_argument("--branch-flushes", type=int, required=True, help="taken-branch flush events counted by simulation")
    parser.add_argument("--execution-seconds", type=float, required=True, help="measured host simulation elapsed time")
    parser.add_argument("--single-cycle-ns", type=float, required=True, help="single-cycle critical-path timing assumption")
    parser.add_argument("--pipeline-cycle-ns", type=float, required=True, help="pipeline clock period assumption")
    args = parser.parse_args()
    if min(args.instructions, args.cycles) <= 0 or min(args.stalls, args.branch_flushes) < 0:
        parser.error("instruction/cycle counts must be positive and event counts non-negative")
    if min(args.execution_seconds, args.single_cycle_ns, args.pipeline_cycle_ns) <= 0:
        parser.error("time measurements and timing assumptions must be positive")
    pipeline_hw_seconds = args.cycles * args.pipeline_cycle_ns * 1e-9
    single_hw_seconds = args.instructions * args.single_cycle_ns * 1e-9
    print(json.dumps({
        "measured_simulation": {
            "instructions": args.instructions, "cycles": args.cycles,
            "CPI": args.cycles / args.instructions,
            "IPC": args.instructions / args.cycles,
            "stall_cycles": args.stalls, "branch_flush_events": args.branch_flushes,
            "host_execution_seconds": args.execution_seconds,
            "host_simulation_throughput_instructions_per_second": args.instructions / args.execution_seconds,
        },
        "timing_assumption_estimates": {
            "single_cycle_ns": args.single_cycle_ns,
            "pipeline_cycle_ns": args.pipeline_cycle_ns,
            "single_cycle_execution_seconds": single_hw_seconds,
            "pipelined_execution_seconds": pipeline_hw_seconds,
            "speedup": single_hw_seconds / pipeline_hw_seconds,
            "estimated_pipeline_throughput_instructions_per_second": args.instructions / pipeline_hw_seconds,
        }
    }, indent=2))


if __name__ == "__main__":
    main()

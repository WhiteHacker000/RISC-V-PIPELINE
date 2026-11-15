#!/usr/bin/env python3
"""Calculate CPI and IPC from counters exported by processor_tb simulation."""
import argparse
import csv
import json
from pathlib import Path


FIELDS = {
    "benchmark", "cycles", "retired", "wb_completed", "stalls",
    "branch_flushes", "taken_branches", "not_taken_branches",
}


def read_results(path: Path) -> list[dict[str, object]]:
    with path.open(newline="", encoding="utf-8") as stream:
        reader = csv.DictReader(stream)
        if set(reader.fieldnames or []) != FIELDS:
            raise ValueError(f"unexpected CSV columns: {reader.fieldnames}")
        results = []
        for row in reader:
            item: dict[str, object] = {"benchmark": row["benchmark"]}
            for field in FIELDS - {"benchmark"}:
                item[field] = int(row[field])
            cycles = int(item["cycles"])
            retired = int(item["retired"])
            if cycles <= 0 or retired <= 0:
                raise ValueError(f"{item['benchmark']}: cycles and retired must be positive")
            if item["wb_completed"] != retired:
                raise ValueError(f"{item['benchmark']}: WB-completed count differs from retirement")
            if item["stalls"] > cycles or item["branch_flushes"] > item["taken_branches"]:
                raise ValueError(f"{item['benchmark']}: impossible stall/flush counter")
            item["CPI"] = cycles / retired
            item["IPC"] = retired / cycles
            results.append(item)
    if not results:
        raise ValueError("CSV contains no benchmark rows")
    return results


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("csv_file", nargs="?", type=Path,
                        default=Path("simulation/performance.csv"),
                        help="simulation-generated performance CSV")
    args = parser.parse_args()
    try:
        results = read_results(args.csv_file)
    except (OSError, ValueError) as exc:
        parser.error(str(exc))
    print("Measured simulation counters (not hardware timing estimates):")
    print(json.dumps(results, indent=2))


if __name__ == "__main__":
    main()

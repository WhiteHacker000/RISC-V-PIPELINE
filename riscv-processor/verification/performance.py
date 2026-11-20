#!/usr/bin/env python3
"""Calculate and chart CPI and IPC from counters exported by processor_tb."""
import argparse
import csv
import html
import json
import math
from pathlib import Path
from typing import TypedDict


FIELDS = {
    "benchmark", "cycles", "retired", "wb_completed", "stalls",
    "branch_flushes", "taken_branches", "not_taken_branches",
}
DOCS = Path(__file__).resolve().parents[1] / "docs"


class Result(TypedDict):
    benchmark: str
    cycles: int
    retired: int
    wb_completed: int
    stalls: int
    branch_flushes: int
    taken_branches: int
    not_taken_branches: int
    CPI: float
    IPC: float


def display_name(benchmark: str) -> str:
    labels = {
        "independent": "Independent arithmetic",
        "dependent": "Dependent arithmetic",
        "load_use": "Load-use dependency",
        "branches": "Taken/not-taken branches",
        "three_addi": "Three dependent ADDI",
        "long_arithmetic": "Long arithmetic (64 ADDI)",
        "independent_50": "Independent arithmetic (50 instructions)",
        "independent_100": "Independent arithmetic (100 instructions)",
        "dependent_50": "Dependent arithmetic (50 instructions)",
        "branch_heavy": "Branch-heavy loop",
    }
    return labels.get(benchmark, benchmark.replace("_", " ").title())


def format_metric(value: float) -> str:
    return f"{value:.4f}".rstrip("0").rstrip(".")


def read_results(path: Path) -> list[Result]:
    with path.open(newline="", encoding="utf-8") as stream:
        reader = csv.DictReader(stream)
        if set(reader.fieldnames or []) != FIELDS:
            raise ValueError(f"unexpected CSV columns: {reader.fieldnames}")
        results: list[Result] = []
        for row in reader:
            item: Result = {
                "benchmark": row["benchmark"] or "",
                "cycles": int(row["cycles"] or ""),
                "retired": int(row["retired"] or ""),
                "wb_completed": int(row["wb_completed"] or ""),
                "stalls": int(row["stalls"] or ""),
                "branch_flushes": int(row["branch_flushes"] or ""),
                "taken_branches": int(row["taken_branches"] or ""),
                "not_taken_branches": int(row["not_taken_branches"] or ""),
                "CPI": 0.0,
                "IPC": 0.0,
            }
            cycles = item["cycles"]
            retired = item["retired"]
            if not item["benchmark"]:
                raise ValueError("benchmark name must not be empty")
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


def write_markdown(results: list[Result], path: Path) -> None:
    lines = [
        "# Measured performance results",
        "",
        "Generated from `simulation/performance.csv` by `verification/performance.py`.",
        "These are simulation measurements, not hardware timing results.",
        "",
        "| Benchmark | Cycles | Retired / WB | Stall cycles | Flush events | Taken branches | Not-taken branches | CPI | IPC |",
        "|---|---:|---:|---:|---:|---:|---:|---:|---:|",
    ]
    for row in results:
        lines.append(
            f"| {display_name(row['benchmark'])} | {row['cycles']} | "
            f"{row['retired']} / {row['wb_completed']} | {row['stalls']} | "
            f"{row['branch_flushes']} | {row['taken_branches']} | "
            f"{row['not_taken_branches']} | {format_metric(row['CPI'])} | "
            f"{format_metric(row['IPC'])} |"
        )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_svg(results: list[Result], path: Path) -> None:
    width = 1080
    row_height = 42
    top = 104
    height = top + row_height * len(results) + 52
    panels = [
        ("CPI", "Cycles per retired instruction", 20, "#3569a8"),
        ("IPC", "Retired instructions per cycle", 555, "#35855b"),
    ]
    svg = [
        f'<svg xmlns="http://www.w3.org/2000/svg" role="img" '
        f'aria-labelledby="title description" width="{width}" height="{height}" '
        f'viewBox="0 0 {width} {height}">',
        "<title id=\"title\">Measured simulation CPI and IPC</title>",
        "<desc id=\"description\">CPI and IPC calculated from the processor testbench CSV.</desc>",
        '<rect width="100%" height="100%" fill="#ffffff"/>',
        '<g font-family="Arial, Helvetica, sans-serif" fill="#222">',
        f'<text x="{width / 2:g}" y="28" text-anchor="middle" font-size="20" font-weight="bold">'
        "Measured pipeline performance (simulation)</text>",
        f'<text x="{width / 2:g}" y="52" text-anchor="middle" font-size="12">'
        "Derived from actual CSV cycle and retirement counters; not hardware timing.</text>",
    ]

    for metric, title, panel_x, color in panels:
        panel_width = 505
        label_width = 187
        plot_width = 268
        plot_x = panel_x + label_width
        max_value = math.ceil(max(row[metric] for row in results) * 4) / 4
        svg.append(
            f'<text x="{panel_x + panel_width / 2:g}" y="78" text-anchor="middle" '
            f'font-size="15" font-weight="bold">{html.escape(title)}</text>'
        )
        for tick in range(5):
            value = max_value * tick / 4
            x = plot_x + plot_width * tick / 4
            svg.append(
                f'<line x1="{x:g}" y1="{top - 14}" x2="{x:g}" '
                f'y2="{top + row_height * len(results) - 6}" '
                'stroke="#d9dde2" stroke-width="1"/>'
            )
            svg.append(
                f'<text x="{x:g}" y="{top + row_height * len(results) + 14}" '
                f'text-anchor="middle" font-size="11">{value:.2f}</text>'
            )
        for index, row in enumerate(results):
            y = top + row_height * index
            name = html.escape(display_name(row["benchmark"]))
            value = row[metric]
            bar_width = plot_width * value / max_value
            svg.extend([
                f'<text x="{panel_x}" y="{y + 13}" font-size="12">{name}</text>',
                f'<rect x="{plot_x:g}" y="{y - 1}" width="{bar_width:g}" height="22" '
                f'rx="2" fill="{color}"/>',
                f'<text x="{plot_x + plot_width + 8:g}" y="{y + 14}" '
                f'font-size="12">{format_metric(value)}</text>',
            ])

    svg.extend([
        "</g>",
        "</svg>",
        "",
    ])
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(svg), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "csv_file", nargs="?", type=Path,
        default=Path("simulation/performance.csv"),
        help="simulation-generated performance CSV",
    )
    parser.add_argument(
        "--markdown-output", type=Path, default=DOCS / "performance_results.md",
        help="path for the generated Markdown results table",
    )
    parser.add_argument(
        "--svg-output", type=Path, default=DOCS / "performance_analysis.svg",
        help="path for the generated CPI/IPC graph",
    )
    args = parser.parse_args()
    try:
        results = read_results(args.csv_file)
    except (OSError, ValueError) as exc:
        parser.error(str(exc))
    write_markdown(results, args.markdown_output)
    write_svg(results, args.svg_output)
    print("Measured simulation counters (not hardware timing estimates):")
    print(json.dumps(results, indent=2))
    print(f"Wrote {args.markdown_output} and {args.svg_output}")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""RU: Собирает открытые пункты из сводок, чтобы передать контекст следующему ассистенту.
EN: Collects open items from session summaries so the next assistant can resume quickly.

Использование / Usage:
    python local/scripts/collect_open_items.py [--summaries-dir local/session_summaries]

RU: Скрипт проходит по всем Markdown-файлам в каталоге сводок (от новых к старым) и вытаскивает
разделы «Рекомендации / Next Steps» и «Открытые вопросы / Pending Items».
EN: The script walks every Markdown summary (newest first) and extracts
the “Рекомендации / Next Steps” and “Открытые вопросы / Pending Items” sections.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path
from typing import Iterable, List, Dict


BILINEAR_HEADER = "# Сводка открытых пунктов / Aggregated open items"
BILINEAR_EMPTY = "_Нет сводок с открытыми пунктами / No session summaries with open items._"
SECTION_HEADINGS = {
    "recommendations": "## Рекомендации / Next Steps",
    "pending": "## Открытые вопросы / Pending Items",
}


def extract_section(lines: List[str], heading: str) -> List[str]:
    items: List[str] = []
    capture = False
    for line in lines:
        stripped = line.rstrip("\n")
        if stripped.startswith("## "):
            if capture:
                break
            capture = stripped.strip() == heading
            continue
        if not capture:
            continue
        if stripped.strip() == "":
            continue
        if stripped.startswith(("-", "*")):
            items.append(stripped.strip())
        elif items:
            items[-1] += f" {stripped.strip()}"
        else:
            items.append(stripped.strip())
    return items


def iter_summary_files(directory: Path) -> Iterable[Path]:
    return sorted(directory.glob("*.md"), reverse=True)


def build_report(directory: Path) -> List[Dict[str, object]]:
    report = []
    for path in iter_summary_files(directory):
        text = path.read_text(encoding="utf-8")
        lines = text.splitlines()
        rec = extract_section(lines, SECTION_HEADINGS["recommendations"])
        pending = extract_section(lines, SECTION_HEADINGS["pending"])
        if not rec and not pending:
            continue
        report.append(
            {
                "path": str(path),
                "recommendations": rec,
                "pending": pending,
            }
        )
    return report


def print_report(entries: List[Dict[str, object]]) -> None:
    print(BILINEAR_HEADER)
    if not entries:
        print(f"\n{BILINEAR_EMPTY}")
        return
    for entry in entries:
        print(f"\n## {entry['path']}")
        if entry["recommendations"]:
            print("\n### Рекомендации / Next Steps")
            for item in entry["recommendations"]:
                print(item)
        if entry["pending"]:
            print("\n### Открытые вопросы / Pending Items")
            for item in entry["pending"]:
                print(item)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="RU: Собирает открытые пункты из сводок / EN: Collects open items from session summaries"
    )
    parser.add_argument(
        "--summaries-dir",
        default=Path("local/session_summaries"),
        type=Path,
        help="RU: Каталог со сводками / EN: Directory with session summaries",
    )
    args = parser.parse_args()

    if not args.summaries_dir.exists():
        print(
            f"Каталог сводок не найден / Summaries directory not found: {args.summaries_dir}",
            file=sys.stderr,
        )
        return 1

    entries = build_report(args.summaries_dir)
    print_report(entries)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

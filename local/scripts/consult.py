#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
RU: Оркестратор для консультаций с несколькими AI-ассистентами.
EN: Orchestrator for multi-assistant AI consultations.

RU: Скрипт реализует два этапа:
  1. execute — собирает контекст (AGENTS.md, local/chat_context.md,
     local/project_addenda.md, local/session_history.md), формирует команды
     для указанных ассистентов и запускает их параллельно. Каждый процесс
     получает единый префикс-подсказку и пишет вывод в `tmp/consultation_runs/<ID>/*.raw.log`.
  2. process — обрабатывает накопленные логи: опционально вызывает
     `local/scripts/trim_consult_logs.py`, сохраняет компактные JSONL и добавляет
     краткую запись в `local/session_history.md`.

EN: The script runs in two stages:
  1. execute — gather context (AGENTS.md, local/chat_context.md,
     local/project_addenda.md, local/session_history.md), spawn the
     requested assistants in parallel, and capture their raw JSON logs.
  2. process — post-process those logs (optionally via
     `local/scripts/trim_consult_logs.py`) and append a summary to
     `local/session_history.md`.
"""

from __future__ import annotations

import argparse
import glob
import json
import os
import shlex
import subprocess
import sys
import textwrap
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Sequence, Tuple

# --- Константы / Constants -------------------------------------------------

CONTEXT_FILES = [
    "AGENTS.md",
    "local/project_addenda.md",
    "local/chat_context.md",
    "local/session_history.md",
]

RUNS_DIR = Path("tmp", "consultation_runs")
ASSISTANT_CONTEXTS = Path("tmp", "assistant_contexts")
ASSISTANT_LOG_DIR = ASSISTANT_CONTEXTS / "logs"
ASSISTANT_ATTACH_DIR = ASSISTANT_CONTEXTS / "attachments"
TRIM_SCRIPT = Path(__file__).parent / "trim_consult_logs.py"
SESSION_HISTORY = Path("local", "session_history.md")
TOTAL_TIMEOUT = 120  # seconds

# Значения по умолчанию можно переопределить переменными окружения.
# Default command templates can be overridden via env vars (AI_CMD_NAME).
DEFAULT_CMD_TEMPLATES: Dict[str, str] = {
    "gemini": os.environ.get("AI_CMD_GEMINI", "gemini --json"),
    "qwen": os.environ.get("AI_CMD_QWEN", "qwen --json"),
    "codex": os.environ.get("AI_CMD_CODEX", "codex exec --json"),
    "copilot": os.environ.get("AI_CMD_COPILOT", "copilot chat --format json"),
}


# --- Утилиты / Helpers ------------------------------------------------------

def _read_file(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError:
        print(f"WARN: {path} отсутствует / missing", file=sys.stderr)
    except OSError as exc:
        print(f"WARN: Не удалось прочитать {path}: {exc}", file=sys.stderr)
    return ""


def _gather_context(prompt: str) -> str:
    parts: List[str] = []
    for rel in CONTEXT_FILES:
        path = Path(rel)
        content = _read_file(path)
        if not content:
            continue
        parts.append(f"--- START OF {rel} ---\n{content}\n--- END OF {rel} ---\n")
    preface = "\n".join(parts)
    return textwrap.dedent(
        f"""
        # Контекст / Context

        {preface}

        # Запрос / Request

        Проанализируй контекст выше и ответь на запрос ниже. /
        Analyze the context above and respond to the request below.

        {prompt}
        """
    ).strip()


def _build_commands(assistants: Sequence[str], run_dir: Path) -> Tuple[List[List[str]], List[Path]]:
    commands: List[List[str]] = []
    outputs: List[Path] = []
    for name in assistants:
        template = DEFAULT_CMD_TEMPLATES.get(name)
        if not template:
            print(f"WARN: Ассистент '{name}' не настроен / assistant '{name}' is not configured", file=sys.stderr)
            continue
        base_cmd = shlex.split(template)
        if not base_cmd:
            continue
        log_path = run_dir / f"{name}.raw.log"
        commands.append(base_cmd)
        outputs.append(log_path)
    return commands, outputs


def _write_session_history(run_id: str, assistants: Sequence[str], files: Sequence[Path]) -> None:
    timestamp = datetime.now(tz=timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    lines = [
        "",
        f"### Консультация {run_id}",
        f"- **Время / Timestamp:** {timestamp}",
        f"- **Ассистенты / Assistants:** {', '.join(assistants) if assistants else 'n/a'}",
    ]
    for path in files:
        lines.append(f"- **Лог / Log:** `{path.as_posix()}`")
    lines.append("- **Примечания / Notes:** (дополните вручную)")
    SESSION_HISTORY.parent.mkdir(parents=True, exist_ok=True)
    with SESSION_HISTORY.open("a", encoding="utf-8") as fh:
        fh.write("\n".join(lines) + "\n")


def _call_trim_script(raw_log: Path, run_dir: Path, run_id: str) -> Path:
    if not TRIM_SCRIPT.exists():
        # Если скрипт не найден, возвращаем исходный лог.
        print(f"WARN: {TRIM_SCRIPT} не найден; пропускаю обработку / skipping trim", file=sys.stderr)
        return raw_log

    namespace = raw_log.stem
    trimmed_dir = ASSISTANT_LOG_DIR / namespace
    trimmed_dir.mkdir(parents=True, exist_ok=True)
    trimmed_path = trimmed_dir / f"{run_id}.jsonl"
    ASSISTANT_ATTACH_DIR.mkdir(parents=True, exist_ok=True)

    cmd = [
        sys.executable,
        str(TRIM_SCRIPT),
        "--input",
        str(raw_log),
        "--output",
        str(trimmed_path),
        "--attachments-dir",
        str(ASSISTANT_ATTACH_DIR),
        "--namespace",
        f"{namespace}-{run_id}",
    ]
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as exc:
        print(f"WARN: trim_consult_logs.py failed for {raw_log}: {exc}", file=sys.stderr)
        return raw_log
    return trimmed_path


# --- Этап 1 / Stage 1 -------------------------------------------------------

def execute_stage(args: argparse.Namespace) -> None:
    run_id = datetime.utcnow().strftime("%Y%m%dT%H%M%S_Z")
    run_dir = RUNS_DIR / run_id
    run_dir.mkdir(parents=True, exist_ok=True)

    assistants = [name.strip() for name in args.assistants.split(",") if name.strip()]
    if not assistants:
        print("ERROR: Список ассистентов пуст / assistant list is empty", file=sys.stderr)
        sys.exit(1)

    context_prompt = _gather_context(args.prompt)
    commands, outputs = _build_commands(assistants, run_dir)
    if not commands:
        print("ERROR: Нет подходящих команд для запуска / no commands to run", file=sys.stderr)
        sys.exit(1)

    print(f"INFO: run_id = {run_id}")
    processes = []
    handles = []
    try:
        for cmd, log_path in zip(commands, outputs):
            log_file = log_path.open("w", encoding="utf-8")
            handles.append(log_file)
            proc = subprocess.Popen(
                cmd,
                stdin=subprocess.PIPE,
                stdout=log_file,
                stderr=log_file,
                text=True,
                encoding="utf-8",
            )
            processes.append(proc)

        for proc in processes:
            try:
                if proc.stdin:
                    proc.stdin.write(context_prompt + "\n")
            except BrokenPipeError:
                print(f"WARN: stdin закрыт у PID {proc.pid}", file=sys.stderr)
            finally:
                if proc.stdin:
                    proc.stdin.close()

        start = time.time()
        while time.time() - start < TOTAL_TIMEOUT:
            if all(p.poll() is not None for p in processes):
                break
            time.sleep(1)
        else:
            print(f"WARN: timeout {TOTAL_TIMEOUT}s, terminating pending processes", file=sys.stderr)
            for proc in processes:
                if proc.poll() is None:
                    proc.terminate()
    finally:
        for handle in handles:
            handle.close()
        for proc in processes:
            if proc.poll() is None:
                proc.kill()

    print("=" * 80)
    print("ЭТАП 2 / STAGE 2")
    print("Запустите / Run:")
    print(f"{sys.executable} {Path(__file__).as_posix()} process {run_id}")
    print("=" * 80)


# --- Этап 2 / Stage 2 -------------------------------------------------------

def process_stage(args: argparse.Namespace) -> None:
    run_dir = RUNS_DIR / args.run_id
    if not run_dir.is_dir():
        print(f"ERROR: {run_dir} не найден / not found", file=sys.stderr)
        sys.exit(1)

    raw_logs = sorted(run_dir.glob("*.raw.log"))
    if not raw_logs:
        print("ERROR: raw логи не найдены / no raw logs", file=sys.stderr)
        sys.exit(1)

    trimmed_paths: List[Path] = []
    for log in raw_logs:
        trimmed_paths.append(_call_trim_script(log, run_dir, args.run_id))

    assistants = [path.stem.split(".")[0] for path in raw_logs]
    _write_session_history(args.run_id, assistants, trimmed_paths)
    print(f"INFO: Готово. Обновлён {SESSION_HISTORY} / Done, history updated.")


# --- CLI --------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="RU: Оркестратор консультаций / EN: Consultation orchestrator",
        formatter_class=argparse.RawTextHelpFormatter,
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    exec_parser = subparsers.add_parser(
        "execute", help="RU: запустить ассистентов / EN: run assistants"
    )
    exec_parser.add_argument(
        "-a",
        "--assistants",
        required=True,
        help="Список ассистентов через запятую (gemini,qwen,...) / comma-separated",
    )
    exec_parser.add_argument(
        "-p",
        "--prompt",
        required=True,
        help="Основной запрос / primary question",
    )
    exec_parser.set_defaults(func=execute_stage)

    proc_parser = subparsers.add_parser(
        "process", help="RU: обработать логи / EN: process logs"
    )
    proc_parser.add_argument("run_id", help="ID из директории tmp/consultation_runs")
    proc_parser.set_defaults(func=process_stage)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()

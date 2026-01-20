#!/usr/bin/env python3
"""RU: Уплотняет журналы консультаций, вынося крупные блоки вывода в файлы.

EN: Compact multi-assistant consultation logs by trimming bulky fields.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from datetime import UTC, datetime
from pathlib import Path
from typing import Dict, Iterable, List, Optional

DEFAULT_TRUNCATE = 2048  # characters
DEFAULT_CHUNK_SIZE = 5 * 1024 * 1024  # 5 MiB


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="RU: Сжимает JSONL-логи консультаций / EN: Compacts consultation JSONL logs."
    )
    parser.add_argument("--input", required=True, type=Path, help="RU: путь к raw JSONL / EN: raw JSONL input")
    parser.add_argument("--output", type=Path, help="RU: путь для компактного JSONL / EN: compact JSONL output")
    parser.add_argument(
        "--attachments-dir",
        type=Path,
        help="RU: директория для вынесенных блоков / EN: directory for extracted attachments",
    )
    parser.add_argument(
        "--namespace",
        default="consult",
        help="RU: именной префикс файлов / EN: attachment namespace (e.g. gemini)",
    )
    parser.add_argument(
        "--truncate",
        type=int,
        default=DEFAULT_TRUNCATE,
        help="RU: сколько символов оставлять inline / EN: inline character limit",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        help="RU: каталог для auto-файлов / EN: directory to auto-create timestamped JSONL (incompatible with --output)",
    )
    parser.add_argument("--tag", type=str, help="RU/EN: optional filename tag")
    parser.add_argument(
        "--chunk-size",
        type=int,
        default=DEFAULT_CHUNK_SIZE,
        help="RU: размер чанка вложения / EN: attachment chunk size in bytes (0 = no chunking)",
    )
    return parser.parse_args()


def _chunk_payload(text: str, max_bytes: int) -> List[str]:
    if max_bytes <= 0:
        return [text]
    chunks: List[str] = []
    current: List[str] = []
    current_bytes = 0

    def flush() -> None:
        nonlocal current, current_bytes
        if current:
            chunks.append("".join(current))
            current = []
            current_bytes = 0

    for line in text.splitlines(True):
        encoded = line.encode("utf-8", errors="ignore")
        size = len(encoded)
        if size > max_bytes:
            flush()
            start = 0
            while start < size:
                piece = encoded[start : start + max_bytes]
                chunks.append(piece.decode("utf-8", errors="ignore"))
                start += max_bytes
            continue
        if current_bytes + size > max_bytes:
            flush()
        current.append(line)
        current_bytes += size
    flush()
    return chunks or [""]


def _write_attachment(
    payload: str,
    attachments_dir: Path,
    namespace: str,
    item_id: str,
    session_stamp: str,
    index: int,
    chunk_size: int,
) -> List[Dict[str, object]]:
    chunks = _chunk_payload(payload, chunk_size) if chunk_size else [payload]
    meta: List[Dict[str, object]] = []
    for chunk_idx, chunk in enumerate(chunks, start=1):
        timestamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
        data = chunk.encode("utf-8", errors="ignore")
        digest = hashlib.sha256(data).hexdigest()
        rel_path = (
            Path(namespace)
            / session_stamp
            / f"{index:02d}_{timestamp}_{digest[:10]}_{item_id}_chunk{chunk_idx:02d}.log"
        )
        abs_path = attachments_dir / rel_path
        abs_path.parent.mkdir(parents=True, exist_ok=True)
        abs_path.write_bytes(data)
        meta.append(
            {
                "path": rel_path.as_posix(),
                "bytes": len(data),
                "sha256": digest,
                "chunk_index": chunk_idx,
                "chunks_total": len(chunks),
            }
        )
    return meta


def _trim_event(
    event: Dict[str, object],
    *,
    attachments_dir: Optional[Path],
    namespace: str,
    truncate: int,
    session_stamp: str,
    index: int,
    chunk_size: int,
) -> None:
    payload = event.get("aggregated_output")
    if not isinstance(payload, str):
        return
    if attachments_dir:
        info = _write_attachment(payload, attachments_dir, namespace, "aggregated_output", session_stamp, index, chunk_size)
        event["aggregated_output"] = f"[externalized: {len(info)} attachment(s)]"
        event.setdefault("attachments", {})["aggregated_output"] = info
    else:
        event["aggregated_output"] = payload[:truncate] + (" …" if len(payload) > truncate else "")


def _prepare_output_path(args: argparse.Namespace, namespace: str) -> Path:
    if args.output:
        return args.output
    if args.output_dir:
        stamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
        tag = f"-{args.tag}" if args.tag else ""
        out_dir = args.output_dir / namespace
        out_dir.mkdir(parents=True, exist_ok=True)
        return out_dir / f"{stamp}{tag}.jsonl"
    raise SystemExit("ERROR: --output или --output-dir обязательно / either --output or --output-dir required")


def main() -> None:
    args = _parse_args()
    attachments_dir = args.attachments_dir
    if attachments_dir:
        attachments_dir.mkdir(parents=True, exist_ok=True)
    output_path = _prepare_output_path(args, args.namespace)

    session_stamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
    with args.input.open("r", encoding="utf-8") as src, output_path.open("w", encoding="utf-8") as dst:
        for idx, line in enumerate(src, start=1):
            line = line.strip()
            if not line:
                continue
            event = json.loads(line)
            _trim_event(
                event,
                attachments_dir=attachments_dir,
                namespace=args.namespace,
                truncate=args.truncate,
                session_stamp=session_stamp,
                index=idx,
                chunk_size=args.chunk_size,
            )
            dst.write(json.dumps(event, ensure_ascii=False) + "\n")

    print(f"OK: compact log saved to {output_path}")


if __name__ == "__main__":
    main()


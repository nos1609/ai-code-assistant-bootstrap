# Инструкции ассистентам (шаблон) / Local agent instructions (template)

> Version: 2026-01-20
> RU: Этот файл намеренно короткий (P0). Детали — в `local/ai/agents/*.md`.
> EN: This file is intentionally short (P0). Details live under `local/ai/agents/*.md`.

## P0 rules / P0 правила
- RU: Сначала прочитай `local/ai/chat_context.md` — это источник истины по договорённостям сессии.
  EN: Read `local/ai/chat_context.md` first; it is the source of truth for session agreements.
- RU: Артефакты/эксперименты писать только в `tmp/ai/**` (и никуда больше) без явного запроса.
  EN: Write artifacts/experiments only under `tmp/ai/**` (and nowhere else) unless explicitly asked.
- RU: Интеграция шаблона: не копируй и не перезаписывай `README.md` / `README.en.md`; максимум — добавить скрытый сниппет из `README_snippet.md` (если политика разрешает).
  EN: Template integration: do not copy/overwrite `README.md` / `README.en.md`; at most add the hidden snippet from `README_snippet.md` (if policy allows).
- RU: Предпочитай `.git/info/exclude` (список берём из блока `BEGIN/END EXCLUDE LIST` в `.gitignore`), а не правку `.gitignore` целевого репозитория.
  EN: Prefer `.git/info/exclude` (copy entries from the `.gitignore` `BEGIN/END EXCLUDE LIST` block) instead of editing the target repo `.gitignore`.
- RU: Windows: симлинки могут требовать Admin/Developer Mode; если недоступно — использовать hardlink (без копий, чтобы не было дрейфа).
  EN: Windows: symlinks may require Admin/Developer Mode; if unavailable, use hardlinks (no copies to avoid drift).
- RU: Не создавать тестовые папки в корне репозитория; для проверок использовать `tmp/ai/**`.
  EN: Do not create test folders in the repo root; use `tmp/ai/**` for tests.

## Modules / Разделы
- local/ai/agents/00-codex-size.md — 32 KiB limit and strategy
- local/ai/agents/01-bootstrap.md — bootstrap + quick start
- local/ai/agents/02-logging.md — JSONL logging policy
- local/ai/agents/03-sandbox.md — sandbox/network/approval rules
- local/ai/agents/04-formatting.md — response formatting + checks
- local/ai/agents/05-upstream.md — upstream sync
- local/ai/agents/06-instructions.md — assistant instruction files + symlinks
- local/ai/agents/07-profile.md — language/gender/profile agreements
- local/ai/agents/08-checks.md — tests/linters/verification
- local/ai/agents/09-closure.md — session closure protocol
- local/ai/agents/10-handoff.md — inter-assistant protocol + handoff checklist
- local/ai/agents/11-cli-bootstrap.md — CLI readiness + safe usage
- local/ai/agents/12-general.md — general requirements (P1+)

## Reading order / Порядок чтения
1) `local/ai/chat_context.md` (source of truth / источник истины)
2) `local/ai/agents/01-bootstrap.md` (integration checklist)
3) `local/ai/agents/02-logging.md` + `local/ai/agents/07-profile.md`
4) Work: `local/ai/agents/12-general.md`, `local/ai/agents/03-sandbox.md`, `local/ai/agents/11-cli-bootstrap.md`, `local/ai/agents/08-checks.md`, `local/ai/agents/04-formatting.md`
5) Handoff/closure: `local/ai/agents/10-handoff.md`, `local/ai/agents/09-closure.md`

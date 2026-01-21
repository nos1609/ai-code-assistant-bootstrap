# Взаимодействие ассистентов и handoff / Inter-assistant protocol & handoff
#
# RU: Что передавать между ассистентами и как делать handoff, чтобы не терять договорённости.
# EN: What to pass between assistants and how to hand off without losing agreements.

## Пакет контекста / Context package
- RU: Перед подключением другого ассистента передать ссылки на `AGENTS.md`, `local/ai/chat_context.md` (quick profile), `local/ai/session_history.md`, `local/ai/project_addenda.md` (если есть).
  EN: Before involving another assistant, share links to `AGENTS.md`, `local/ai/chat_context.md` (quick profile), `local/ai/session_history.md`, and `local/ai/project_addenda.md` (if present).
- RU: Напомнить про логи: `local/ai/<assistant>/{sessions.log,requests.log}` и проверить, что записи действительно создаются.
  EN: Remind about logs: `local/ai/<assistant>/{sessions.log,requests.log}` and confirm entries are actually being written.
- RU: Если требуется несколько CLI/команд — согласовать одним запросом полный список команд (по строке) и обоснование (см. `local/ai/agents/03-sandbox.md`).
  EN: If multiple CLIs/commands are needed, align once on the full per-line command list and justification (see `local/ai/agents/03-sandbox.md`).
- RU: При распределении задач между ассистентами фиксировать роли и очередь (кто консультирует, кто проверяет), чтобы избегать конфликтов.
  EN: When splitting work across assistants, record roles and ordering (who consults, who reviews) to avoid conflicts.
- RU: По завершении консультации законспектировать выводы в `local/ai/session_history.md` и при необходимости обновить `local/ai/chat_context.md`.
  EN: After a consultation, summarize findings in `local/ai/session_history.md` and update `local/ai/chat_context.md` if needed.
- RU: Про лимит инструкций: помнить про ~32 KiB и держать P0 в корне (см. `local/ai/agents/00-codex-size.md`).
  EN: Size limit reminder: keep P0 in root and mind ~32 KiB limits (see `local/ai/agents/00-codex-size.md`).

## Handoff‑чеклист / Handoff checklist
- RU: Отмечать выполнение в `local/ai/session_history.md`.
  EN: Record completion in `local/ai/session_history.md`.

| Пункт / Item | RU | EN |
| --- | --- | --- |
| Контекст / Context | Ссылки: `AGENTS.md`, `local/ai/project_addenda.md` (если есть), quick profile в `local/ai/chat_context.md`, релевантные фрагменты `local/ai/session_history.md`. | Links: `AGENTS.md`, `local/ai/project_addenda.md` (if present), quick profile in `local/ai/chat_context.md`, relevant parts of `local/ai/session_history.md`. |
| Окружение / Environment | Текущие `sandbox_mode`, `network_access`, `approval_policy`. | Current `sandbox_mode`, `network_access`, `approval_policy`. |
| Эскалации / Escalations | Активные/ожидаемые согласования (что можно/нельзя делать сейчас). | Active/pending approvals (what is allowed now). |
| Последние шаги / Last steps | Что было сделано, что осталось, какие проверки ожидаются. | What was done, what remains, what checks are pending. |
| Логи / Logs | Подтвердить, что логи обновляются: `local/ai/<assistant>/{sessions.log,requests.log}`. | Confirm logs are updated: `local/ai/<assistant>/{sessions.log,requests.log}`. |
| Temp dirs / Temp dirs | Разрешено ли создавать tool temp dirs; кто чистит; где лежат (`tmp/ai/**`). | Whether tool temp dirs may be created; who cleans; where they live (`tmp/ai/**`). |

## Артефакты консультаций / Consultation artifacts
- RU: Сырые логи внешних инструментов складывать в `tmp/ai/consultation_runs/`, обработанные контексты/выжимки — в `tmp/ai/assistant_contexts/` (без секретов).
  EN: Store raw external-tool logs under `tmp/ai/consultation_runs/` and processed contexts/summaries under `tmp/ai/assistant_contexts/` (no secrets).

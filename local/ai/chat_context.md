# Контекст чата — <YYYY-MM-DD> / Chat context — <YYYY-MM-DD>

Файл фиксирует ключевые договорённости текущей сессии. Детализированная история хранится в `local/ai/session_history.md`, долговременные правила — в `local/ai/project_addenda.md`. После подтверждения рабочего языка и формы обращения записи ведутся только на нём.

## Рабочие языки / Working languages
- **RU:** Базовый язык — `<русский/english/...>`.  
- **EN:** Base language — `<ru/en/...>`.  
- **RU:** О себе говорю в `<женском/мужском/нейтральном>` роде, пользователя адресую как `<указать обращение>`.  
- **EN:** I speak about myself in `<feminine/masculine/neutral>` form and address the user as `<preferred salutation>`.

## Статус готовности / Readiness status
- `status`: `<pending|completed>`
- `last_verified_at`: `<YYYY-MM-DDTHH:MM:SSZ>`
- `agents_md_hash`: `sha256:<...>`
- **RU:** После прохождения bootstrap-чеклиста обновите поле `status` на `completed`, отметьте ISO-время и хэш `AGENTS.md`.  
  **EN:** Once the bootstrap checklist passes, set `status` to `completed`, record the ISO timestamp, and store the `AGENTS.md` hash.

## Системные указания / System directives
- **RU:** Соблюдаю иерархию контекста: `local/ai/chat_context.md` → `local/ai/project_addenda.md` → `local/ai/session_history.md`.  
  **EN:** Follow the context hierarchy: `local/ai/chat_context.md` → `local/ai/project_addenda.md` → `local/ai/session_history.md`.
- **RU:** В первом ответе подтверждаю язык, род, желаемую детализацию и доступность CLI; прошу сообщать об изменениях.  
  **EN:** First reply confirms language, gendered form, detail level, and CLI availability; invite updates if anything changes.
- **RU:** Формат ответов — согласно [AGENTS.md](../AGENTS.md). Перед запуском нового CLI изучаю `--help`.  
  **EN:** Responses follow [AGENTS.md](../AGENTS.md); run `--help` before using a new CLI.
- **RU:** При ограничениях песочницы прошу эскалацию (`with_escalated_permissions=true` + justification) вместо обхода.  
  **EN:** Request escalations (`with_escalated_permissions=true` + justification) whenever the sandbox blocks required actions.

## Краткая памятка / Quick profile
- **RU:** Окружения:  
  1. `<OS / shell 1>` — `<назначение>`.  
  2. `<OS / shell 2>` — `<назначение>`.  
  **EN:** Environments: see above; add or remove rows as needed.
- **RU:** CLI `gemini`, `qwen`, `codex`, `copilot` доступны `<по умолчанию/после подтверждения>`.  
  **EN:** List when each CLI becomes available (default or after approval).
- **RU:** Пользователь: `<роль>; уровень детализации>`; до запроса не упрощаю инструкции.  
  **EN:** User profile and required detail level.
- **RU:** Bootstrap-пункты (README комментарий, симлинки, `.gitignore`, логи) `<проверены/ожидают проверки>`; отклонения фиксирую в `local/ai/session_history.md`.  
  **EN:** State whether bootstrap items are verified; log deviations in `local/ai/session_history.md`.

## Документация / Documentation
- **RU:** Перечислите ключевые файлы (`docs/`, runbooks, onboarding) и договорённости где искать больше сведений.  
- **EN:** List key docs (runbooks, onboarding) for quick reference.

## Логирование / Logging
- **RU:** Логирование включено (`local/ai/<assistant>/sessions.log`, `requests.log`), формат JSONL, ISO-время (`YYYY-MM-DDTHH:MM:SSZ`). При запрете пользователем делаю пометку.  
- **EN:** Logging is enabled (JSONL with ISO timestamps); note explicitly if the user disables it.
- **RU:** Отмечаю текущие `sandbox_mode`, `network_access`, `approval_policy`; изменения фиксирую отдельной строкой.  
- **EN:** Record the current `sandbox_mode`, `network_access`, and `approval_policy`; append lines when they change.

## Разрешённые противоречия / Resolved contradictions
- **RU:** Список правил, где проектные указания переопределяют `AGENTS.md` (например, язык общения, формат таймстемпов, порядок приветствия).  
- **EN:** List rule overrides where project guidance replaces `AGENTS.md` defaults (language, timestamp policy, greeting order, etc.).

## Процедуры / Procedures
- **RU:**  
  - Минимизировать ручной ввод: делю инструкции на короткие команды.  
  - После каждой консультации обновляю `local/ai/session_history.md`, а при закрытии — `local/ai/session_summaries/<ISO>.md` с чек-листом `[summary][history][path][reminder][tmp cleanup]`.  
  - Многоагентные консультации: запускаю минимум `<N>` ассистентов через `local/ai/scripts/consult.py execute -a ...`, затем `process`.  
- **EN:**  
  - Keep commands short for manual entry.  
  - Update `local/ai/session_history.md` after each consultation; on closure create `local/ai/session_summaries/<ISO>.md` and tick the checklist `[summary][history][path][reminder][tmp cleanup]`.  
  - Multi-assistant workflow: run at least `<N>` assistants via `local/ai/scripts/consult.py execute -a ...`, then `process`.

## Хронология текущей сессии / Session request log
1. `<Добавляйте ключевые события: чтение инструкций, запуски скриптов, проверки.>`

## Выполненные изменения / Applied changes
- `<path>:<line> — краткое описание>`

## Проверки / Checks
- `<команда>` — `<успех/ошибка + вывод>`

## Оставшиеся идеи / Pending ideas
- `<кратко перечислите будущие шаги или вопросы>`

## Логи и hand-off / Logs & hand-off
- **RU:** Актуальные журналы: `local/ai/<assistant>/sessions.log`, `local/ai/<assistant>/requests.log` (JSONL, ISO UTC).  
  **EN:** Current logs: `local/ai/<assistant>/sessions.log`, `local/ai/<assistant>/requests.log` (JSONL, ISO UTC).
- **RU:** Долгосрочный контекст — `local/ai/session_history.md`; итоговые сводки — `local/ai/session_summaries/`.  
  **EN:** Long-term context lives in `local/ai/session_history.md`; final summaries reside in `local/ai/session_summaries/`.
- **RU:** При hand-off обновляю `handoff_from` / `handoff_to` в `local/ai/<assistant>/sessions.log` и ссылку на последнюю сводку.  
  **EN:** During hand-off, set `handoff_from` / `handoff_to` in `local/ai/<assistant>/sessions.log` and reference the latest summary file.


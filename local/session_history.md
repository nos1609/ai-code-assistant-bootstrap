# Журнал сессии — <YYYY-MM-DD> / Session history — <YYYY-MM-DD>

Файл хранит подробную хронологию действий всех ассистентов (gemini, qwen, codex, copilot). Он не коммитится и служит общим блокнотом: фиксируйте выводы, договорённости, логи и ссылки на артефакты.

## Полезные ссылки / Helpful resources
- `<docs/runbooks/manuals>`

## Хронология / Timeline
1. `<ISO-время>` — `<действие: чтение AGENTS.md, запуск bootstrap_check, консультация gemini ...>`
2. `<ISO-время>` — `<список команд или наблюдений>`

## Решения и договорённости / Agreements
- `<коротко сформулируйте вывод + ссылка на файл/строку>`

## Открытые вопросы / Pending topics
- `<TODO / вопрос пользователя / ожидаемая проверка>`

## Проверки / Checks
- `./scripts/bootstrap_check.sh` — `<OK/FAIL + суть вывода>`
- `<другая команда>` — `<результат, путь к логам>`

## Логи и hand-off / Logs & hand-off
- **RU:** Каждую консультацию фиксируем в `local/<assistant>/sessions.log` и `requests.log` с ISO таймстемпом и ссылкой на артефакты (`tmp/assistant_contexts/...`).  
  **EN:** Log every consultation in `local/<assistant>/sessions.log` and `requests.log`, including ISO timestamps and links to `tmp/assistant_contexts/...`.
- **RU:** Для hand-off перечисляем открытые задачи, текущие `sandbox_mode`/`network_access`/`approval_policy`, и ссылки на свежие сводки `local/session_summaries/<ISO>.md`.  
  **EN:** For hand-offs list open tasks, current `sandbox_mode`/`network_access`/`approval_policy`, and provide links to `local/session_summaries/<ISO>.md`.

## Сводки / Summaries
- `<2025-01-01T120000Z.md>` — `<короткое описание содержания>`

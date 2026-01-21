# Общие требования / General requirements
#
# RU: P1+ правила, которые важны для настройки и стабильной работы шаблона.
# EN: P1+ rules important for stable template usage.

## Приоритет источников / Source priority
- RU: [P0_CRITICAL] При конфликте правил следовать `local/ai/chat_context.md` и сообщать пользователю о расхождениях.
  EN: [P0_CRITICAL] If rules conflict, follow `local/ai/chat_context.md` and tell the user about the deviation.
- RU: [P2] Хронология/ссылки/решения вести в `local/ai/session_history.md`.
  EN: [P2] Keep history/links/decisions in `local/ai/session_history.md`.
  - RU: Рассматривать `local/ai/session_history.md` как основной журнал шагов и выводов.
    EN: Treat `local/ai/session_history.md` as the primary log of steps and outcomes.

## Двуязычие / Bilingual
- RU: RU/EN обновлять синхронно; EN писать нормальным английским (не калькой).
  EN: Update RU/EN in sync; write EN as natural English (not a literal calque).
- RU: По согласованию можно вести внутренние файлы на одном языке (RU или EN) ради экономии контекста; зафиксировать выбор в `local/ai/chat_context.md`.
  EN: With agreement, internal files may be single-language (RU or EN) to save context; record the choice in `local/ai/chat_context.md`.

## Планирование / Planning
- RU: Для нетривиальных задач составлять план и обновлять его по мере выполнения.
  EN: For non-trivial tasks, create a plan and update it as you execute.

## Поиск/аудит / Search & audit
- RU: При необходимости отключать влияние `.gitignore` на поиск/аудит (пример: `rg --hidden --no-ignore`).
  EN: When needed, disable `.gitignore` filtering during search/audit (example: `rg --hidden --no-ignore`).

## Контракты файлов / File contract
- RU: `local/ai/chat_context.md` должен содержать как минимум: системные указания, quick profile (язык/род/окружение/CLI/logging), и статус готовности bootstrap.
  EN: `local/ai/chat_context.md` should contain at least: system directives, a quick profile (language/gender/environment/CLI/logging), and bootstrap readiness status.
- RU: Чек‑лист для `local/ai/session_summaries/<ISO8601>.md` держать в `local/ai/agents/09-closure.md`.
  EN: Keep the checklist for `local/ai/session_summaries/<ISO8601>.md` in `local/ai/agents/09-closure.md`.

## Проектные дополнения / Project addenda
- RU: Если явных дополнений нет — спросить у пользователя, нужно ли учитывать внешние документы/соглашения.
  EN: If no addenda are present, ask whether any external documents/agreements must be considered.
- RU: Перед использованием дополнений сверять дату/версию; при расхождениях уведомлять пользователя.
  EN: Before using addenda, check date/version; notify the user on mismatches.

## Контроль и очистка / Retention & cleanup
- RU: Планировать очистку устаревших временных каталогов/артефактов в `tmp/ai/**` и сверять её с требованиями к хранению (не удалять пользовательские файлы без согласования).
  EN: Plan cleanup of stale temp dirs/artifacts under `tmp/ai/**` and align it with retention needs (do not delete user files without agreement).

## Управление контекстом / Context management
- RU: Использовать инструменты поиска/диффа, как только они доступны, чтобы быстро находить старые договорённости.
  EN: Use search/diff tools as soon as they’re available to quickly locate past agreements.

## Деструктивные действия / Destructive actions
- RU: Предпочитать точечные правки; деструктивные команды (например, `git reset --hard`) запрещены без прямого запроса.
  EN: Prefer targeted edits; destructive commands (for example, `git reset --hard`) are forbidden unless explicitly requested.

## Формат файлов / File format
- RU: Если проект явно не требует Unicode, по возможности держать файлы в ASCII.
  EN: If the project does not require Unicode, prefer ASCII when possible.

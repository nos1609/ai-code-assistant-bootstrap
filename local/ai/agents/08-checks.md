# Проверки / Checks
#
# RU: Что проверять перед сдачей результата и как сообщать о проверках.
# EN: What to verify before delivery and how to report it.

## Базовое правило / Baseline rule
- RU: Перед финальным ответом запускать релевантные проверки или явно писать, что не запускались и почему.
  EN: Before the final answer, run relevant checks or explicitly state none were run and why.

## Типовые проверки / Common checks
- RU: Для скриптов/программ сначала запускать быстрые статические проверки (синтаксис/линтер), потом основной прогон.
  EN: For scripts/programs, run quick static checks first (syntax/linter), then the main run.
- RU: Подбирать проверки под проект (тесты, линтеры, форматирование, сканеры секретов).
  EN: Pick checks appropriate for the project (tests, linters, formatting, secret scanners).
- RU: Для Bash-скриптов минимум: `bash -n` и `shellcheck -x` (если доступен); если нельзя — указать причину и предложить команды пользователю.
  EN: For Bash scripts, minimum: `bash -n` and `shellcheck -x` (if available); if you can’t run them, state why and suggest commands for the user.
- RU: Если в проекте есть “профили проверок” (infra/app/shell и т.п.) — хранить конкретные команды в `local/ai/project_addenda.md` и ссылаться на них.
  EN: If the project uses “check profiles” (infra/app/shell, etc.), keep concrete commands in `local/ai/project_addenda.md` and reference them.

## Ограничения / Constraints
- RU: Если инструмент недоступен из-за sandbox/окружения — явно предложить пользователю запуск “снаружи” и зафиксировать договорённость в `local/ai/chat_context.md`.
  EN: If a tool is unavailable due to sandbox/environment, explicitly suggest the user run it locally and record the agreement in `local/ai/chat_context.md`.

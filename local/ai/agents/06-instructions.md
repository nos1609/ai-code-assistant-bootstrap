# Инструкции ассистентов (файлы) / Assistant instruction files
#
# RU: Эти файлы нужны, чтобы разные ассистенты/инструменты читали один и тот же источник истины (`AGENTS.md`).
# EN: These files keep different assistants/tools aligned on a single source of truth (`AGENTS.md`).

## Обязательные файлы / Required files
- RU: Должны существовать (как симлинки на `AGENTS.md`, по возможности).
  EN: Must exist (preferably as symlinks to `AGENTS.md`).
- `.github/copilot-instructions.md` → `AGENTS.md` (relative)
- `.gemini/GEMINI.md` → `AGENTS.md` (relative)
- `.qwen/QWEN.md` → `AGENTS.md` (relative)
- `GEMINI.md` → `AGENTS.md` (relative)
- `QWEN.md` → `AGENTS.md` (relative)

## Важные детали / Important details
- RU: Использовать относительные пути в симлинках, чтобы перенос/клонирование работали.
  EN: Use relative symlink targets so moving/cloning the repo keeps links valid.
- RU: `.git/info/exclude` должен скрывать *эти файлы* (как служебные артефакты шаблона), но не должен скрывать весь каталог `.github/` (workflow-файлы проекта должны оставаться отслеживаемыми).
  EN: `.git/info/exclude` should hide *these files* (template artifacts), but must not ignore the entire `.github/` directory (project workflows must remain tracked).
  - RU: Причина: `.github/workflows/*` — это GitHub Actions; если скрыть весь `.github/`, workflows пропадут из репозитория.
    EN: Reason: `.github/workflows/*` is GitHub Actions; if you ignore all of `.github/`, workflows disappear from the repo.
- RU: Порядок применения разных “instruction file” форматов не гарантируется (AGENTS/Copilot/Gemini/другие). Поэтому держим один источник истины и сводим остальные файлы к ссылкам на него.
  EN: The application order of different instruction-file formats is not guaranteed (AGENTS/Copilot/Gemini/others). Use `AGENTS.md` as the single source of truth and make the rest point to it.
- RU: Для Copilot могут требоваться настройки редактора/IDE для включения instruction files (например, соответствующая настройка в VS Code). Если поведение отличается — зафиксировать в `local/ai/chat_context.md`.
  EN: Copilot may require editor/IDE settings to enable instruction files (for example, a VS Code setting). If behavior differs, record it in `local/ai/chat_context.md`.

## Проверка доступности CLI / CLI availability check
- RU: Если задача предполагает использование `gemini`/`qwen`/`codex`/`copilot`, сначала подтвердить, что нужный CLI доступен, и какие режимы/флаги требуются (пример: `--help`, `--screen-reader`, `-y`).
  EN: If the task requires `gemini`/`qwen`/`codex`/`copilot`, first confirm the CLI is available and which modes/flags are required (example: `--help`, `--screen-reader`, `-y`).

## Copilot (VS Code) / Copilot (VS Code)
- RU: VS Code поддерживает несколько типов “instruction files” (например, `.github/copilot-instructions.md`, `*.instructions.md`, `AGENTS.md`); порядок применения при наличии нескольких файлов не гарантируется.
  EN: VS Code supports multiple instruction file formats (for example, `.github/copilot-instructions.md`, `*.instructions.md`, `AGENTS.md`); when multiple are present, the application order is not guaranteed.
- RU: Инструкции влияют на чат/генерацию кода, но не обязаны применяться к inline suggestions (автодополнению).
  EN: Instruction files affect chat/code generation but are not guaranteed to apply to inline suggestions (autocomplete).
- RU: `.github/copilot-instructions.md` применяется в чате при включённой настройке `github.copilot.chat.codeGeneration.useInstructionFiles` (и может учитываться в Visual Studio и на GitHub.com).
  EN: `.github/copilot-instructions.md` applies to chat when `github.copilot.chat.codeGeneration.useInstructionFiles` is enabled (and may be recognized by Visual Studio and GitHub.com).
- RU: Использование `AGENTS.md` и вложенных `AGENTS.md` может зависеть от экспериментальных настроек IDE/клиента; если поведение отличается — зафиксировать в `local/ai/chat_context.md`.
  EN: Whether `AGENTS.md` (and nested `AGENTS.md`) is used may depend on IDE/client settings/experiments; if behavior differs, record it in `local/ai/chat_context.md`.

## Windows / Windows
- RU: Создание симлинков может требовать Admin или Developer Mode. Если симлинки недоступны:
  EN: Creating symlinks may require Admin or Developer Mode. If symlinks are unavailable:
- RU: Предпочитать hardlink; если hardlink невозможен — остановиться и согласовать с пользователем дальнейшие действия (копии не делать, чтобы не было дрейфа).
  EN: Prefer hardlinks; if hardlinks are not possible, stop and align next steps with the user (do not create copies to avoid drift).

<!--
Инструкция для AI-агента:
MUST немедленно изучить файлы [AGENTS.md](AGENTS.md) и [local/chat_context.md](local/chat_context.md).
ВАЖНО: Файлы скрыты в [.gitignore](.gitignore). Отключи фильтрацию по gitignore при поиске и чтении.
Примеры команд: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.
Дополнительно: Ознакомься с симлинками [.github/copilot-instructions.md](.github/copilot-instructions.md) и [.gemini/GEMINI.md](.gemini/GEMINI.md).

---

Instruction for the AI Agent:
MUST immediately read [AGENTS.md](AGENTS.md) and [local/chat_context.md](local/chat_context.md).
IMPORTANT: These files are hidden via [.gitignore](.gitignore); disable gitignore filtering when searching and reading.
Example commands: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.
Additionally, review symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md) and [.gemini/GEMINI.md](.gemini/GEMINI.md).
-->

# ai-code-assistant-bootstrap
## Шаблон для локальных ассистентов

> 🇬🇧 English version: see [README.en.md](README.en.md)

Набор ai-code-assistant-bootstrap включает:

- [README.md](README.md) / [README.en.md](README.en.md) — краткий обзор набора файлов на русском и английском, готовый скрытый HTML-комментарий внутри.
- [AGENTS.md](AGENTS.md) — универсальный набор правил с вашими предпочтениями; включает требование в первом ответе уточнять предпочтительный грамматический род пользователя.
- [local/chat_context.md](local/chat_context.md) — заготовка контекста чата для фиксации договорённостей.
- [README_snippet.md](README_snippet.md) — исходник HTML-комментария, если нужно переиспользовать его вручную.
- [scripts/init.sh](scripts/init.sh) — скрипт для развёртывания симлинков и заполнения `.gitignore`.
- [.gitignore](.gitignore) — заготовка для скрытия [AGENTS.md](AGENTS.md), [local/](local/) и симлинков (строки закомментированы по умолчанию — при внедрении шаблона раскомментируй их либо запусти `./scripts/init.sh`).

Скопируй содержимое каталога в нужный репозиторий, адаптируй дату и договорённости в [local/chat_context.md](local/chat_context.md), затем выполни `./scripts/init.sh` для подготовки симлинков. После этого убедись, что README нового репозитория содержит HTML-комментарий для агентов (его можно вставить из текущего файла).

## Быстрый старт

1. Склонируй или скопируй этот шаблон в целевой репозиторий.
2. Выполни `./scripts/init.sh`, чтобы создать симлинки и обновить [.gitignore](.gitignore).
3. Заполни актуальные данные в [local/chat_context.md](local/chat_context.md) (дата, договорённости, проверки).
4. Проверь, что README нового репозитория содержит скрытый HTML-комментарий (ищи подсказку в начале файла).
5. Ознакомься с [AGENTS.md](AGENTS.md) и договорись с командой о дополнительных правилах при необходимости.

Перед изменениями смотри правила в [CONTRIBUTING.md](CONTRIBUTING.md) и [CONTRIBUTING.en.md](CONTRIBUTING.en.md), чтобы поддерживать двуязычную документацию в рабочем состоянии.

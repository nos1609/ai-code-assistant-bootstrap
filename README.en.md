<!--
Instruction for the AI Agent:
MUST immediately read [AGENTS.md](AGENTS.md) and [local/chat_context.md](local/chat_context.md).
IMPORTANT: These files are hidden via [.gitignore](.gitignore); disable gitignore filtering when searching and reading.
Example commands: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.
Additionally, review symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md) and [.gemini/GEMINI.md](.gemini/GEMINI.md).
-->

# ai-code-assistant-bootstrap
## Template for local assistants

> 🇷🇺 Русская версия: см. [README.md](README.md)

The ai-code-assistant-bootstrap pack includes:

- [README.md](README.md) / [README.en.md](README.en.md) — quick overview in Russian and English with the ready-to-use hidden HTML snippet.
- [AGENTS.md](AGENTS.md) — shared instruction set with your preferred workflow, including a requirement to ask for the user’s preferred grammatical gender in the first reply.
- [local/chat_context.md](local/chat_context.md) — template that captures agreements for each assistant session.
- [README_snippet.md](README_snippet.md) — source of the HTML comment in case you need to re-use it.
- [scripts/init.sh](scripts/init.sh) — helper script that prepares symlinks and populates `.gitignore`.
- [.gitignore](.gitignore) — defaults that hide [AGENTS.md](AGENTS.md), [local/](local/), and agent-specific symlinks (the entries are commented out by default — uncomment them during setup or run `./scripts/init.sh`).

Copy this directory into the target repository, adjust the date and notes inside [local/chat_context.md](local/chat_context.md), then run `./scripts/init.sh` to create the symlinks. Afterwards, ensure the target README keeps the HTML comment for assistants (reuse the snippet from this file or from [README_snippet.md](README_snippet.md)).

## Quick Start

1. Copy or clone this template into the target repository.
2. Run `./scripts/init.sh` to create the symlinks and update [.gitignore](.gitignore).
3. Fill in current details in [local/chat_context.md](local/chat_context.md) (date, agreements, checks).
4. Verify that the new repository’s README contains the hidden HTML comment (see the top of this file for the snippet).
5. Review [AGENTS.md](AGENTS.md) and align any extra rules with your team.

Before changing anything, read [CONTRIBUTING.md](CONTRIBUTING.md) and [CONTRIBUTING.en.md](CONTRIBUTING.en.md) to keep the bilingual docs aligned.

<!--
Instruction for the AI Agent:
MUST immediately read [AGENTS.md](AGENTS.md) and [local/chat_context.md](local/chat_context.md).
IMPORTANT: These files are hidden via [.gitignore](.gitignore); disable gitignore filtering when searching and reading.
Example commands: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.
Additionally, review symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), and [QWEN.md](QWEN.md). For Codex run the `codex exec` subcommand (alias `codex e`).
-->


# ai-code-assistant-bootstrap
## Template for local assistants

> 🇷🇺 Русская версия: см. [README.md](README.md)

This template targets repositories that rely on local AI assistants: it codifies communication rules, tool usage, and response formatting so human developers and agents share the same expectations.

The ai-code-assistant-bootstrap pack includes:

- [README.md](README.md) / [README.en.md](README.en.md) — quick overview in Russian and English with the ready-to-use hidden HTML snippet.
- [AGENTS.md](AGENTS.md) — shared instruction set reflecting local workflow preferences, containing instructions for `gemini`, `qwen`, and `codex`; it requires asking for the user’s preferred grammatical gender in the first reply.
- [local/chat_context.md](local/chat_context.md) — template that captures agreements for each assistant session.
- [README_snippet.md](README_snippet.md) — source of the HTML comment in case you need to re-use it.
- [scripts/init.sh](scripts/init.sh) — helper script that prepares symlinks and populates `.gitignore`.
- [.gitignore](.gitignore) — defaults that hide [AGENTS.md](AGENTS.md), [local/](local/), and agent-specific symlinks (the entries are commented out by default; they should be uncommented during setup or handled via `./scripts/init.sh`).
- [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), and [QWEN.md](QWEN.md) — symlinks pointing to [AGENTS.md](AGENTS.md), keeping every assistant on a single source of truth.

Local installation of the command-line interfaces (`gemini`, `qwen`, `codex`, `copilot`) is required. Codex should be invoked via the `codex exec` subcommand (alias `codex e`) to follow the non-interactive workflow described here.

### Template alignment for assistants

| Assistant | Local install | Approval | Link | Repository placement | Notes |
|-----------|--------------|----------|------|-----------------------|-------|
| `gemini`  | ☑ | ☑ | [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli) | [.gemini/GEMINI.md](.gemini/GEMINI.md) → [AGENTS.md](AGENTS.md); [GEMINI.md](GEMINI.md) (repo root) → [AGENTS.md](AGENTS.md) | — |
| `qwen`    | ☑ | ☑ | [QwenLM/qwen-code](https://github.com/QwenLM/qwen-code)     | [QWEN.md](QWEN.md) (repo root) → [AGENTS.md](AGENTS.md) | May switch to the requested locale only from the second reply; restate the rules if needed. |
| `codex`   | ☑ | ☑ | [openai/codex](https://github.com/openai/codex)             | [AGENTS.md](AGENTS.md) (repo root) | run via `codex exec` |
| `copilot` | ☑ | ☑ | [github/copilot-cli](https://github.com/github/copilot-cli) | [.github/copilot-instructions.md](.github/copilot-instructions.md) → [AGENTS.md](AGENTS.md) | — |

The directory is copied into the target repository, after which [local/chat_context.md](local/chat_context.md) is updated with the current date and agreements. Running `./scripts/init.sh` then prepares the symlinks. Finally, confirm that the target README retains the hidden HTML comment for assistants (the snippet is available in this file and in [README_snippet.md](README_snippet.md)).

## Quick Start

1. Clone or copy this template into the target repository.
2. Run `./scripts/init.sh` to create the symlinks and update [.gitignore](.gitignore); afterwards confirm the entries for `AGENTS.md`, `local/`, and the symlinks are uncommented.
3. Verify that the symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), and [QWEN.md](QWEN.md) exist in the workspace, each pointing back to [AGENTS.md](AGENTS.md).
4. Populate [local/chat_context.md](local/chat_context.md) with current data (date, agreements, checks).
5. Confirm that the new repository’s README retains the hidden HTML comment (the snippet appears at the top of this file; it can also be copied from [README_snippet.md](README_snippet.md)).
6. Review [AGENTS.md](AGENTS.md) and, if needed, coordinate additional rules with the team.

Before introducing changes, consult [CONTRIBUTING.md](CONTRIBUTING.md) and [CONTRIBUTING.en.md](CONTRIBUTING.en.md) to keep the bilingual documentation aligned.

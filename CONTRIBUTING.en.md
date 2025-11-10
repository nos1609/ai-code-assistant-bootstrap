# Contributing

> 🇷🇺 Русская версия: см. [CONTRIBUTING.md](CONTRIBUTING.md)

## Documentation
- Keep both READMEs functionally equivalent: [README.md](README.md) (RU) and [README.en.md](README.en.md) (EN).
- When changing core functionality, configuration, or user-facing scripts, update both.
- Examples/commands can be phrased differently, but steps and meaning must match.
- If a section is region-specific, mark it explicitly.
- When adjusting assistant rules, update the “Quick Start,” “Environment Limits,” “Logging Requests,” “Context handoff,” and “Upstream Sync” sections in [AGENTS.md](AGENTS.md) and reflect the changes in the READMEs.

Recommended workflow:
1) Change code/scripts.
2) Update RU [README.md](README.md).
3) Sync EN [README.en.md](README.en.md).
4) Verify Quick Start and Terraform sections.

## Code style
- Comments are bilingual but concise: RU sentence + a short EN line above or next.
- In Terraform use RU in `description`, add EN as `# EN: ...` above the block.
- Shell/Ansible: help and error messages are bilingual when feasible.
- Avoid verbose commentary; keep only what helps users.
- Follow the rules outlined in the “Response Formatting” section of [AGENTS.md](AGENTS.md): headers, bullets, monospace references.

## Commits
- Conventional English imperative subject, e.g. `docs: sync README RU/EN for TF vars`.
- Optional second paragraph in Russian for nuances.

## Testing
- Run all relevant local checks (linters, tests, etc.) before submitting a PR.
- Linters and basic checks run in CI.
- Consult the `Checks and Tooling` matrix in [AGENTS.md](AGENTS.md) and keep concrete commands in `local/project_addenda.md` up to date.

## Pre-PR checklist
- Walk through the “Assistant PR Checklist” in [AGENTS.md](AGENTS.md), ensuring RU/EN docs stay in sync and logs are up to date.

Thank you!

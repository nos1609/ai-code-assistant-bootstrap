# Workflow Details

## Audit

Audit is read-only. It must answer:

- Which required framework files are missing?
- Which managed files differ from the template?
- Which bundled repo skills are missing or drifting?
- Which agent-specific skill discovery links are missing, wrong, or blocked by platform permissions?
- Which protected files need allowed patch operations?
- Which instruction links are missing or wrong?
- Which local-only/runtime paths are tracked by git?
- Which required `.git/info/exclude` lines are missing?

## Plan

Plan emits operations without writing. Group results by:

- Safe operations: can be applied without losing project-owned content.
- Conflicts: require explicit user decision.
- Informational drift: tracked local-only files, missing optional links, or environment-specific limits.

## Apply

Apply executes safe operations only:

- create missing managed files;
- create ensure-if-missing files only when absent;
- insert/move README snippet;
- append missing exclude lines;
- create missing instruction links/hardlinks.

Apply must skip conflicts. Forced replacement of managed files requires an explicit user request and `-ForceManagedExact`.

## Verify

Verify fails when required invariants are still unmet:

- missing mandatory managed files;
- missing README snippet;
- missing exclude lines;
- missing or wrong instruction links;
- tracked local-only runtime files;
- managed file drift not explicitly accepted.

Use `Verify` after `Apply`. Report the exact failing paths.

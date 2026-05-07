# Agent Log

This folder stores task-level agent work logs for DizzyAsset.

Use this folder for execution history.

Reusable lessons belong in:

    docs/knowledge/

---

## Purpose

Agent logs help track what happened during a task.

They are useful for:

- reviewing agent work
- checking what was attempted
- seeing what commands were run
- tracking skipped verification
- understanding failed or partial work
- preserving handoff history

Agent logs are not product documentation.

Agent logs are not reusable knowledge by default.

---

## File Naming

Use this format:

    YYYY-MM-DD-task-id-short-title.md

Examples:

    2026-05-07-DA-001-app-foundation.md
    2026-05-07-DA-009-search-engine.md
    2026-05-07-DA-016-fcp-drag.md

If there is no DA task ID, use a short scope name.

Example:

    2026-05-07-docs-agents-update.md

Use lowercase words.

Use hyphens.

---

## Required Format

Each agent log SHOULD use this structure:

    # Agent Log: <task id or short title>

    ## Task

    - Task ID:
    - Lifecycle stage:
    - Risk level:
    - Date:
    - Agent/tool:

    ## Scope

    - In scope:
    - Out of scope:

    ## Actions Taken

    - item:

    ## Files Changed

    - path:
      - change:

    ## Commands Run

    - command:
      - result:

    ## Verification

    - verified:
    - not verified:
    - skipped checks:

    ## Issues

    - issue:
    - status:

    ## Artifacts

    - path:

    ## Knowledge Notes

    - path:

    ## Handoff Summary

    - summary:
    - next step:

---

## Rules

MUST:

- record meaningful task activity
- include commands actually run
- include verification status
- include skipped checks
- include known risks
- link visual artifacts when UI changed
- link knowledge notes when created

MUST NOT:

- include secrets
- include private credentials
- include raw bookmark data
- paste huge logs
- claim checks were run when they were not
- declare final acceptance

---

## Relationship to Handoff

Handoff is the concise task-end report.

Agent log is the longer task record.

For small tasks, a handoff may be enough.

For non-trivial or high-risk tasks, create an agent log.

Recommended:

- Trivial task:
  - handoff only

- Non-trivial task:
  - handoff plus agent log if useful

- High-risk task:
  - handoff plus agent log required

---

## Relationship to Knowledge Base

Use `docs/agent-log/` for what happened.

Use `docs/knowledge/` for what should be remembered.

If an issue is reusable, create a knowledge note.

If an issue only matters to the current task, keep it in the agent log.

---

## Visual Evidence

For UI changes, store visual evidence under:

    artifacts/YYYY-MM-DD/<task-id>/

Then link it from the agent log.

Examples:

    artifacts/2026-05-07/DA-014/right-panel-after.png
    artifacts/2026-05-07/DA-015/quick-peek-demo.mov

---

## Retention

Agent logs may grow over time.

Keep logs useful.

Do not store noisy low-value notes.

Prefer concise factual records.

Old logs may be archived later if needed.
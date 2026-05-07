# Implementation Prompt Template

Use this template to start one scoped implementation task.

Replace placeholders before sending it to an agent.

Do not assign multiple DA tasks in one prompt.

---

## Template

Implement `<TASK_ID>`.

Read:

- `AGENTS.md`
- `docs/task/<TASK_FILE>.md`
- required guidelines listed in the task

Follow:

- `docs/workflows/implementation-task.md`
- `docs/templates/handoff.md`

Rules:

- Do not implement `<NEXT_TASK_ID>` or later.
- Do not expand scope.
- Do not edit protected areas.
- Run verification.
- Record any changes beyond the initial implementation scope in `docs/agent-log/<YYYY-MM-DD>-<TASK_ID>-<short-title>.md`.
- If UI changes, save visual evidence under `artifacts/YYYY-MM-DD/<TASK_ID>/`.
- End with a handoff.

---

## Required Replacement Fields

Replace:

- `<TASK_ID>`
  - example: `DA-001`

- `<TASK_FILE>`
  - example: `DA-001-app-foundation.md`

- `<NEXT_TASK_ID>`
  - example: `DA-002`

---

## Example

Implement `DA-001`.

Read:

- `AGENTS.md`
- `docs/task/DA-001-app-foundation.md`
- required guidelines listed in the task

Follow:

- `docs/workflows/implementation-task.md`
- `docs/templates/handoff.md`

Rules:

- Do not implement `DA-002` or later.
- Do not expand scope.
- Do not edit protected areas.
- Run verification.
- Record any changes beyond the initial implementation scope in `docs/agent-log/2026-05-07-DA-001-app-foundation.md`.
- If UI changes, save visual evidence under `artifacts/YYYY-MM-DD/DA-001/`.
- End with a handoff.

---

## Optional Additions

Use these only when needed.

### High-Risk Task Addition

For high-risk tasks, add:

- This is a high-risk task.
- Run Full Verification.
- Stop if platform, permission, sandbox, database migration, or release behavior is unclear.
- Do not continue with risky workaround.
- Use `code-review-graph` after implementation if available.

### UI Task Addition

For UI tasks, add:

- Visual evidence is required.
- Save screenshots or recordings under `artifacts/YYYY-MM-DD/<TASK_ID>/`.
- Include artifact paths in the handoff.

### Database Task Addition

For database tasks, add:

- Do not perform destructive migration.
- Do not delete or rewrite user data.
- Report schema changes.
- Report migration path and verification.

### File Access Task Addition

For file access tasks, add:

- Do not delete asset records on file access failure.
- Preserve recoverable states.
- Report missing, offline, stale bookmark, and permission-denied behavior.
- Do not change entitlements without explicit approval.

### Final Cut Pro Task Addition

For Final Cut Pro tasks, add:

- Do not use hidden media copying.
- Do not move original files.
- Use real file URL drag behavior.
- Do not claim Final Cut Pro verification unless actually tested with Final Cut Pro.

---

## Usage Notes

This template is a launcher.

The detailed task file defines the real scope.

AGENTS.md defines safety and routing.

Guidelines define technical rules.

Use `docs/agent-log/` to record any follow-up changes, review-driven fixes, or verification outcomes that go beyond the initial implementation scope.

Handoff records evidence.

Instruction owner decides final acceptance.

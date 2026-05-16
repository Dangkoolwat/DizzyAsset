# [PLAN] 2026-05-16-dizzyasset-semble-rs-defaults

## Goal
Align `AGENTS.md` and the `semble_rs` policy docs with conditional defaults so other agents have one deterministic workflow when the choice is ambiguous.

## Files Impacted
- [x] `AGENTS.md`
- [x] `docs/agent-policy/3-stage-pipeline.md`
- [x] `docs/agent-policy/semble_rs-operation-guide.md`
- [x] `docs/history.md`
- [x] `docs/agent-log/2026-05-16-dizzyasset-semble-rs-defaults-gpt-5.5/WORK_REPORT.md`

## Steps
- [x] Reconcile the current wording against the repo’s existing router and `semble_rs` workflow.
- [x] Patch the workflow docs with explicit defaults for unclear cases.
- [x] Add a concise work report and history entry with the before/after comparison.
- [x] Verify the final diff for scope, consistency, and context contamination.

## Verification
- Manual re-read of the edited sections for consistency.
- `git diff --check` for formatting integrity.
- Confirm the final wording keeps `AGENTS.md` lean and the guide authoritative.

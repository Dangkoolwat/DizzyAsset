# [PLAN] 2026-05-16-dizzyasset-docs-routing-cache

## Goal
Add a repo-local docs routing cache for DizzyAsset so agents can reuse the docs layout without rescanning the full tree.

## Files Impacted
- [x] `AGENTS.md`
- [x] `docs/analysis/dizzyasset-docs-routing-cache.md`
- [x] `scripts/sync-docs-routing-cache.sh`
- [x] `docs/history.md`
- [x] `docs/agent-log/2026-05-16-dizzyasset-docs-routing-cache-gpt-5.5/WORK_REPORT.md`

## Steps
- [x] Confirm the current docs layout and the repo's policy references.
- [x] Add the cache doc and repo-local sync script with a `--check` path.
- [x] Update `AGENTS.md`, `docs/history.md`, and the work report with minimal cache-only notes.
- [x] Verify the generated cache and staged diff for scope and formatting.

## Verification
- `bash scripts/sync-docs-routing-cache.sh --check`
- `git diff --check`
- Manual re-read of the edited sections for cache-only scope

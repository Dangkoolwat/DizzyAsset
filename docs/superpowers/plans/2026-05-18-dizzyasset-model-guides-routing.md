# [PLAN] 2026-05-18-dizzyasset-model-guides-routing

## Goal
Port the fcpx-auto-captions model guide pattern into DizzyAsset so AGENTS routing can point to dedicated prompt guides for Gemini, GPT 5.4 Mini, GPT 5.x Codex, and the generic fallback.

## Files Impacted
- [x] `AGENTS.md`
- [x] `docs/agent-policy/gemini-coding-prompt-guide.md`
- [x] `docs/agent-policy/gemini-pro-coding-prompt-guide.md`
- [x] `docs/agent-policy/gpt-5-4-mini-coding-prompt-guide.md`
- [x] `docs/agent-policy/gpt-5-x-codex-coding-prompt-guide.md`
- [x] `docs/agent-policy/generic-coding-prompt-guide.md`
- [x] `docs/history.md`
- [x] `docs/agent-log/2026-05-18-dizzyasset-model-guides-routing-gpt-5.5/WORK_REPORT.md`
- [x] `docs/analysis/dizzyasset-docs-routing-cache.md`

## Steps
- [x] Add concise model-specific prompt guides adapted to DizzyAsset.
- [x] Add AGENTS routing rows that point to each guide.
- [x] Record the change in `docs/history.md` and the task work report.
- [x] Refresh the docs routing cache and verify the final diff.

## Verification
- `bash scripts/sync-docs-routing-cache.sh`
- `bash scripts/sync-docs-routing-cache.sh --check`
- `git diff --check`

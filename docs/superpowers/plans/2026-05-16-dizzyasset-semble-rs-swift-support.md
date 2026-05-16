# [PLAN] 2026-05-16-dizzyasset-semble-rs-swift-support

## Goal
- Update DizzyAsset agent docs so `semble_rs` Swift AST support is allowed for discovery, while CRG and Serena remain the validation path.

## Files
- `AGENTS.md`
- `docs/agent-policy/3-stage-pipeline.md`
- `docs/agent-policy/semble_rs-operation-guide.md`
- `docs/agent-policy/semble_rs-troubleshooting.md`
- `docs/history.md`
- `docs/agent-log/2026-05-16-dizzyasset-semble-rs-swift-support-gpt-5.5/WORK_REPORT.md`

## Steps
- [x] Verify current `semble_rs` CLI behavior on a Swift file in DizzyAsset.
- [ ] Update `semble_rs` guide to allow `tree --symbols`, `deps`, and `search --outline` for Swift discovery.
- [ ] Update `3-stage-pipeline.md` and `AGENTS.md` to match the new Swift discovery flow.
- [ ] Update troubleshooting and history/log records.
- [ ] Run diff checks and confirm the staged scope is limited to the intended docs.

## Verification
- `git diff --check`
- Manual reread of the updated routing lines

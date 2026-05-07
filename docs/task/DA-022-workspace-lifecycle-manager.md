# DA-022 Workspace Lifecycle Manager — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-022  
**Task name:** Workspace Lifecycle Manager  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-022-workspace-lifecycle-manager.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first workspace lifecycle manager foundation.

Workspace files should be classified and managed safely.

Workspace lifecycle must distinguish:

- temp files
- preview cache
- analysis output
- derived assets
- exports
- unknown files

Original files must never be cleaned up by workspace lifecycle logic.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-022 task prompt
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Safety/platform guidelines in `docs/guidelines/`
8. Existing code patterns

Raw chat is not implementation scope.

---

## 3. Required Reading

Always read:

- `AGENTS.md`
- this task prompt
- `docs/guidelines/workspace-lifecycle.md`
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/state-management.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `macos-sandbox-security-skill`
  - workspace permissions and external workspace behavior

- `sqlite-fts-optimizer`
  - workspace_items schema if touched

- `swift-concurrency`
  - cleanup scan or background classification

- `karpathy-guidelines`
  - conservative implementation

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- workspace item classification
- workspace item status model
- temp cleanup simulation or safe cleanup foundation
- preview cache classification
- derived asset preservation rule
- orphan state representation
- workspace_items persistence if schema exists
- cleanup report model
- no original file deletion

Possible item types:

- temp
- previewCache
- analysisOutput
- derivedAsset
- exportOutput
- proxy
- unknown

Possible statuses:

- active
- stale
- orphaned
- missingSource
- recoverable
- cleanupCandidate

---

## 6. Out of Scope

Do not implement:

- aggressive automatic cleanup
- deleting derived assets
- deleting exports
- deleting unknown files
- workspace migration UI
- external workspace reconnect UI
- actual media conversion
- trimming/export workflows
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `WorkspaceLifecycleManager`
- `WorkspaceItem`
- `WorkspaceItemType`
- `WorkspaceItemStatus`
- `WorkspaceCleanupReport`
- `WorkspaceItemRepository`

Keep cleanup conservative.

A dry-run cleanup report is preferred before actual deletion.

---

## 8. Cleanup Rules

Cleanup-safe candidates:

- known temp files
- failed partial temp output
- regeneratable preview cache if policy exists

Not cleanup-safe by default:

- original files
- derived assets
- exports
- user-created output
- unknown files
- confirmed analysis results

Do not delete unknown files.

Do not follow unsafe symlinks.

---

## 9. Orphan Rules

Derived assets may become orphaned if:

- source file is missing
- source drive is offline
- source permission is denied
- source asset was removed from library

Rules:

- mark orphaned
- preserve derived file
- preserve relation if recoverable
- allow future user decision
- avoid automatic deletion

---

## 10. Database Rules

If persistence exists:

- store workspace item records
- store type/status
- preserve source relation
- avoid destructive migration

If persistence is not ready:

- implement in-memory classification or service boundary
- report limitation in handoff

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Workspace verification should include:

- classify temp item
- classify preview cache item
- classify derived item
- unknown file is not deleted
- dry-run cleanup if implemented
- no original file deletion
- orphan status if practical

Report skipped checks.

---

## 12. Visual Evidence

If UI is changed, visual evidence is required.

Store under:

- `artifacts/YYYY-MM-DD/DA-022/`

If no UI changed, state not applicable.

---

## 13. Stop Conditions

Stop and report if:

- cleanup may delete original files
- cleanup may delete derived assets unexpectedly
- unknown files would be deleted
- workspace migration may lose files
- permission behavior is unclear
- symlink behavior is unclear
- database relation would be broken
- task expands into full cleanup UI or migration UI

---

## 14. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-022
- Risk level: Medium
- files changed
- item types implemented
- cleanup behavior:
  - none/dry-run/actual
- deletion behavior:
  - none/temp/cache/other
- original files affected:
  - must be no
- persistence behavior
- verification run
- skipped checks
- known risks
- next suggested task

---

## 15. Expected Completion Criteria

DA-022 is complete when:

- workspace lifecycle foundation exists
- workspace item types/statuses are represented
- cleanup behavior is safe and conservative
- original files are not affected
- verification is reported
- handoff is produced

---

## 16. Suggested Next Task

After DA-022:

- DA-023 Verification Harness / Manual QA Checklist

Do not start DA-023 in this task.

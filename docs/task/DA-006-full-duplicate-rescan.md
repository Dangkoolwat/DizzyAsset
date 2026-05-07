# DA-006 Full Duplicate Rescan — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-006  
**Task name:** Full Duplicate Rescan  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-006-full-duplicate-rescan.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement a user-triggered full duplicate rescan foundation.

This task extends DA-005 by allowing DizzyAsset to rescan the existing library for duplicates after assets have already been registered.

The scan must be non-destructive.

DizzyAsset must report duplicates, not delete files.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-006 task prompt
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
- `docs/guidelines/duplicate-detection.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `sqlite-fts-optimizer`
  - duplicate scan records, query/index considerations

- `swift-concurrency`
  - background scan, cancellation, batching

- `macos-sandbox-security-skill`
  - external storage or permission behavior

- `karpathy-guidelines`
  - small scoped implementation

- `xcode-project-analyzer`
  - only for project changes

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- full duplicate scan service or coordinator
- scan session model
- library-wide duplicate candidate enumeration
- staged duplicate strategy reuse from DA-005
- progress state if existing UI/state supports it
- cancellation hook if architecture supports it
- duplicate scan result persistence if database supports it
- safe handling of missing/offline files
- scan summary result

Scan summary may include:

- total assets scanned
- candidates found
- confirmed duplicates
- skipped unavailable assets
- failures
- duration if easy

---

## 6. Out of Scope

Do not implement:

- duplicate deletion
- auto-merge
- canonical asset selection UI
- advanced duplicate management screen
- full UI redesign
- search ranking changes
- import flow redesign
- preview
- Final Cut Pro integration
- Quick Peek
- AI analysis
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Build on DA-005.

Possible components:

- `DuplicateRescanService`
- `DuplicateScanSession`
- `DuplicateScanProgress`
- duplicate repository methods
- reusable hash service
- scan cancellation token or task handle

Keep scan behavior conservative.

Do not compute full hash for every file unless explicitly needed.

Use partial hash and staged narrowing where possible.

---

## 8. Scan Rules

Full duplicate rescan should:

- run only when triggered
- run in background
- avoid blocking UI
- skip or mark unavailable files
- preserve records
- collect failures
- support cancellation if practical
- never delete original files

Missing/offline assets should remain records.

Offline external drives should not cause records to be removed.

---

## 9. Database Rules

If persistence exists:

- create or update duplicate scan session record
- store duplicate relationships non-destructively
- preserve scan history if useful
- avoid destructive migration

If persistence is not ready:

- return in-memory scan summary
- report limitation in handoff

---

## 10. Verification

Run when possible:

- `xcodegen generate` if files changed project structure
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Duplicate rescan verification should include:

- small library scan
- no duplicates case
- duplicate candidate case
- missing/offline asset handling if practical
- cancellation if implemented
- no original file deletion
- duplicate session/result saved if implemented

Report what was not tested.

---

## 11. Stop Conditions

Stop and report if:

- scan might delete files
- canonical duplicate policy is required but undefined
- full hash cost is unsafe
- database relationship semantics are unclear
- external drive behavior is unclear
- migration would be destructive
- task expands into duplicate management UI

---

## 12. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-006
- Risk level: Medium
- files changed
- scan session behavior
- hashing stages used
- persistence behavior
- cancellation:
  - yes/no
- unavailable file handling
- verification run
- skipped checks
- known risks
- next suggested task

---

## 13. Expected Completion Criteria

DA-006 is complete when:

- full duplicate rescan foundation exists
- scan result/session is represented
- unavailable files are handled safely
- original files are not deleted or modified
- verification is reported
- handoff is produced

---

## 14. Suggested Next Task

After DA-006:

- DA-007 Metadata Extraction

Do not start DA-007 in this task.

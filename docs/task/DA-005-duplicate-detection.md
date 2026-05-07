# DA-005 Duplicate Detection — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-005  
**Task name:** Duplicate Detection  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-005-duplicate-detection.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first duplicate detection foundation for DizzyAsset.

Duplicate detection should identify:

- path duplicates
- likely content duplicates
- confirmed content duplicates when safe and necessary

This task should integrate with import flow enough to report duplicates during registration.

DizzyAsset must never automatically delete original files.

---

## 2. Source of Truth

Follow this priority order:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-005 task prompt
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
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`
- relevant duplicate detection section of `docs/product/dizzyasset_design_doc.md`

Do not read full product docs unless duplicate policy is unclear.

---

## 4. Relevant Skills

Do not load all skills.

Use only if relevant:

- `sqlite-fts-optimizer`
  - for schema/index considerations around duplicate records

- `swift-concurrency`
  - for hashing, cancellation, and background work

- `macos-sandbox-security-skill`
  - if file access, permissions, or external storage behavior is touched

- `karpathy-guidelines`
  - for small surgical implementation

- `xcode-project-analyzer`
  - only if `project.yml`, target membership, or build settings are touched

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- path duplicate detection
- quick duplicate candidate lookup
- partial hash helper or service
- duplicate detection service boundary
- duplicate scan result model
- import-time duplicate reporting hook
- basic database persistence for duplicate-related data if schema exists
- safe handling of hash failures
- no automatic deletion behavior
- XcodeGen update if new source files are added

Partial hash policy:

- first 8KB
- middle 8KB
- last 8KB

Full hash may be implemented only if small and clearly scoped.

It is acceptable to prepare full hash as future work if partial hash foundation is enough for this task.

---

## 6. Out of Scope

Do not implement:

- full duplicate rescan UI
- whole-library duplicate rescan workflow
- duplicate deletion
- automatic merge
- canonical asset selection UI
- user-facing duplicate management screen
- aggressive full hashing of every file
- search ranking
- preview
- Quick Peek
- Final Cut Pro drag
- AI analysis
- destructive cleanup
- release/signing/notarization

Do not change:

- entitlements
- sandbox permissions
- CI/CD
- signing
- release packaging

---

## 7. Expected Project Shape

Use existing project structure when present.

Expected locations may include:

- `DizzyAsset/Domain/Duplicates/`
- `DizzyAsset/Domain/Import/`
- `DizzyAsset/Domain/Entities/`
- `DizzyAsset/Data/Repositories/`
- `DizzyAsset/Infrastructure/Hashing/`
- `DizzyAsset/Infrastructure/FileSystem/`

Task prompt files belong under:

- `docs/task/`

If new source files are added, ensure XcodeGen includes them.

Run `xcodegen generate` after file add/delete/move when required.

Do not manually edit `.xcodeproj`.

---

## 8. Implementation Guidance

Keep the first duplicate detection implementation staged and conservative.

Possible components:

- `DuplicateDetectionService`
  - evaluates import candidates against known assets

- `HashService`
  - computes partial hash
  - optionally computes full hash if assigned

- `DuplicateCandidate`
  - represents possible match

- `DuplicateDetectionResult`
  - unique
  - pathDuplicate
  - contentDuplicateCandidate
  - contentDuplicateConfirmed
  - failed

- duplicate repository methods
  - find by path
  - find by file size / quick fingerprint
  - save duplicate group or scan result, if schema exists

Do not overbuild duplicate management UI.

Do not add deletion actions.

---

## 9. Duplicate Policy

Duplicate types:

### Path Duplicate

Same path already registered.

Expected behavior:

- detect quickly
- report existing asset if available
- do not create duplicate record unless policy says to update location
- preserve existing tags/categories

### Content Duplicate

Different path but same file content.

Expected behavior:

- detect with staged strategy
- report duplicate relationship
- do not delete either file
- preserve both paths if both are tracked

Path duplicate and content duplicate are different.

Do not collapse them into one generic duplicate state.

---

## 10. Detection Strategy

Use staged detection.

### Stage 1: Quick Check

Use:

- path
- file size
- extension
- modified date

Purpose:

- fast rejection
- candidate narrowing

### Stage 2: Partial Hash

Use:

- first 8KB
- middle 8KB
- last 8KB

Purpose:

- likely content duplicate detection
- avoid unnecessary full hash work

### Stage 3: Full Hash

Use only when needed.

Purpose:

- confirmation

Do not compute full hash for every file unless assigned.

---

## 11. Hashing Rules

MUST:

- hash off the main thread for large files
- handle read failures
- handle missing files
- handle permission denied
- handle external drive offline
- avoid excessive memory use
- report hash failure safely

MUST NOT:

- load whole large media file into memory unnecessarily
- block UI during hashing
- delete file or asset record when hashing fails
- treat hash failure as proof of uniqueness

---

## 12. Database Rules

If database layer supports duplicate records:

- store duplicate scan results safely
- keep duplicate group records non-destructive
- avoid deleting existing data
- use repository boundary
- keep schema changes explicit

Potential records:

- duplicate scan session
- duplicate group
- duplicate relationship
- hash values
- hash status

If schema is not ready:

- return duplicate results without persistence
- report limitation in handoff

Do not create destructive migrations.

---

## 13. Import Integration

DA-005 may connect to DA-004 import scan.

Expected behavior:

- import candidate enters duplicate check
- path duplicate is detected
- likely content duplicate is detected when enough info exists
- import summary can report duplicates
- failures are collected and visible

Do not implement full import queue redesign.

Do not block all import because one hash fails.

---

## 14. Error Handling

Possible errors:

- file missing
- permission denied
- volume offline
- read failure
- hash failure
- database failure

Rules:

- report failed file or candidate
- continue other files when safe
- preserve asset records
- preserve original files
- do not silently ignore failures

---

## 15. Concurrency Notes

Hashing can be expensive.

MUST:

- keep hashing off the main thread
- avoid unbounded parallel hashing
- support cancellation if scan is long-running and architecture allows
- keep UI state updates on MainActor if UI is touched

If cancellation is not implemented yet:

- keep API compatible with future cancellation
- report limitation in handoff

---

## 16. XcodeGen Rules

If adding, deleting, or moving source files:

1. update `project.yml` if required
2. run `xcodegen generate`
3. run CLI build if possible

Do not edit `.xcodeproj` manually.

If XcodeGen fails, stop and report.

---

## 17. Verification

Minimum Verification is required.

Run when possible:

- `xcodegen generate` if files were added/deleted/moved or project.yml changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Duplicate-focused verification should include:

- same path duplicate
- same content different path if sample exists
- different content same size if sample exists
- partial hash calculation
- hash failure or missing file path if practical
- no original file deletion
- import summary or duplicate result reporting

If tests exist, add or run focused tests.

If tests do not exist, perform focused manual or lightweight verification and report limits.

Report commands actually run.

Do not claim build/test passed unless commands were run and passed.

---

## 18. Visual Evidence

If UI is changed, provide visual evidence.

Store under:

- `artifacts/YYYY-MM-DD/DA-005/`

If no UI changed, state that visual evidence is not applicable.

---

## 19. Knowledge Capture

Create a knowledge note only if reusable knowledge is discovered.

Possible topics:

- partial hash edge case
- large file hashing performance issue
- external drive read issue
- permission denied during hash
- database duplicate relation issue
- XcodeGen target membership issue

Use:

- `docs/knowledge/YYYY-MM-DD-short-topic.md`

Do not log every small mistake.

---

## 20. Stop Conditions

Stop and report if:

- implementation might delete original files
- duplicate policy is unclear
- canonical asset selection is required but not defined
- full hash performance is unsafe
- database relation semantics are unclear
- offline external drive behavior is unclear
- hashing requires loading huge files into memory
- project target membership is unclear
- XcodeGen fails
- build fails
- protected area change appears necessary
- task scope expands into full duplicate rescan or duplicate management UI

Do not guess deletion, merge, or canonical asset policy.

---

## 21. Handoff Requirements

Use:

- `docs/templates/handoff.md`

Handoff MUST include:

- Task ID: DA-005
- Risk level: Medium
- files changed
- duplicate detection components added
- detection stages implemented
- hash behavior:
  - none/partial/full
- database persistence:
  - yes/no
- import integration:
  - yes/no
- XcodeGen run:
  - yes/no
- build run:
  - yes/no
- duplicate verification run:
  - yes/no
- samples tested
- visual evidence:
  - not applicable or path
- skipped checks and why
- known risks
- next suggested task

Do not declare final acceptance.

Instruction owner decides acceptance.

---

## 22. Expected Completion Criteria

DA-005 is complete when:

- path duplicate detection exists
- staged content duplicate foundation exists
- partial hash behavior is implemented or clearly prepared
- duplicate result model is clear
- duplicate failure states are safe
- original files are not moved, modified, copied, or deleted
- implementation does not include out-of-scope features
- handoff is produced

---

## 23. Suggested Next Task

After DA-005, the likely next task is:

- DA-006 Full Duplicate Rescan

Do not start DA-006 in this task.

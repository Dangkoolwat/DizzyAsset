# DA-004 File Import & Scan — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-004  
**Task name:** File Import & Scan  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-004-file-import-scan.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first file/folder import and recursive media scan foundation for DizzyAsset.

When the user provides files or folders, DizzyAsset should discover supported media files and prepare them for later indexing.

This task should create the import scanning pipeline, but should not implement full duplicate detection, hashing, metadata extraction, search, preview, or Final Cut Pro integration.

Original files must remain where they are.

---

## 2. Source of Truth

Follow this priority order:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-004 task prompt
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
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/duplicate-detection.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`
- relevant import/indexing section of `docs/product/dizzyasset_design_doc.md`

Do not read full product docs unless import behavior is unclear.

---

## 4. Relevant Skills

Do not load all skills.

Use only if relevant:

- `macos-sandbox-security-skill`
  - for file access, folders, external drive considerations, permission behavior

- `swift-concurrency`
  - for recursive scan, cancellation, background work

- `karpathy-guidelines`
  - for small surgical implementation

- `xcode-project-analyzer`
  - only if `project.yml`, target membership, or build settings are touched

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- input handling for file/folder URLs
- recursive folder scan
- supported media file filtering
- import candidate model
- import scan result summary
- basic error collection per failed file/folder
- non-destructive behavior
- connection point to database/repository if DA-002 exists
- XcodeGen update if new source files are added

Supported initial media candidates may include:

- audio: `mp3`, `wav`, `aiff`, `m4a`
- video: `mp4`, `mov`
- image/GIF: `png`, `jpg`, `jpeg`, `gif`

Keep supported type handling simple and explicit.

---

## 6. Out of Scope

Do not implement:

- full duplicate detection
- partial hash
- full hash
- full metadata extraction
- waveform generation
- preview playback
- search
- tag/category suggestion
- AI analysis
- Quick Peek
- Final Cut Pro drag
- workspace derived output
- destructive cleanup
- cloud sync
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

- `DizzyAsset/Domain/Entities/`
- `DizzyAsset/Domain/Import/`
- `DizzyAsset/Data/Repositories/`
- `DizzyAsset/Infrastructure/FileSystem/`
- `DizzyAsset/Presentation/Import/`

Task prompt files belong under:

- `docs/task/`

If new source files are added, ensure XcodeGen includes them.

Run `xcodegen generate` after file add/delete/move when required.

Do not manually edit `.xcodeproj`.

---

## 8. Implementation Guidance

Keep this task focused on discovery and scan result structure.

Possible components:

- `ImportCandidate`
  - represents a discovered file candidate

- `ImportScanResult`
  - total input count
  - files discovered
  - folders scanned
  - unsupported files
  - failures

- `AssetImportService`
  - accepts URLs
  - scans folders recursively
  - returns candidates or result

- `MediaFileType`
  - identifies supported media types by extension

- `FileSystemAccess`
  - if existing architecture uses a file access wrapper

Do not create a full import queue unless already scoped.

Do not create hashing pipeline in this task.

Do not persist complex asset records unless DA-002 structure is ready and the scope is minimal.

---

## 9. File Access Rules

Original files remain in place.

MUST:

- scan without moving files
- scan without modifying files
- handle permission errors
- collect per-file or per-folder failures
- support external storage paths when accessible
- preserve recoverability

MUST NOT:

- copy files into workspace automatically
- delete files
- rewrite files
- hide permission failures
- treat inaccessible folder as empty without reporting

---

## 10. Recursive Scan Rules

Recursive scan should:

- walk folder contents
- identify supported media files
- skip unsupported files with count or reason
- avoid crashing on inaccessible files
- avoid blocking the main thread for large folders
- support cancellation if async task structure exists or is simple to add

Be careful with:

- packages
- symlinks
- hidden files
- large folders
- external drives
- permission denied folders

Do not follow unsafe symlinks unless explicitly designed.

---

## 11. Supported Media Rules

Supported media detection may initially be extension-based.

Rules:

- normalize extension case
- keep supported list explicit
- avoid pretending unsupported files are imported
- collect unsupported count if useful
- do not perform heavy file inspection in this task

Future metadata extraction belongs to DA-007.

---

## 12. Database Interaction

If DA-002 database layer exists and has a minimal repository:

- candidate persistence may be minimal
- keep insert behavior conservative
- do not implement duplicate logic
- do not implement metadata extraction beyond simple file info

If database layer is not ready or current code does not support persistence:

- return scan result without persistence
- report limitation in handoff

Do not create parallel persistence.

---

## 13. Error Handling

Import scan should continue when possible.

Possible errors:

- permission denied
- file missing during scan
- folder unavailable
- unsupported file
- unreadable folder
- external drive offline
- unknown file system error

Rules:

- collect errors
- continue scanning other files when safe
- report summary
- do not fail entire import because one file failed
- do not hide errors

---

## 14. Concurrency Notes

File scanning may be slow.

MUST:

- avoid blocking the main thread for recursive scan
- consider cancellation for long scans
- avoid unbounded parallel file access
- keep UI state updates on MainActor if UI is touched

If concurrency is deferred:

- keep API shape compatible with async evolution
- report limitation in handoff

---

## 15. XcodeGen Rules

If adding, deleting, or moving source files:

1. update `project.yml` if required
2. run `xcodegen generate`
3. run CLI build if possible

Do not edit `.xcodeproj` manually.

If XcodeGen fails, stop and report.

---

## 16. Verification

Minimum Verification is required.

Run when possible:

- `xcodegen generate` if files were added/deleted/moved or project.yml changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Import-focused verification should include:

- single supported file input
- folder with supported files
- folder with unsupported files
- nested folder scan
- missing/unreadable item if practical
- no file move/copy/delete
- scan result summary is correct

If tests exist, add or run focused tests.

If tests do not exist, perform focused manual or lightweight verification and report limits.

Report commands actually run.

Do not claim build/test passed unless commands were run and passed.

---

## 17. Visual Evidence

If UI is changed, provide visual evidence.

Store under:

- `artifacts/YYYY-MM-DD/DA-004/`

If no UI changed, state that visual evidence is not applicable.

---

## 18. Knowledge Capture

Create a knowledge note only if reusable knowledge is discovered.

Possible topics:

- sandbox folder access issue
- external drive scan behavior
- FileManager recursion issue
- symlink or package behavior
- XcodeGen target membership issue
- concurrency issue during scan

Use:

- `docs/knowledge/YYYY-MM-DD-short-topic.md`

Do not log every small mistake.

---

## 19. Stop Conditions

Stop and report if:

- scan requires entitlement changes
- sandbox behavior is unclear
- recursive scan risks modifying files
- symlink behavior is unsafe or unclear
- external storage behavior is unsafe
- database persistence scope becomes unclear
- project target membership is unclear
- XcodeGen fails
- build fails
- protected area change appears necessary
- task scope expands into duplicate detection, metadata extraction, search, or preview

Do not continue with destructive guesses.

---

## 20. Handoff Requirements

Use:

- `docs/templates/handoff.md`

Handoff MUST include:

- Task ID: DA-004
- Risk level: Medium
- files changed
- import scan components added
- supported media types
- recursive scan behavior
- database persistence:
  - yes/no
- XcodeGen run:
  - yes/no
- build run:
  - yes/no
- import scan verification run:
  - yes/no
- visual evidence:
  - not applicable or path
- skipped checks and why
- known risks
- next suggested task

Do not declare final acceptance.

Instruction owner decides acceptance.

---

## 21. Expected Completion Criteria

DA-004 is complete when:

- file/folder input can be scanned
- supported media candidates can be discovered
- recursive folder scan works for basic cases
- unsupported files are ignored or reported safely
- scan failures are collected and surfaced
- original files are not moved, modified, copied, or deleted
- implementation does not include out-of-scope features
- handoff is produced

---

## 22. Suggested Next Task

After DA-004, the likely next task is:

- DA-005 Duplicate Detection

Do not start DA-005 in this task.

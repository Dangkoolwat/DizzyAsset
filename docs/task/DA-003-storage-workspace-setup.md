# DA-003 Storage / Workspace Setup — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-003  
**Task name:** Storage / Workspace Setup  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-003-storage-workspace-setup.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Initialize DizzyAsset’s app-internal storage and default workspace structure.

This task establishes the separation between:

- app internal data
- user original files
- DizzyAsset workspace output

Default locations:

- app internal data: `~/Library/Application Support/DizzyAsset/`
- workspace: `~/DizzyAsset/`

The task should create or verify required folders and persist minimal workspace setting state.

This task must not move or modify original user files.

---

## 2. Source of Truth

Follow this priority order:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-003 task prompt
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Safety/platform guidelines in `docs/guidelines/`
8. Existing code patterns

Raw chat is not implementation scope.

---

## 3. Required Reading

Read only the required context.

Always read:

- `AGENTS.md`
- this task prompt
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/workspace-lifecycle.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/xcodegen-project.md`
- relevant storage/workspace section of `docs/product/dizzyasset_design_doc.md`

Do not read full product docs unless storage behavior is unclear.

---

## 4. Relevant Skills

Do not load all skills.

Use only if relevant:

- `macos-sandbox-security-skill`
  - for app storage, sandbox, file permissions, bookmark-related storage concerns

- `karpathy-guidelines`
  - for small surgical implementation and avoiding over-abstraction

- `swift-concurrency`
  - if folder creation or settings load/save is async

- `xcode-project-analyzer`
  - only if `project.yml`, target membership, or build settings are touched

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- app internal data root resolution
- default workspace root resolution
- creation of required app internal folders
- creation of required workspace folders
- minimal workspace setting persistence
- safe handling when folders already exist
- safe error reporting when folder creation fails
- integration with existing database/settings layer if DA-002 created one
- XcodeGen update if new source files are added

App internal folder candidates:

- `Database/`
- `Settings/`
- `Index/`
- `Bookmarks/`
- `AIAnalysis/`

Workspace folder candidates:

- `Derived/`
- `Derived/Trimmed/`
- `Derived/Converted/`
- `Derived/Proxy/`
- `Generated/`
- `Generated/Preview/`
- `Generated/Export/`
- `Analysis/`
- `Analysis/Waveforms/`
- `Analysis/Speech/`
- `Analysis/Vision/`
- `Temp/`

Keep implementation conservative.

---

## 6. Out of Scope

Do not implement:

- file/folder import
- drag-and-drop import
- recursive media scan
- duplicate detection
- bookmark resolution for user media
- external drive reconnect flow
- workspace migration UI
- cache cleanup
- derived asset generation
- preview cache generation
- AI analysis output
- settings screen UI beyond minimal persistence if needed
- Final Cut Pro integration
- Quick Peek
- production release/signing/notarization

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

- `DizzyAsset/Data/`
- `DizzyAsset/Data/Settings/`
- `DizzyAsset/Infrastructure/`
- `DizzyAsset/Infrastructure/FileSystem/`
- `DizzyAsset/Infrastructure/Workspace/`
- `DizzyAsset/Domain/`
- `DizzyAsset/Domain/Settings/`

Task prompt files belong under:

- `docs/task/`

If new source files are added, ensure XcodeGen includes them.

Run `xcodegen generate` after file add/delete/move when required.

Do not manually edit `.xcodeproj`.

---

## 8. Implementation Guidance

Keep the storage setup focused.

Possible components:

- `AppStoragePaths`
  - resolves app internal data directories

- `WorkspaceManager`
  - resolves default workspace path
  - creates workspace folder structure
  - reports workspace status

- `WorkspaceSettingsRepository`
  - saves and loads selected workspace root if DA-002 persistence exists

- `FileSystemAccess`
  - small wrapper around file manager operations if existing architecture expects it

Do not create large workspace lifecycle cleanup logic yet.

DA-003 prepares folders and settings only.

---

## 9. Storage Policy

DizzyAsset separates three worlds:

### Original files

Examples:

- `/Volumes/ExternalSSD/SFX/`
- `~/Downloads/`

Rules:

- do not move
- do not modify
- do not delete
- do not copy into workspace automatically

### App internal data

Default:

- `~/Library/Application Support/DizzyAsset/`

Stores:

- database
- settings
- index
- bookmarks
- internal metadata

### Workspace output

Default:

- `~/DizzyAsset/`

Stores:

- derived files
- generated previews
- analysis output
- temporary files

Do not mix these worlds.

---

## 10. Folder Creation Rules

MUST:

- create missing required folders
- treat existing folders as success
- fail clearly when creation fails
- avoid deleting existing folders
- avoid clearing folder contents
- avoid following unsafe cleanup behavior
- keep folder creation idempotent

MUST NOT:

- delete user files
- delete workspace files
- overwrite unknown files
- assume workspace path is always writable
- silently ignore permission failure

---

## 11. Workspace Settings

Minimal setting behavior may include:

- default workspace root
- current workspace root
- created_at or updated_at if persistence exists

If database/settings layer exists:

- store workspace root through app settings or settings repository

If persistence is not ready:

- keep behavior minimal
- report limitation in handoff
- do not build a parallel long-term settings system

Workspace location change UI is out of scope unless explicitly assigned.

---

## 12. Error States

Represent or report clear states when possible:

- ready
- missing
- created
- permissionDenied
- unavailable
- invalidLocation
- creationFailed

Do not collapse all storage failures into a generic error.

---

## 13. Architecture Constraints

MUST:

- keep file-system logic out of SwiftUI Views
- keep storage path logic in a focused service or infrastructure type
- avoid hidden global mutable state
- avoid destructive cleanup
- preserve existing project patterns
- keep APIs small and testable

MUST NOT:

- mix workspace setup with import logic
- implement cleanup jobs
- implement external reconnect flow
- implement bookmark recovery
- create speculative abstraction

---

## 14. XcodeGen Rules

If adding, deleting, or moving source files:

1. update `project.yml` if required
2. run `xcodegen generate`
3. run CLI build if possible

Do not edit `.xcodeproj` manually.

If XcodeGen fails, stop and report.

---

## 15. Verification

Minimum Verification is required.

Run when possible:

- `xcodegen generate` if files were added/deleted/moved or project.yml changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Storage-focused verification should include:

- app internal root resolves
- app internal folders are created or detected
- workspace root resolves
- workspace folders are created or detected
- rerunning setup is safe
- existing folders are not deleted
- failure path is not silently ignored, if testable
- workspace setting persists, if implemented

If tests exist, add or run focused tests.

If tests do not exist, perform a focused manual or lightweight verification and report limits.

Report commands actually run.

Do not claim build/test passed unless commands were run and passed.

---

## 16. Visual Evidence

This task may not require UI visual evidence.

If UI is changed, provide visual evidence.

Store under:

- `artifacts/YYYY-MM-DD/DA-003/`

If no UI changed, state that visual evidence is not applicable.

---

## 17. Knowledge Capture

Create a knowledge note only if reusable knowledge is discovered.

Possible topics:

- Application Support path behavior
- sandbox path permission issue
- workspace creation issue
- XcodeGen target membership issue
- FileManager behavior issue

Use:

- `docs/knowledge/YYYY-MM-DD-short-topic.md`

Do not log every small mistake.

---

## 18. Stop Conditions

Stop and report if:

- folder creation may delete existing user files
- workspace path behavior is unclear
- app internal path behavior is unclear
- sandbox permission behavior is unclear
- persistence layer is missing and task requires durable settings
- project target membership is unclear
- XcodeGen fails
- build fails
- protected area change appears necessary
- task scope expands into import, bookmarks, cleanup, or migration UI

Do not continue with destructive guesses.

---

## 19. Handoff Requirements

Use:

- `docs/templates/handoff.md`

Handoff MUST include:

- Task ID: DA-003
- Risk level: Medium
- files changed
- app internal folders created/verified
- workspace folders created/verified
- workspace root behavior
- settings persistence:
  - yes/no
- XcodeGen run:
  - yes/no
- build run:
  - yes/no
- storage verification run:
  - yes/no
- visual evidence:
  - not applicable or path
- skipped checks and why
- known risks
- next suggested task

Do not declare final acceptance.

Instruction owner decides acceptance.

---

## 20. Expected Completion Criteria

DA-003 is complete when:

- app internal data root is resolved
- required app internal folders can be created or detected
- default workspace root is resolved
- required workspace folders can be created or detected
- setup is idempotent
- no original files are moved, modified, or deleted
- workspace setting persistence is implemented or limitation is clearly reported
- implementation does not include out-of-scope features
- handoff is produced

---

## 21. Suggested Next Task

After DA-003, the likely next task is:

- DA-004 File Import & Scan

Do not start DA-004 in this task.

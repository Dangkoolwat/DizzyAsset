# DA-001 App Foundation — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-001  
**Task name:** App Foundation  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Low  
**Target repo path:** `docs/task/DA-001-app-foundation.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Set up the app lifecycle and main window foundation for DizzyAsset.

The app should launch into a minimal macOS SwiftUI shell that can later host the 3-column workspace:

- Sidebar
- Asset list
- Asset information hub

This task creates the foundation only.

Do not implement import, database, search, preview, tagging, or Final Cut Pro integration in this task.

---

## 2. Source of Truth

Follow this priority order:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-001 task prompt
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
- existing app entry point files
- existing `project.yml`, if project structure or target membership is touched

Read if needed:

- `docs/guidelines/apple-coding-style.md`
- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`
- `docs/templates/handoff.md`

Do not read full product docs unless the app shell behavior is unclear.

---

## 4. Relevant Skills

Do not load all skills.

Use only if relevant:

- `swiftui-expert-skill`
  - for SwiftUI app shell, window, root view, layout, ViewModel boundaries

- `karpathy-guidelines`
  - for small surgical implementation and avoiding over-abstraction

- `xcode-project-analyzer`
  - only if `project.yml`, build settings, scheme, or target membership is touched

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- macOS SwiftUI app entry point
- main window startup
- minimal root view
- placeholder 3-column layout shell
- basic app composition point
- clean folder placement under existing project structure
- build command verification

Allowed placeholders:

- Sidebar placeholder
- Asset list placeholder
- Asset information hub placeholder
- empty state text
- minimal static labels

The result should make it clear that this app is DizzyAsset, but it should not implement product features yet.

---

## 6. Out of Scope

Do not implement:

- SQLite database
- migrations
- file import
- drag-and-drop import
- duplicate detection
- metadata extraction
- search engine
- preview playback
- Quick Peek
- Final Cut Pro drag
- security-scoped bookmark logic
- workspace folder creation
- tag/category system
- settings screen
- AI or analysis provider
- asset persistence
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

Expected directories may include:

- `DizzyAsset/App/`
- `DizzyAsset/Presentation/`
- `DizzyAsset/Presentation/Views/`
- `DizzyAsset/Presentation/ViewModels/`
- `DizzyAsset/Resources/`

Task prompt files belong under:

- `docs/task/`

If new source files are added, ensure XcodeGen includes them.

Run `xcodegen generate` after file add/delete/move when required.

Do not manually edit `.xcodeproj`.

---

## 8. Implementation Guidance

Keep the implementation small.

Suggested minimum components:

- `DizzyAssetApp`
  - SwiftUI app entry point

- Root app shell view
  - e.g. `MainWindowView`

- Placeholder layout sections:
  - sidebar area
  - asset list area
  - asset detail area

The placeholder shell should support later replacement by real modules.

Do not add a large dependency container yet unless existing code already has one.

If a minimal app container already exists, preserve it.

If no ViewModel is needed yet, do not create one just to create structure.

Prefer static placeholders over fake business logic.

---

## 9. UI Intent

The initial main window should communicate the future product shape:

- left: organization / library navigation
- center: asset list / search results
- right: asset information hub

Acceptable placeholder labels:

- Library
- Assets
- Asset Information
- Search, Preview, Drag, Use

Do not over-design the UI.

No visual polish is required beyond a stable shell.

---

## 10. Architecture Constraints

MUST:

- keep SwiftUI View simple
- avoid business logic in the root view
- avoid database or filesystem calls
- avoid global mutable state
- avoid unrelated refactors
- preserve existing project patterns

MUST NOT:

- implement fake import/search behavior
- create placeholder services that imply real behavior
- add speculative protocols
- add unnecessary abstraction
- change protected areas

---

## 11. XcodeGen Rules

If adding, deleting, or moving source files:

1. update `project.yml` if required
2. run `xcodegen generate`
3. run CLI build if possible

Do not edit `.xcodeproj` manually.

If XcodeGen fails, stop and report.

---

## 12. Verification

Minimum Verification is required.

Run when possible:

- `xcodegen generate` if files were added/deleted/moved or project.yml changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Manual check if possible:

- app launches
- main window appears
- placeholder 3-column shell is visible
- no obvious startup crash

Report commands actually run.

Do not claim build passed unless the command was run and passed.

---

## 13. Visual Evidence

This task changes UI.

When environment allows, provide visual evidence.

Store under:

- `artifacts/YYYY-MM-DD/DA-001/`

Examples:

- `artifacts/YYYY-MM-DD/DA-001/main-window.png`
- `artifacts/YYYY-MM-DD/DA-001/app-launch.mov`

If visual evidence cannot be produced, explain why in the handoff.

---

## 14. Stop Conditions

Stop and report if:

- build fails
- XcodeGen fails
- app target membership is unclear
- app entry point conflicts with existing code
- project structure is unclear
- protected area change appears necessary
- entitlement or signing change appears necessary
- task scope expands beyond app foundation

Do not continue by guessing around project setup errors.

---

## 15. Handoff Requirements

Use:

- `docs/templates/handoff.md`

Handoff MUST include:

- Task ID: DA-001
- Risk level: Low
- files changed
- app entry point status
- window/root view status
- XcodeGen run:
  - yes/no
- build run:
  - yes/no
- launch/manual check:
  - yes/no
- visual evidence path or reason missing
- skipped checks and why
- known risks
- next suggested task

Do not declare final acceptance.

Instruction owner decides acceptance.

---

## 16. Expected Completion Criteria

DA-001 is complete when:

- the app has a working SwiftUI entry point
- the main window opens
- the app shows a minimal DizzyAsset shell
- the shell does not implement out-of-scope features
- project generation/build status is reported
- handoff is produced

---

## 17. Suggested Next Task

After DA-001, the likely next task is:

- DA-002 Database Layer

Do not start DA-002 in this task.

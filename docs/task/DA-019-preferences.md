# DA-019 Preferences — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-019  
**Task name:** Preferences  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Low  
**Target repo path:** `docs/task/DA-019-preferences.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first Preferences foundation for DizzyAsset.

Preferences should provide minimal settings needed for the app foundation.

Priority settings:

- workspace location display
- workspace location change hook if safely scoped
- basic app settings persistence
- future settings structure

This task should not implement advanced settings UI or risky permission changes.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-019 task prompt
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
- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/workspace-lifecycle.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `swiftui-expert-skill`
  - preferences UI and state

- `macos-sandbox-security-skill`
  - workspace folder selection and permission behavior

- `karpathy-guidelines`
  - small scoped implementation

- `xcode-project-analyzer`
  - only for project changes

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- Preferences view foundation
- Preferences ViewModel if needed
- workspace path display
- minimal app setting read/write
- workspace location selection hook if safe
- settings persistence through repository if available
- clear unavailable/error state

Keep UI simple.

---

## 6. Out of Scope

Do not implement:

- advanced settings categories
- release settings
- signing/notarization settings
- entitlement toggles
- cloud settings
- AI provider configuration
- full workspace migration
- automatic cleanup controls unless assigned
- Final Cut Pro sound library linking

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `PreferencesView`
- `PreferencesViewModel`
- `AppSettingsRepository`
- `WorkspacePreferenceSection`

Do not create a full settings architecture unless needed.

Use existing persistence if DA-002/DA-003 supports it.

If persistence is not ready, report limitation.

---

## 8. Workspace Preference Rules

Workspace location is important.

Rules:

- show current workspace path
- do not move workspace files unless explicitly assigned
- do not delete workspace files
- do not change permissions silently
- handle invalid location clearly
- treat external workspace as possible

Changing workspace location may be non-trivial.

If change flow is unsafe, implement display-only and report follow-up.

---

## 9. UI Rules

Preferences should be simple.

If UI is changed:

- visual evidence is required
- show clear labels
- show disabled/unavailable state when needed
- avoid broad redesign

---

## 10. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Preferences verification should include:

- preferences view opens if UI exists
- workspace path displays
- setting persists if implemented
- invalid/unavailable state if practical
- no protected setting changed

Report skipped checks.

---

## 11. Visual Evidence

This is likely a UI task.

Visual evidence is required when UI changes.

Store under:

- `artifacts/YYYY-MM-DD/DA-019/`

If no UI changed, state not applicable.

---

## 12. Stop Conditions

Stop and report if:

- entitlement change is required
- sandbox permission behavior is unclear
- workspace move would risk data loss
- settings persistence is unclear
- UI scope expands into advanced preferences
- protected area change appears necessary

---

## 13. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-019
- Risk level: Low
- files changed
- preferences UI:
  - yes/no
- workspace path display:
  - yes/no
- settings persistence:
  - yes/no
- protected areas touched:
  - must be no unless approved
- visual evidence path
- verification run
- skipped checks
- known risks
- next suggested task

---

## 14. Expected Completion Criteria

DA-019 is complete when:

- preferences foundation exists
- workspace location is visible or persistence foundation is prepared
- no protected settings are changed
- visual evidence is provided if UI changed
- handoff is produced

---

## 15. Suggested Next Task

After DA-019:

- DA-020 Search Index Architecture

Do not start DA-020 in this task.

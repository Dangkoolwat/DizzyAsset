# DA-014 Right Panel Asset Information Hub — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-014  
**Task name:** Right Panel Asset Information Hub  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-014-right-panel-asset-information-hub.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the right panel foundation as an Asset Information Hub.

The right panel is not just a preview pane.

It should become the place where selected asset details, status, tags, categories, preview state, duplicate status, and future analysis information are displayed.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-014 task prompt
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
- `docs/guidelines/preview-engine.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/duplicate-detection.md`
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/workspace-lifecycle.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `swiftui-expert-skill`
  - panel composition, inspector sections, state binding

- `avfoundation-media-pro`
  - only if preview surface is touched

- `karpathy-guidelines`
  - simple scoped implementation

- `code-review-graph`
  - if panel depends on many feature states

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- right panel view foundation
- selected asset detail display
- clear empty state
- basic section layout
- tag/category display if available
- path display if available
- duplicate status display if available
- preview placeholder or preview state if available
- missing/offline/permission status display if available
- visual evidence

Possible sections:

- Preview
- File Info
- Tags
- Categories
- Duplicate Status
- Storage Status
- Analysis
- Usage History

Implement only data that exists.

Use placeholders only when clearly marked.

---

## 6. Out of Scope

Do not implement:

- full preview engine if not already available
- waveform generation
- silence analysis
- tag editing if not already scoped
- category editing if not already scoped
- duplicate management actions
- file reconnect flow
- Final Cut Pro drag
- Quick Peek
- AI analysis execution
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `AssetInformationHubView`
- `AssetInfoSection`
- `AssetPreviewSection`
- `AssetTagsSection`
- `AssetCategoriesSection`
- `AssetStatusSection`
- `AssetInformationHubViewModel`

Keep sections composable.

Do not build one giant inspector view.

Do not invent fake data sources.

---

## 8. State Rules

Right panel should reflect selected asset.

Rules:

- selected asset source should be clear
- right panel should not own global selection unless assigned
- panel should handle nil selection
- panel should handle missing asset
- panel should update when selection changes
- panel should not directly access database from SwiftUI View

---

## 9. UI Rules

The panel should be useful but not over-designed.

Must support:

- no selection state
- selected asset state
- unavailable/missing state if data exists
- compact, readable sections

Visual evidence is required when environment allows.

---

## 10. Data Display Rules

Show only reliable data.

If data is not available:

- show placeholder
- hide section
- or show clear unavailable state

Do not imply analysis exists when it does not.

Do not show fake duplicate status as real.

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Right panel verification should include:

- no selection state
- selected asset state
- selection change update if possible
- tag/category display if available
- missing/offline state if available
- visual evidence

Report skipped checks.

---

## 12. Visual Evidence

This is a UI task.

Visual evidence is required when environment allows.

Store under:

- `artifacts/YYYY-MM-DD/DA-014/`

Examples:

- no selection
- selected asset
- status section

---

## 13. Stop Conditions

Stop and report if:

- selected asset state ownership is unclear
- panel requires broad state architecture change
- UI scope expands into full editing tools
- fake data would be required to appear complete
- preview behavior expands beyond scope
- protected area change appears necessary

---

## 14. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-014
- Risk level: Medium
- files changed
- sections implemented
- data source
- ViewModel added:
  - yes/no
- selected asset behavior
- visual evidence path
- verification run
- skipped checks
- known risks
- next suggested task

---

## 15. Expected Completion Criteria

DA-014 is complete when:

- right panel foundation exists
- panel behaves as Asset Information Hub
- empty/selected states are handled
- displayed data is reliable or clearly unavailable
- visual evidence is provided or explained
- handoff is produced

---

## 16. Suggested Next Task

After DA-014:

- DA-015 Quick Peek

Do not start DA-015 in this task.

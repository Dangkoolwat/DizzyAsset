# DA-008 Asset List UI — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-008  
**Task name:** Asset List UI  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-008-asset-list-ui.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first asset list UI foundation.

The UI should show indexed or placeholder asset rows in the center column and support basic selection.

This task prepares the central asset browsing area for later search, preview, tagging, and drag workflows.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-008 task prompt
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
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/search-architecture.md`
- `docs/guidelines/preview-engine.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `swiftui-expert-skill`
  - SwiftUI list, selection, ViewModel state

- `karpathy-guidelines`
  - simple scoped UI changes

- `code-review-graph`
  - if change affects multiple UI flows

- `xcode-project-analyzer`
  - only if project files are touched

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- central asset list view
- asset row view
- basic list selection state
- empty state
- loading or placeholder state if useful
- connection to repository/ViewModel if available
- visual structure that fits 3-column shell
- no heavy business logic in views

Possible row fields:

- file name
- file type
- duration if available
- tag chips placeholder if available
- missing/offline status placeholder if available

---

## 6. Out of Scope

Do not implement:

- full search engine
- tag editing
- category editing
- drag tagging
- preview playback
- keyboard Space preview
- Final Cut Pro drag
- Quick Peek
- duplicate management UI
- AI suggestions
- settings
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `AssetListView`
- `AssetRowView`
- `AssetListViewModel`
- lightweight `AssetListItemViewData`

If existing equivalents exist, extend them surgically.

Keep UI small and composable.

Do not create fake persistence if repository is unavailable.

If database integration is not ready, use clearly marked placeholder/sample data only if appropriate, and report it.

---

## 8. State Rules

Selection should have one clear owner.

Possible owner:

- `AssetListViewModel`

Rules:

- selection updates row highlight
- selection can later drive right panel
- no duplicate selection state across unrelated ViewModels
- no unnecessary EnvironmentObject
- no persistence in the View

---

## 9. UI Rules

The asset list should support later workflow:

- search results
- keyboard navigation
- preview
- drag
- tags/categories
- duplicate status
- offline state

But do not implement those features yet unless assigned.

Keep visual hierarchy clear.

Avoid over-polishing.

---

## 10. Visual Evidence

This is a UI task.

Visual evidence is required when environment allows.

Store under:

- `artifacts/YYYY-MM-DD/DA-008/`

Examples:

- `artifacts/YYYY-MM-DD/DA-008/asset-list-empty.png`
- `artifacts/YYYY-MM-DD/DA-008/asset-list-rows.png`

If visual evidence cannot be produced, explain why.

---

## 11. XcodeGen Rules

If adding, deleting, or moving source files:

1. update `project.yml` if required
2. run `xcodegen generate`
3. run CLI build if possible

Do not edit `.xcodeproj` manually.

---

## 12. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

UI verification should include:

- asset list appears
- empty state appears
- row rendering works if data exists
- selection works if implemented
- no obvious layout break
- visual evidence captured if possible

Report skipped checks.

---

## 13. Stop Conditions

Stop and report if:

- asset list requires broad architecture change
- state ownership is unclear
- repository integration is unclear
- UI change expands into search/preview/tagging
- build fails
- XcodeGen fails
- protected area change appears necessary

---

## 14. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-008
- Risk level: Medium
- files changed
- UI components added
- ViewModel added:
  - yes/no
- data source:
  - repository/sample/placeholder
- selection behavior:
  - yes/no
- visual evidence path
- verification run
- skipped checks
- known risks
- next suggested task

---

## 15. Expected Completion Criteria

DA-008 is complete when:

- asset list UI foundation exists
- rows or empty state render
- selection state is clear if implemented
- no out-of-scope feature is added
- visual evidence is provided or explained
- handoff is produced

---

## 16. Suggested Next Task

After DA-008:

- DA-009 Search Engine

Do not start DA-009 in this task.

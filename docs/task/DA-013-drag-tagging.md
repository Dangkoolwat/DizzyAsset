# DA-013 Drag Tagging — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-013  
**Task name:** Drag Tagging  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-013-drag-tagging.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first drag tagging foundation.

Users should be able to assign tags or categories to assets through simple drag interactions where scoped.

This task improves organization UX but must remain non-destructive.

Dragging for tagging must not move original files.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-013 task prompt
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

- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/final-cut-pro-integration.md`
- `docs/guidelines/xcodegen-project.md`

Do not confuse drag tagging with Final Cut Pro drag.

---

## 4. Relevant Skills

Use only if relevant:

- `swiftui-expert-skill`
  - drag/drop UI, state management

- `karpathy-guidelines`
  - scoped UI implementation

- `code-review-graph`
  - if drag behavior touches list, tags, categories, and selection together

- `xcode-project-analyzer`
  - only for project changes

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- basic drag source for selected asset or asset row
- drop target for tag or category if UI exists
- assignment action on drop
- visual feedback for valid drop if simple
- safe rejection for invalid drop
- no original file movement
- persistence through tag/category repository if available

Possible first scope:

- drag asset row onto tag chip/list
- drag asset row onto category item
- assign relationship in DB

Use the smallest useful path.

---

## 6. Out of Scope

Do not implement:

- Final Cut Pro drag
- Finder drag export
- moving files between folders
- complex multi-select drag unless assigned
- drag reorder of categories
- advanced visual animation
- Quick Peek drag
- hidden media copying
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `AssetDragPayload`
- `TagDropTarget`
- `CategoryDropTarget`
- `DragTaggingService`
- assignment repository call

Keep drag payload internal to DizzyAsset.

Do not reuse FCP drag payload unless task explicitly requires it.

---

## 8. State Rules

Drag tagging should preserve clear state ownership.

Rules:

- selected asset state has one owner
- drag payload should represent asset identity
- tag/category assignment should go through service/repository
- UI should update after assignment
- failed drop should not partially assign

---

## 9. UI Rules

If UI is touched:

- show valid drop target when possible
- show invalid drop state when simple
- preserve keyboard flow
- avoid layout redesign
- visual evidence is required

Do not make the app feel like Finder file movement.

This is logical organization only.

---

## 10. Persistence Rules

If persistence exists:

- write asset/tag or asset/category relation
- preserve existing assignments
- avoid duplicate relation rows
- avoid destructive migration

If persistence is not ready:

- implement UI payload/state only if useful
- report limitation in handoff

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Drag tagging verification should include:

- drag asset to tag/category target
- invalid drop rejected if implemented
- relation saved if persistence exists
- duplicate assignment behavior
- no original file movement
- UI visual evidence

Report skipped checks.

---

## 12. Visual Evidence

This is a UI task.

Visual evidence is required when environment allows.

Store under:

- `artifacts/YYYY-MM-DD/DA-013/`

Examples:

- drag target screenshot
- assignment result screenshot
- short recording

---

## 13. Stop Conditions

Stop and report if:

- drag behavior conflicts with Final Cut Pro drag
- drag operation may move original files
- assignment persistence is unclear
- state ownership is unclear
- UI scope expands into major redesign
- protected area change appears necessary

---

## 14. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-013
- Risk level: Medium
- files changed
- drag source implemented:
  - yes/no
- drop target implemented:
  - yes/no
- persistence behavior
- visual evidence path
- verification run
- skipped checks
- known risks
- next suggested task

---

## 15. Expected Completion Criteria

DA-013 is complete when:

- drag tagging foundation exists
- drop assignment is safe
- original files are not moved
- invalid drops are safe
- visual evidence is provided or explained
- handoff is produced

---

## 16. Suggested Next Task

After DA-013:

- DA-014 Right Panel Asset Information Hub

Do not start DA-014 in this task.

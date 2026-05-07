# DA-012 Category System — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-012  
**Task name:** Category System  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-012-category-system.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first category system foundation for DizzyAsset.

Categories should provide shallow, editor-friendly organization without moving original files.

Category rule:

- default 2 levels
- maximum 3 levels
- no unlimited folder tree

Files remain in their original locations.

Category assignment is a database relationship, not a file move.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-012 task prompt
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
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/search-architecture.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `sqlite-fts-optimizer`
  - category schema, hierarchy query, indexes

- `swiftui-expert-skill`
  - if category UI is touched

- `karpathy-guidelines`
  - simple scoped implementation

- `code-review-graph`
  - if category relationships affect multiple features

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- category entity/model
- parent-child category relation
- max depth validation
- category sort order if simple
- asset/category relation
- category repository or service
- basic create/rename/move/delete behavior if scoped
- category assignment/removal foundation
- search compatibility if available

Category operations may include:

- add
- rename
- move
- merge
- delete
- reorder

Implement only the minimal subset assigned or needed for foundation.

---

## 6. Out of Scope

Do not implement:

- unlimited tree UI
- complex drag reorder UI
- bulk category management
- AI category recommendation
- advanced merge conflict UI
- file/folder moves
- Finder folder synchronization
- Quick Peek
- Final Cut Pro integration
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `Category`
- `CategoryRepository`
- `CategoryService`
- `CategoryDepthValidator`
- `AssetCategoryAssignment`

Keep category rules explicit.

Do not encode hierarchy only in display strings.

Use parent relation or equivalent stable model.

---

## 8. Category Depth Rules

MUST enforce:

- maximum 3 levels
- no unlimited nesting

Examples:

- level 1: Sound Effects
- level 2: Impact
- level 3: Heavy Hit

A fourth level should be rejected or prevented.

If enforcement is not implemented yet, document limitation in handoff.

---

## 9. Database Rules

If persistence exists:

- use repository boundary
- preserve user categories
- avoid destructive migration
- keep asset_categories relation explicit
- avoid deleting assigned assets when category is deleted
- handle orphan relation safely

If persistence is not ready:

- implement model/service boundary only
- report limitation in handoff

---

## 10. UI Rules

If UI is touched:

- keep it simple
- show shallow hierarchy clearly
- do not mimic unlimited Finder tree
- category assignment must not imply file move
- visual evidence is required

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Category verification should include:

- create category
- create child category
- reject or prevent depth above 3
- assign asset to category if persistence exists
- remove assignment if implemented
- rename category if implemented
- no original file movement

Report skipped checks.

---

## 12. Visual Evidence

If UI is changed, visual evidence is required.

Store under:

- `artifacts/YYYY-MM-DD/DA-012/`

If no UI changed, state not applicable.

---

## 13. Stop Conditions

Stop and report if:

- category depth policy is unclear
- delete/merge behavior risks data loss
- category assignment implies file movement
- schema migration becomes destructive
- UI scope expands into complex tree management
- task expands into AI category recommendation

---

## 14. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-012
- Risk level: Medium
- files changed
- category model added/changed
- max depth enforcement:
  - yes/no
- persistence behavior
- UI touched:
  - yes/no
- search touched:
  - yes/no
- verification run
- skipped checks
- known risks
- next suggested task

---

## 15. Expected Completion Criteria

DA-012 is complete when:

- category foundation exists
- shallow hierarchy rule is represented
- asset/category relation is supported or clearly prepared
- no file movement is introduced
- verification is reported
- handoff is produced

---

## 16. Suggested Next Task

After DA-012:

- DA-013 Drag Tagging

Do not start DA-013 in this task.

# DA-011 Editing Language Tag System — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-011  
**Task name:** Editing Language Tag System  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-011-editing-language-tag-system.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first editor-language tag system foundation.

Tags should reflect real editor search language, not generic AI research labels.

Examples:

- 예능 / Funny
- 긴장 / Tension
- 타격 / Impact
- 전환 / Transition
- 쇼츠 / Shorts
- 실패 / Fail
- 리액션 / Reaction
- 밈 / Meme

This task should support tag storage, basic assignment, and normalized names.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-011 task prompt
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
- `docs/guidelines/search-architecture.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/ai-analysis-provider.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `sqlite-fts-optimizer`
  - tag schema, normalization, indexes

- `swiftui-expert-skill`
  - if tag UI is touched

- `karpathy-guidelines`
  - simple scoped implementation

- `code-review-graph`
  - if tag behavior affects multiple features

---

## 5. In Scope

Implement or verify:

- tag entity/model
- normalized tag name
- Korean/English tag storage support
- tag source field if schema supports it
- asset/tag relation
- basic tag assignment/removal service or repository
- built-in editor-language seed list if assigned or simple
- search compatibility for tags

Tag source may include:

- user
- filename
- folder
- aiSuggested
- systemSeed

---

## 6. Out of Scope

Do not implement:

- advanced AI tagging
- Sound Analysis tagging
- Vision/Speech tagging
- tag recommendation engine
- complex tag management UI
- bulk tag operations
- drag tagging
- category system
- Quick Peek
- Final Cut Pro integration
- release/signing/notarization

---

## 7. Implementation Guidance

Possible components:

- `Tag`
- `TagSource`
- `TagRepository`
- `TaggingService`
- `EditorLanguageTagSeed`
- `TagNormalizer`

Keep tag behavior explicit.

Do not make AI output confirmed user tags.

User-confirmed tags should be preserved.

---

## 8. Tag Philosophy

Tags should use editing language.

Good tag examples:

- 예능
- Funny
- 긴장
- Tension
- 타격
- Impact
- 전환
- Transition
- 쇼츠
- Shorts
- 실패
- Fail
- 리액션
- Reaction
- 밈
- Meme

Avoid generic labels unless useful:

- object
- sound
- file
- media
- thing
- scene

---

## 9. Normalization

Normalize tags for search.

Consider:

- trim whitespace
- lowercase English
- preserve display name
- store normalized_name
- avoid duplicate tags that differ only by case or whitespace

Do not over-normalize Korean text without clear policy.

---

## 10. Database Rules

If persistence exists:

- use repository boundary
- preserve user tags
- avoid destructive migration
- keep asset_tags relation explicit
- do not delete tags automatically when unassigned unless policy exists

If persistence is not ready:

- implement model/service boundary only
- report limitation in handoff

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Tag verification should include:

- create tag
- normalize tag
- assign tag to asset if persistence exists
- remove tag from asset if implemented
- Korean tag
- English tag
- duplicate normalized tag handling if implemented
- search compatibility if search integration exists

Report skipped checks.

---

## 12. Visual Evidence

If UI is changed, visual evidence is required.

Store under:

- `artifacts/YYYY-MM-DD/DA-011/`

If no UI changed, state not applicable.

---

## 13. Stop Conditions

Stop and report if:

- tag/category boundary becomes unclear
- AI suggested vs user confirmed semantics are unclear
- schema migration becomes destructive
- search ranking behavior becomes unclear
- task expands into drag tagging or tag management UI
- build fails

---

## 14. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-011
- Risk level: Medium
- files changed
- tag model added/changed
- normalization behavior
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

DA-011 is complete when:

- editor-language tag foundation exists
- tags can be represented and normalized
- user-confirmed tag data is preserved
- persistence or limitation is clear
- no AI overreach is introduced
- handoff is produced

---

## 16. Suggested Next Task

After DA-011:

- DA-012 Category System

Do not start DA-012 in this task.

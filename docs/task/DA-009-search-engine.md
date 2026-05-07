# DA-009 Search Engine — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-009  
**Task name:** Search Engine  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-009-search-engine.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first search engine foundation for DizzyAsset.

Search should support fast filtering of indexed assets by:

- filename
- tag
- category

This task should keep the first search implementation simple and reliable.

Do not implement advanced ranking, FTS5 migration, AI search, or Quick Peek search in this task unless explicitly assigned.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-009 task prompt
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
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/state-management.md`
- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `sqlite-fts-optimizer`
  - query/index design and search performance

- `swift-concurrency`
  - async search and cancellation

- `swiftui-expert-skill`
  - if search UI or ViewModel is touched

- `karpathy-guidelines`
  - simple scoped implementation

- `xcode-project-analyzer`
  - only for project changes

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- `SearchService` or equivalent search boundary
- filename search
- tag search if tag persistence exists
- category search if category persistence exists
- basic filter result model
- simple deterministic ordering
- empty query behavior
- no-result behavior
- repository query methods if needed
- async/cancellable shape if needed

Keep the first version simple.

---

## 6. Out of Scope

Do not implement:

- FTS5 migration unless assigned
- advanced ranking
- alias expansion
- AI search
- transcript search
- vision result search
- Quick Peek search
- search suggestions
- fuzzy search
- semantic search
- large-scale performance overhaul
- UI redesign
- release/signing/notarization

---

## 7. Implementation Guidance

Possible components:

- `SearchService`
- `SearchQuery`
- `SearchResult`
- `SearchFilter`
- `AssetSearchRepository`
- `SearchViewModel` only if UI is touched

Initial matching may use:

- SQL LIKE
- normalized lowercase strings
- tag/category join queries
- in-memory filtering only if dataset is small and clearly temporary

Do not make in-memory filtering the long-term plan without documenting it.

---

## 8. Search Behavior

Define clear behavior for:

- empty query
- filename match
- extension match if useful
- tag match
- category match
- no result
- missing/offline assets

Exact filename match should be predictable.

Do not hide missing/offline assets unless a filter says to hide them.

---

## 9. Performance

Search should feel instant.

Rules:

- avoid blocking UI
- cancel stale searches if search-as-you-type is implemented
- avoid full scans for large libraries when practical
- add indexes only when justified
- report performance limits

Do not introduce FTS5 unless this task explicitly includes it.

---

## 10. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Search verification should include:

- empty query
- filename query
- Korean filename query if sample exists
- English query if sample exists
- tag query if implemented
- category query if implemented
- no result state
- missing/offline result behavior if relevant

Report skipped checks.

---

## 11. Stop Conditions

Stop and report if:

- ranking policy is unclear
- search requires broad schema migration
- FTS5 migration becomes necessary
- UI becomes blocked
- tag/category schema is not ready
- query performance is unsafe
- task expands into Quick Peek or advanced search

---

## 12. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-009
- Risk level: Medium
- files changed
- search scope implemented
- query method
- ranking changed:
  - yes/no
- FTS5 touched:
  - yes/no
- tag/category search:
  - yes/no
- verification run
- skipped checks
- known risks
- next suggested task

---

## 13. Expected Completion Criteria

DA-009 is complete when:

- basic search service exists
- filename search works
- tag/category search works if persistence exists
- no-result and empty-query behavior are defined
- search does not block UI in normal use
- handoff is produced

---

## 14. Suggested Next Task

After DA-009:

- DA-010 Preview Engine

Do not start DA-010 in this task.

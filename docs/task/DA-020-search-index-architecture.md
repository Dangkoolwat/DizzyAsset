# DA-020 Search Index Architecture — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-020  
**Task name:** Search Index Architecture  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-020-search-index-architecture.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Prepare the scalable search indexing architecture for DizzyAsset.

This task extends DA-009 by preparing search to evolve beyond simple LIKE queries.

Search should support future:

- normalized tokens
- Korean/English mixed search
- editor-language aliases
- tag/category weighting
- SQLite FTS5
- recent usage boost

This task should not rewrite the entire search UI.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-020 task prompt
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
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `sqlite-fts-optimizer`
  - FTS5, indexing, ranking, query strategy

- `swift-concurrency`
  - index rebuild and async search

- `karpathy-guidelines`
  - avoid overbuilding

- `code-review-graph`
  - if search architecture touches multiple modules

Skills do not expand scope.

---

## 5. In Scope

Implement or verify one or more scoped foundations:

- normalized search token model
- alias dictionary structure
- search index table design
- FTS5 migration path
- index rebuild service stub
- ranking signal model
- recent usage search signal
- search latency measurement hook

The task may be architecture-preparation only if implementation would be too broad.

Keep behavior compatible with DA-009.

---

## 6. Out of Scope

Do not implement:

- full semantic search
- AI search
- cloud search
- transcript search
- vision search
- broad UI redesign
- Quick Peek advanced ranking
- full ranking overhaul without product decision
- destructive migration
- release/signing/notarization

---

## 7. Implementation Guidance

Possible components:

- `SearchIndex`
- `SearchToken`
- `SearchAlias`
- `SearchRankingSignal`
- `SearchIndexRepository`
- `SearchIndexRebuilder`

FTS5 may be introduced only if scoped and safe.

It is acceptable to create migration plan or interfaces first.

---

## 8. Search Architecture Rules

Search should remain predictable.

Priority direction:

- exact filename
- filename prefix
- tag
- category
- alias
- recent usage
- recent import

Do not let weak alias match outrank exact filename match.

Do not make AI suggestions dominate user-confirmed tags.

---

## 9. FTS5 Rules

If FTS5 is touched:

- source tables remain canonical
- FTS table is derived
- index is rebuildable
- migration is explicit
- index rebuild must not delete canonical data
- ranking behavior is documented

If FTS5 is not implemented:

- document extension path
- avoid pretending it exists

---

## 10. Alias Rules

Alias search should support editor language.

Examples:

- 예능 / Funny
- 긴장 / Tension
- 타격 / Impact
- 전환 / Transition
- 쇼츠 / Shorts

Rules:

- alias source should be traceable
- user-confirmed terms rank higher
- weak aliases rank lower
- alias expansion should be testable

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Search index verification should include:

- filename search still works
- Korean/English query behavior if implemented
- tag/category search still works if implemented
- alias behavior if implemented
- FTS5 migration if touched
- index rebuild if implemented
- latency check if measurement exists

Report skipped checks.

---

## 12. Stop Conditions

Stop and report if:

- search ranking policy is unclear
- migration may affect existing data
- FTS5 behavior is unsafe
- exact filename search would regress
- alias dictionary scope is unclear
- task expands into AI/semantic search
- performance cannot be checked for a performance-sensitive task

---

## 13. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-020
- Risk level: Medium
- files changed
- search index design changed
- FTS5 touched:
  - yes/no
- alias behavior:
  - yes/no
- ranking behavior changed:
  - yes/no
- migration behavior:
  - none/non-destructive/other
- verification run
- skipped checks
- known risks
- next suggested task

---

## 14. Expected Completion Criteria

DA-020 is complete when:

- search indexing architecture is prepared or implemented safely
- DA-009 search behavior is not broken
- future FTS5/alias/ranking path is clearer
- migration risk is controlled
- handoff is produced

---

## 15. Suggested Next Task

After DA-020:

- DA-021 Bookmark & External Storage Recovery

Do not start DA-021 in this task.

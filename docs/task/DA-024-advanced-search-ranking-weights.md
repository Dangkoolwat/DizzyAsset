# DA-024 Advanced Search Ranking & Weights — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-024  
**Task name:** Advanced Search Ranking & Weights  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation / Optimization  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-024-advanced-search-ranking-weights.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement a sophisticated relevance scoring and ranking system for the DizzyAsset search engine.
The goal is to ensure that search results are ordered by "Perceived Relevance" rather than arbitrary database order.

Scoring criteria:
- **Exact Match (Filename):** Highest weight (+10.0)
- **Prefix Match (Filename):** High weight (+5.0)
- **Tag Match (Confirmed):** Medium weight (+3.0)
- **Category Match:** Low-Medium weight (+2.0)
- **Recent Usage:** Bonus weight (+1.0)
- **Duplicate Flag:** Penalty weight (-1.0)

---

## 2. Source of Truth

Follow:
1. Explicit implementation request
2. `AGENTS.md`
3. This DA-024 task prompt
4. `docs/guidelines/search-architecture.md`
5. `docs/guidelines/sqlite-migration.md`
6. `docs/product/dizzyasset_design_doc.md` (Search section)

---

## 3. Required Reading

Always read:
- `AGENTS.md`
- `docs/guidelines/search-architecture.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/templates/handoff.md`

---

## 4. In Scope

- Implement a custom scoring SQL query for `asset_search_index`.
- Add a `relevance_score` calculation to search results.
- Update `SearchService` to sort by `relevance_score DESC`.
- Implement weight adjustments for different match types (Filename vs Tag).
- Ensure high performance for 10,000+ asset libraries.

---

## 5. Out of Scope

- Implementing full NLP/Semantic search.
- UI changes beyond the search result order.
- Real-time indexing of file content.
- Changing the FTS5 tokenizer (unless necessary for ranking).

---

## 6. Implementation Guidance

### SQL Scoring Logic
Use a `CASE` statement or a derived ranking table in SQLite to calculate scores.
Example logic:
```sql
SELECT 
    rowid, 
    offsets(asset_search_index) as match_info,
    -- Custom scoring logic here
FROM asset_search_index 
WHERE asset_search_index MATCH :query
```

### SearchService Refactoring
- Refactor the `SearchService` to calculate and return sorted results.
- Ensure the `AssetListViewModel` respects the new ordering.

---

## 7. Verification

- `xcodegen generate`
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`
- Verify:
  - Searching for an exact filename brings it to the top.
  - Tag matches appear below filename matches for the same keyword.
  - Search latency remains < 100ms.

---

## 8. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:
- Ranking weights used.
- Performance impact (latency).
- Verification results.
- Next suggested task.

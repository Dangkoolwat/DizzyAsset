# Search Architecture Guideline

Use this guideline when changing search behavior, filtering, ranking, indexing, aliases, FTS5, tag search, category search, or search UI behavior.

Search is a core product engine.

Primary user flow:

    Search
    Preview
    Drag
    Use

---

## 1. Core Principles

MUST:

- keep search fast
- keep search predictable
- support editor-language queries
- support Korean and English terms
- preserve keyboard-first workflow
- avoid blocking UI
- keep source tables canonical

MUST NOT:

- make search depend only on AI
- make FTS index the source of truth
- break filename search
- break tag/category filtering
- hide missing/offline state in search results unless explicitly filtered
- introduce ranking changes without documenting them

---

## 2. Search Scope

v1.0 search may include:

- filename
- file extension
- tags
- categories
- basic metadata
- registration date
- sort order

Future search may include:

- alias
- normalized tokens
- usage history
- speech transcript
- vision analysis
- LLM normalized tags
- similar asset matching

Do not add future scope unless assigned.

---

## 3. Search Sources

Search may read from:

- assets
- tags
- categories
- asset_tags
- asset_categories
- asset_locations
- usage_history
- search index tables
- FTS5 virtual tables

Canonical data remains in source tables.

Derived indexes must be rebuildable.

---

## 4. Query Normalization

Normalize search input when appropriate.

Consider:

- lowercase
- trimming whitespace
- Korean/English mixed terms
- punctuation removal where safe
- filename separators
- common aliases
- editor-language synonyms

Examples of editor-language relation:

- 예능
- Funny
- 웃김
- comedy
- 실패
- fail
- 타격
- impact
- 전환
- transition
- 쇼츠
- shorts

Do not over-normalize until behavior is defined.

---

## 5. Alias Search

Alias search should help users search in real editing language.

Aliases may come from:

- built-in editor-language dictionary
- tag aliases
- category aliases
- user-added aliases
- future AI suggestion

Rules:

- alias source should be visible or traceable
- alias match should not override exact match
- user-confirmed terms should rank higher than weak suggestions
- avoid surprising result jumps

---

## 6. Ranking

Initial ranking should be simple.

Possible ranking signals:

- exact filename match
- prefix filename match
- tag match
- category match
- alias match
- recent usage
- recent import
- favorite or repeated usage

Rules:

- exact match should rank high
- confirmed user tags should rank high
- weak inferred aliases should rank lower
- missing/offline files may still appear with status
- ranking changes should be documented

Avoid complex ranking before baseline search works.

---

## 7. Filtering

Filters may include:

- tag
- category
- file type
- duration
- missing/offline status
- duplicates
- orphan assets
- recent imports
- unorganized assets

Rules:

- filters should compose predictably
- active filters should be visible
- clearing filters should be easy
- filters should not silently remove all results without clear state

---

## 8. FTS5

FTS5 may be used when basic SQL search is not enough.

Use FTS5 for:

- scalable filename search
- normalized token search
- mixed Korean/English search
- alias-expanded search
- large library performance

Rules:

- FTS5 tables are derived indexes
- source tables remain canonical
- FTS index should be rebuildable
- index rebuild should not delete canonical data
- migration must be explicit
- ranking behavior must be documented

Do not introduce FTS5 casually in small UI tasks.

---

## 9. Performance

Search should feel instant.

Rules:

- do not block main thread
- debounce search-as-you-type if needed
- cancel stale searches
- avoid full scans for large libraries
- add indexes when justified
- measure latency when possible

Performance-sensitive cases:

- large SFX folders
- mixed media libraries
- external storage metadata
- tag/category joins
- FTS rebuild

---

## 10. UI Behavior

Search UI should preserve keyboard flow.

Important behavior:

- typing updates results
- arrow keys move selection
- Space previews selected result
- Esc clears or exits according to context
- Enter selects or uses according to context
- drag remains available when file is available

Search results should show useful status:

- duplicate
- missing
- offline
- permission denied
- unsupported preview
- derived/original relation if relevant

---

## 11. Quick Peek Search

Quick Peek search is high-risk.

Rules:

- keep Quick Peek search fast
- isolate Quick Peek state
- cancel stale search tasks
- avoid blocking overlay
- preserve keyboard focus
- reuse search service where practical
- do not add advanced ranking unless assigned

---

## 12. Testing and Verification

Search verification should include:

- filename search
- Korean query
- English query
- mixed Korean/English query
- tag search
- category search
- empty result state
- active filter clearing
- missing/offline result state if relevant
- large library latency if sample data exists

Report what was not tested.

---

## 13. Stop Conditions

Stop and report if:

- search change requires broad schema migration
- ranking semantics are unclear
- FTS5 migration may affect existing data
- search becomes UI-blocking
- product search behavior conflicts with PRD
- alias dictionary scope is unclear
- query performance cannot be checked for a performance task

Do not guess ranking policy for editor-language search.

---

## 14. Handoff Requirements

For search work, handoff must include:

- files changed
- search scope changed
- ranking changed:
  - yes/no
- schema/index changed:
  - yes/no
- FTS5 touched:
  - yes/no
- queries verified
- filters verified
- latency checked:
  - yes/no
- skipped checks
- known risks
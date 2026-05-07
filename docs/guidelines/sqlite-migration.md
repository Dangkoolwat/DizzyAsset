# SQLite and Migration Guideline

Use this guideline when changing SQLite schema, repositories, search indexes, migrations, FTS5, persistence models, or data access behavior.

DizzyAsset stores product memory locally.

User data safety is more important than convenience.

---

## 1. Core Principles

MUST:

- preserve user data
- keep migrations explicit
- keep repository boundaries
- keep database access out of SwiftUI Views
- keep schema changes reviewable
- report migration risk
- verify changed queries

MUST NOT:

- delete user data without explicit approval
- rewrite user data silently
- perform destructive migration casually
- bypass repositories from UI
- hide migration failures
- change relationship semantics without documenting it

---

## 2. Database Role

SQLite stores:

- assets
- tags
- categories
- asset/tag relations
- asset/category relations
- asset locations
- bookmarks
- analysis results
- duplicate scan sessions
- import sessions
- workspace items
- usage history
- app settings

SQLite is app memory.

Original files are not stored in SQLite.

SQLite must not be used as an excuse to move or delete original files.

---

## 3. Layering

SwiftUI Views must not access SQLite directly.

ViewModels should not run raw SQL.

Repositories own database access.

Services coordinate repositories.

Recommended flow:

- View
- ViewModel
- Service or Use Case
- Repository
- SQLite

Do not bypass this flow without a documented reason.

---

## 4. Schema Change Risk

Classify schema work before editing.

### Low Risk

- adding non-required nullable column
- adding non-destructive index
- adding read-only query
- adding table not yet used by user data

### Medium Risk

- adding relationship table
- adding required column with default
- changing query semantics
- changing search ranking
- adding FTS5 index
- adding migration step

### High Risk

- deleting table
- deleting column
- rewriting existing records
- changing primary keys
- changing asset identity
- changing asset_locations semantics
- changing bookmark_data storage
- changing derived asset relation semantics
- destructive cleanup
- migration without rollback strategy

Use stricter classification when unsure.

---

## 5. Expected Core Tables

Expected tables may include:

- assets
- tags
- categories
- asset_tags
- asset_categories
- asset_analysis
- asset_locations
- asset_derivations
- duplicate_scan_sessions
- import_sessions
- import_failures
- app_settings
- workspace_items
- usage_history

Do not rename or remove core tables without explicit approval.

---

## 6. Asset Identity

Asset identity must remain stable.

Do not casually redefine identity.

Possible identity inputs:

- database id
- original path
- bookmark data
- file size
- modified date
- partial hash
- full hash

Rules:

- path duplicate and content duplicate are different concepts
- same path means path duplicate
- same content means content duplicate
- external drive offline does not mean asset is deleted
- missing file does not mean asset identity is gone

---

## 7. Asset Locations

Asset locations are important.

They may represent:

- original path
- security-scoped bookmark
- volume identifier
- last seen timestamp
- file status

Possible statuses:

- available
- missing
- permission_denied
- volume_offline
- stale_bookmark
- recoverable

Rules:

- do not delete asset location on temporary failure
- update status instead
- preserve reconnect possibility
- keep bookmark failures visible

---

## 8. Derived Assets and Workspace Items

Derived assets are not original files.

Derived data may include:

- trimmed output
- converted output
- proxy
- preview cache
- waveform analysis
- export output
- temporary files

Rules:

- original files must not be deleted
- derived assets must link to source assets
- cache may be regeneratable
- user-valuable derived output should be preserved
- orphan state should be explicit
- cleanup must distinguish temp/cache from derived output

---

## 9. Migration Rules

Every schema change needs a migration plan.

Migration plan should include:

- old schema state
- new schema state
- data transformation, if any
- risk level
- rollback or recovery thought
- verification steps

MUST:

- keep migrations ordered
- keep migrations idempotent when practical
- fail clearly on migration error
- avoid partial destructive state
- back up or preserve user data when risk exists

MUST NOT:

- silently ignore migration failure
- drop user data for convenience
- run destructive migration without approval

---

## 10. FTS5 and Search Indexes

FTS5 may be used for search.

Use FTS5 for:

- filename search
- normalized token search
- tag/category search support
- editor-language alias search
- mixed Korean/English search

Rules:

- search index should be rebuildable
- source tables remain canonical
- FTS tables are derived indexes
- index rebuild should not delete canonical data
- ranking changes should be documented
- large library performance should be considered

Do not treat FTS index as source of truth.

---

## 11. Query Design

Queries should be readable and testable.

MUST:

- use parameters
- avoid string interpolation with user input
- keep query responsibilities clear
- document complex ranking
- avoid unnecessary full scans
- add indexes when justified

Search queries should consider:

- filename
- tag
- category
- alias
- recent usage
- file type
- missing/offline status

---

## 12. Transactions

Use transactions for grouped writes.

Good transaction candidates:

- import session insert plus assets
- asset plus tags
- category move
- duplicate scan session results
- workspace cleanup status
- migration steps

Transactions should avoid leaving half-written relationship state.

Do not keep long transactions open during slow file IO.

---

## 13. Repository Rules

Repositories should expose intent methods.

Good examples:

- `insertAssetCandidate`
- `findDuplicateCandidates`
- `updateAssetLocationStatus`
- `assignAssetsToCategory`
- `recordUsage`
- `saveAnalysisResult`

Avoid exposing raw SQL to ViewModels.

Avoid generic repository methods that hide meaning.

Bad:

- `executeAnything`
- `saveData`
- `updateStuff`

---

## 14. Data Mapping

Keep mapping explicit.

Mapping layers may include:

- database row
- persistence model
- domain entity
- UI model

Rules:

- avoid lossy mapping unless intentional
- keep bookmark data protected
- keep file path display separate from bookmark storage
- keep user-facing labels separate from normalized search values

---

## 15. User Data Safety

MUST NOT automatically delete:

- original files
- asset records
- asset locations
- user tags
- user categories
- usage history
- confirmed metadata

Unless explicitly approved.

Prefer:

- mark missing
- mark offline
- mark permission denied
- mark orphaned
- mark recoverable

---

## 16. Backup and Recovery

For risky migrations, consider:

- database backup
- migration dry run
- migration transaction
- migration log
- recovery path

If backup is not implemented, mention risk in handoff.

Do not pretend migration is safe without evidence.

---

## 17. Testing and Verification

For database changes, verification should include:

- build
- migration run
- basic CRUD check
- affected repository check
- affected query check
- failure state if relevant

For search changes, check:

- filename search
- Korean query
- English query
- mixed Korean/English query
- tag search
- category search
- alias search if implemented
- missing/offline asset filtering if relevant

For migration changes, check:

- empty database
- existing database if sample exists
- migration version update
- rollback or failure behavior if possible

Report what was not tested.

---

## 18. Stop Conditions

Stop and report if:

- migration may delete user data
- schema impact is unclear
- asset identity would change
- bookmark storage would change
- asset_locations semantics would change
- generated migration fails
- DB cannot open
- query corrupts expected relations
- rollback strategy is unclear for high-risk migration

Do not continue with destructive guesses.

---

## 19. Handoff Requirements

For SQLite or migration work, handoff must include:

- schema files changed
- migration files changed
- repository files changed
- risk level
- data affected
- migration path
- verification run
- queries checked
- skipped checks
- known risks
- backup/recovery notes if relevant

---

## 20. Review Checklist

Before finishing database work, check:

- Did I preserve user data?
- Did I avoid direct DB access from UI?
- Did I keep repository boundary?
- Did I classify migration risk?
- Did I avoid destructive changes?
- Did I verify affected queries?
- Did I document skipped checks?
- Did I avoid treating FTS as canonical data?
# DA-002 Database Layer — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-002  
**Task name:** Database Layer  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-002-database-layer.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Create the initial local SQLite database layer for DizzyAsset.

The database layer should provide the foundation for storing app memory:

- assets
- tags
- categories
- workspace settings
- duplicate scan records
- future analysis metadata

This task creates the persistence foundation only.

Do not implement full import, search, preview, Quick Peek, Final Cut Pro integration, or AI analysis in this task.

---

## 2. Source of Truth

Follow this priority order:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-002 task prompt
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Safety/platform guidelines in `docs/guidelines/`
8. Existing code patterns

Raw chat is not implementation scope.

---

## 3. Required Reading

Read only the required context.

Always read:

- `AGENTS.md`
- this task prompt
- existing database or persistence files, if any
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`
- relevant database section of `docs/product/dizzyasset_design_doc.md`

Do not read full product docs unless schema intent is unclear.

---

## 4. Relevant Skills

Do not load all skills.

Use only if relevant:

- `sqlite-fts-optimizer`
  - for SQLite schema, indexing, migration shape, persistence design

- `swift-concurrency`
  - if database access is async or actor/queue-based

- `karpathy-guidelines`
  - for simple, surgical implementation

- `xcode-project-analyzer`
  - only if `project.yml`, target membership, or build settings are touched

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- initial database setup
- SQLite database open/create behavior
- basic migration mechanism or schema version mechanism
- foundational tables needed for early tasks
- repository boundary or database access boundary
- basic CRUD verification for at least one foundational entity
- safe error reporting for database open/init failure
- XcodeGen update if new files are added

Initial tables may include:

- `assets`
- `tags`
- `categories`
- `asset_tags`
- `asset_categories`
- `duplicate_scan_sessions`
- `app_settings`
- `schema_migrations` or equivalent migration tracking table

Optional if already planned in design and simple to include:

- `asset_locations`
- `asset_analysis`
- `asset_derivations`
- `workspace_items`
- `usage_history`

Keep schema minimal but forward-compatible.

---

## 6. Out of Scope

Do not implement:

- full file import
- folder scanning
- duplicate hashing logic
- full duplicate rescan
- FTS5 search implementation
- search ranking
- preview playback
- bookmark resolution
- workspace folder creation
- Final Cut Pro drag
- Quick Peek
- AI provider execution
- destructive migrations
- cloud sync
- release/signing/notarization

Do not change:

- entitlements
- sandbox permissions
- CI/CD
- signing
- release packaging

---

## 7. Expected Project Shape

Use existing project structure when present.

Expected locations may include:

- `DizzyAsset/Data/`
- `DizzyAsset/Data/Database/`
- `DizzyAsset/Data/Repositories/`
- `DizzyAsset/Domain/Entities/`
- `DizzyAsset/Domain/Repositories/`

Task prompt files belong under:

- `docs/task/`

If new source files are added, ensure XcodeGen includes them.

Run `xcodegen generate` after file add/delete/move when required.

Do not manually edit `.xcodeproj`.

---

## 8. Implementation Guidance

Keep the database layer small and explicit.

Possible components:

- `Database`
  - opens SQLite database
  - applies migrations
  - provides controlled access

- `DatabaseMigrator`
  - manages schema version
  - applies ordered migrations

- `AssetRepository`
  - early repository boundary
  - minimal CRUD or insert/fetch behavior

- persistence models or row mappers
  - explicit mapping between database rows and domain entities

Do not create a generic all-purpose database abstraction unless needed.

Do not expose raw SQL to SwiftUI Views.

Do not create fake feature behavior just to use the database.

---

## 9. Schema Guidance

Schema should support DizzyAsset’s core philosophy:

- original files remain in user locations
- app stores metadata and relationships
- user tags/categories are preserved
- duplicate information is reported, not used to delete originals
- future bookmark and workspace relations can be added safely

Recommended early entity ideas:

### assets

Should support:

- id
- file_name
- file_extension
- original_path or future location relation
- file_size
- media_type
- duration if known
- imported_at
- modified_at
- is_missing or status placeholder

### tags

Should support:

- id
- name
- normalized_name
- source
- created_at

### categories

Should support:

- id
- name
- parent_id
- sort_order
- created_at

Category depth rule is product-level:

- default 2 levels
- max 3 levels

Do not enforce complex category UX in this task unless simple schema support is needed.

### relationship tables

May include:

- asset_tags
- asset_categories

### app_settings

May include:

- key
- value
- updated_at

Do not overbuild.

---

## 10. Migration Guidance

MUST:

- track schema version
- apply migrations in order
- fail clearly on migration error
- avoid destructive migration
- keep user data safe

MUST NOT:

- drop user data
- rewrite user data silently
- hide migration failure
- pretend migration succeeded if it failed

For DA-002, migration can be simple.

The goal is to establish the pattern.

---

## 11. Data Safety

DizzyAsset database is app memory.

MUST NOT:

- delete original files
- delete asset records due to temporary file access failure
- implement destructive cleanup
- implement automatic duplicate deletion

Prefer recoverable state fields for future tasks.

---

## 12. Architecture Constraints

MUST:

- keep database access out of SwiftUI Views
- keep repositories or database services testable
- keep mapping explicit
- keep errors meaningful
- avoid hidden global mutable database state

MUST NOT:

- access SQLite directly from UI
- mix database setup with app UI shell
- add broad service container unless already present
- create speculative abstractions

---

## 13. Concurrency Notes

If database access is asynchronous:

- keep UI updates on MainActor
- serialize database writes
- avoid unsafe shared SQLite connection access
- do not block main thread with heavy queries
- report concurrency assumptions in handoff

If using a simpler synchronous setup for initial MVP:

- keep it behind repository or database boundary
- do not call heavy database work from UI loops
- leave room for safe async evolution

---

## 14. XcodeGen Rules

If adding, deleting, or moving source files:

1. update `project.yml` if required
2. run `xcodegen generate`
3. run CLI build if possible

Do not edit `.xcodeproj` manually.

If XcodeGen fails, stop and report.

---

## 15. Verification

Minimum Verification is required.

Run when possible:

- `xcodegen generate` if files were added/deleted/moved or project.yml changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Database-focused verification should include at least:

- database opens or initializes
- schema/migration runs
- basic insert/fetch works for one core table or repository
- migration tracking exists or schema version is verifiable
- failure path is not silently ignored

If tests exist, add or run focused tests.

If tests do not exist, perform a focused manual or lightweight verification and report limits.

Report commands actually run.

Do not claim build/test passed unless commands were run and passed.

---

## 16. Visual Evidence

This task may not require UI visual evidence.

If UI is changed, provide visual evidence.

Store under:

- `artifacts/YYYY-MM-DD/DA-002/`

If no UI changed, state that visual evidence is not applicable.

---

## 17. Knowledge Capture

Create a knowledge note only if reusable knowledge is discovered.

Possible topics:

- SQLite package behavior
- migration issue
- XcodeGen target membership issue
- Swift concurrency issue around database access
- build setting issue

Use:

- `docs/knowledge/YYYY-MM-DD-short-topic.md`

Do not log every small mistake.

---

## 18. Stop Conditions

Stop and report if:

- database library or SQLite integration is unclear
- schema impact becomes broader than DA-002
- migration may delete or rewrite user data
- asset identity semantics are unclear
- project target membership is unclear
- XcodeGen fails
- build fails
- protected area change appears necessary
- task scope expands into import/search/preview

Do not continue with destructive guesses.

---

## 19. Handoff Requirements

Use:

- `docs/templates/handoff.md`

Handoff MUST include:

- Task ID: DA-002
- Risk level: Medium
- files changed
- database files created/changed
- schema tables added
- migration mechanism status
- repository boundary status
- XcodeGen run:
  - yes/no
- build run:
  - yes/no
- database verification run:
  - yes/no
- tests run:
  - yes/no
- visual evidence:
  - not applicable or path
- skipped checks and why
- known risks
- next suggested task

Do not declare final acceptance.

Instruction owner decides acceptance.

---

## 20. Expected Completion Criteria

DA-002 is complete when:

- the app has an initial local database layer
- the schema can be initialized safely
- migration/version tracking exists or is clearly prepared
- at least one repository or database boundary exists
- at least one focused persistence verification is performed or explicitly not possible with reason
- the implementation does not include out-of-scope features
- handoff is produced

---

## 21. Suggested Next Task

After DA-002, the likely next task is:

- DA-003 Storage / Workspace Setup

Do not start DA-003 in this task.

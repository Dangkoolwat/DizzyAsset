# DA-002 Database Layer Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- `docs/task/DA-002-database-layer.md`
- `docs/agent-log/2026-05-07-DA-002-database-layer.md`
- changed files in commit `a0d5a4d`
- `docs/workflows/verification-review.md`

## Scope Check

- The implementation is mostly aligned with DA-002 scope:
  - SQLite database initialization
  - schema creation
  - schema version tracking
  - repository boundary
- The change stays within the persistence layer and does not spill into search, preview, Quick Peek, or FCP integration.
- However, the implementation does not satisfy the task’s “safe error reporting for database open/init failure” requirement.

## Protected Areas

- Protected areas touched:
  - no
- No entitlements, signing, CI/CD, or release packaging files were changed.

## Verification Evidence

- Commands actually run:
  - `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`
- Result:
  - `BUILD SUCCEEDED`
- What was verified:
  - the app still builds after the database layer changes
- What was not verified:
  - runtime database initialization behavior
  - CRUD correctness with real data
  - migration replay across version changes
  - foreign-key enforcement behavior

## Visual Evidence

- UI changed:
  - no
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- Unit tests:
  - no test suite was added or run
- Runtime DB checks:
  - skipped because the evidence only covers build success
- Migration upgrade path:
  - skipped because there is only a single schema version in the current implementation

## Risks

- The database opens successfully only because the build passes; that does not prove the schema behaves correctly at runtime.
- The implementation uses raw SQL string interpolation for inserts, which is unsafe for user-controlled text.
- Foreign-key constraints are declared in the schema but are not enabled in the connector, so cascade/relationship behavior may not work.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Data/Repositories/AssetRepository.swift:12-18`
  - impact: `filename` is interpolated directly into SQL, which breaks on quotes and creates SQL injection risk; the timestamp is also injected as a quoted numeric string instead of a bound parameter.
- Finding 2:
  - severity: high
  - evidence: `DizzyAsset/Data/Persistence/SQLite3/SQLiteConnector.swift:14-20` and `DizzyAsset/Data/Persistence/Schema.swift:24-70`
  - impact: foreign keys are declared but SQLite foreign-key enforcement is never enabled, so `ON DELETE CASCADE` and `ON DELETE SET NULL` rules are not guaranteed to run.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Data/Persistence/DatabaseManager.swift:17-23`
  - impact: database initialization failures call `fatalError`, which crashes the app instead of reporting the failure safely as requested by the task prompt.

## Follow-up Needed

- Replace raw SQL interpolation in `AssetRepository` with bound parameters.
- Enable SQLite foreign keys immediately after opening the connection.
- Replace the `fatalError` path with a recoverable initialization error path or user-visible failure reporting.

## Minimal Changes Needed For Accept

- Replace every user-controlled SQL string interpolation with bound parameters or a safe repository helper.
- Enable `PRAGMA foreign_keys = ON` on the opened SQLite connection before relying on relational delete behavior.
- Replace `fatalError` in database initialization with explicit error propagation or a user-visible failure path.

## Notes

- This report does not declare final acceptance.
- Instruction owner decides the final outcome.

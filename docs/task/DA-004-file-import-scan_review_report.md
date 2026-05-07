# DA-004 File Import & Scan Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- `docs/task/DA-004-file-import-scan.md`
- `docs/agent-log/2026-05-07-DA-004-file-import-scan.md`
- changed files in commit `a620ad6`
- `build_log_clean.txt`
- current `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

## Scope Check

- The implementation matches the task goal at a high level:
  - recursive folder scan
  - supported media extension filtering
  - candidate modeling
  - sandbox access wrapper
- The change stays within import/scan and does not drift into duplicate detection, metadata extraction, search, preview, or Final Cut Pro integration.
- The current implementation does not yet satisfy the task's failure-collection requirement for per-file scan errors.

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
  - the app still builds after the import scanner changes
  - the agent log reports async scanning and bookmark wrapper behavior
- What was not verified:
  - recursive scan behavior on permission-denied folders
  - large-folder performance
  - per-file failure reporting
  - bookmark persistence behavior with real bookmark blobs

## Visual Evidence

- UI changed:
  - no
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- Large-folder stress test:
  - skipped
- Permission-denied folder test:
  - skipped
- Bookmark persistence test:
  - skipped

## Risks

- The scan loop throws out on the first unreadable file, so one bad path can abort the entire import scan instead of being recorded as a failure.
- `bookmarkData` is accepted by `AssetRepository.saveImportCandidate` but not persisted, so later recovery from sandboxed paths is incomplete.
- The repository still uses raw SQL string interpolation for import persistence, which is fragile for path and filename data.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Domain/Import/AssetImportService.swift:30-35` and `DizzyAsset/Domain/Import/AssetImportService.swift:42-64`
  - impact: a single unreadable file throws out of `process(url:)` and can abort the whole scan, so per-file failure collection is not implemented.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Data/Repositories/AssetRepository.swift:6-29`
  - impact: the `bookmarkData` parameter is ignored, so the scan pipeline cannot persist the bookmark state that the sandbox flow depends on.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Data/Repositories/AssetRepository.swift:11-24` and `DizzyAsset/Data/Repositories/AssetRepository.swift:35-38`
  - impact: import persistence still uses manual SQL string construction, which is brittle and increases escaping risk for user-supplied paths.

## Follow-up Needed

- Catch per-file scan errors inside the enumeration loop, increment `errorCount`, and keep scanning.
- Persist bookmark data when available so the import pipeline can support later sandbox recovery.
- Replace import SQL string interpolation with bound parameters now that the connector supports them.

## Minimal Changes Needed For Accept

- Wrap each `process(url:)` call in a `do/catch` and record the failure in `ImportScanResult` instead of aborting the full scan.
- Store `bookmarkData` alongside the asset location record or explicitly report that bookmark persistence is deferred.
- Switch import persistence calls to parameterized SQL so path and filename values are not interpolated manually.

## Notes

- This report does not declare final acceptance.
- Instruction owner decides the final outcome.

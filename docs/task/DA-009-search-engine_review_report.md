# DA-009 Search Engine Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-009-search-engine.md`
- agent log: `docs/agent-log/2026-05-07-DA-009-search-engine.md`
- changed files: `DizzyAsset/Domain/Search/SearchService.swift`, `DizzyAsset/Domain/Search/SearchIndexService.swift`, `DizzyAsset/Presentation/AssetList/AssetListViewModel.swift`, `DizzyAsset/Presentation/QuickPeek/QuickPeekViewModel.swift`
- visual artifacts: not applicable

## Scope Check

- What was in scope:
  - simple filename/tag/category search
  - deterministic ordering
  - empty/no-result behavior
- What was out of scope:
  - advanced ranking
  - FTS5 migration
  - AI search
  - Quick Peek search
- Any scope drift:
  - `SearchService` already includes bm25 weighting, recency bonus, and duplicate penalty logic, which belongs to the later ranking task rather than this foundation task.

## Protected Areas

- Protected areas touched:
  - no
- If not touched, state that explicitly:
  - no entitlements, signing, CI/CD, or release files were changed.

## Verification Evidence

- Commands or checks actually run:
  - `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug -destination 'platform=macOS' -derivedDataPath /private/tmp/DizzyAssetDerivedData build`
- Results:
  - build failed in this environment
  - failure surfaced at `MainWindowView.swift:20` `#Preview` and later during `sandbox_apply`
- What was verified:
  - search query plumbing is wired through `SearchService`
  - `SearchIndexService` can rebuild and query the search table
- What was not verified:
  - successful clean build
  - actual search latency under use
  - search correctness against live data

## Visual Evidence

- UI changed:
  - no direct search UI redesign, but the list and quick peek now depend on search behavior
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- FTS5 migration test:
  - skipped
- ranking verification against exact filename:
  - skipped
- latency measurement:
  - skipped

## Risks

- The search implementation is more complex than the task asked for, so later ranking work may need to untangle current behavior.
- Local file paths are converted with `URL(string:)`, which is not safe for file system paths and can break result handoff.
- Raw SQL interpolation remains in the search/index path, so query safety and escaping are still a concern.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Domain/Search/SearchService.swift:13-35`
  - impact: advanced ranking and duplicate penalties are already implemented in the base search service, which exceeds DA-009 scope and mixes in DA-024 behavior.
- Finding 2:
  - severity: high
  - evidence: `DizzyAsset/Domain/Search/SearchService.swift:53-60`
  - impact: `URL(string:)` is used for local file paths, so returned `fileURL` values can fail to resolve or behave incorrectly for non-URL file system paths.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Search/SearchIndexService.swift:43-53`
  - impact: index updates still use hand-built SQL strings, so the search architecture remains fragile and not yet aligned with the safer repository style already used elsewhere in the project.

## Follow-up Needed

- Reduce `SearchService` to the simple filename/tag/category foundation that DA-009 asks for.
- Replace local-path URL construction with file URL creation or direct path storage.
- Move index writes to parameterized queries.

## Minimal Changes Needed For Accept

- Strip the advanced ranking signals out of DA-009 and keep the service to deterministic filtering/order only.
  - why: the current implementation conflates DA-009 with later ranking work.
- Switch local file path handling from `URL(string:)` to a file-path-safe representation.
  - why: search results need valid URLs for preview, drag, and detail handoff.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

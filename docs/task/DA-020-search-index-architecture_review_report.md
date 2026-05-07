# DA-020 Search Index Architecture Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-020-search-index-architecture.md`
- agent log: `docs/agent-log/2026-05-07-DA-020-search-index-architecture.md`
- changed files: `DizzyAsset/Domain/Search/SearchIndexService.swift`, `DizzyAsset/Domain/Search/SearchService.swift`
- visual artifacts: not applicable

## Scope Check

- What was in scope:
  - normalized search token model
  - alias dictionary structure
  - index table design
  - migration path
  - rebuild stub
- What was out of scope:
  - full semantic search
  - AI search
  - broad UI redesign
- Any scope drift:
  - the current code already implements the live search path, but the architecture-prep task itself is still only partially represented.

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
  - failure surfaced at `MainWindowView.swift:20` `#Preview` and later with `sandbox_apply`
- What was verified:
  - index rebuild service exists
  - search ranking signals are already being used in the live search layer
- What was not verified:
  - alias structure
  - latency measurement
  - FTS5 migration path

## Visual Evidence

- UI changed:
  - no direct UI change for this architecture task
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- latency measurement:
  - skipped
- alias behavior test:
  - skipped
- FTS5 migration proof:
  - skipped

## Risks

- The architecture prep is incomplete: there is no explicit alias model or normalized token store yet.
- `SearchIndexService` still uses interpolated SQL, which makes index updates fragile.
- The live search layer already includes advanced ranking, which makes future separation harder if the architecture remains unstructured.

## Findings

- Finding 1:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Search/SearchIndexService.swift:43-53`
  - impact: index row writes still use string interpolation, so the search index architecture is not yet using the safer query boundary expected elsewhere.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Search/SearchService.swift:13-35`
  - impact: the live search layer has already absorbed advanced ranking logic, so the architecture-prep task does not have a clean separation between foundation and optimization concerns.

## Follow-up Needed

- Add an explicit token/alias model or document that the task is architecture-only and not yet implemented.
- Parameterize index writes.
- Separate DA-020 architecture prep from DA-024 ranking logic.

## Minimal Changes Needed For Accept

- Introduce a concrete normalized token or alias structure.
  - why: the task is about preparing the architecture, not just the live query.
- Move index updates to bound parameters.
  - why: the search index path should use safe persistence primitives.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

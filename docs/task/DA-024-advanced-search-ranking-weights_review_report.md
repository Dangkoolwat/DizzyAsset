# DA-024 Advanced Search Ranking & Weights Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-024-advanced-search-ranking-weights.md`
- agent log: not present
- changed files: `DizzyAsset/Domain/Search/SearchService.swift`, `DizzyAsset/Domain/Search/SearchIndexService.swift`, `DizzyAsset/Presentation/AssetList/AssetListViewModel.swift`, `DizzyAsset/Presentation/QuickPeek/QuickPeekViewModel.swift`
- visual artifacts: not applicable

## Scope Check

- What was in scope:
  - custom relevance scoring
  - exact, prefix, tag, category, recency, and duplicate weighting
  - sorted search results
- What was out of scope:
  - semantic search
  - UI redesign
  - real-time content indexing
- Any scope drift:
  - the implementation already includes a strong custom ranking query, but the requested prefix-match weight is not explicitly represented as its own signal.

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
  - the search layer now has a custom scoring query
  - `AssetListViewModel` and `QuickPeekViewModel` consume search results
- What was not verified:
  - ranking behavior on live data
  - exact vs prefix ordering proof
  - latency target under 100 ms

## Visual Evidence

- UI changed:
  - not directly for the ranking layer
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- exact filename ranking check:
  - skipped
- prefix-match ranking check:
  - skipped
- latency measurement:
  - skipped

## Risks

- The ranking query is tightly coupled to raw SQL, so later ranking tuning will continue to be fragile if the query shape grows further.
- The service returns `URL(string:)` for local paths, which can break the downstream preview and detail handoff.
- Prefix-match behavior is implicit through FTS query syntax, but the task asked for an explicit prefix weight.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Domain/Search/SearchService.swift:21-35`
  - impact: the task asks for a prefix-match weight, but the ranking query only exposes exact, recency, and duplicate-related signals explicitly.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Search/SearchService.swift:53-60`
  - impact: local file paths are converted with `URL(string:)`, which is unreliable for file-system paths and can break downstream consumers of search results.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Search/SearchIndexService.swift:43-53`
  - impact: search index updates still use interpolated SQL strings, which makes the ranking path brittle for future tuning and query safety.

## Follow-up Needed

- Add an explicit prefix-match score path or document the implicit FTS behavior as the prefix weight source.
- Convert local paths to file URLs safely.
- Parameterize search index writes.

## Minimal Changes Needed For Accept

- Add a distinct prefix-match signal in the ranking query.
  - why: the task explicitly asks for prefix weighting, not only FTS wildcard behavior.
- Switch search result file handling to file URLs.
  - why: search output feeds preview and detail panes that expect valid local URLs.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

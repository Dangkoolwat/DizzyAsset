# DA-014 Right Panel Asset Information Hub Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-014-right-panel-asset-information-hub.md`
- agent log: `docs/agent-log/2026-05-07-DA-014-right-panel-asset-information-hub.md`
- changed files: `DizzyAsset/Presentation/Views/AssetDetailView.swift`, `DizzyAsset/Presentation/AssetDetail/AssetInformationHubViewModel.swift`, `DizzyAsset/Presentation/AssetDetail/BatchEditViewModel.swift`
- visual artifacts: not produced

## Scope Check

- What was in scope:
  - right panel foundation
  - selected asset detail display
  - empty state
  - tags/categories/duplicate/storage/preview state display if available
- What was out of scope:
  - full preview engine
  - batch cleanup
  - AI analysis execution
  - Final Cut Pro drag
- Any scope drift:
  - the hub mixes in silence, derivation, AI suggestion, and recovery concerns, which is acceptable only if those data sources are actually complete.

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
  - the right panel renders sections for preview, metadata, tags, categories, silence, derivation, and AI suggestions
  - selection changes drive the hub view model
- What was not verified:
  - runtime correctness of each section
  - visual evidence

## Visual Evidence

- UI changed:
  - yes
- Artifact path:
  - not produced
- Screenshot or recording:
  - not produced
- If missing, why:
  - no artifact capture was present in the workspace

## Skipped Checks

- panel screenshot capture:
  - skipped
- selection-change smoke test:
  - skipped
- missing/offline state visual verification:
  - skipped

## Risks

- The duplicate indicator is hardcoded to `false`, so the UI can show a stable-looking but incorrect status.
- Technical metadata fetch still uses raw SQL string interpolation, which is fragile for the hub's data path.
- `analyzeAsset` turns a stored path into `URL(string:)`, which is unsafe for local file paths.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Presentation/AssetDetail/AssetInformationHubViewModel.swift:128-131`
  - impact: the duplicate status section is a placeholder that always reports `false`, so the panel can display a misleadingly complete but incorrect status.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Presentation/AssetDetail/AssetInformationHubViewModel.swift:90-108`
  - impact: technical metadata is loaded with interpolated SQL, which is brittle and inconsistent with the safer parameterized repository path already available elsewhere in the project.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Presentation/AssetDetail/AssetInformationHubViewModel.swift:45-50`
  - impact: the analysis trigger converts a stored path to `URL(string:)`, so AI analysis may receive an invalid file URL for normal file-system paths.

## Follow-up Needed

- Replace the duplicate placeholder with a real status query or hide the section until the data is available.
- Move technical metadata lookup to a parameterized repository call.
- Convert analysis path handling to a file URL-safe form.

## Minimal Changes Needed For Accept

- Remove the hardcoded duplicate placeholder or replace it with a real query.
  - why: the hub should not present fake status as if it were real data.
- Fix local path handling for analysis and metadata lookups.
  - why: the right panel depends on accurate local file resolution.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

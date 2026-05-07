# DA-027 AI Analysis Infrastructure Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-027-ai-analysis-infrastructure.md`
- agent log: not present
- changed files: `DizzyAsset/Domain/Analysis/AIAnalysisService.swift`, `DizzyAsset/Domain/Analysis/AIProvider.swift`, `DizzyAsset/Domain/Analysis/Providers/LocalMetadataProvider.swift`, `DizzyAsset/Data/Repositories/AIRepository.swift`, `DizzyAsset/Presentation/AssetDetail/AssetInformationHubViewModel.swift`, `DizzyAsset/Presentation/Views/AssetDetailView.swift`
- visual artifacts: not produced

## Scope Check

- What was in scope:
  - analysis result schema
  - provider protocol
  - local filename/metadata provider
  - repository persistence
  - suggested tags in the detail panel
- What was out of scope:
  - cloud AI integration
  - automatic batch analysis on import
  - transcription/scene detection
- Any scope drift:
  - the infrastructure is mostly present, but the local provider still only parses filenames and does not yet use technical metadata the way the task describes.

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
  - the provider protocol, repository, and analysis service exist
  - suggested tags are displayed and accept/reject actions are wired in the detail panel
- What was not verified:
  - provider output against sample files
  - acceptance flow with real assets
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

- filename extraction scratch test:
  - skipped
- metadata extraction test:
  - skipped
- suggested-tags UI capture:
  - skipped

## Risks

- `LocalMetadataProvider` does not yet extract technical metadata like 4K/60fps, so the "filename and metadata" foundation is incomplete.
- `AssetInformationHubViewModel.analyzeAsset` still turns a stored path into `URL(string:)`, which is unsafe for local file paths.
- Technical metadata lookup in the hub still uses interpolated SQL, which is fragile and inconsistent with the repository boundary used elsewhere.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Domain/Analysis/Providers/LocalMetadataProvider.swift:11-38`
  - impact: the local provider only tokenizes filenames and extensions; it does not yet satisfy the task's filename-plus-technical-metadata analysis goal.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Presentation/AssetDetail/AssetInformationHubViewModel.swift:45-50`
  - impact: analysis uses `URL(string:)` for local paths, which can invalidate file access for normal on-disk assets.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Presentation/AssetDetail/AssetInformationHubViewModel.swift:90-108`
  - impact: technical metadata is fetched via interpolated SQL inside the view model, which is a fragile persistence path for an infrastructure feature.

## Follow-up Needed

- Extend the local provider to use technical metadata, not just filename tokens.
- Convert analysis path handling to file URLs.
- Move technical metadata reads behind a repository boundary.

## Minimal Changes Needed For Accept

- Teach `LocalMetadataProvider` to incorporate actual technical metadata signals.
  - why: the task explicitly asks for filename plus metadata analysis.
- Fix local path URL creation in the hub's analysis flow.
  - why: analysis cannot be reliable if file paths are malformed.
- Move metadata SQL into a repository call.
  - why: the UI layer should not own raw persistence queries.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

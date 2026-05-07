# DA-008 Asset List UI Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-008-asset-list-ui.md`
- agent log: `docs/agent-log/2026-05-07-DA-008-asset-list-ui.md`
- changed files: `DizzyAsset/Presentation/Views/MainWindowView.swift`, `DizzyAsset/Presentation/AssetList/AssetListView.swift`, `DizzyAsset/Presentation/AssetList/AssetListViewModel.swift`, `DizzyAsset/Presentation/AssetList/AssetRowView.swift`
- visual artifacts: not produced

## Scope Check

- What was in scope:
  - central asset list view
  - row layout
  - empty state
  - basic selection
  - lightweight connection to data source if available
- What was out of scope:
  - full search engine
  - preview playback
  - drag tagging
  - category editing
  - Quick Peek
  - AI suggestions
- Any scope drift:
  - the asset list implementation already depends on `SearchService` and `.searchable`, which belongs to DA-009 rather than the DA-008 foundation task.

## Protected Areas

- Protected areas touched:
  - no
- If touched, why:
  - not applicable
- If not touched, state that explicitly:
  - no entitlements, signing, CI/CD, or release files were changed.

## Verification Evidence

- Commands or checks actually run:
  - `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug -destination 'platform=macOS' -derivedDataPath /private/tmp/DizzyAssetDerivedData build`
- Results:
  - build failed in this environment
  - failure surfaced in `MainWindowView.swift:20` at the `#Preview` macro and later with `sandbox_apply: Operation not permitted`
- What was verified:
  - the current code path reaches the asset list UI, row rendering, and binding structure
  - the list uses `AssetDisplayModel` rows and selection state as implemented
- What was not verified:
  - successful clean build in this environment
  - runtime UI behavior
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

- Screenshot capture:
  - skipped
- Selection/hover manual UI pass:
  - skipped
- Search integration smoke test:
  - skipped because search is out of scope for DA-008

## Risks

- The asset list is already coupled to search behavior, so the foundation is no longer isolated and later search changes will have to unwind this dependency.
- The empty-state copy mentions importing, but there is no import UI in this task scope, so the call to action is slightly misleading.
- Because no visual artifact exists, the UI shape cannot be independently reviewed.

## Findings

- Finding 1:
  - severity: medium
  - evidence: `DizzyAsset/Presentation/AssetList/AssetListView.swift:43-46` and `DizzyAsset/Presentation/AssetList/AssetListViewModel.swift:16-27`
  - impact: DA-008 now depends on `SearchService` and `.searchable`, which pulls later search behavior into a task that should have remained a simple asset list foundation.
- Finding 2:
  - severity: medium
  - evidence: no artifact under `artifacts/YYYY-MM-DD/DA-008/`
  - impact: the UI task cannot be reviewed visually, so layout, spacing, and interaction quality remain unverified.

## Follow-up Needed

- Remove search coupling from the DA-008 asset list foundation or explicitly reclassify the implementation as including DA-009 search behavior.
- Capture a UI artifact for the list empty state and populated state.

## Minimal Changes Needed For Accept

- Move search logic back behind the DA-009 boundary and keep DA-008 focused on list rendering, selection, and placeholder data.
  - why: the current implementation crosses task scope and makes the asset list depend on later search infrastructure.
- Produce at least one screenshot of the asset list empty state or a populated state.
  - why: this is a UI task and the visual design cannot be reviewed without evidence.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

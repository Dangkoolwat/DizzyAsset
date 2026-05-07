# DA-025 Batch Metadata Edit Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-025-batch-metadata-edit.md`
- agent log: not present
- changed files: `DizzyAsset/Presentation/Views/AssetDetailView.swift`, `DizzyAsset/Presentation/AssetDetail/BatchEditViewModel.swift`, `DizzyAsset/Domain/Tagging/TaggingService.swift`, `DizzyAsset/Data/Repositories/CategoryRepository.swift`
- visual artifacts: not produced

## Scope Check

- What was in scope:
  - multi-selection
  - batch tag add/remove
  - batch category set/clear
  - right-panel batch edit mode
  - immediate UI refresh
- What was out of scope:
  - file renaming
  - file deletion
  - technical metadata batch editing
  - undo/redo
- Any scope drift:
  - the UI side of multi-selection and batch mode is present, but the requested service boundary (`MetadataService`) is not implemented as such.

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
  - `AssetDetailView` switches between empty, single, and batch modes
  - batch add/remove category actions are wired in the view model
- What was not verified:
  - live UI refresh after batch actions
  - batch operation correctness on many assets
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

- batch add/remove manual test:
  - skipped
- 100+ item responsiveness test:
  - skipped
- screenshot capture:
  - skipped

## Risks

- There is no dedicated `MetadataService` boundary, so batch metadata behavior is split across UI and repository/service classes.
- The batch remove tag path currently uses `findOrCreateTag`, which can create tags while attempting to remove them.
- The UI comment acknowledges refresh is not wired, so selection and row state can drift after batch operations.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Presentation/AssetDetail/BatchEditViewModel.swift:17-19` and `DizzyAsset/Presentation/AssetDetail/BatchEditViewModel.swift:39-73`
  - impact: the requested `MetadataService` bulk-update boundary is missing; batch behavior is split across the view model, tagging service, and category repository.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Tagging/TaggingService.swift:52-64`
  - impact: batch tag removal can create the tag row before removing relations, which is the wrong behavior for a remove action.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Presentation/AssetDetail/BatchEditViewModel.swift:42-45`
  - impact: the implementation does not yet notify the rest of the UI to refresh after batch updates, so the new metadata may not appear immediately across selected rows.

## Follow-up Needed

- Introduce a dedicated metadata batch service boundary or clearly document the split implementation.
- Fix tag removal so it does not create missing tags.
- Wire a refresh path after batch updates so the list and detail panes stay in sync.

## Minimal Changes Needed For Accept

- Add a service boundary for bulk metadata updates or rename the current layer to match the actual design.
  - why: the task explicitly asks for `MetadataService` methods.
- Make tag removal use lookup-only tag resolution.
  - why: remove actions should never create database rows.
- Trigger a UI refresh after batch operations complete.
  - why: batch editing must reflect immediately on all affected rows.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

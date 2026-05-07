# DA-013 Drag Tagging Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-013-drag-tagging.md`
- agent log: `docs/agent-log/2026-05-07-DA-013-drag-tagging.md`
- changed files: `DizzyAsset/Presentation/AssetList/AssetRowView.swift`, `DizzyAsset/Presentation/Views/SidebarView.swift`, `DizzyAsset/Presentation/AssetDetail/BatchEditViewModel.swift`
- visual artifacts: not produced

## Scope Check

- What was in scope:
  - basic drag source
  - drop target for tag or category
  - assignment action on drop
  - safe rejection for invalid drop
- What was out of scope:
  - Final Cut Pro drag
  - file movement
  - complex multi-select drag
  - drag reorder UI
- Any scope drift:
  - the current code only implements a generic asset-row drag and a category drop in the sidebar, so the tag/category drag-tagging workflow is incomplete.

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
  - asset rows can start a drag payload
  - categories can accept a drop path in the sidebar
- What was not verified:
  - tag drop behavior
  - invalid drop rejection
  - duplicate assignment behavior
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

- drag onto tag target:
  - skipped because no tag drop target exists
- invalid drop rejection test:
  - skipped
- screenshot capture:
  - skipped

## Risks

- The drag payload is generic and does not encode a dedicated drag-tagging contract, so future tag/category targets will have to guess payload intent.
- Only category drop handling is visible; tag drag/tag drop is not wired at all.
- There is no explicit visual feedback for valid versus invalid drag targets.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Presentation/AssetList/AssetRowView.swift:74-81`
  - impact: the row only exposes a generic drag payload, so there is no dedicated asset-to-tag/category drag contract for the feature to build on.
- Finding 2:
  - severity: high
  - evidence: `DizzyAsset/Presentation/Views/SidebarView.swift:42-64`
  - impact: the only drop handler shown is category assignment, so drag tagging is only half implemented and the tag workflow requested by the task is still missing.
- Finding 3:
  - severity: medium
  - evidence: no artifact under `artifacts/YYYY-MM-DD/DA-013/`
  - impact: the drag/drop interaction cannot be reviewed visually, so valid/invalid drop affordances remain unverified.

## Follow-up Needed

- Add an explicit drag payload type and tag/category drop targets.
- Wire tag drop handling, not only category drop handling.
- Capture drag-state UI evidence.

## Minimal Changes Needed For Accept

- Introduce a dedicated payload for asset drag-and-drop and use it for both tag and category targets.
  - why: the feature needs a stable contract instead of a generic string payload.
- Add the missing tag drop target or explicitly narrow the task to category-only drag tagging.
  - why: the current implementation does not cover the requested tag flow.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

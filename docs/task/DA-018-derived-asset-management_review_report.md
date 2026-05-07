# DA-018 Derived Asset Management Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-018-derived-asset-management.md`
- agent log: `docs/agent-log/2026-05-07-DA-018-derived-asset-management.md`
- changed files: `DizzyAsset/Domain/Derivation/DerivedAssetService.swift`, `DizzyAsset/Domain/Workspace/WorkspaceLifecycleManager.swift`, `DizzyAsset/Presentation/Views/AssetDetailView.swift`
- visual artifacts: not applicable

## Scope Check

- What was in scope:
  - derived asset model
  - source-to-derived relation
  - derived type enum
  - orphan/missing-source status
  - workspace path association
- What was out of scope:
  - actual trimming
  - conversion
  - export workflow
  - workspace cleanup
- Any scope drift:
  - the implementation stays at the relation/model layer, which is fine for foundation, but persistence safety is still weak.

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
  - derived relation types and statuses exist
  - the workspace lifecycle code can read derived relations
- What was not verified:
  - end-to-end creation of derived files
  - orphan recovery behavior in a live workspace

## Visual Evidence

- UI changed:
  - no direct derived-asset UI was added
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- derived asset creation test:
  - skipped
- orphan state UI test:
  - skipped
- visual artifact capture:
  - skipped

## Risks

- Derived relations are stored with raw SQL interpolation, so the persistence layer is not yet robust.
- The current code represents derived assets, but it does not yet prove a safe generation or cleanup lifecycle.
- Workspace orphan handling references derived assets, but the source-side recovery path is still incomplete elsewhere.

## Findings

- Finding 1:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Derivation/DerivedAssetService.swift:37-46`
  - impact: derived relation persistence still uses interpolated SQL, which is fragile and inconsistent with parameterized writes already present in parts of the project.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Workspace/WorkspaceLifecycleManager.swift:92-109`
  - impact: orphan handling only updates workspace items after a join, but the broader derived-asset lifecycle is still not exercised end to end.

## Follow-up Needed

- Parameterize derived asset writes.
- Add an end-to-end derived asset lifecycle verification path.

## Minimal Changes Needed For Accept

- Move derived asset insertion to bound parameters.
  - why: workspace-linked paths and derivation data should not be string-concatenated into SQL.
- Add a concrete creation or recovery test path for one derived asset type.
  - why: the model should be proven, not just declared.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

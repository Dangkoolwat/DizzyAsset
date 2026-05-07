# DA-022 Workspace Lifecycle Manager Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-022-workspace-lifecycle-manager.md`
- agent log: `docs/agent-log/2026-05-07-DA-022-workspace-lifecycle-manager.md`
- changed files: `DizzyAsset/Domain/Workspace/WorkspaceLifecycleManager.swift`, `DizzyAsset/Domain/Services/WorkspaceManager.swift`, `DizzyAsset/Presentation/Settings/SettingsView.swift`
- visual artifacts: not applicable

## Scope Check

- What was in scope:
  - workspace item classification
  - workspace item status model
  - safe cleanup report
  - orphan representation
  - conservative cleanup rules
- What was out of scope:
  - aggressive cleanup
  - deleting original files
  - migration UI
  - release/signing/notarization
- Any scope drift:
  - the implementation stays conservative, but it only covers temp files in the cleanup report and leaves the rest of the lifecycle classification mostly unexercised.

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
  - workspace item types and statuses exist
  - cleanup report generation scans the temp tree
- What was not verified:
  - classification of preview cache, analysis output, export output, and unknown paths
  - actual cleanup report visual or runtime output

## Visual Evidence

- UI changed:
  - no direct UI change
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- cleanup report preview:
  - skipped
- non-temp item classification test:
  - skipped
- visual artifact capture:
  - skipped

## Risks

- `classifyItem` uses substring matching with `contains`, which can misclassify unrelated paths.
- `generateCleanupReport` only scans the temp directory, so the lifecycle manager is not yet exercising the rest of the item types the task calls out.
- `registerItem` and `saveWorkspaceRoot` still rely on interpolated SQL, which keeps the workspace layer brittle.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Domain/Workspace/WorkspaceLifecycleManager.swift:38-48` and `DizzyAsset/Domain/Workspace/WorkspaceLifecycleManager.swift:51-75`
  - impact: the classifier uses `contains`, and the cleanup report only scans temp files, so the lifecycle manager does not yet implement the broader classification and cleanup model requested by the task.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Workspace/WorkspaceLifecycleManager.swift:77-89` and `DizzyAsset/Domain/Services/WorkspaceManager.swift:72-77`
  - impact: workspace metadata is still persisted with interpolated SQL, which is fragile for paths.

## Follow-up Needed

- Make classification path-safe instead of substring-based.
- Expand the dry-run report beyond temp files.
- Parameterize workspace metadata writes.

## Minimal Changes Needed For Accept

- Replace `contains` classification with path-bound matching.
  - why: substring checks can misclassify unrelated folders.
- Include the other declared workspace item categories in the dry-run report or explicitly label the implementation as temp-only.
  - why: the task asks for a broader lifecycle manager than temp cleanup alone.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

# DA-010 Preview Engine Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-010-preview-engine.md`
- agent log: `docs/agent-log/2026-05-07-DA-010-preview-engine.md`
- changed files: `DizzyAsset/Presentation/Preview/PreviewViewModel.swift`, `DizzyAsset/Infrastructure/Media/PreviewService.swift`, `DizzyAsset/Presentation/Views/AssetDetailView.swift`, `DizzyAsset/Presentation/QuickPeek/Views/QuickPeekView.swift`
- visual artifacts: not produced

## Scope Check

- What was in scope:
  - minimal preview service
  - selection-to-preview handoff
  - missing/permission state handling
  - stale playback prevention
- What was out of scope:
  - waveform generation
  - trimming
  - Quick Peek as a separate feature
  - Final Cut Pro drag
- Any scope drift:
  - the preview layer is already being consumed by Quick Peek, so preview and Quick Peek behaviors are now entangled earlier than the task boundaries suggest.

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
  - preview loading is wired through `PreviewViewModel`
  - `PreviewService` has explicit loading/ready/failed states
- What was not verified:
  - successful build
  - playback behavior on real assets
  - Space-key toggle in the running app
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

- audio preview playback test:
  - skipped
- missing file test:
  - skipped
- permission denied test:
  - skipped

## Risks

- `PreviewViewModel` converts stored file paths with `URL(string:)`, which is unreliable for local paths and can break preview resolution.
- Bookmark-based access is consumed here, but the import path still does not persist bookmark data end-to-end, so the preview recovery path is incomplete.
- `PreviewService` uses a generic failed state, so unsupported format, permission denied, and missing file states can be hard to distinguish in the UI.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Presentation/Preview/PreviewViewModel.swift:22-24`
  - impact: local file paths are parsed with `URL(string:)`, so preview resolution can fail or behave unpredictably for normal file-system paths.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Presentation/Preview/PreviewViewModel.swift:28-41` and `DizzyAsset/Data/Repositories/AssetRepository.swift:15-37`
  - impact: preview recovery depends on bookmark data, but the import/persistence path still does not reliably store it, so the sandbox recovery path cannot be completed.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Infrastructure/Media/PreviewService.swift:23-83`
  - impact: the service state machine exists, but unsupported/missing/permission-specific failures are still collapsed into generic handling, which reduces diagnostic clarity.

## Follow-up Needed

- Replace local path parsing with file URL construction or stored URL objects.
- Finish bookmark persistence in the import layer so preview can actually restore sandbox access.
- Split preview failure states more explicitly if the UI is meant to explain access problems.

## Minimal Changes Needed For Accept

- Change preview path handling to use file URLs rather than `URL(string:)`.
  - why: preview must resolve local files reliably.
- Persist bookmark data in the import path before relying on preview recovery.
  - why: the preview engine cannot recover access without bookmark storage.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

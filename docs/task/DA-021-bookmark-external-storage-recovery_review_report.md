# DA-021 Bookmark & External Storage Recovery Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-021-bookmark-external-storage-recovery.md`
- agent log: `docs/agent-log/2026-05-07-DA-021-bookmark-external-storage-recovery.md`
- changed files: `DizzyAsset/Infrastructure/FileSystem/BookmarkManager.swift`, `DizzyAsset/Domain/FileSystem/AssetLocationRecoveryService.swift`, `DizzyAsset/Domain/Import/AssetImportService.swift`, `DizzyAsset/Data/Repositories/AssetRepository.swift`
- visual artifacts: not applicable

## Scope Check

- What was in scope:
  - bookmark storage
  - bookmark resolve flow
  - stale bookmark detection/refresh
  - offline/missing/permission states
  - startup or retry recovery hook
- What was out of scope:
  - full reconnect wizard
  - mass relink UI
  - destructive cleanup
  - entitlement changes
- Any scope drift:
  - the recovery helpers exist, but the import path still does not persist bookmark data end to end, so the core recovery chain is broken.

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
  - bookmark resolution returns explicit states
  - asset location recovery can map offline/missing/permission states
- What was not verified:
  - bookmark persistence at import time
  - stale bookmark refresh write-back
  - reconnect flow in the running app

## Visual Evidence

- UI changed:
  - not directly
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- import-time bookmark persistence test:
  - skipped
- stale bookmark refresh test:
  - skipped
- reconnect UI test:
  - skipped

## Risks

- `AssetRepository.saveImportCandidate` still leaves `bookmarkData` as a TODO, so the recovery path cannot work for new imports.
- `recoverAsset` updates status, but it does not refresh stale bookmark blobs back into storage.
- File-system path handling in preview and analysis layers still depends on correct bookmark persistence, so this task is coupled to later issues.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Data/Repositories/AssetRepository.swift:15-37`
  - impact: the import pipeline still does not persist bookmark data, so recovery cannot work end to end.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/FileSystem/AssetLocationRecoveryService.swift:17-42`
  - impact: the recovery flow updates status but does not refresh and store stale bookmarks, so reconnect behavior remains incomplete.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Infrastructure/FileSystem/BookmarkManager.swift:28-52`
  - impact: the bookmark resolver correctly classifies offline/missing/permission states, but the caller path is not yet completing the full recovery lifecycle.

## Follow-up Needed

- Finish bookmark persistence in import.
- Refresh stale bookmarks back into storage when recovery succeeds.
- Add a reconnect or retry verification path.

## Minimal Changes Needed For Accept

- Persist bookmark data during import.
  - why: without bookmark storage, external-storage recovery cannot start.
- Write refreshed bookmark data back when a stale bookmark resolves.
  - why: recovery should repair the stored access state, not just report it.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

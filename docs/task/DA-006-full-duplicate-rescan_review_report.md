# DA-006 Full Duplicate Rescan Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- `docs/task/DA-006-full-duplicate-rescan.md`
- `docs/agent-log/2026-05-07-DA-006-full-duplicate-rescan.md`
- changed files in commit `3ed9ea0`
- `build_log_clean.txt`
- current `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

## Scope Check

- The implementation stays in the duplicate rescan area and reuses the detection foundation.
- The code does not expand into duplicate deletion, merge UI, or other protected work.
- The current implementation does not actually rescan and compare files beyond size grouping, so the main task goal is only partially met.

## Protected Areas

- Protected areas touched:
  - no
- No entitlements, signing, CI/CD, or release packaging files were changed.

## Verification Evidence

- Commands actually run:
  - `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`
- Result:
  - `BUILD SUCCEEDED`
- What was verified:
  - the app still builds after the rescan scaffolding changes
  - the agent log reports session tracking and cancellation checks
- What was not verified:
  - real duplicate discovery on sample libraries
  - offline asset handling
  - persisted duplicate groups from actual matches

## Visual Evidence

- UI changed:
  - no
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- Real-file duplicate fixture scan:
  - skipped
- Offline asset handling:
  - skipped
- Cancellation proof with a live scan:
  - skipped

## Risks

- `DuplicateRescanService.performFullRescan()` never fetches file URLs or compares hashes, so it only counts size groups and cannot report real duplicates.
- `duplicateGroupsFound` is incremented as a placeholder, which makes the saved scan summary misleading.
- The `unavailableAssets` field is never populated, so missing/offline files are not represented even though the task asks for them.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Domain/Duplicates/DuplicateRescanService.swift:21-47`
  - impact: the rescan does not fetch URLs or compare hashes, so it does not actually identify duplicate groups.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Duplicates/DuplicateRescanService.swift:34-44`
  - impact: `duplicateGroupsFound` is a placeholder count based only on size grouping, so the persisted summary is not trustworthy.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Duplicates/DuplicateRescanService.swift:3-9` and `DizzyAsset/Domain/Duplicates/DuplicateRescanService.swift:16-50`
  - impact: the progress model includes unavailable assets, but the service never updates that field, so offline or missing items are not reflected.

## Follow-up Needed

- Fetch asset URLs from the repository and compare partial hashes for each candidate group.
- Replace the placeholder duplicate count with actual discovered groups.
- Populate unavailable asset counts when file access fails or paths are offline.

## Minimal Changes Needed For Accept

- Add real file comparison in the size-group loop, using the staged hash helper instead of placeholder counting.
- Save a summary that reflects the actual duplicate groups found, not a synthetic count.
- Track missing or offline assets in `DuplicateScanProgress.unavailableAssets` and surface them in the session result.

## Notes

- This report does not declare final acceptance.
- Instruction owner decides the final outcome.

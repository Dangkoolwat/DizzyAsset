# DA-005 Duplicate Detection Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- `docs/task/DA-005-duplicate-detection.md`
- `docs/agent-log/2026-05-07-DA-005-duplicate-detection.md`
- changed files in commit `34ad70f`
- `build_log_clean.txt`
- current `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

## Scope Check

- The implementation covers the staged detection pipeline and hashing helper that the task asked for.
- The code stays within duplicate detection and import integration.
- The current implementation does not yet implement the actual partial-hash comparison that makes the staged strategy meaningful.

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
  - the app still builds after duplicate detection changes
  - the agent log reports path, size, and hashing stage checks
- What was not verified:
  - real duplicate identification against sample files
  - partial-hash collision behavior
  - duplicate import reporting with known test fixtures

## Visual Evidence

- UI changed:
  - no
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- Duplicate test fixture verification:
  - skipped
- Collision verification:
  - skipped
- Full-hash scale verification:
  - skipped

## Risks

- `detectDuplicate(for:)` returns `.contentPartialMatch` for any same-size file, so different files with the same size are treated as duplicate candidates without a real hash comparison.
- The computed `partialHash` is currently unused, which means the staged hash strategy is not actually applied.
- The implementation still depends on string-based repository lookups, so search and duplicate candidate reporting can drift from the staged strategy.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Domain/Duplicates/DuplicateDetectionService.swift:28-41`
  - impact: the service marks any same-size asset as a partial-match candidate without comparing partial hashes, so duplicate detection is too weak and can produce false positives.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Duplicates/DuplicateDetectionService.swift:34-41`
  - impact: `partialHash` is computed but never used, so the core staged detection step is only nominal.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Infrastructure/Security/HashService.swift:10-61`
  - impact: the hash helper is sound as a utility, but the duplicate service does not yet consume it in a way that satisfies the task's staged strategy.

## Follow-up Needed

- Compare the partial hash against stored fingerprints before returning a content duplicate candidate.
- Preserve size matching as a narrowing step only, not as a final duplicate signal.
- Add a small fixture-based verification for same-size different-content cases.

## Minimal Changes Needed For Accept

- Fetch existing fingerprints for same-size candidates and compare them against the new partial hash before marking `contentPartialMatch`.
- Use the computed hash to distinguish candidates from confirmed matches, rather than returning the first size match.
- Add a sample-file test or scratch script that proves a non-duplicate same-size file is not flagged as a duplicate.

## Notes

- This report does not declare final acceptance.
- Instruction owner decides the final outcome.

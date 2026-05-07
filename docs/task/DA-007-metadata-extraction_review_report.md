# DA-007 Metadata Extraction Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- `docs/task/DA-007-metadata-extraction.md`
- `docs/agent-log/2026-05-07-DA-007-metadata-extraction.md`
- changed files in commit `5bef45b`
- `build_log_clean.txt`
- current `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

## Scope Check

- The implementation covers AVFoundation metadata loading and persistence.
- The change stays within metadata extraction and does not drift into preview, waveform, silence, or AI analysis.
- The current implementation does not yet satisfy the task's explicit file-access failure reporting requirement.

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
  - the app still builds after metadata extraction changes
  - the agent log reports async AVFoundation loading and schema persistence
- What was not verified:
  - extraction on real audio/video/image samples
  - unsupported file handling
  - missing/offline file handling
  - sample-based scratch script or unit test coverage

## Visual Evidence

- UI changed:
  - no
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- Sample media verification:
  - skipped
- Unsupported file handling with a real sample:
  - skipped
- Offline or permission-denied file verification:
  - skipped

## Risks

- `MetadataExtractor.extractMetadata(from:)` silently collapses failures into nil metadata instead of reporting a structured failure state.
- The extractor does not preflight file access or distinguish missing/offline files from unsupported formats, so failure modes are not visible to downstream consumers.
- `AssetRepository.saveTechnicalMetadata` still uses manual SQL string interpolation, which is fragile for codec strings and future fields.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Infrastructure/Media/MetadataExtractor.swift:20-58`
  - impact: extraction failures are swallowed into nil fields, so callers cannot tell unsupported, missing, or permission-denied files apart.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Infrastructure/Media/MetadataExtractor.swift:20-48`
  - impact: the extractor goes straight to AVAsset without file-access preflight or an explicit offline/permission path, which conflicts with the task's file-access rules.
- Finding 3:
  - severity: medium
  - evidence: `DizzyAsset/Data/Repositories/AssetRepository.swift:52-64`
  - impact: technical metadata persistence still uses interpolated SQL, so a codec string with quotes or unexpected characters can break the statement.

## Follow-up Needed

- Return an explicit extraction result or error reason for unsupported and inaccessible files.
- Add file-access preflight so missing/offline/permission-denied states are reported before AVFoundation work starts.
- Convert technical metadata persistence to parameterized SQL.

## Minimal Changes Needed For Accept

- Add a structured failure path to `MetadataExtractor` instead of using `try?` for every property.
- Resolve file access and existence before creating the `AVAsset`, and map missing/offline/permission failures into the result.
- Use bound parameters when persisting codec and other metadata fields.

## Notes

- This report does not declare final acceptance.
- Instruction owner decides the final outcome.

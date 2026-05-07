# DA-011 Editing Language Tag System Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-011-editing-language-tag-system.md`
- agent log: `docs/agent-log/2026-05-07-DA-011-editing-language-tag-system.md`
- changed files: `DizzyAsset/Domain/Tagging/TaggingService.swift`, `DizzyAsset/Data/Repositories/TagRepository.swift`, `DizzyAsset/Presentation/AssetDetail/AssetInformationHubViewModel.swift`
- visual artifacts: not applicable

## Scope Check

- What was in scope:
  - tag entity/model
  - normalized tag names
  - basic assignment/removal
  - search compatibility
- What was out of scope:
  - complex tag management UI
  - bulk tag operations
  - drag tagging
  - AI tagging
- Any scope drift:
  - the implementation reaches into later features through the hub view model, but the core tag foundation itself stays within scope.

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
  - tag create/assign/fetch paths exist
  - tag normalization currently lowercases and trims input
- What was not verified:
  - runtime tag assignment/removal in the app
  - visual evidence

## Visual Evidence

- UI changed:
  - no direct tag editor UI was added
- Artifact path:
  - not applicable
- Screenshot or recording:
  - not applicable

## Skipped Checks

- manual tag assignment test:
  - skipped
- tag removal test:
  - skipped
- visual artifact capture:
  - skipped

## Risks

- Tag removal currently routes through `findOrCreateTag`, which can create missing tags instead of simply removing a relation.
- Raw SQL string interpolation remains in the tag repository, so the current persistence path is still fragile for user-provided values.
- The code normalizes to lowercase, but there is no separate display-vs-normalized representation, so future search/display behavior may need to split those concerns.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Data/Repositories/TagRepository.swift:10-19` and `DizzyAsset/Data/Repositories/TagRepository.swift:22-40`
  - impact: tag persistence still uses raw SQL interpolation, which is brittle and exposes the tag path to escaping/injection problems.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Domain/Tagging/TaggingService.swift:17-20`
  - impact: `removeTag` calls `findOrCreateTag`, so attempting to remove a tag can create a new tag record if it does not already exist.

## Follow-up Needed

- Split tag lookup from tag creation so removals do not create new tag rows.
- Replace interpolated SQL in the tag repository with bound parameters.
- If the product expects a stable display name and normalized name, add that separation explicitly.

## Minimal Changes Needed For Accept

- Make tag removal use a pure lookup path instead of `findOrCreateTag`.
  - why: removal should not create database rows.
- Parameterize the tag repository SQL calls.
  - why: user-provided tag values must be escaped safely.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

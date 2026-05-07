# DA-012 Category System Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-012-category-system.md`
- agent log: `docs/agent-log/2026-05-07-DA-012-category-system.md`
- changed files: `DizzyAsset/Domain/Categories/CategoryService.swift`, `DizzyAsset/Data/Repositories/CategoryRepository.swift`, `DizzyAsset/Presentation/Views/SidebarView.swift`, `DizzyAsset/Presentation/AssetDetail/BatchEditViewModel.swift`
- visual artifacts: not produced

## Scope Check

- What was in scope:
  - category entity/model
  - parent-child relation
  - max depth validation
  - basic assignment/removal
  - shallow hierarchy display
- What was out of scope:
  - unlimited tree UI
  - complex drag reorder UI
  - AI category recommendation
  - full merge/delete workflow
- Any scope drift:
  - the UI-side hierarchy display is acceptable, but the database layer does not yet enforce the task's 3-level maximum.

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
  - category hierarchy loading exists
  - category assignment and batch assignment methods exist
- What was not verified:
  - runtime hierarchy editing
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

- category depth UI test:
  - skipped
- create/rename/move/delete workflow test:
  - skipped
- visual artifact capture:
  - skipped

## Risks

- The current depth check is not enforcing the required 3-level maximum, so deeper trees can still slip through.
- `CategoryRepository` still uses string interpolation for inserts, lookups, and batch clears, so the persistence layer is not safe yet for arbitrary category names and IDs.
- `SidebarView` mutates categories through drag/drop and load logic, but there is no clear error surface if the database path fails.

## Findings

- Finding 1:
  - severity: high
  - evidence: `DizzyAsset/Domain/Categories/CategoryService.swift:17-24` and `DizzyAsset/Domain/Categories/CategoryService.swift:42-54`
  - impact: the task requires a maximum depth of 3, but the implementation only has a loose `depth > 10` safety break, so the real limit is not enforced.
- Finding 2:
  - severity: high
  - evidence: `DizzyAsset/Data/Repositories/CategoryRepository.swift:6-13` and `DizzyAsset/Data/Repositories/CategoryRepository.swift:58-62`
  - impact: category persistence still relies on raw SQL interpolation, which is brittle and exposes user-provided values to escaping problems.

## Follow-up Needed

- Enforce the 3-level maximum directly in `CategoryService`.
- Parameterize category repository SQL.
- Capture a UI artifact for the category sidebar and hierarchy state.

## Minimal Changes Needed For Accept

- Replace the depth safety break with explicit rejection at depth 4.
  - why: the task requires a strict 3-level limit.
- Replace interpolated SQL with bound parameters in category create and clear paths.
  - why: category names and IDs should not be inserted into SQL by string concatenation.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

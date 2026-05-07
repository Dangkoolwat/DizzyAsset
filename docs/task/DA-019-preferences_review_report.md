# DA-019 Preferences Review Report

## Decision

Needs follow-up

## Reviewed Artifacts

- task document: `docs/task/DA-019-preferences.md`
- agent log: `docs/agent-log/2026-05-07-DA-019-preferences.md`
- changed files: `DizzyAsset/Presentation/Settings/SettingsView.swift`, `DizzyAsset/Presentation/Settings/SettingsViewModel.swift`, `DizzyAsset/Data/Repositories/SettingsRepository.swift`
- visual artifacts: not produced

## Scope Check

- What was in scope:
  - workspace path display
  - minimal settings read/write
  - safe workspace location selection hook if possible
  - error/unavailable state
- What was out of scope:
  - advanced settings categories
  - full migration UI
  - entitlement toggles
- Any scope drift:
  - the preferences foundation is present, but the workspace change flow is disabled rather than safely implemented.

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
  - workspace path and auto-analysis settings are wired through a view model
  - settings read/write boundaries exist
- What was not verified:
  - actual preferences window behavior
  - workspace change flow
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

- preferences window screenshot:
  - skipped
- workspace change flow:
  - skipped because the button is disabled
- settings persistence smoke test:
  - skipped

## Risks

- The change-location action is disabled, so the task does not yet provide a safe workspace selection hook.
- Settings persistence still uses interpolated SQL in the repository layer.
- The workspace path is loaded and displayed, but there is no explicit invalid/unavailable state in the UI.

## Findings

- Finding 1:
  - severity: medium
  - evidence: `DizzyAsset/Presentation/Settings/SettingsView.swift:56-60`
  - impact: the workspace change action is disabled, so the safe location-selection hook requested by the task is not actually implemented.
- Finding 2:
  - severity: medium
  - evidence: `DizzyAsset/Data/Repositories/SettingsRepository.swift:6-18`
  - impact: settings persistence still uses interpolated SQL, which is fragile for user-controlled values.
- Finding 3:
  - severity: medium
  - evidence: no artifact under `artifacts/YYYY-MM-DD/DA-019/`
  - impact: the preferences UI cannot be reviewed visually.

## Follow-up Needed

- Either implement a safe location-selection hook or clearly label the settings screen as display-only.
- Parameterize the settings repository SQL.
- Capture a preferences screenshot.

## Minimal Changes Needed For Accept

- Enable a safe workspace selection flow or explicitly narrow the task to display-only preferences.
  - why: the task asked for a location change hook if safe, and the current button is just disabled.
- Replace interpolated settings SQL with bound parameters.
  - why: settings values should be persisted safely.

## Notes

- The report does not declare final acceptance.
- Instruction owner decides the final outcome.

# XcodeGen and Project Guideline

Use this guideline when changing project structure, `project.yml`, build settings, resources, or target membership.

DizzyAsset uses XcodeGen.

`project.yml` is the source of truth.

Do not edit `.xcodeproj` manually.

---

## 1. When to Use

Use this guideline when the task touches:

- `project.yml`
- source file add/delete/move
- target membership
- build settings
- schemes
- entitlements
- resources
- asset catalogs
- Info.plist settings
- test targets
- generated Xcode project behavior

Use `xcode-project-analyzer` for project audits.

---

## 2. Core Rules

MUST:

- edit `project.yml`, not `.xcodeproj`
- run `xcodegen generate` after file add/delete/move
- run build after generation when possible
- report commands actually run
- report generation or build failures

MUST NOT:

- manually edit `.xcodeproj`
- silently change entitlements
- silently change signing
- silently change sandbox permissions
- silently change release settings
- move files without checking target membership

---

## 3. Project Structure

Expected structure:

- `DizzyAsset/App/`
- `DizzyAsset/Presentation/`
- `DizzyAsset/Domain/`
- `DizzyAsset/Data/`
- `DizzyAsset/Infrastructure/`
- `DizzyAsset/Resources/`

Tests:

- `DizzyAssetTests/`
- `DizzyAssetUITests/`

Artifacts:

- `artifacts/`

Docs:

- `docs/product/`
- `docs/guidelines/`
- `docs/workflows/`
- `docs/templates/`
- `docs/knowledge/`
- `docs/agent-log/`

---

## 4. Add File Flow

When adding a source file:

1. Add file in the correct folder.
2. Update `project.yml` if target inclusion is not automatic.
3. Run `xcodegen generate`.
4. Run build if possible.
5. Report changed files and commands.

If generation fails, stop and report.

---

## 5. Delete or Move File Flow

When deleting or moving a file:

1. Check references.
2. Update imports or call sites.
3. Update `project.yml` if needed.
4. Run `xcodegen generate`.
5. Run build if possible.
6. Report risks.

Do not leave stale target references.

---

## 6. Resources

Resources may include:

- asset catalogs
- entitlements
- images
- icons
- Info.plist-related files

Resource changes are non-trivial.

Entitlements are protected.

Sandbox permissions are protected.

Apple Events permissions are protected.

Do not change protected resources without explicit approval.

---

## 7. Build Settings

Build setting changes are non-trivial.

Stop and report before changing:

- signing
- provisioning
- sandbox
- entitlements
- notarization
- deployment target
- release configuration
- CI/CD-related settings

Safe changes may include:

- adding debug-only flags
- adding test target settings
- correcting local target membership

Still report all changes.

---

## 8. Schemes

Scheme changes are non-trivial.

Before changing schemes:

- explain why
- check impact on build command
- check impact on tests
- check impact on CI if any

After changing schemes:

- run `xcodegen generate`
- run CLI build if possible
- report commands

---

## 9. Verification

Minimum verification:

- `xcodegen generate`
- CLI build if possible

Recommended build command:

    xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build

Report:

- command run
- result
- failure summary if failed
- whether `.xcodeproj` was regenerated

Do not claim success unless commands passed.

---

## 10. Stop Conditions

Stop and report if:

- `xcodegen generate` fails
- build fails
- target membership is unclear
- protected setting change is required
- entitlements change is required
- signing behavior is unclear
- generated project differs unexpectedly
- CI/CD impact is unclear

Do not continue by manually editing `.xcodeproj`.

---

## 11. Handoff Notes

For project changes, handoff MUST include:

- files added
- files deleted
- files moved
- `project.yml` changed:
  - yes/no
- `xcodegen generate` run:
  - yes/no
- build run:
  - yes/no
- generated project manually edited:
  - must be no
- protected areas touched:
  - yes/no
- known risks
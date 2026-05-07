# DA-018 Derived Asset Management — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-018  
**Task name:** Derived Asset Management  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-018-derived-asset-management.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first derived asset management foundation.

Derived assets are generated or transformed files that relate to an original source asset.

Examples:

- trimmed output
- converted output
- proxy media
- normalized audio
- generated export

This task should represent derived assets and their relation to source assets.

It must not implement destructive trimming/export unless explicitly assigned.

Original files must remain untouched.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-018 task prompt
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Safety/platform guidelines in `docs/guidelines/`
8. Existing code patterns

Raw chat is not implementation scope.

---

## 3. Required Reading

Always read:

- `AGENTS.md`
- this task prompt
- `docs/guidelines/workspace-lifecycle.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `sqlite-fts-optimizer`
  - derived relation schema, indexes

- `macos-sandbox-security-skill`
  - workspace file access or external workspace behavior

- `karpathy-guidelines`
  - scoped implementation

- `xcode-project-analyzer`
  - only for project changes

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- derived asset model
- source asset to derived asset relationship
- derived asset type enum
- workspace path association
- orphan/missing-source status representation
- repository methods if persistence exists
- non-destructive behavior
- display-ready data for future right panel

Possible derived types:

- silenceTrim
- normalizedVolume
- convertedFormat
- proxy
- preview
- export

Implement only types needed for foundation.

---

## 6. Out of Scope

Do not implement:

- actual trimming
- actual conversion
- batch cleanup
- destructive media changes
- proxy generation
- export workflow
- workspace cleanup
- Quick Peek
- Final Cut Pro integration
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `DerivedAsset`
- `DerivedAssetType`
- `DerivedAssetStatus`
- `AssetDerivation`
- `DerivedAssetRepository`
- `DerivedAssetService`

Keep relationships explicit.

Do not treat derived assets as original files.

---

## 8. Data Rules

Derived records should preserve:

- source asset id
- derived asset id or derived file path
- derivation type
- workspace path
- created at
- status

Possible statuses:

- active
- orphaned
- missingSource
- recoverable
- missingFile

Do not delete derived files automatically.

Do not delete source asset records.

---

## 9. Workspace Rules

Derived assets belong in workspace.

Default workspace root:

- `~/DizzyAsset/`

Potential folder:

- `Derived/`
- `Derived/Trimmed/`
- `Derived/Converted/`
- `Derived/Proxy/`

If workspace is unavailable:

- record recoverable state
- do not delete relation
- show limitation in handoff

---

## 10. Database Rules

If persistence exists:

- use repository boundary
- avoid destructive migration
- preserve source relation
- avoid deleting assets on relation failure
- keep derived relationship queryable

If persistence is not ready:

- implement model/service boundary only
- report limitation in handoff

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Derived asset verification should include:

- create derived relation
- fetch derived relation
- missing source state if practical
- workspace path association
- no original file modification
- no automatic deletion

Report skipped checks.

---

## 12. Visual Evidence

If UI is changed, visual evidence is required.

Store under:

- `artifacts/YYYY-MM-DD/DA-018/`

If no UI changed, state not applicable.

---

## 13. Stop Conditions

Stop and report if:

- implementation would modify original files
- cleanup/delete behavior becomes necessary
- derived/source relation semantics are unclear
- workspace path behavior is unclear
- database migration becomes destructive
- task expands into trimming/export/conversion

---

## 14. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-018
- Risk level: Medium
- files changed
- derived types represented
- persistence behavior
- workspace paths touched
- original file modified:
  - must be no
- verification run
- skipped checks
- known risks
- next suggested task

---

## 15. Expected Completion Criteria

DA-018 is complete when:

- derived asset foundation exists
- source/derived relationship is represented
- orphan/missing-source state is possible
- original files are not modified
- verification is reported
- handoff is produced

---

## 16. Suggested Next Task

After DA-018:

- DA-019 Preferences

Do not start DA-019 in this task.

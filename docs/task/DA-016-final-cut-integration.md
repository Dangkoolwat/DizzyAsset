# DA-016 Final Cut Integration — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-016  
**Task name:** Final Cut Integration  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** High  
**Target repo path:** `docs/task/DA-016-final-cut-integration.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first Final Cut Pro drag integration foundation.

Primary workflow:

- search in DizzyAsset
- preview in DizzyAsset
- drag original file URL to Final Cut Pro
- use in Final Cut Pro

DizzyAsset must not force hidden media copying.

Original files stay where they are.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-016 task prompt
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
- `docs/guidelines/final-cut-pro-integration.md`
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/swiftui-architecture.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `macos-sandbox-security-skill`
  - file access, bookmarks, entitlements, permissions

- `swiftui-expert-skill`
  - drag source UI

- `avfoundation-media-pro`
  - media compatibility if touched

- `karpathy-guidelines`
  - scoped implementation

- `code-review-graph`
  - required after implementation if non-trivial

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- drag source from asset row or asset list
- file URL payload for available original file
- file access check before drag
- missing/offline/permission failure state
- no hidden copying
- no original file movement
- visual feedback if UI is touched
- basic FCP-compatible drag behavior if environment allows testing

Acceptable initial scope:

- drag from asset list to external app using file URL

Final Cut Pro verification may be manual if FCP is available.

---

## 6. Out of Scope

Do not implement:

- Final Cut Pro sound library symlink automation
- Apple Events automation
- proprietary import pipeline
- hidden temp copy workaround
- Quick Peek drag
- batch drag workflows
- file conversion for FCP
- release/signing/notarization

Do not change protected areas without approval.

Apple Events and entitlements are protected.

---

## 7. Implementation Guidance

Possible components:

- `DragAndDropProvider`
- `AssetFileDragPayload`
- `FinalCutIntegrationService`
- `AssetRowDragModifier`
- file availability resolver

Keep drag payload behavior focused.

Do not reuse internal drag tagging payload unless safe and clearly separated.

---

## 8. File Access Rules

Before drag:

1. load asset location
2. resolve bookmark if applicable
3. check file availability
4. check permission
5. provide file URL payload
6. return recoverable failure if invalid

Failure states:

- missing
- volumeOffline
- permissionDenied
- staleBookmark
- unsupportedFile
- unknownFailure

Do not show successful drag if file is unavailable.

---

## 9. FCP Rules

Do not claim FCP integration is verified unless tested with Final Cut Pro.

If FCP is unavailable:

- verify file URL drag mechanics if possible
- state FCP not verified
- list required manual check

Test separately when possible:

- internal disk file
- external SSD file
- app restart then drag
- drive reconnect then drag

---

## 10. Verification

Full Verification is required.

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

FCP verification should include:

- drag available file
- drag missing file state
- permission denied state if practical
- no hidden copy
- original file not moved
- FCP drag if FCP available
- visual evidence if UI changed

Report skipped checks.

---

## 11. Visual Evidence

If UI is changed, visual evidence is required.

Store under:

- `artifacts/YYYY-MM-DD/DA-016/`

If FCP drag is manually tested, include screenshot or short recording when possible.

---

## 12. Stop Conditions

Stop and report if:

- drag requires hidden copying
- entitlement change is required
- Apple Events permission change is required
- sandbox behavior is unclear
- file URL payload behavior is unclear
- FCP behavior cannot be verified but task requires proof
- implementation expands into Quick Peek drag
- build fails

---

## 13. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-016
- Risk level: High
- files changed
- drag source
- payload type
- file access checks
- hidden copy used:
  - must be no
- FCP tested:
  - yes/no
- storage tested:
  - internal/external/not tested
- visual evidence path
- verification run
- skipped checks
- known risks
- next suggested task

---

## 14. Expected Completion Criteria

DA-016 is complete when:

- file URL drag foundation exists
- missing/permission failures are safe
- original files are not copied, moved, or modified
- hidden media management is not introduced
- verification is reported honestly
- handoff is produced

---

## 15. Suggested Next Task

After DA-016:

- DA-017 Silence Detection

Do not start DA-017 in this task.

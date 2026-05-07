# DA-017 Silence Detection — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-017  
**Task name:** Silence Detection  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-017-silence-detection.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first silence detection foundation.

v1.0 scope is display-only:

- detect front silence
- detect tail silence
- store or return analysis result
- show or prepare for display in asset information hub

This task must not trim, export, or modify original files.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-017 task prompt
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
- `docs/guidelines/preview-engine.md`
- `docs/guidelines/ai-analysis-provider.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/macos-file-access.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `avfoundation-media-pro`
  - audio analysis, sample loading, AVFoundation behavior

- `swift-concurrency`
  - background analysis

- `macos-sandbox-security-skill`
  - file access

- `karpathy-guidelines`
  - scoped implementation

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- silence analysis service boundary
- front silence duration
- tail silence duration
- analysis result model
- safe failure state
- storage hook if asset_analysis exists
- background execution if analysis is heavy
- no original file modification

Possible result fields:

- assetId
- frontSilenceDuration
- tailSilenceDuration
- analyzedAt
- analyzerVersion
- status
- failureReason

---

## 6. Out of Scope

Do not implement:

- trimming
- export
- batch cleanup
- destructive audio modification
- normalized audio generation
- waveform editor
- Sound Analysis tagging
- Speech analysis
- Vision analysis
- LLM classification
- release/signing/notarization

---

## 7. Implementation Guidance

Possible components:

- `SilenceDetectionService`
- `SilenceAnalysisResult`
- `AudioAnalyzer`
- `SilenceAnalysisRepository`

Keep algorithm simple and documented.

Do not block UI.

Do not require silence analysis for import completion.

---

## 8. File Access Rules

Before analysis:

- resolve file URL
- check availability
- check permission
- handle missing/offline states
- avoid modifying file

Analysis failure should not make asset unusable.

---

## 9. Algorithm Notes

Initial silence detection may use simple threshold-based logic.

Document:

- threshold
- minimum duration
- sample interpretation
- supported audio types
- known limitations

Do not overstate accuracy.

Do not use AI for this task unless assigned.

---

## 10. Database Rules

If persistence exists:

- store analysis result
- include analyzer version if possible
- preserve previous user-confirmed data
- avoid destructive migration

If persistence is not ready:

- return result in memory
- report limitation in handoff

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Silence verification should include:

- audio with front silence if sample exists
- audio with tail silence if sample exists
- audio with no silence if sample exists
- unsupported file handling
- missing file state if practical
- no original file modification

Report skipped checks.

---

## 12. Visual Evidence

If UI is changed, visual evidence is required.

Store under:

- `artifacts/YYYY-MM-DD/DA-017/`

If no UI changed, state not applicable.

---

## 13. Stop Conditions

Stop and report if:

- implementation would modify original files
- trimming/export becomes required
- algorithm accuracy policy is unclear
- AVFoundation behavior is unclear
- analysis blocks UI
- database migration becomes destructive
- task expands into Sound Analysis, Speech, Vision, or LLM

---

## 14. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-017
- Risk level: Medium
- files changed
- algorithm summary
- supported file types
- persistence behavior
- UI touched:
  - yes/no
- original file modified:
  - must be no
- verification run
- skipped checks
- known risks
- next suggested task

---

## 15. Expected Completion Criteria

DA-017 is complete when:

- silence detection foundation exists
- front/tail silence can be represented
- failures are safe
- original files are not modified
- trimming/export is not implemented
- handoff is produced

---

## 16. Suggested Next Task

After DA-017:

- DA-018 Derived Asset Management

Do not start DA-018 in this task.

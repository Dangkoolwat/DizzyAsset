# DA-010 Preview Engine — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-010  
**Task name:** Preview Engine  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-010-preview-engine.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first preview engine foundation for DizzyAsset.

Preview should allow selected assets to be quickly previewed, especially audio.

Core behavior:

- Space toggles preview
- selected asset can be previewed
- missing/permission states are handled
- rapid selection changes do not leave stale playback

This task should not implement advanced waveform editing, trimming, Quick Peek, or Final Cut Pro drag.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-010 task prompt
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
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `avfoundation-media-pro`
  - AVPlayer, AVAudioPlayer, metadata, preview behavior

- `swift-concurrency`
  - async preview loading, cancellation

- `macos-sandbox-security-skill`
  - file access and bookmark-related permission behavior

- `swiftui-expert-skill`
  - if UI or keyboard handling is touched

- `karpathy-guidelines`
  - scoped implementation

---

## 5. In Scope

Implement or verify:

- `PreviewService` or equivalent
- preview state model
- basic audio preview if supported
- basic video preview if easy and scoped
- Space play/pause connection if UI is ready
- selected asset preview handoff
- missing file state
- permission denied state
- unsupported format state
- stale preview cancellation or prevention

---

## 6. Out of Scope

Do not implement:

- waveform generation
- waveform UI
- silence detection
- trimming
- export
- batch cleanup
- Quick Peek preview
- Final Cut Pro drag
- advanced media browser
- AI preview recommendation
- release/signing/notarization

---

## 7. Implementation Guidance

Possible components:

- `PreviewService`
- `PreviewState`
- `PreviewItem`
- `PreviewError`
- `PreviewViewModel` if UI is touched

Preview states may include:

- idle
- loading
- ready
- playing
- paused
- failed
- unavailable

Keep AVFoundation details out of SwiftUI Views.

---

## 8. File Access

Before preview:

1. resolve asset file URL
2. check availability
3. check permission
4. create player or preview item
5. surface recoverable error if needed

Do not modify original files.

Do not copy files secretly for preview.

---

## 9. Keyboard Behavior

If keyboard behavior is touched:

- Space toggles selected asset preview
- repeated Space should not create multiple players
- selection change should not leave stale playback
- missing file should show clear state
- permission denied should show clear state

Do not break arrow-key flow.

---

## 10. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Preview verification should include:

- audio preview if sample exists
- Space toggle if UI supports it
- rapid selection change if UI supports it
- missing file state if practical
- unsupported file state if practical
- external SSD file if available

Report skipped checks.

---

## 11. Visual Evidence

This task may include UI.

If UI is changed, visual evidence is required.

Store under:

- `artifacts/YYYY-MM-DD/DA-010/`

If no UI changed, state not applicable.

---

## 12. Stop Conditions

Stop and report if:

- AVFoundation behavior is unclear
- preview blocks UI
- permission behavior is unclear
- original file modification is required
- hidden copying is required
- rapid selection causes stale playback
- task expands into waveform, silence, Quick Peek, or FCP drag

---

## 13. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-010
- Risk level: Medium
- files changed
- preview types supported
- AVFoundation touched:
  - yes/no
- file access touched:
  - yes/no
- keyboard behavior touched:
  - yes/no
- visual evidence path or not applicable
- verification run
- skipped checks
- known risks
- next suggested task

---

## 14. Expected Completion Criteria

DA-010 is complete when:

- preview foundation exists
- preview state is explicit
- basic preview works or limitation is documented
- missing/permission failures are safe
- original files are not modified
- handoff is produced

---

## 15. Suggested Next Task

After DA-010:

- DA-011 Editing Language Tag System

Do not start DA-011 in this task.

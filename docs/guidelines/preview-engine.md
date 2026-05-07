# Preview Engine Guideline

Use this guideline when changing preview playback, Space key behavior, AVFoundation integration, waveform display, preview cache, media loading, or preview error states.

Preview is a core workflow feature.

Primary flow:

    Search
    Preview
    Drag
    Use

---

## 1. Core Principles

MUST:

- keep preview fast
- keep UI responsive
- support keyboard-first flow
- handle missing files
- handle permission failures
- handle rapid selection changes
- keep preview state explicit

MUST NOT:

- block the main thread
- hide preview failures
- play stale media after selection changes
- rewrite original files
- generate destructive output
- make preview depend on AI analysis

---

## 2. v1.0 Scope

v1.0 preview may include:

- audio preview
- basic video preview
- Space play/pause
- selection change handling
- missing file state
- permission denied state

Out of v1.0 unless assigned:

- advanced waveform editor
- trimming UI
- batch cleanup
- AI-based preview recommendation
- destructive media edits

---

## 3. Preview Ownership

Preview state should be owned by:

- `PreviewService`
- focused preview ViewModel
- feature-specific ViewModel when scoped

SwiftUI Views should not own AVFoundation details.

Views may own:

- local hover state
- local expanded/collapsed state
- local display-only state

Views should not own:

- AVPlayer lifecycle
- file bookmark resolution
- media metadata extraction
- long-running preview loading
- waveform generation

---

## 4. Space Key Behavior

Space is the primary preview shortcut.

Rules:

- Space toggles preview for selected asset
- selection change should update preview target
- repeated Space should not create multiple players
- missing file should show clear state
- permission denied should show clear state
- unsupported file should show clear state

Do not break keyboard flow.

---

## 5. Rapid Selection Changes

Users may move quickly through results.

Rules:

- cancel stale preview loading
- stop previous playback when needed
- avoid overlapping audio
- avoid stale UI state
- keep selected asset and playing asset clear
- do not crash on missing file during navigation

Good states:

- idle
- loading
- ready
- playing
- paused
- failed
- unavailable

---

## 6. AVFoundation

Use AVFoundation carefully.

Possible APIs:

- AVPlayer
- AVAudioPlayer
- AVAsset
- AVAssetReader

Rules:

- isolate AVFoundation code from SwiftUI Views
- load metadata asynchronously when possible
- keep player lifecycle clear
- handle unsupported formats
- handle file access failure before player creation
- avoid blocking main thread

AVFoundation edge cases must be reported in handoff.

---

## 7. File Access Before Preview

Before preview:

1. load asset location
2. resolve bookmark if needed
3. check file availability
4. check permission
5. create preview item or player
6. surface recoverable failure if needed

Failure states:

- missing
- volumeOffline
- permissionDenied
- staleBookmark
- unsupportedFormat
- previewFailed

Do not collapse all failures into a generic error.

---

## 8. Preview Cache

Preview cache may be used for:

- thumbnails
- waveform images
- lightweight preview metadata
- generated preview files

Rules:

- cache is derived data
- cache must be regeneratable
- cache must not be source of truth
- cache cleanup must not affect original files
- cache path should live under workspace
- cache failure should not corrupt asset state

---

## 9. Waveform

Waveform display may be generated from audio.

Rules:

- waveform generation should run in background
- waveform output should live under workspace analysis path
- waveform should link to source asset
- waveform should be regeneratable
- waveform generation failure should be visible but non-fatal

Do not block preview playback on waveform generation unless assigned.

---

## 10. Silence Detection Interaction

Silence detection is related but separate.

v1.0 silence behavior:

- detect front silence
- detect tail silence
- show values in detail panel
- do not modify original file

Preview may show silence information.

Preview must not perform destructive trimming unless assigned.

---

## 11. Error Handling

Preview errors should be user-visible.

Examples:

- File is missing.
- External drive is offline.
- Permission is required.
- File format is unsupported.
- Preview failed.

Do not silently fail.

Do not leave player in unknown state.

Do not keep playing old media when new preview fails.

---

## 12. Performance

Preview should feel instant.

Rules:

- avoid main-thread blocking
- reuse player if safe
- preload only when useful
- avoid excessive memory use
- cancel stale loading
- do not calculate full hash for preview
- do not run heavy analysis before playback

Target:

- perceived preview start should feel immediate
- exact latency target may depend on file type and storage

External storage may be slower.

Do not hide slow external drive behavior.

---

## 13. Quick Peek Preview

Quick Peek preview is high-risk.

Rules:

- keep overlay responsive
- preserve keyboard focus
- keep preview state isolated
- cancel preview when overlay closes
- stop playback on Esc if expected
- avoid coupling Quick Peek playback tightly to main window

Do not implement advanced Quick Peek preview behavior unless assigned.

---

## 14. UI Feedback

Preview UI should show:

- loading
- playing
- paused
- unavailable
- missing
- permission denied
- unsupported format
- offline drive

Right panel may show richer preview state.

Quick Peek should show minimal clear state.

---

## 15. Testing and Verification

Preview verification should include:

- Space play/pause
- rapid arrow key selection
- repeated Space toggle
- missing file state
- permission denied state if possible
- external SSD playback if available
- unsupported file type
- app restart then preview if bookmark touched

Report what was not tested.

---

## 16. Stop Conditions

Stop and report if:

- AVFoundation behavior is unclear
- preview requires hidden file copying
- permission behavior is unclear
- preview blocks UI
- rapid selection causes stale playback
- original file modification is required
- Quick Peek focus behavior becomes unstable

Do not guess around media playback failures.

---

## 17. Handoff Requirements

For preview work, handoff must include:

- files changed
- preview source changed
- AVFoundation touched:
  - yes/no
- file access touched:
  - yes/no
- cache behavior changed:
  - yes/no
- waveform behavior changed:
  - yes/no
- keyboard behavior verified:
  - yes/no
- external storage tested:
  - yes/no
- skipped checks
- known risks
- visual evidence if UI changed
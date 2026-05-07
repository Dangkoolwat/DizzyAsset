# Final Cut Pro Integration Guideline

Use this guideline when changing Final Cut Pro drag behavior, file URL drag payloads, Apple Events assumptions, media handoff, or related UI flows.

Final Cut Pro integration is workflow-critical.

Primary flow:

    Search
    Preview
    Drag
    Use

---

## 1. Core Principles

MUST:

- use real file URL based drag behavior
- preserve original files
- respect file access permissions
- support external SSD workflows
- surface errors clearly
- keep user workflow fast

MUST NOT:

- force hidden media copying
- move original files
- rewrite original files
- invent a proprietary import pipeline
- hide permission failures
- fake successful drag state

---

## 2. Product Role

DizzyAsset is not a media management replacement.

It is a logical indexing and workflow layer.

Final Cut Pro should receive usable file references.

DizzyAsset should help the user find, preview, and drag assets quickly.

---

## 3. Drag Sources

Possible drag sources:

- Asset list
- Right panel
- Quick Peek
- Search results
- Recent items
- Favorite items

v1.0 priority:

- Asset list to Final Cut Pro

Quick Peek drag is high-risk and may be follow-up unless assigned.

---

## 4. Drag Payload

Preferred payload:

- actual file URL
- compatible file representation
- stable provider behavior

Rules:

- resolve bookmark before drag
- confirm file exists
- confirm permission
- do not copy as hidden workaround
- do not create temp media unless explicitly assigned
- preserve original file path semantics

If using NSItemProvider or pasteboard integration, keep behavior focused and test with FCP.

---

## 5. File Access Before Drag

Before creating drag payload:

1. Load asset location.
2. Resolve bookmark.
3. Check file availability.
4. Check permission.
5. Return file URL payload if valid.
6. Show recoverable error if invalid.

Possible failure states:

- missing
- volumeOffline
- permissionDenied
- staleBookmark
- unsupportedFile
- unknownFailure

Do not let failure appear as successful drag.

---

## 6. External Storage

External SSD drag must be considered.

Test separately:

- internal disk file
- external SSD file
- file after app restart
- file after drive reconnect
- missing/offline drive

Do not assume external storage path is stable.

Do not assume mounted volume is always present.

---

## 7. Final Cut Pro Drop Behavior

FCP behavior may vary by:

- timeline area
- browser area
- file type
- sandbox access
- OS version
- FCP version
- external drive state

Agents must not claim FCP integration is verified unless it was actually tested.

If FCP is not available, report not verified.

---

## 8. Supported Media

Initial likely support:

- audio
- video
- images / GIF if supported by workflow

Do not expand supported types without task scope.

Unsupported file should show clear state.

---

## 9. Sound Library Link

Final Cut Pro sound library soft-link behavior is follow-up unless explicitly assigned.

Rules:

- do not auto-create symlinks silently
- ask user or require explicit scope
- show connection status
- allow disconnect/rebuild if implemented
- warn if FCP restart is needed

---

## 10. Quick Peek and FCP

Quick Peek is high-risk.

Quick Peek drag combines:

- global hotkey
- overlay focus
- preview
- drag payload
- FCP target behavior

Do not implement advanced Quick Peek drag unless assigned.

For v1.0, Quick Peek may focus on:

- open
- search
- keyboard navigation
- preview
- close

---

## 11. Apple Events

Apple Events permissions may be required for some integration paths.

Apple Events are protected.

Do not add or change Apple Events permissions without explicit approval.

Prefer standard drag behavior before automation.

---

## 12. Error Handling

Errors should be user-visible.

Examples:

- File is offline.
- Permission is required.
- File no longer exists.
- External drive is disconnected.
- This file type cannot be dragged to Final Cut Pro.
- Drag failed. Try reconnecting the source drive.

Avoid generic errors.

Avoid silent failure.

---

## 13. UI Feedback

UI should show:

- drag availability
- offline status
- permission denied status
- unsupported status
- reconnect option if relevant

Do not let users discover failure only after trying to drag.

---

## 14. Verification

Minimum FCP verification:

- build
- internal file drag attempt
- failure state check when file missing or unavailable

Full FCP verification:

- internal disk drag
- external SSD drag
- app restart then drag
- drive reconnect then drag
- missing file state
- permission denied state
- target area behavior if possible

Report:

- FCP version if known
- macOS version if known
- tested file types
- tested storage type
- what was not tested

---

## 15. Stop Conditions

Stop and report if:

- hidden copying is required to make drag work
- entitlement change is required
- Apple Events permission change is required
- sandbox behavior is unclear
- FCP behavior cannot be verified but task requires proof
- drag payload behavior is unknown
- external storage behavior is unsafe

Do not guess successful FCP behavior.

---

## 16. Handoff Requirements

For FCP work, handoff must include:

- files changed
- drag source
- payload type
- storage tested
- FCP tested:
  - yes/no
- file types tested
- permission states tested
- skipped checks
- known risks
- visual evidence if UI changed
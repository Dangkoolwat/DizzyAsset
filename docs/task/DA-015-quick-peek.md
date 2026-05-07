# DA-015 Quick Peek — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-015  
**Task name:** Quick Peek  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** High  
**Target repo path:** `docs/task/DA-015-quick-peek.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first minimal Quick Peek overlay.

Quick Peek is a Spotlight-style fast search overlay for DizzyAsset.

v1.0 scope is minimal:

- open with shortcut or app-controlled trigger
- search input
- result list
- keyboard navigation
- Space preview if PreviewService exists
- Esc close

Quick Peek is high-risk because it touches focus, overlay behavior, keyboard input, and preview synchronization.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-015 task prompt
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
- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/search-architecture.md`
- `docs/guidelines/preview-engine.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `swiftui-expert-skill`
  - overlay UI, focus, ViewModel state

- `swift-concurrency`
  - search cancellation, preview loading

- `avfoundation-media-pro`
  - only if preview playback is touched

- `karpathy-guidelines`
  - keep implementation minimal

- `code-review-graph`
  - required after implementation if non-trivial

Skills do not expand scope.

---

## 5. In Scope

Implement or verify minimal Quick Peek:

- overlay/panel foundation
- search input
- result list
- keyboard navigation
- Esc close
- state isolation from main window
- SearchService reuse if available
- PreviewService reuse if available
- visual evidence

Acceptable trigger:

- menu command
- toolbar/debug button
- app-controlled shortcut
- global hotkey only if already safe and scoped

If global hotkey requires protected permissions or broad architecture, stop.

---

## 6. Out of Scope

Do not implement:

- advanced recommendation
- AI query suggestion
- Quick Peek to Final Cut Pro drag
- complex multi-monitor behavior unless assigned
- deep global hotkey infrastructure if not already present
- accessibility permission changes
- entitlement changes
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `QuickPeekView`
- `QuickPeekViewModel`
- `QuickPeekController`
- `QuickPeekPanel`
- `QuickPeekResultRow`

Keep Quick Peek state isolated.

Do not let Quick Peek directly mutate MainWindow state unless explicitly designed.

Reuse services instead of duplicating logic:

- SearchService
- PreviewService

---

## 8. AppKit / Focus Rules

Quick Peek may require AppKit.

Rules:

- isolate NSPanel / NSWindow behavior
- keep SwiftUI-facing API small
- document platform workaround
- test focus behavior
- test Esc behavior
- test text input focus
- test close/reopen behavior

Do not spread AppKit lifecycle logic across unrelated views.

---

## 9. Keyboard Rules

Expected keys:

- typing searches
- arrow keys move selection
- Space previews selected result if available
- Esc closes
- Enter may select/use if defined

If a key behavior is not implemented, document it.

Do not break main window keyboard flow.

---

## 10. Verification

Full Verification is required.

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Quick Peek verification should include:

- open
- search typing
- arrow navigation
- Esc close
- close and reopen
- Space preview if implemented
- focus after open
- focus after close
- main window still works after closing
- visual evidence

Report skipped checks.

---

## 11. Visual Evidence

This is a UI task.

Visual evidence is required when environment allows.

Store under:

- `artifacts/YYYY-MM-DD/DA-015/`

Examples:

- overlay open screenshot
- search result screenshot
- short keyboard interaction recording

---

## 12. Stop Conditions

Stop and report if:

- global hotkey requires permission or protected setting change
- focus behavior is unstable
- NSPanel lifecycle is unclear
- Quick Peek state ownership is unclear
- search/preview coupling causes broad refactor
- implementation expands into FCP drag
- entitlement or accessibility change is required
- build fails

---

## 13. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-015
- Risk level: High
- files changed
- trigger method
- overlay implementation
- search behavior
- preview behavior:
  - yes/no
- keyboard behavior verified
- focus behavior verified
- visual evidence path
- verification run
- skipped checks
- known risks
- next suggested task

---

## 14. Expected Completion Criteria

DA-015 is complete when:

- minimal Quick Peek opens and closes
- search input works or limitation is clear
- result list displays if SearchService exists
- keyboard flow is verified or skipped with reason
- visual evidence is provided or explained
- handoff is produced

---

## 15. Suggested Next Task

After DA-015:

- DA-016 Final Cut Integration

Do not start DA-016 in this task.

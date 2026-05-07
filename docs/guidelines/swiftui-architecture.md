# SwiftUI Architecture Guideline

Use this guideline when working on SwiftUI views, ViewModels, navigation, layout, AppKit bridges, or macOS-specific UI.

DizzyAsset is a macOS SwiftUI app.
Keep UI fast, clear, and keyboard-friendly.

---

## 1. Core Principles

MUST:

- keep views small
- keep views composable
- keep business logic out of views
- keep persistence out of views
- keep file-system access out of views
- keep platform bridge code isolated
- preserve keyboard-first workflow

MUST NOT:

- put SQLite logic in a SwiftUI View
- put bookmark resolution in a SwiftUI View
- put import/indexing logic in a SwiftUI View
- create large all-in-one screens
- use global state without a clear owner

---

## 2. Layer Roles

### View

A SwiftUI View should:

- render state
- forward user intent
- own local UI-only state
- keep body readable
- use small subviews

Examples of view-owned state:

- hover state
- local popover visibility
- temporary text field focus
- local animation toggle

A View should not own:

- asset library state
- database state
- bookmark state
- workspace state
- long-running task state
- preview playback state

---

### ViewModel

A ViewModel should:

- own screen state
- coordinate user actions
- call services or use cases
- expose simple published or observable state
- translate domain results into UI models

A ViewModel should not:

- directly run raw SQL
- directly resolve bookmarks
- directly perform hashing
- directly scan folders
- directly perform AVFoundation parsing unless explicitly scoped

---

### Service

A Service should:

- implement domain behavior
- coordinate repositories and infrastructure
- be independent from SwiftUI
- expose clear async APIs when needed

Examples:

- `AssetImportService`
- `SearchService`
- `PreviewService`
- `DuplicateDetectionService`
- `FinalCutIntegrationService`

---

### Infrastructure

Infrastructure should:

- wrap platform APIs
- isolate AppKit
- isolate AVFoundation
- isolate filesystem APIs
- isolate security-scoped bookmarks
- isolate drag provider details

Examples:

- `BookmarkStore`
- `FileSystemAccess`
- `DragAndDropProvider`
- `MetadataExtractor`

---

## 3. View Size

Keep SwiftUI views short.

If a view becomes hard to read:

- extract row views
- extract toolbar views
- extract empty states
- extract inspector sections
- extract platform bridges

Good examples:

- `AssetListView`
- `AssetRowView`
- `AssetDetailView`
- `TagChipView`
- `QuickPeekPanelView`

Avoid:

- one huge `ContentView`
- deeply nested conditional layout
- large view bodies with business logic

---

## 4. ViewModel Ownership

Use one ViewModel per major screen or flow.

Examples:

- `AssetListViewModel`
- `AssetDetailViewModel`
- `ImportViewModel`
- `QuickPeekViewModel`
- `PreferencesViewModel`

Do not share one giant ViewModel across the whole app.

Do not duplicate the same state across multiple ViewModels without a clear owner.

---

## 5. State Property Usage

Use `@State` for local view-only state.

Use `@StateObject` when a view creates and owns the ViewModel.

Use `@ObservedObject` when a ViewModel is passed from outside.

Use `@EnvironmentObject` only for stable app-wide state.

Avoid `@EnvironmentObject` for feature state that can be passed explicitly.

Use `@Binding` for simple parent-child UI state.

Do not use `@State` as persistence.

---

## 6. Keyboard-First UI

DizzyAsset must support fast keyboard flow.

Important flows:

- arrow key list movement
- Space preview
- Esc close
- Enter select
- Quick Peek search
- search to preview to drag

When changing UI, check:

- keyboard focus
- selected row
- Space behavior
- list navigation
- text input focus
- Esc behavior in overlays

Do not break keyboard flow for mouse-only convenience.

---

## 7. Right Panel

The right panel is an Asset Information Hub.

It may show:

- preview
- waveform
- path
- tags
- categories
- duplicate status
- offline drive status
- silence analysis
- usage history
- source/derived relationship

Do not treat it as a simple preview pane only.

Keep sections composable.

Avoid mixing all detail logic in one view.

---

## 8. Quick Peek

Quick Peek is high-risk.

It uses:

- global hotkey
- overlay window
- AppKit panel behavior
- keyboard focus
- preview synchronization

Rules:

- isolate Quick Peek state
- avoid coupling it tightly to MainWindow state
- reuse SearchService and PreviewService when possible
- keep QuickPeekViewModel focused
- do not add advanced drag behavior unless assigned
- test Esc, Space, arrow keys, and focus

Use AppKit bridge carefully.

---

## 9. AppKit Bridge

Use AppKit only when SwiftUI is insufficient.

Examples:

- NSPanel for Quick Peek
- global hotkey integration
- drag provider edge cases
- file URL drag compatibility

Rules:

- isolate AppKit code
- keep SwiftUI-facing API small
- avoid AppKit lifecycle leaks into Views
- document platform workarounds
- classify AppKit bridge changes as non-trivial or high-risk

---

## 10. Preview UI

Preview must feel instant.

UI should not block on:

- metadata extraction
- waveform generation
- full hash calculation
- bookmark refresh
- heavy analysis

Use loading states when needed.

Do not freeze the UI while preview prepares.

---

## 11. Error and Empty States

UI should show clear states for:

- no assets
- no search results
- unsupported file
- missing file
- offline external drive
- permission denied
- duplicate found
- analysis pending
- preview unavailable

Do not hide missing or permission states.

Do not show only generic errors for recoverable states.

---

## 12. Visual Evidence

All UI changes MUST provide visual evidence when possible.

Store under:

    artifacts/YYYY-MM-DD/<task-id>/

Include in handoff:

- screenshot path
- recording path
- or reason not provided

Text-only UI reports are not enough when a screenshot or recording is possible.

---

## 13. Review Checklist

Before finishing UI work, check:

- Is the view small enough?
- Is business logic outside the view?
- Is persistence outside the view?
- Is state ownership clear?
- Does keyboard flow still work?
- Is visual evidence provided?
- Did I avoid unrelated redesign?
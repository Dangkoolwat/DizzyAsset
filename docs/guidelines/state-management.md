# State Management Guideline

Use this guideline when changing app state, ViewModels, dependency ownership, selection state, preview state, search state, or shared services.

Goal: keep one clear source of truth for each state.

---

## 1. Core Principle

Every important state must have one owner.

Readers may observe state.

Writers must be limited and intentional.

Avoid duplicate state across multiple ViewModels.

Avoid hidden global mutable state.

---

## 2. State Categories

Classify state before changing it.

### Local UI State

Owned by a SwiftUI View.

Examples:

- hover state
- local disclosure expanded/collapsed
- popover visibility
- temporary text field focus

Use:

- `@State`
- `@Binding`

---

### Screen State

Owned by a ViewModel.

Examples:

- current search query
- current filter selection
- selected asset in a list flow
- visible import progress
- current detail panel mode

Use:

- ViewModel observable state
- explicit actions

---

### Domain State

Owned by services or domain models.

Examples:

- asset identity
- duplicate status
- category relation
- tag confirmation status
- usage history event

Use:

- domain entities
- domain services
- repositories

---

### Persistence State

Owned by repositories and database layer.

Examples:

- saved assets
- saved tags
- saved categories
- saved bookmarks
- saved workspace settings

Use:

- repository APIs
- database migrations
- persistence models

---

### Platform State

Owned by infrastructure services.

Examples:

- security-scoped bookmark access
- external drive availability
- AVPlayer state
- global hotkey registration
- NSPanel lifecycle

Use:

- infrastructure wrappers
- focused services
- clear status enums

---

## 3. Preferred Ownership

Use these defaults:

- Asset library state:
  - repository plus library ViewModel

- Selection state:
  - relevant list or flow ViewModel

- Search query state:
  - Search ViewModel or AssetListViewModel

- Preview playback state:
  - PreviewService or focused preview ViewModel

- Quick Peek state:
  - QuickPeekViewModel

- Bookmark state:
  - BookmarkStore / FileSystemAccess

- Workspace state:
  - WorkspaceManager

- Import progress:
  - ImportViewModel plus import service

- Duplicate scan state:
  - DuplicateDetectionService plus scan session model

---

## 4. Single Source of Truth Rules

MUST:

- identify owner before adding state
- keep writes inside owner or owner-approved actions
- expose read-only state when possible
- persist only through repositories
- keep platform state behind infrastructure services

MUST NOT:

- duplicate same state across multiple ViewModels
- mutate shared state directly from SwiftUI Views
- store database state only in `@State`
- use `@EnvironmentObject` for convenience
- create hidden singleton mutable state
- let Quick Peek mutate MainWindow state directly without design reason

---

## 5. EnvironmentObject Rules

Use `@EnvironmentObject` sparingly.

Allowed for:

- stable app-wide container
- app settings view model if truly global
- theme or UI preference state

Avoid for:

- selected asset
- search query
- preview playback
- import progress
- temporary screen state
- feature-specific state

If using `@EnvironmentObject`, document why the state is app-wide.

---

## 6. Dependency Container

A small app-level dependency container is allowed.

It may own:

- repositories
- services
- infrastructure adapters
- app settings
- shared factories

It should not become a giant mutable app state object.

Prefer:

- `AppContainer`
- explicit service properties
- injection into ViewModels

Avoid:

- service locator behavior from random views
- mutable global access
- implicit runtime dependencies

---

## 7. ViewModel Actions

ViewModels should expose intent methods.

Good examples:

- `performSearch()`
- `selectAsset(_:)`
- `togglePreview()`
- `assignSelectedAssets(to:)`
- `refreshMissingAssetStatus()`

Avoid exposing raw mutable collections for outside mutation.

Prefer:

- method calls
- read-only published state
- explicit state transitions

---

## 8. State Enums

Use enums for multi-state flows.

Good candidates:

- import state
- preview state
- bookmark state
- file availability
- duplicate scan state
- workspace cleanup state

Example states:

- idle
- loading
- ready
- failed
- permissionDenied
- volumeOffline
- missing
- recoverable

Avoid using multiple booleans when one enum is clearer.

---

## 9. Selection State

Selection should be stable and clear.

Rules:

- one owner per UI flow
- selection should survive list refresh when asset still exists
- missing asset should not crash selection
- selection should update right panel
- Quick Peek selection should not accidentally overwrite main selection unless intended

---

## 10. Search State

Search state should include:

- query
- active filters
- sort order
- result list
- loading state if needed

Search should not own:

- raw database connection
- file system access
- preview playback internals

Search query should be normalized by SearchService or related search layer.

---

## 11. Preview State

Preview state should include:

- selected preview asset
- playback status
- loading status
- failure status
- permission or missing-file state

Preview should not silently fail.

Preview should not block the main UI while preparing.

Rapid selection changes must not leave stale playback.

---

## 12. Bookmark and File Access State

Bookmark and file access state should be explicit.

Use states such as:

- available
- missing
- volumeOffline
- permissionDenied
- staleBookmark
- resolving
- recoverable

Do not encode these states as a single optional URL.

Do not delete records when file access fails.

---

## 13. Workspace State

Workspace state should include:

- current workspace root
- default workspace root
- migration status
- cleanup status
- derived asset relation
- orphan status

Workspace changes are non-trivial.

Moving workspace location requires clear state transition and verification.

---

## 14. Concurrency and State

UI state updates should happen on MainActor.

Long-running work should not mutate UI state directly from background tasks.

Use services or actors for shared mutable background state.

Be careful with:

- import queue
- duplicate scan
- hash calculation
- preview loading
- bookmark refresh
- workspace cleanup

---

## 15. Handoff Requirements

For state changes, handoff should include:

- state owner
- readers
- writers
- persistence boundary
- reset behavior
- verification performed
- skipped checks
- known risks

---

## 16. Review Checklist

Before finishing state-related work, check:

- Is there one owner?
- Are writes controlled?
- Is state duplicated?
- Is `@EnvironmentObject` justified?
- Is persistence separated?
- Is platform state isolated?
- Are recoverable states explicit?
- Is handoff clear?
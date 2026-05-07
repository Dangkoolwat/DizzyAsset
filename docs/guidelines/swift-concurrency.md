# Swift Concurrency Guideline

Use this guideline when changing async code, background work, indexing, preview loading, database access, file access, analysis jobs, or UI state updates.

DizzyAsset targets Swift 6 strict concurrency.

Prefer correctness over clever concurrency.

---

## 1. Core Principles

MUST:

- use async/await when practical
- keep UI updates on MainActor
- keep heavy work off the main thread
- avoid data races
- make shared mutable state explicit
- report concurrency warnings honestly
- preserve user data safety

MUST NOT:

- block the main thread with file scanning
- block the main thread with hashing
- block the main thread with AVFoundation loading
- block the main thread with SQLite queries over large data
- mutate UI state from background tasks
- use detached tasks casually
- ignore Swift 6 concurrency warnings

---

## 2. MainActor Rules

UI state belongs on MainActor.

Use MainActor for:

- SwiftUI ViewModel observable state
- selection state exposed to UI
- loading state exposed to UI
- error state exposed to UI
- preview status shown in UI
- import progress shown in UI

Do not perform heavy work on MainActor.

Good pattern:

- ViewModel starts task
- service performs work off main thread
- ViewModel receives result
- ViewModel updates UI state on MainActor

Avoid:

- hashing in ViewModel on MainActor
- folder scan in View body
- AVAsset metadata extraction blocking UI
- SQLite full scan from UI event without async boundary

---

## 3. Task Usage

Use `Task` for user-triggered async work when needed.

Examples:

- import folder
- run duplicate scan
- load preview
- refresh missing file status
- resolve bookmarks
- update search results

Rules:

- keep task lifetime clear
- cancel old task when new state supersedes it
- avoid unbounded task creation
- avoid detached tasks unless justified
- store task handles when cancellation matters

Good candidates for cancellation:

- search-as-you-type
- preview loading during rapid selection
- waveform generation
- metadata loading
- duplicate scan if user cancels

---

## 4. Task Cancellation

Cancellation is part of correctness.

MUST check cancellation in long-running work.

Long-running work includes:

- recursive folder scan
- full duplicate rescan
- full hash calculation
- waveform generation
- speech or vision analysis
- workspace cleanup
- search indexing

When cancelled:

- stop work safely
- do not leave partial DB state without status
- do not delete files
- surface cancellation if user-visible

---

## 5. Actors

Use actors for shared mutable state when useful.

Good actor candidates:

- import queue state
- duplicate scan coordinator
- preview session coordinator
- bookmark restore coordinator
- workspace cleanup coordinator

Do not create actors for every type.

Use actors when there is real shared mutable state or sequencing.

Actors should not directly own SwiftUI Views.

---

## 6. Sendable

Respect Swift 6 Sendable checks.

MUST:

- avoid passing non-Sendable mutable objects across concurrency boundaries
- make value models Sendable when appropriate
- keep platform objects isolated when they are not Sendable
- avoid unsafe Sendable conformance unless justified

Be careful with:

- AVFoundation objects
- AppKit objects
- SQLite connection handles
- file handles
- security-scoped resource handles
- NSItemProvider / drag objects

If unsafe conformance is used, explain why in a comment and handoff.

---

## 7. Database Concurrency

Database access must be serialized or otherwise concurrency-safe.

Rules:

- do not share unsafe SQLite connection across tasks without coordination
- keep writes controlled
- keep migrations exclusive
- avoid UI-thread full scans
- use repository boundary
- report database failures

Recommended:

- one database queue or actor
- explicit repository methods
- transaction for grouped writes
- background work for expensive reads

High-risk:

- migration
- schema rewrite
- deleting records
- asset_locations update
- bookmark_data update
- derived asset relation changes

---

## 8. File System Concurrency

File scanning and hashing must run off the main thread.

Rules:

- recursive scan should be cancellable
- hash calculation should be background work
- partial hash should run before full hash when possible
- full hash should be delayed until needed
- external drive failures should be recoverable
- permission errors should be surfaced

Do not assume external storage is always available.

Do not drop records just because a file is temporarily unavailable.

---

## 9. Bookmark Concurrency

Security-scoped bookmark resolution can affect file access state.

Rules:

- avoid resolving the same bookmark repeatedly in parallel
- coordinate startup restoration
- handle stale bookmark refresh carefully
- update UI-visible state on MainActor
- preserve asset records on failure
- mark recoverable states explicitly

Relevant states:

- available
- resolving
- staleBookmark
- permissionDenied
- volumeOffline
- missing
- recoverable

---

## 10. Preview Concurrency

Preview must remain stable during rapid selection changes.

Rules:

- cancel previous preview load when selection changes
- avoid stale playback after selection changes
- avoid multiple players fighting over state
- report unsupported format
- report missing file
- report permission denied
- avoid blocking UI while preparing preview

Preview state should be explicit.

Examples:

- idle
- loading
- ready
- playing
- paused
- failed

---

## 11. Search Concurrency

Search-as-you-type may create frequent work.

Rules:

- debounce if needed
- cancel stale searches
- return latest query result only
- avoid blocking UI
- avoid full table scan on every keystroke for large libraries
- prefer normalized/indexed search as library grows

Search result ordering must be deterministic when possible.

---

## 12. Import and Indexing Concurrency

Import can touch many systems.

Flow may include:

- folder scan
- duplicate check
- metadata extraction
- DB insert
- analysis queue
- UI progress

Rules:

- keep UI responsive
- batch database writes when useful
- report progress
- allow cancellation
- preserve partial success information
- report failures per file when possible

Do not fail the whole import because one file fails.

---

## 13. Analysis Jobs

Analysis jobs may be heavy.

Examples:

- waveform generation
- silence detection
- Sound Analysis
- Speech
- Vision
- LLM-based analysis

Rules:

- run heavy analysis in background
- limit concurrency if resource-heavy
- do not block import completion on optional analysis
- store analysis status
- support retry where practical
- keep provider structure replaceable

Vision/Speech are not MVP runtime requirements unless explicitly assigned.

---

## 14. AppKit and AVFoundation

AppKit and AVFoundation may have thread or lifecycle constraints.

Rules:

- isolate AppKit UI work to main thread
- isolate NSPanel behavior
- avoid passing AppKit objects across tasks
- be careful with AVPlayer lifecycle
- be careful with AVAsset loading
- document platform workarounds

Quick Peek changes are high-risk.

Preview engine changes are non-trivial or high-risk depending on scope.

---

## 15. Error Handling

Async errors must be visible.

MUST:

- propagate meaningful errors
- map technical errors to user-visible state where needed
- preserve original error context for logs
- report skipped verification

MUST NOT:

- swallow errors in catch blocks
- convert all errors into generic failure
- ignore cancellation
- hide permission errors
- hide external drive offline state

---

## 16. Testing and Verification

For concurrency changes, verification should include:

- build
- relevant focused flow
- cancellation case if applicable
- rapid repeated action if applicable
- failure state if applicable

Specific checks:

- rapid search typing
- rapid arrow selection
- repeated Space preview toggle
- large folder import
- duplicate scan cancellation
- external drive reconnect if file access touched
- app restart if bookmark restoration touched

Report what was not tested.

---

## 17. Review Checklist

Before finishing concurrency work, check:

- Is UI work on MainActor?
- Is heavy work off MainActor?
- Is cancellation handled?
- Is shared mutable state protected?
- Are Sendable warnings addressed?
- Are platform objects isolated?
- Are errors visible?
- Are recoverable file states preserved?
- Did I avoid detached tasks unless justified?
- Did I report verification honestly?
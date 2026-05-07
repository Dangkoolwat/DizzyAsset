# Swift Concurrency

**Document:** `docs/guidelines/swift-concurrency.md`  
**Related Skill:** `swift-concurrency`

## 1. Concurrency Standards
- Use Swift 6 strict concurrency rules.
- Prefer async/await and structured concurrency.
- **MainActor:** Keep all UI updates and UI state on the MainActor.

## 2. Thread Safety
- **Forbidden on Main Thread:** File scanning, hashing, AVFoundation loading, or SQLite work.
- Use actors or isolated services for shared mutable state.
- Avoid detached tasks unless there is a strong architectural reason.

## 3. High-Performance Jobs
- Long-running indexing or duplicate scanning must be cancelable and background-prioritized.
- Use structured concurrency (task groups) for parallel hashing or thumbnail generation.

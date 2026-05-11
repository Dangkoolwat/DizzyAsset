# Style and Conventions for DizzyAsset

## Naming & Style
- Follow `docs/guidelines/apple-coding-style.md`.
- Use surgical changes; do not "polish" adjacent code.
- Suppress instinct to fix linter warnings unless explicitly asked.

## Documentation
- Follow `docs/guidelines/comments-and-docs.md`.
- Preserve existing comments and docstrings.

## Architecture
- **SwiftUI**: Follow `docs/guidelines/swiftui-architecture.md`.
- **State Management**: Follow `docs/guidelines/state-management.md` (SSOT).
- **Concurrency**: Follow `docs/guidelines/swift-concurrency.md` (Async/await, actors).
- **Persistence**: Follow `docs/guidelines/sqlite-migration.md`.

## Quality
- Minimal required logic.
- No speculative abstraction.
- No removal of default parameters for local cases.

# SwiftUI Architecture

**Document:** `docs/guidelines/swiftui-architecture.md`  
**Related Skill:** `swiftui-expert-skill`

## 1. Layered Architecture
Keep layers strictly separated. Do not bypass layers without a task-driven reason.

### SwiftUI View
- Render UI and own local UI-only state (`@State`).
- Forward user intent to ViewModel.
- Stay small and composable.
- **Forbidden:** Direct persistence or file-system logic.

### ViewModel
- Own screen state and coordinate use cases.
- Expose simple observable state.
- Translate user intent into domain actions.
- **Forbidden:** Raw SQLite or raw file-system access.

### Domain
- Own business rules, entities, and use case protocols.
- **Forbidden:** SwiftUI or AppKit UI dependency.

### Data
- Own persistence, repository implementations, and database mapping.

### Infrastructure
- Own file system access, bookmarks, and platform bridges (AVFoundation, AppKit).
- Hide platform details behind clear interfaces.

## 2. SwiftUI View Rules
- Avoid massive view bodies; use composition.
- Use `@StateObject` for view-owned ViewModels.
- Use `@ObservedObject` for injected ViewModels.
- Avoid business logic or database access inside `body`.
- Use AppKit bridge only when SwiftUI is insufficient; isolate `NSViewRepresentable` logic.

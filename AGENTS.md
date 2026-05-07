# Repository Guidelines

## 🛠 Mandatory Agent Skills
Any agent working on this repository MUST load and follow these specialized skills:
- `swiftui-expert-skill`: Follow for all UI components, state management, and macOS-specific views.
- `swift-concurrency`: Follow for all asynchronous logic (Swift 6 strict concurrency checks).
- `karpathy-guidelines`: Follow for surgical changes, avoiding over-abstraction, and maintaining code quality.
- `xcode-project-analyzer`: Use when auditing build settings, scheme behavior, or `project.yml` changes.

## 🏗 Project Structure & Module Organization
This repository is a macOS SwiftUI app managed with XcodeGen. Source code lives under `DizzyAsset/`:

- `DizzyAsset/App/` for the app entry point and lifecycle
- `DizzyAsset/Presentation/` for SwiftUI views, ViewModels, and shared UI helpers
- `DizzyAsset/Domain/` for business logic, entities, and use cases (Protocol-first)
- `DizzyAsset/Data/` for data persistence (SQLite/FTS5) and repository implementations
- `DizzyAsset/Resources/` for entitlements, asset catalogs, and branded images

## 📄 Product Documentation (Context-Aware Reference)
To minimize token usage, DO NOT read all documents at once. Follow these rules:
- **New Features**: Only read the specific section of `docs/product/dizzyasset_v1_prd.md` related to the task.
- **UI/Architecture**: Refer to `docs/product/dizzyasset_design_doc.md` only when changing shared UI components or core architecture.
- **Task Tracking**: Check `docs/product/dizzyasset_development_plan.md` to see the current progress and next steps.

The project file is generated from `project.yml`; do not edit the Xcode project manually.

## ⚙️ Build, Test, and Development Commands
- `xcodegen generate`: Creates `DizzyAsset.xcodeproj`. **CRITICAL: Must be run after adding/deleting/moving any source files.**
- `open DizzyAsset.xcodeproj`: Opens the app in Xcode.
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`: CLI build command.

## 🎨 Coding Style & Naming Conventions
Use standard Swift style (Swift 6.0+ with strict concurrency).
- **Style**: 4-space indentation, `UpperCamelCase` for types, `lowerCamelCase` for methods/properties.
- **SwiftUI**: Keep views small and composable. Use `@StateObject`/`@ObservedObject` correctly per `swiftui-expert-skill`.
- **Naming**: Prefer descriptive names (e.g., `AssetIndexingManager`, `SearchResultRow`). Use `enum` namespaces for constants.

## Testing Guidelines
Place future unit tests in `DizzyAssetTests/` and UI tests in `DizzyAssetUITests/`. Name test methods to describe behavior, for example `testSelectionUpdatesDetailPane()`. Focus coverage on view state, data transformation, and any file or indexing logic before UI-only behavior.

## Commit & Pull Request Guidelines
Git history is minimal, but existing commits use a conventional prefix style such as `chore: initial project setup with clean architecture and xcodegen`. Follow the same pattern: `feat:`, `fix:`, `chore:`, and keep the subject imperative and brief. Pull requests should include a short summary, linked issue or task when available, screenshots for UI changes, and notes about any XcodeGen or entitlement changes.

## Configuration Notes
The app requests access to Desktop, Downloads, removable volumes, and Apple Events. Review changes to `DizzyAsset/Resources/DizzyAsset.entitlements` and related `INFOPLIST_KEY_*` settings carefully, since they affect runtime permissions and app review behavior.

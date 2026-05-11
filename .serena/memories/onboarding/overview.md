# DizzyAsset Project Overview

## Project Purpose
DizzyAsset is a macOS application designed for asset management, potentially with Final Cut Pro integration, AI analysis, and media preview capabilities.

## Tech Stack
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Persistence**: SQLite (with FTS5)
- **Infrastructure**: AVFoundation, AppKit
- **Project Management**: XcodeGen (generates `.xcodeproj` from `project.yml`)

## Codebase Structure
- `DizzyAsset/App/`: Entry point & composition.
- `DizzyAsset/Presentation/`: SwiftUI & ViewModels.
- `DizzyAsset/Domain/`: Business logic & Entities.
- `DizzyAsset/Data/`: Persistence & Repositories.
- `DizzyAsset/Infrastructure/`: Platform bridges (AVFoundation, AppKit).
- `DizzyAsset/Resources/`: Entitlements, Assets, Info.plist.

## Operating Principles
- **Precision First**: Small surgical changes.
- **Evidence-Based**: Verification through commands.
- **Context Economy**: Read only what is needed.
- **Zero Trust**: No assumptions, inspect code before writing.

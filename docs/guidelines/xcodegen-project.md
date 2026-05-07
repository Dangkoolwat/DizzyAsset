# XcodeGen & Project Structure

**Document:** `docs/guidelines/xcodegen-project.md`  
**Related Skill:** `xcode-project-analyzer`

## 1. Project Management
- DizzyAsset uses **XcodeGen** to manage the `.xcodeproj` file.
- **Source of Truth:** `project.yml`.
- **Forbidden:** Manual changes to the `.xcodeproj` file in Xcode (except for temporary debugging).

## 2. XcodeGen Workflow
- After adding, moving, or deleting any file: Run `xcodegen generate`.
- After changing build settings or schemes: Update `project.yml` and run `xcodegen generate`.

## 3. Project Structure
- `DizzyAsset/App/`: Entry point & composition.
- `DizzyAsset/Presentation/`: SwiftUI & ViewModels.
- `DizzyAsset/Domain/`: Business logic & Entities.
- `DizzyAsset/Data/`: Persistence & Repositories.
- `DizzyAsset/Infrastructure/`: Platform bridges (AVFoundation, AppKit).
- `DizzyAsset/Resources/`: Entitlements, Assets, Info.plist.

## 4. Build Settings & Schemes
- Maintain separate configurations for `Debug` and `Release`.
- Keep schemes clean and synchronized with the current target structure.

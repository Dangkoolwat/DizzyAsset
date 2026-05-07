# State Management

**Document:** `docs/guidelines/state-management.md`  
**Related Skill:** `swiftui-expert-skill`

## 1. Single Source of Truth (SSOT)
- Every piece of data should have one clear owner.
- Avoid duplicate source of truth across multiple ViewModels.

### Ownership Map
- **Asset Library:** Repository / Shared Asset Service.
- **Selection:** relevant Feature ViewModel.
- **Search Query:** Search ViewModel.
- **Preview Playback:** PreviewService or focused Preview ViewModel.
- **File Access State:** BookmarkStore / FileSystemAccess.
- **Workspace State:** WorkspaceManager.

## 2. Shared State Rules
- Use `@EnvironmentObject` only for truly app-wide stable state.
- Prefer explicit dependency injection for feature-level state.
- **Forbidden:** Direct mutation of shared state from SwiftUI Views.

## 3. Implementation Process
When adding new shared state, document:
1. Owner
2. Readers/Writers
3. Persistence boundary
4. Reset behavior

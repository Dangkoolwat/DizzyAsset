# macOS File Access and Sandbox

**Document:** `docs/guidelines/macos-file-access.md`  
**Related Skill:** `macos-sandbox-security-skill`

## 1. File Access Integrity
- DizzyAsset depends on security-scoped bookmarks for external/user-selected files.
- **Never silently drop an asset record** because a file is missing.
- Mark states explicitly: `volume_offline`, `permission_denied`, `missing`.

## 2. Bookmark Policy
- Always attempt to resolve stored bookmarks with security scope.
- Refresh stale bookmarks immediately and save back to the repository.
- Support retry/reconnect UX for external drives.

## 3. Permissions
- Do not change entitlements or sandbox settings without explicit approval.
- Handle AppKit/SwiftUI sandbox edge cases (e.g., OpenPanel vs stored bookmarks).

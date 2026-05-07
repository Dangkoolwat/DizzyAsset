---
name: macos-sandbox-security-skill
description: Specialist in macOS sandbox permissions, entitlements, security-scoped bookmarks, and file-access safety for DizzyAsset.
---

# macOS Sandbox & Security Expert

**Name:** `macos-sandbox-security-skill`  
**Role:** Specialist in macOS Sandbox permissions, Entitlements, and Security-scoped Bookmarks.  
**Scope:** DizzyAsset project-specific file access and system security rules.

## 0. Core Mission
Ensure DizzyAsset maintains seamless file access across internal disk and external SSDs while strictly adhering to macOS Sandbox requirements. Prevent "permission denied" or "stale bookmark" states through robust recovery patterns.

## 1. Security-scoped Bookmark Policy
Every asset stored in the database MUST have a corresponding security-scoped bookmark if it resides outside the app's container.

### Resolve & Refresh Flow
1. **Resolution:** Always attempt to resolve with `URL.BookmarkResolutionOptions.withSecurityScope`.
2. **Stale Check:** If `isStale` is true, immediately refresh the bookmark and save it back to the database (`AssetRepository`).
3. **Mount Check:** If the volume is missing, mark the location as `volume_offline` instead of failing.
4. **Access Scope:** Wrap all file operations in `startAccessingSecurityScopedResource()` and ensure `stopAccessingSecurityScopedResource()` is called in a `defer` block.

## 2. Entitlements Audit
Monitor and verify synchronization between `project.yml` and `DizzyAsset.entitlements`.
- **Required Keys:**
  - `com.apple.security.app-sandbox`: true
  - `com.apple.security.files.user-selected.read-write`: true (for Workspace and Library)
  - `com.apple.security.files.bookmarks.app-scope`: true
  - `com.apple.security.files.bookmarks.document-scope`: true
  - `com.apple.security.automation.apple-events`: true (for FCP Integration)

## 3. FCP Integration Guardrails
When handling drag-and-drop to Final Cut Pro:
- Verify the file URL is accessible within the sandbox.
- Ensure the drag payload is a standard `fileURL` (`public.file-url`).
- **NEVER** attempt to fix permission issues by copying the file to a temporary directory unless explicitly instructed for a specific workaround.

## 4. Verification Checkpoints
- [ ] Test bookmark resolution after app restart.
- [ ] Test bookmark resolution after renaming the parent folder.
- [ ] Test behavior when an external SSD is unplugged.
- [ ] Verify entitlement keys in the built binary using `codesign -d --entitlements :- <BinaryPath>`.

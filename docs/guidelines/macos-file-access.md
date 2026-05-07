# macOS File Access Guideline

Use this guideline when changing file access, sandbox behavior, security-scoped bookmarks, external drive handling, missing file states, or permission recovery.

DizzyAsset is a logical indexing app.

Original files stay where the user keeps them.

---

## 1. Core Principles

MUST:

- preserve original files
- preserve asset records
- use recoverable states
- surface permission failures
- handle external storage
- avoid destructive cleanup
- respect sandbox behavior

MUST NOT:

- move original files automatically
- delete original files automatically
- rewrite original files automatically
- silently drop asset records
- hide permission failures
- use hidden copying as a workaround
- change entitlements without explicit approval

---

## 2. Original File Policy

Original files may live in:

- internal disk
- external SSD
- Downloads
- Desktop
- user-selected folders
- NAS or mounted volumes

DizzyAsset stores:

- location
- bookmark
- metadata
- tags
- categories
- analysis
- usage history

DizzyAsset does not own the original file.

When original access fails, mark state.

Do not delete records.

---

## 3. App Data Location

App internal data belongs under:

    ~/Library/Application Support/DizzyAsset/

This may include:

- Database
- Settings
- Index
- Bookmarks
- AIAnalysis

Do not put app memory in the workspace.

Do not put app memory next to original user files.

---

## 4. Workspace Location

Workspace output belongs under:

    ~/DizzyAsset/

by default.

Workspace may be changed by the user.

Workspace may move to:

- external SSD
- NAS
- user-selected folder

Workspace contains generated or derived data only.

Examples:

- preview cache
- waveform data
- derived assets
- converted assets
- temp files
- analysis output

---

## 5. Security-Scoped Bookmarks

Use security-scoped bookmarks for persistent file access in sandboxed macOS contexts.

Bookmark data may be stored for:

- original file
- containing folder
- external volume
- workspace root

Rules:

- store bookmark data securely in app database or bookmark store
- resolve bookmark before accessing protected files
- call startAccessingSecurityScopedResource when needed
- call stopAccessingSecurityScopedResource when access ends
- handle stale bookmarks
- refresh stale bookmark when possible
- preserve old record if refresh fails

Do not log raw bookmark data.

---

## 6. Bookmark Resolve Flow

Recommended flow:

1. Load asset location.
2. Try to resolve bookmark.
3. If resolved and not stale, access file.
4. If resolved but stale, refresh bookmark.
5. Save refreshed bookmark if successful.
6. If volume is offline, mark `volumeOffline`.
7. If permission is denied, mark `permissionDenied`.
8. If file is missing, mark `missing`.
9. If recovery may be possible, mark `recoverable`.

Do not collapse all failures into one generic error.

---

## 7. External Drive Reconnect

External SSD workflow is product-critical.

When a drive reconnects:

- retry bookmark resolution
- refresh stale bookmark if possible
- update location status
- keep asset relations
- keep tags and categories
- keep usage history
- update UI-visible state

Do not require users to reimport everything.

Do not delete asset records because a drive was offline.

---

## 8. File Status Values

Use explicit status values.

Recommended statuses:

- available
- resolving
- missing
- volumeOffline
- permissionDenied
- staleBookmark
- recoverable

Avoid using only optional URL.

Avoid using only boolean `isMissing` when more detail is needed.

---

## 9. Missing File Handling

Missing file does not mean deleted asset.

Possible causes:

- external drive offline
- file moved
- file renamed
- permission expired
- bookmark stale
- volume renamed
- network volume unavailable

Rules:

- preserve database record
- show missing or offline state
- allow reconnect
- avoid silent removal
- avoid destructive cleanup

---

## 10. Permission Denied Handling

Permission denied should be user-visible.

UI should allow:

- reconnect
- choose new location
- retry access
- open settings if relevant

Do not treat permission denied as file missing.

Do not hide permission denied behind generic failure.

---

## 11. Volume Offline Handling

Volume offline is recoverable.

When volume is offline:

- keep asset visible if useful
- show offline status
- disable preview/drag if file is unavailable
- allow reconnect flow
- retry when volume appears if supported

Do not reclassify volume offline as deleted.

---

## 12. Reconnect Flow

Reconnect flow should allow the user to choose:

- original file
- containing folder
- replacement volume
- workspace root, if workspace moved

After reconnect:

- validate file identity if possible
- update asset_locations
- refresh bookmark
- preserve tags/categories/usage
- report status clearly

Validation may use:

- file name
- file size
- modified date
- partial hash
- full hash if needed

---

## 13. File Identity

Do not rely only on path.

Useful identity signals:

- path
- file size
- modified date
- partial hash
- full hash
- volume identifier
- bookmark identity

Path duplicate and content duplicate are different concepts.

Moving a file may change path but not content.

External drive rename may change path behavior.

---

## 14. Drag and Preview Access

Preview and Final Cut Pro drag both require file access.

Before preview:

- resolve bookmark
- check availability
- surface permission failure
- avoid blocking UI

Before drag:

- resolve file URL
- confirm file is available
- avoid hidden copying
- return user-visible failure if access fails

---

## 15. Entitlements

Entitlements are protected.

Do not change without explicit approval.

Protected examples:

- App Sandbox
- Downloads folder access
- Desktop folder access
- removable volumes
- Apple Events
- file access permissions

If a task requires entitlement change, stop and report.

---

## 16. Logging

Log useful diagnostics.

Good log topics:

- bookmark resolution failure
- stale bookmark refresh
- volume offline detection
- permission denied
- reconnect attempt
- file identity mismatch

Do not log:

- secrets
- raw bookmark data
- private user file content
- huge paths unnecessarily

---

## 17. Testing and Verification

File access verification should include:

- internal file access
- Downloads file access if relevant
- external SSD file access if available
- app restart restore
- stale bookmark scenario if possible
- volume offline state
- permission denied state
- reconnect flow

Report what was not tested.

---

## 18. Stop Conditions

Stop and report if:

- entitlement change is required
- sandbox behavior is unclear
- bookmark refresh behavior is unclear
- external storage behavior cannot be verified
- reconnect flow risks data loss
- workaround requires hidden copying
- code would delete asset records on access failure

Do not guess around macOS permission behavior.

---

## 19. Handoff Requirements

For file access work, handoff must include:

- files changed
- permission area touched
- bookmark behavior changed
- asset location behavior changed
- verification run
- external drive tested:
  - yes/no
- app restart tested:
  - yes/no
- skipped checks
- known risks
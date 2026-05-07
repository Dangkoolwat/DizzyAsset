# DA-021 Bookmark & External Storage Recovery — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-021  
**Task name:** Bookmark & External Storage Recovery  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** High  
**Target repo path:** `docs/task/DA-021-bookmark-external-storage-recovery.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first bookmark and external storage recovery foundation.

DizzyAsset must support users who keep assets on external SSDs, removable drives, mounted volumes, or user-selected folders.

This task should make file access state recoverable and explicit.

The app must not delete asset records when a drive is offline or a bookmark cannot be resolved.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-021 task prompt
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Safety/platform guidelines in `docs/guidelines/`
8. Existing code patterns

Raw chat is not implementation scope.

---

## 3. Required Reading

Always read:

- `AGENTS.md`
- this task prompt
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/workspace-lifecycle.md`
- `docs/guidelines/final-cut-pro-integration.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `macos-sandbox-security-skill`
  - required for bookmark, sandbox, external storage, entitlements review

- `swift-concurrency`
  - startup restoration, retry, async file access

- `sqlite-fts-optimizer`
  - asset_locations schema or status persistence if touched

- `karpathy-guidelines`
  - keep implementation scoped

- `code-review-graph`
  - required after non-trivial/high-risk implementation

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- security-scoped bookmark storage boundary
- bookmark resolve flow
- stale bookmark detection
- stale bookmark refresh if possible
- asset location status model
- external volume offline state
- permission denied state
- missing file state
- reconnect/retry hook
- startup restoration hook if safely scoped
- safe persistence of asset location status

Possible statuses:

- available
- resolving
- missing
- volumeOffline
- permissionDenied
- staleBookmark
- recoverable

---

## 6. Out of Scope

Do not implement:

- full reconnect UI wizard
- mass relink UI
- Finder sync
- Final Cut Pro drag changes unless needed for file access check
- workspace migration
- destructive cleanup
- entitlement changes without approval
- Apple Events changes
- release/signing/notarization

Do not change protected areas without explicit approval.

---

## 7. Implementation Guidance

Possible components:

- `BookmarkStore`
- `FileSystemAccess`
- `AssetLocationStatus`
- `AssetLocationRecoveryService`
- `ExternalStorageMonitor`
- `BookmarkResolutionResult`

Keep API focused.

Do not spread bookmark logic into SwiftUI Views.

Do not delete records on failure.

---

## 8. Bookmark Resolve Flow

Recommended flow:

1. Load asset location.
2. Try to resolve bookmark.
3. If resolved and not stale, mark available.
4. If resolved but stale, refresh bookmark if possible.
5. If volume is offline, mark volumeOffline.
6. If permission is denied, mark permissionDenied.
7. If file is missing, mark missing.
8. If recovery may be possible, mark recoverable.
9. Preserve asset, tag, category, and usage records.

Do not collapse all failures into generic error.

---

## 9. External Storage Rules

External SSD workflow is product-critical.

Rules:

- offline drive does not mean deleted asset
- app restart should attempt restoration where safe
- drive reconnect should allow retry
- volume rename should not destroy records
- permission denied should be visible
- reconnect should preserve relationships

Do not require reimport when recovery is possible.

---

## 10. Database Rules

If persistence exists:

- store bookmark data safely
- store location status
- store last seen path if useful
- avoid destructive migration
- preserve asset records
- preserve relations

Do not log raw bookmark data.

Do not expose bookmark data to UI.

---

## 11. UI / State Rules

If UI is touched:

- show offline state
- show permission denied state
- show missing state
- show retry/reconnect action if scoped
- visual evidence is required

If UI is not touched:

- expose clear status for future UI

---

## 12. Verification

Full Verification is required.

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

File access verification should include:

- internal file bookmark restore if implemented
- external SSD bookmark restore if available
- app restart behavior if possible
- stale bookmark behavior if possible
- volume offline state
- permission denied state if practical
- no asset record deletion

Report skipped checks.

---

## 13. Visual Evidence

If UI is changed, visual evidence is required.

Store under:

- `artifacts/YYYY-MM-DD/DA-021/`

If no UI changed, state not applicable.

---

## 14. Stop Conditions

Stop and report if:

- entitlement change is required
- sandbox behavior is unclear
- bookmark refresh behavior is unclear
- external storage behavior cannot be verified
- recovery flow risks data loss
- database migration may delete or rewrite user data
- code would delete asset records on access failure
- task expands into full reconnect UI or FCP integration

---

## 15. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-021
- Risk level: High
- files changed
- bookmark behavior changed
- asset location status changed
- database migration:
  - none/non-destructive/other
- external drive tested:
  - yes/no
- app restart tested:
  - yes/no
- visual evidence:
  - path/not applicable
- verification run
- skipped checks
- known risks
- next suggested task

---

## 16. Expected Completion Criteria

DA-021 is complete when:

- bookmark recovery foundation exists
- external storage states are explicit
- stale/missing/permission states are recoverable
- asset records are preserved
- full verification is reported
- handoff is produced

---

## 17. Suggested Next Task

After DA-021:

- DA-022 Workspace Lifecycle Manager

Do not start DA-022 in this task.

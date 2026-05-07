# DA-025 Batch Metadata Edit — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-025  
**Task name:** Batch Metadata Edit  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation / Enrichment  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-025-batch-metadata-edit.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Enable users to select multiple assets and perform batch operations on their metadata (tags and categories).
This is a critical "Power User" feature for large library organization.

Operations:
- **Batch Add Tags:** Append tags to all selected assets.
- **Batch Remove Tags:** Remove specific tags from all selected assets.
- **Batch Set Category:** Move all selected assets to a single category.
- **Batch Clear Category:** Remove categories from all selected assets.

---

## 2. Source of Truth

Follow:
1. Explicit implementation request
2. `AGENTS.md`
3. This DA-025 task prompt
4. `docs/guidelines/swiftui-architecture.md`
5. `docs/guidelines/state-management.md`

---

## 3. Required Reading

Always read:
- `AGENTS.md`
- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/state-management.md`
- `docs/templates/handoff.md`

---

## 4. In Scope

- Update `AssetListView` to support multi-selection (`Set<Int64>`).
- Update `AssetListViewModel` to track multiple selected IDs.
- Create a `BatchEditView` for the Right Panel (Asset Information Hub).
- Implement `MetadataService` methods for bulk updates.
- Ensure the UI reflects changes immediately across all selected rows.

---

## 5. Out of Scope

- Batch renaming of files.
- Batch deletion of files.
- Batch editing of technical metadata (duration, resolution, etc.).
- Undo/Redo support for batch operations (v1.5 goal).

---

## 6. Implementation Guidance

### UI: Multi-selection
Change `selectedAssetId: Int64?` to `selectedAssetIds: Set<Int64>` in the view and view model.
Update the `List` to use the set for selection.

### Right Panel: State Switch
The `AssetDetailView` should switch modes based on selection count:
- 0: "No selection" empty state.
- 1: Standard detail view (current).
- >1: "Batch Edit" view showing count and common metadata.

### Service: SQL Batching
Use `IN` clauses or multiple `INSERT/DELETE` statements within a single transaction for performance.
```sql
-- Example for batch tagging
INSERT OR IGNORE INTO asset_tags (asset_id, tag_id) 
SELECT id, ? FROM assets WHERE id IN (...)
```

---

## 7. Verification

- `xcodegen generate`
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`
- Verify:
  - Selecting 5 assets and adding "SFX" tag applies it to all 5.
  - Selecting 3 assets and changing category works for all 3.
  - Deselecting or changing selection updates the Right Panel instantly.
  - UI remains responsive during 100+ item batch updates.

---

## 8. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:
- Summary of multi-selection changes.
- Performance observations.
- Verification results.
- Next suggested task.

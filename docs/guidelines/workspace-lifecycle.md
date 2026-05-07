# Workspace Lifecycle

**Document:** `docs/guidelines/workspace-lifecycle.md`

## 1. Workspace Isolation
- Original files stay where they are.
- Workspace output belongs under `~/DizzyAsset/` by default.
- App internal memory (FTS index, local settings) belongs under `Application Support`.

## 2. File Categories
- **Derived/Generated:** Preserved assets linked to originals.
- **Cache/Temp:** Regeneratable data (thumbnails, waveforms); safe for periodic cleanup.

## 3. Maintenance Rules
- Do not mix original files with workspace output.
- Orphan derived assets should be marked as such, not deleted automatically.
- Temp cleanup must be safe and non-destructive to user metadata.

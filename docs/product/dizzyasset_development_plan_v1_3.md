# DizzyAsset Development Plan v1.3

## Source
- PRD: DizzyAsset v1.3 PRD
- Design Doc: DizzyAsset 개발 설계 문서
- Current project stage: active-development

---

## Goal

Deliver a macOS application that enables:
- Fast import of scattered assets (internal/external storage)
- Instant search and preview
- Editor-centric organization (tags/categories)
- Seamless drag & drop into Final Cut Pro

핵심 기준:

> 검색 → 미리듣기 → 드래그 → 완료

---

## In Scope

- File/Folder drag & drop
- Recursive media scan
- Metadata extraction
- Duplicate detection (hash-based)
- SQLite persistence
- 3-column UI
- Filename + tag search
- Space-based preview
- Tag/Category system (basic)
- Drag tagging
- Quick Peek (minimal)
- Final Cut Pro drag integration
- Silence detection (display only)

---

## Out of Scope

- LLM-based classification
- Full Vision/Speech analysis
- Audio trimming/export
- Cloud sync
- Collaboration

---

## UX Principles (Critical)

### 1. Speed First
- Search result latency must feel instant
- Preview must start immediately (target <300ms perceived delay)

### 2. Keyboard-Centric Flow
- Arrow keys + Space = primary interaction
- No forced mouse dependency

### 3. Zero Friction Usage
- No required import restructuring
- No forced file copying

### 4. Workflow Integration
- Drag to Final Cut Pro must always work
- No intermediate steps allowed

---

## Affected Areas

- SwiftUI UI layer
- AppKit bridge (Quick Peek / global hotkey)
- SQLite DB
- File system (bookmark handling)
- AVFoundation (preview + analysis)
- Drag & Drop system

---

## Implementation Tasks

### DA-001 App Foundation
- Goal: Setup app lifecycle + window
- Expected behavior: App launches with main 3-column shell
- Affected areas: App lifecycle, root navigation, window configuration
- Verification: App launches
- Risk: Low
- Dependencies: none

### DA-002 Database Layer
- Goal: SQLite schema + persistence
- Expected behavior: Asset, tag, category, workspace, duplicate scan records persist
- Affected areas: Database init, migration, repositories
- Verification: CRUD works
- Risk: Medium
- Dependencies: DA-001

### DA-003 Storage / Workspace Setup
- Goal: Initialize app internal data and default workspace
- Expected behavior: App data uses Application Support, workspace defaults to `~/DizzyAsset/`
- Affected areas: Storage settings, workspace manager, folder creation
- Verification: Required folders are created and settings persist
- Risk: Medium
- Dependencies: DA-002

### DA-004 File Import & Scan
- Goal: Drag & drop + recursive scan
- Expected behavior: Supported media files are discovered and queued
- Affected areas: File system, drag/drop, import queue
- Verification: Files indexed
- Risk: Medium
- Dependencies: DA-002, DA-003

### DA-005 Duplicate Detection
- Goal: Path duplicate + content duplicate detection
- Expected behavior: Already registered paths and identical contents are detected
- Affected areas: DuplicateDetectionService, hash service, import summary
- Verification: Duplicate skipped or reported
- Risk: Medium
- Dependencies: DA-004

### DA-006 Full Duplicate Rescan
- Goal: Settings/Tools based full duplicate scan
- Expected behavior: User can run full duplicate scan over library or selected scope
- Affected areas: Settings, duplicate scan session, background task
- Verification: Duplicate report generated
- Risk: Medium
- Dependencies: DA-005

### DA-007 Metadata Extraction
- Goal: Extract duration/type/basic media metadata
- Expected behavior: Metadata populated for supported assets
- Affected areas: AVFoundation, UniformTypeIdentifiers, metadata service
- Verification: Metadata populated
- Risk: Low
- Dependencies: DA-004

### DA-008 Asset List UI
- Goal: Display assets
- Expected behavior: List renders indexed assets with metadata and tags
- Affected areas: AssetListView, AssetListViewModel
- Verification: List renders correctly
- Risk: Low
- Dependencies: DA-002, DA-007

### DA-009 Search Engine
- Goal: Fast filename + tag + category search
- Expected behavior: Results update instantly
- Affected areas: SearchService, database query
- Verification: Results filtered correctly
- Risk: Medium
- Dependencies: DA-008

### DA-010 Preview Engine
- Goal: Space playback
- Expected behavior: Audio preview starts quickly and selection changes remain stable
- Affected areas: PreviewService, AVPlayer/AVFoundation
- Verification: Audio plays instantly
- Risk: Medium
- Dependencies: DA-008

### DA-011 Editing Language Tag System
- Goal: Korean/English editor-oriented tag system
- Expected behavior: Tags support Korean/English labels, aliases, suggested/confirmed states
- Affected areas: Tag model, tag repository, UI chips
- Verification: Tags persist and display correctly
- Risk: Medium
- Dependencies: DA-002

### DA-012 Category System
- Goal: Editable category tree with max depth 3
- Expected behavior: User can add, rename, move, merge, delete, and sort categories
- Affected areas: Category model, sidebar UI, category repository
- Verification: Category edits persist and depth limit is enforced
- Risk: Medium
- Dependencies: DA-011

### DA-013 Drag Tagging
- Goal: Assign assets to categories via drag
- Expected behavior: Dragging assets to category saves relation without moving files
- Affected areas: Sidebar, asset list, asset_categories relation
- Verification: Relation saved
- Risk: Medium
- Dependencies: DA-012

### DA-014 Right Panel Asset Information Hub
- Goal: Expand right panel into detailed asset information hub
- Expected behavior: Preview, path, tags, duplicate status, analysis, usage shown
- Affected areas: AssetDetailView, AssetDetailViewModel
- Verification: Selected asset information updates correctly
- Risk: Medium
- Dependencies: DA-008, DA-011, DA-012

### DA-015 Quick Peek
- Goal: Global search overlay
- Expected behavior: Opens fast, supports search and preview
- Affected areas: NSPanel, global hotkey, search/preview reuse
- Verification: Opens fast, preview works
- Risk: High
- Dependencies: DA-009, DA-010

### DA-016 Final Cut Integration
- Goal: Drag to FCP
- Expected behavior: File appears in Final Cut Pro timeline via file URL drag
- Affected areas: DragAndDropProvider, asset file access, permissions
- Verification: File appears in timeline
- Risk: High
- Dependencies: DA-004, DA-010

### DA-017 Silence Detection
- Goal: Detect silence
- Expected behavior: Front/back silence values displayed
- Affected areas: SilenceDetectionService, AVAssetReader, right panel
- Verification: Values displayed
- Risk: Medium
- Dependencies: DA-014

### DA-018 Derived Asset Management
- Goal: Represent generated/trimmed/converted files as derived assets
- Expected behavior: Derived assets are stored in workspace and linked to source assets
- Affected areas: Workspace manager, asset_derivations, file generation policies
- Verification: Derived asset relation saved
- Risk: Medium
- Dependencies: DA-003, DA-017

### DA-019 Preferences
- Goal: Minimal settings
- Expected behavior: Settings persist, workspace location can be viewed/changed
- Affected areas: PreferencesView, app_settings, workspace settings
- Verification: Settings persist
- Risk: Low
- Dependencies: DA-003

## Acceptance Criteria Mapping

- Import → DA-003
- Deduplication → DA-004
- Search → DA-007
- Preview → DA-008
- Tagging → DA-009/010
- FCP Integration → DA-012

---

## Execution Strategy

### Phase 1 (Core Loop)
- DA-001 ~ DA-008

### Phase 2 (Organization)
- DA-009 ~ DA-010

### Phase 3 (Workflow Integration)
- DA-011 ~ DA-012

### Phase 4 (Enhancement)
- DA-013 ~ DA-014

---

## Verification Plan

Manual test scenarios:

1. Drop folder → files indexed
2. Search → instant result
3. Space → preview works
4. Drag → FCP timeline insert

---

## Risks

- File permission (sandbox)
- External drive disconnect
- AVFoundation edge cases
- FCP drag compatibility

---

## Follow-ups

- LLM tagging
- Vision/Speech analysis
- Smart recommendations
- Audio trimming

---

## v1.3 Plan Updates

### New / Updated Tasks

- DA-003 Storage / Workspace Setup added
- DA-006 Full Duplicate Rescan added
- DA-011 Editing Language Tag System expanded
- DA-012 Category System expanded with max depth 3
- DA-014 Right Panel Asset Information Hub added
- DA-018 Derived Asset Management added

### Updated Core Scope

- Workspace default: `~/DizzyAsset/`
- App internal data: `~/Library/Application Support/DizzyAsset/`
- Duplicate detection: import-time automatic + full rescan
- Tagging: Korean/English editor-oriented tagging
- Category: editable, max depth 3
- Derived files: stored in workspace and linked to source assets

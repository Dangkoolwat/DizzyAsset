# DizzyAsset Development Plan v1.4

## Source
- PRD: DizzyAsset v1.4 PRD
- Design Doc: DizzyAsset 개발 설계 문서 v1.4
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

## Implementation Governance

Development Plan은 구현 순서와 task 경계를 정의한다. 세부 코딩 규칙 전문은 이 문서에 모두 넣지 않고, AGENTS.md와 `docs/agent/guidelines/*` 문서에서 관리한다.

### Source of Truth

구현 작업은 다음 우선순위를 따른다.

1. 명시적 task invocation
2. AGENTS.md
3. Assigned DA task
4. Development Plan
5. Design Doc
6. PRD
7. Existing code patterns

Raw planning chat은 implementation scope가 아니다.

### Required Rule Documents

각 implementation task는 필요한 경우 다음 문서를 참조한다.

- `AGENTS.md`
- `docs/agent/guidelines/apple-coding-style.md`
- `docs/agent/guidelines/swiftui-architecture.md`
- `docs/agent/guidelines/comments-and-docs.md`
- `docs/agent/guidelines/sqlite-migration.md`
- `docs/agent/workflows/implementation-task.md`
- `docs/agent/workflows/verification-review.md`
- `docs/agent/templates/handoff.md`

### Coding / Architecture Standards

모든 task는 다음 원칙을 따른다.

- SwiftUI View와 business logic를 분리한다.
- ViewModel은 UI state와 user intent orchestration을 담당한다.
- Domain Service는 SwiftUI/AppKit UI layer에 직접 의존하지 않는다.
- Infrastructure layer는 SQLite, FileSystem, AVFoundation, AppKit bridge 접근을 담당한다.
- Repository pattern을 유지한다.
- async/await를 우선 사용하되, UI update는 MainActor boundary를 명확히 한다.
- speculative abstraction과 repo-wide refactor를 피한다.
- 기존 동작은 명시적 요구가 없으면 변경하지 않는다.

### Comment / Documentation Standards

- public API 또는 cross-module API에는 documentation comment를 사용한다.
- 명백한 코드를 설명하는 주석은 피한다.
- non-obvious decision, platform workaround, permission/sandbox edge case는 주석으로 남긴다.
- TODO/FIXME는 이유와 후속 task 후보를 함께 적는다.
- 임시 workaround는 verification 또는 follow-up과 연결한다.

### Task Execution Rules

- 하나의 DA task는 독립적으로 구현하고 검증한다.
- task 범위를 벗어난 개선은 follow-up으로 기록한다.
- High-Risk task는 Full Verification 또는 manual validation이 필요하다.
- protected area 변경이 필요하면 중지하고 보고한다.
- 각 task 완료 후 handoff를 남긴다.

### Protected Areas

명시적 승인 없이 다음 영역을 변경하지 않는다.

- signing / notarization / release packaging
- entitlements
- app sandbox / permission settings
- CI/CD workflows
- production configuration
- database migrations that delete or rewrite user data
- data deletion logic
- keychain / credential storage

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
- Verification: Results filtered correctly, including filename/tag/category filtering
- Risk: Medium
- Dependencies: DA-008
- Required guides:
  - `docs/agent/guidelines/apple-coding-style.md`
  - `docs/agent/guidelines/sqlite-migration.md`
- Notes:
  - Keep the first implementation simple.
  - Do not introduce complex ranking or FTS migration in this task unless explicitly assigned.

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
- Verification: Opens fast, keyboard navigation works, preview works, Esc closes reliably
- Risk: High
- Dependencies: DA-009, DA-010
- Required guides:
  - `docs/agent/guidelines/swiftui-architecture.md`
  - `docs/agent/guidelines/apple-coding-style.md`
- High-risk notes:
  - Isolate Quick Peek state from MainWindow state.
  - Avoid broad refactors while implementing NSPanel/global hotkey behavior.
  - Manual validation is required for focus, keyboard input, and multi-window behavior.

### DA-016 Final Cut Integration
- Goal: Drag to FCP
- Expected behavior: File appears in Final Cut Pro timeline via file URL drag
- Affected areas: DragAndDropProvider, asset file access, permissions
- Verification: File appears in Final Cut Pro timeline or browser via file URL drag
- Risk: High
- Dependencies: DA-004, DA-010, DA-021
- Required guides:
  - `docs/agent/guidelines/apple-coding-style.md`
  - `docs/agent/guidelines/macos-file-access.md`
- High-risk notes:
  - Validate internal disk and external SSD assets separately.
  - Do not silently copy files as a workaround.
  - Permission failure must surface as user-visible state.

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
- Notes:
  - v1.0 does not require destructive trimming/export.
  - Preserve original files and link derived assets through DB relations.

### DA-019 Preferences
- Goal: Minimal settings
- Expected behavior: Settings persist, workspace location can be viewed/changed
- Affected areas: PreferencesView, app_settings, workspace settings
- Verification: Settings persist
- Risk: Low
- Dependencies: DA-003

### DA-020 Search Index Architecture
- Goal: Prepare scalable search indexing strategy
- Expected behavior: Search can evolve from SQL LIKE to normalized token search and FTS5 without changing product behavior
- Affected areas: SearchService, SQLite schema/indexes, normalized tokens, tag/category query layer
- Verification: Korean/English filename search, tag/category search, alias candidate search, and basic latency check pass
- Risk: Medium
- Dependencies: DA-009, DA-011, DA-012
- Required guides:
  - `docs/agent/guidelines/sqlite-migration.md`
  - `docs/agent/guidelines/apple-coding-style.md`
- Notes:
  - This task should not rewrite the entire search UI.
  - Treat FTS5 as an extension path unless explicitly assigned.

### DA-021 Bookmark & External Storage Recovery
- Goal: Restore and validate access to indexed files on internal/external storage
- Expected behavior: Assets on external SSD can recover access after app restart or drive reconnect, and failure states are visible
- Affected areas: BookmarkStore, FileSystemAccess, asset_locations, startup restoration, missing/offline status
- Verification: Internal file restore, external SSD reconnect, stale bookmark handling, permission denied state display
- Risk: High
- Dependencies: DA-003, DA-004
- Required guides:
  - `docs/agent/guidelines/macos-file-access.md`
  - `docs/agent/guidelines/apple-coding-style.md`
- Stop if:
  - sandbox entitlement changes are required
  - permission behavior is unclear
  - existing asset location records would need destructive migration

### DA-022 Workspace Lifecycle Manager
- Goal: Manage temp, preview cache, analysis output, and derived asset lifecycle
- Expected behavior: Workspace files are classified, cleanup-safe files can be cleaned, derived assets remain linked, orphan state is detectable
- Affected areas: WorkspaceManager, workspace_items, asset_derivations, cleanup jobs, Preferences
- Verification: Temp cleanup simulation, preview cache regeneration, derived relation persistence, orphan derived asset state
- Risk: Medium
- Dependencies: DA-003, DA-018
- Required guides:
  - `docs/agent/guidelines/apple-coding-style.md`
  - `docs/agent/guidelines/sqlite-migration.md`
- Notes:
  - Never delete original files.
  - Cleanup must distinguish regeneratable cache from user-valuable derived output.

### DA-023 Verification Harness / Manual QA Checklist
- Goal: Standardize Minimum and Full Verification for DizzyAsset tasks
- Expected behavior: Each task can produce consistent verification evidence and handoff
- Affected areas: docs/agent/workflows, manual QA checklist, task prompt templates
- Verification: Verification checklist exists and covers core flows
- Risk: Low
- Dependencies: DA-001
- Notes:
  - This task creates process artifacts, not product UI.

## Acceptance Criteria Mapping

- Import → DA-004
- Deduplication → DA-005 / DA-006
- Search → DA-009 / DA-020
- Preview → DA-010
- Tagging → DA-011 / DA-012 / DA-013
- Right Panel / Asset Information Hub → DA-014
- Quick Peek → DA-015
- FCP Integration → DA-016
- Silence Detection → DA-017
- Derived Assets / Workspace Output → DA-018 / DA-022
- Preferences → DA-019
- Bookmark / External Storage Recovery → DA-021
- Verification Process → DA-023

---

## Execution Strategy

### Phase 1 (Foundation / Core Index)
- DA-001 App Foundation
- DA-002 Database Layer
- DA-003 Storage / Workspace Setup
- DA-004 File Import & Scan
- DA-005 Duplicate Detection
- DA-006 Full Duplicate Rescan
- DA-007 Metadata Extraction
- DA-008 Asset List UI

### Phase 2 (Search / Organization / Detail)
- DA-009 Search Engine
- DA-010 Preview Engine
- DA-011 Editing Language Tag System
- DA-012 Category System
- DA-013 Drag Tagging
- DA-014 Right Panel Asset Information Hub
- DA-020 Search Index Architecture

### Phase 3 (Workflow Integration / High-Risk)
- DA-015 Quick Peek
- DA-016 Final Cut Integration
- DA-021 Bookmark & External Storage Recovery

### Phase 4 (Analysis / Workspace / Preferences)
- DA-017 Silence Detection
- DA-018 Derived Asset Management
- DA-019 Preferences
- DA-022 Workspace Lifecycle Manager

### Phase 5 (Process / Verification)
- DA-023 Verification Harness / Manual QA Checklist

---

## Verification Plan

### Minimum Verification

Minimum Verification is required for every task.

Minimum Verification may include:

1. App builds successfully
2. App launches
3. Assigned feature path does not crash
4. Focused manual check passes
5. Changed code is limited to assigned scope

Minimum Verification does not mean release-ready.

### Full Verification

Full Verification is required for High-Risk tasks or when persistence, file permissions, app lifecycle, external storage, or FCP integration are touched.

Full Verification should include:

1. Build / launch
2. Focused feature flow
3. Relevant manual smoke test
4. Failure-state check
5. Handoff with evidence
6. Checks not run and reasons

### Manual Test Scenarios

Core scenarios:

1. Drop folder → files indexed
2. Search → instant result
3. Space → preview works
4. Drag → FCP timeline insert

Search scenarios:

1. Korean filename search
2. English/Korean mixed query
3. Tag/category filtering
4. Alias candidate search
5. Large library latency check, if sample data exists

Preview scenarios:

1. Rapid arrow key selection
2. Repeated Space toggle
3. Missing file preview failure state
4. External SSD playback, if available

Final Cut / File Access scenarios:

1. Drag from internal disk
2. Drag from external SSD
3. Drag after app restart/bookmark restore
4. External drive disconnected state
5. Reconnect flow
6. Permission denied state

Workspace scenarios:

1. Required folders created
2. Workspace location change persists
3. Temp cleanup simulation
4. Derived asset relation saved
5. Orphan derived asset state displayed or recorded

---

## Risks

### High Risk

- Quick Peek global hotkey / NSPanel focus
- Final Cut Pro drag compatibility
- Security-scoped bookmark restore
- External drive reconnect / volume rename
- Sandbox / permission behavior
- Any destructive database migration or data deletion logic

### Medium Risk

- Search latency at scale
- Preview stability during rapid selection
- Duplicate scan performance on large files
- Workspace cleanup safety
- AVFoundation edge cases

### Low Risk

- Static UI shell
- Basic preferences persistence
- Non-destructive display-only metadata

---

## Stop Conditions

Agents must stop and report if:

- build fails
- required tool fails
- verification fails
- scope expansion becomes necessary
- protected areas must be changed
- sandbox entitlement behavior is unclear
- database migration could delete or rewrite user data
- FCP drag payload fails and workaround would require hidden copying
- external storage permission behavior cannot be confirmed

---

## Handoff Requirements

Each implementation task must produce a concise handoff.

Required fields:

- Task ID
- Summary
- Files changed
- Scope status
- Verification commands/checks actually run
- What is verified
- What is not verified
- Known risks
- Suggested next step
- Final decision reserved for instruction owner

---

## Detailed Implementation Prompt Boundary

Development Plan defines task scope and sequencing.

Detailed Implementation Prompts are generated later from:

- Assigned DA task
- AGENTS.md
- Required guide documents
- Relevant source files
- Verification requirements
- Stop conditions
- Handoff template

Development Plan must not become the full coding style manual. Detailed coding rules live in `docs/agent/guidelines/*`.

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
---

## v1.4 Plan Updates

### Update Principle

v1.4 preserves the v1.3 Development Plan structure and task-oriented execution model while synchronizing it with PRD v1.4, Design Doc v1.4, and the agentic development workflow.

### Updated Source

- PRD updated from v1.3 to v1.4
- Design Doc updated from v1.3 to v1.4

### Corrected Items

- Acceptance Criteria Mapping corrected
- Execution Strategy expanded to include DA-015 through DA-023
- High-Risk workflow integration tasks separated into a dedicated phase
- Minimum Verification and Full Verification clarified

### New / Updated Tasks

- DA-009 Search Engine expanded with required guides and scope notes
- DA-015 Quick Peek expanded with high-risk notes
- DA-016 Final Cut Integration expanded with file access and external SSD notes
- DA-018 Derived Asset Management clarified as non-destructive for v1.0
- DA-020 Search Index Architecture added
- DA-021 Bookmark & External Storage Recovery added
- DA-022 Workspace Lifecycle Manager added
- DA-023 Verification Harness / Manual QA Checklist added

### Governance Added

- Implementation Governance section added
- Source of Truth order added
- Required Rule Documents added
- Coding / Architecture Standards added as references
- Comment / Documentation Standards added as references
- Task Execution Rules added
- Protected Areas added
- Stop Conditions added
- Handoff Requirements added
- Detailed Implementation Prompt boundary clarified

### Updated Core Scope

- Search remains core product engine
- Quick Peek remains v1.0 minimal scope
- Final Cut Pro drag remains workflow-critical
- Vision/Speech remains out of MVP runtime scope
- Audio trimming/export remains out of MVP scope
- Workspace lifecycle and external storage recovery are now explicit implementation concerns

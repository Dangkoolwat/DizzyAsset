# DizzyAsset Development Plan (v1.0)

## Source
- PRD: DizzyAsset v1.0 PRD
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
- Verification: App launches
- Risk: Low

### DA-002 Database Layer
- Goal: SQLite schema + persistence
- Verification: CRUD works
- Risk: Medium

### DA-003 File Import & Scan
- Goal: Drag & drop + recursive scan
- Verification: Files indexed
- Risk: Medium

### DA-004 Duplicate Detection
- Goal: Hash-based deduplication
- Verification: Duplicate skipped
- Risk: Medium

### DA-005 Metadata Extraction
- Goal: Extract duration/type
- Verification: Metadata populated
- Risk: Low

### DA-006 Asset List UI
- Goal: Display assets
- Verification: List renders correctly
- Risk: Low

### DA-007 Search Engine
- Goal: Fast filename + tag search
- Verification: Results update instantly
- Risk: Medium

### DA-008 Preview Engine
- Goal: Space playback
- Verification: Audio plays instantly
- Risk: Medium

### DA-009 Tag System
- Goal: Basic tagging
- Verification: Tags persist
- Risk: Medium

### DA-010 Drag Tagging
- Goal: Assign via drag
- Verification: Relation saved
- Risk: Medium

### DA-011 Quick Peek
- Goal: Global search overlay
- Verification: Opens fast, preview works
- Risk: High

### DA-012 Final Cut Integration
- Goal: Drag to FCP
- Verification: File appears in timeline
- Risk: High

### DA-013 Silence Detection
- Goal: Detect silence
- Verification: Values displayed
- Risk: Medium

### DA-014 Preferences
- Goal: Minimal settings
- Verification: Settings persist
- Risk: Low

---

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


# Manual QA Checklist

**Document version:** v1.0  
**Project:** DizzyAsset  
**Document role:** End-to-end functional verification guide  
**Status:** Ready for use  
**Last updated:** 2026-05-07

---

## 0. Purpose

This document provides a repeatable manual verification checklist for DizzyAsset features. Use this during PR reviews or before milestone releases.

---

## 1. Core Workflow Checklist

### [ ] App Launch & Setup
- [ ] App launches without crashing.
- [ ] Workspace initializes correctly (folders created in `~/Library/Containers/...` or custom path).
- [ ] Database schema is created/verified.

### [ ] Import & Scanning
- [ ] "Import Folder" dialog opens.
- [ ] Asset scan completes and shows progress.
- [ ] Assets appear in the list with correct filenames.
- [ ] Duplicate assets are correctly flagged with the "Duplicate" indicator.

### [ ] Search & Discovery
- [ ] Search bar filters the asset list in real-time.
- [ ] Prefix matching works (e.g., "vid" matches "video").
- [ ] Search handles Korean/English queries (if applicable).
- [ ] Search index rebuilds correctly via Workspace Manager.

### [ ] Asset Preview & Waveforms
- [ ] Selecting an asset loads the preview player.
- [ ] Video/Audio playback works (Play/Pause/Scrub).
- [ ] Waveform generates and displays correctly for audio assets.
- [ ] Quick Peek (Cmd+P) opens the overlay and shows current asset info.

### [ ] Information Hub (Right Panel)
- [ ] Technical metadata (Format, Resolution, Duration) is accurate.
- [ ] Tags and Categories can be assigned/removed.
- [ ] Online/Offline status reflects actual file availability.
- [ ] Silence Analysis results are displayed (Front/Tail silence).
- [ ] Lineage (Parent/Child) relationships are visible.

---

## 2. Integration & Advanced Features

### [ ] Final Cut Pro Integration
- [ ] Dragging an asset into Final Cut Pro successfully imports the file.
- [ ] Dual-payload (Asset ID + File URL) is present in the drag pasteboard.

### [ ] External Storage
- [ ] Assets on external SSD are accessible after app restart.
- [ ] Unmounting the drive shows "Offline (Volume Offline)" in the UI.
- [ ] Remounting the drive and selecting the asset restores "Online" status.

### [ ] Preferences
- [ ] Cmd+, opens the Settings window.
- [ ] Auto-Analysis toggle persists after app restart.
- [ ] Workspace path is displayed correctly.

---

## 3. Reporting Evidence

Every manual QA run MUST report:
- **Environment:** (e.g., macOS Sequoia, M2 Max, External SSD)
- **Commands Run:** (e.g., `xcodebuild ...`)
- **Result:** (Pass/Fail)
- **Visual Evidence:** Link to screenshots/recordings in `artifacts/YYYY-MM-DD/`
- **Known Risks:** Any observed hitches or edge cases.

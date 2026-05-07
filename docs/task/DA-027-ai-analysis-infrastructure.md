# DA-027 Smart Tags & AI Analysis Infrastructure — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-027  
**Task name:** Smart Tags & AI Analysis Infrastructure  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation / Infrastructure  
**Risk level:** Non-trivial (DB schema change + new service layer)  
**Target repo path:** `docs/task/DA-027-ai-analysis-infrastructure.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the foundation for AI-driven asset organization. This includes the database schema for storing analysis results, a pluggable provider architecture, and the first "Smart" provider that analyzes filenames and technical metadata.

---

## 2. Source of Truth

Follow:
1. `AGENTS.md`
2. `docs/guidelines/ai-analysis-provider.md`
3. This DA-027 task prompt
4. `docs/guidelines/sqlite-migration.md`

---

## 3. Required Reading

Always read:
- `docs/guidelines/ai-analysis-provider.md`
- `docs/guidelines/sqlite-migration.md`

---

## 4. In Scope

- **Database Migration:** Add `asset_ai_results` and `suggested_tags` tables.
- **Provider Protocol:** Define `AIProvider` with `canAnalyze`, `analyze(asset)`, and `identifier`.
- **LocalMetadataProvider:** Implement an analyzer that extracts keywords from filename (e.g., "Intro_Loop_01.wav" -> "Intro", "Loop") and metadata (e.g., "4K", "60fps").
- **AIAnalysisService:** A service to run providers and persist results.
- **Repository Support:** Add `AIRepository` to handle CRUD for analysis results and suggestions.
- **UI (Basic):** Show suggested tags in `AssetDetailView` with "Accept" (+) buttons.

---

## 5. Out of Scope

- Integrating cloud AI (OpenAI/Gemini) in this specific task (infrastructure first).
- Automatic batch analysis on import (manual trigger for now).
- Scene detection or transcription (future tasks).

---

## 6. Implementation Guidance

### DB Schema
```sql
CREATE TABLE IF NOT EXISTS asset_ai_results (
    asset_id INTEGER PRIMARY KEY,
    provider_id TEXT NOT NULL,
    provider_version TEXT,
    raw_json TEXT,
    normalized_json TEXT,
    confidence REAL,
    status TEXT,
    analyzed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS suggested_tags (
    asset_id INTEGER NOT NULL,
    tag_name TEXT NOT NULL,
    confidence REAL,
    source TEXT,
    PRIMARY KEY (asset_id, tag_name),
    FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
);
```

### AIProvider Protocol
```swift
protocol AIProvider {
    var identifier: String { get }
    var version: String { get }
    func canAnalyze(asset: Asset) -> Bool
    func analyze(asset: Asset) async throws -> AnalysisResult
}
```

---

## 7. Verification

- `xcodegen generate`
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`
- **Unit Test (or Scratch Script):** Verify that `LocalMetadataProvider` correctly extracts tags from a test filename and metadata.
- **UI Check:** Verify that "Suggested Tags" appear in the detail panel and can be accepted (converted to real tags).

---

## 8. Handoff Requirements

Follow `docs/templates/handoff.md` and the AI specific checklist in `docs/guidelines/ai-analysis-provider.md`.

# AGENTS.md

**Document version:** v1.4  
**Project:** DizzyAsset  
**Document role:** Repository-level instruction router and agent operating guide  
**Status:** Living document  
**Last updated:** 2026-05-07

---

## 0. Purpose

This file is the repository-level instruction router for coding agents.

It defines how agents should work in this repository.

It is now a **lean router** document. Technical details have been moved to `docs/guidelines/`.

---

## 1. Operating Model

This repository is developed by a solo developer using coding agents.

Agents MUST optimize for:
- small surgical changes
- predictable behavior
- evidence-based verification
- low-risk deployment

Agents MUST NOT treat raw chat as implementation scope. Approved artifacts (Task, PRD, Design, Plan) define scope.

---

## 2. Source of Truth

For implementation work, follow this order:
1. Explicit task invocation
2. AGENTS.md (this file)
3. Assigned DA task
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Detailed Technical Guidelines (see Section 4)

---

## 3. Lifecycle Routing

Classify the task stage before acting. Load only relevant documents.

- **Planning/PRD/Design:** Read relevant sections in `docs/product/`.
- **Implementation:** Read this file, the assigned task, and relevant guidelines in `docs/guidelines/`.
- **Verification:** Read the diff and `docs/workflows/verification-review.md`.

---

## 4. Detailed Technical Guidelines

For detailed technical rules, read ONLY the relevant file:

- **Swift / naming / style:** `docs/guidelines/apple-coding-style.md`
- **Comments / documentation:** `docs/guidelines/comments-and-docs.md`
- **SwiftUI architecture / layers:** `docs/guidelines/swiftui-architecture.md`
- **State ownership / SSOT:** `docs/guidelines/state-management.md`
- **Async / Concurrency:** `docs/guidelines/swift-concurrency.md`
- **SQLite / migrations:** `docs/guidelines/sqlite-migration.md`
- **File access / bookmarks / sandbox:** `docs/guidelines/macos-file-access.md`
- **Final Cut Pro integration:** `docs/guidelines/final-cut-pro-integration.md`
- **Workspace / lifecycle:** `docs/guidelines/workspace-lifecycle.md`

---

## 5. Skill Policy

Use installed skills as follows. Each skill is grounded by the guidelines above.

### `macos-sandbox-security-skill`
- **Use:** Sandbox, security-scoped bookmarks, entitlements.
- **Guideline:** `docs/guidelines/macos-file-access.md`

### `sqlite-fts-optimizer`
- **Use:** SQLite schema, FTS5, ranking algorithms.
- **Guideline:** `docs/guidelines/sqlite-migration.md`

### `avfoundation-media-pro`
- **Use:** Media metadata, hashing, waveforms, preview playback.
- **Guideline:** `docs/guidelines/macos-file-access.md` (for file handling)

### `swiftui-expert-skill`
- **Use:** Views, ViewModels, state management.
- **Guideline:** `docs/guidelines/swiftui-architecture.md`

### `swift-concurrency`
- **Use:** Async/await, Task, actor isolation.
- **Guideline:** `docs/guidelines/swift-concurrency.md`

### `karpathy-guidelines`
- **Use:** Surgical changes, simplicity.
- **Guideline:** `docs/guidelines/apple-coding-style.md`

---

## 6. Context Economy

Treat context as expensive.
- Read only what is needed for the current task.
- Do not search the whole repository unless architecture must be verified.
- Prefer assigned task file over full plan.

---

## 7. Project Structure

- `DizzyAsset/App/`: Entry point & composition.
- `DizzyAsset/Presentation/`: SwiftUI & ViewModels.
- `DizzyAsset/Domain/`: Business logic & Entities.
- `DizzyAsset/Data/`: Persistence & Repositories.
- `DizzyAsset/Infrastructure/`: Platform bridges (AVFoundation, AppKit).
- `DizzyAsset/Resources/`: Entitlements, Assets, Info.plist.

**XcodeGen:** Run `xcodegen generate` after any file move/add/delete. Do not edit `.xcodeproj` manually.

---

## 8. Build & Verification Commands

- `xcodegen generate`: Regenerate project.
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`: CLI Build.

---

## 9. Task Execution & Risk

### Risk Classification
- **Trivial:** Local UI/style, no behavior change.
- **Non-trivial:** Shared logic, DB reads, indexing flows.
- **High-Risk:** Sandbox, Bookmarks, FCP Integration, DB Migrations.

### Stop Conditions
- Stop and report if build/test fails, scope expansion is needed, or sandbox behavior is unclear.
- Never implement hidden media copying for FCP workarounds.

---

## 10. Handoff & Knowledge

### Handoff
Every task must end with a concise handoff (Task ID, Summary, Evidence, Verification results).

### Visual Evidence
UI changes MUST include screenshots/recordings in `artifacts/YYYY-MM-DD/<task-id>/`.

### Knowledge Base
Non-obvious fixes or platform behaviors MUST be documented in `docs/knowledge/YYYY-MM-DD-short-topic.md`.

---

## 11. Final Authority

Agents provide evidence; instruction owner makes final decisions. Do not declare final acceptance.

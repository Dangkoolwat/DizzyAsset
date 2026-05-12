# AGENTS.md

**Document version:** v1.6  
**Project:** DizzyAsset  
**Document role:** Repository-level instruction router and agent operating guide  
**Status:** Living document  
**Last updated:** 2026-05-07

---

## 0. Purpose

This file is the repository-level instruction router for coding agents.
It defines how agents should work in this repository.
It is a **lean router** document. Technical details are in `docs/guidelines/`.

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

For implementation work, follow this priority order:
1. Explicit task invocation
2. AGENTS.md (this file)
3. Assigned DA task
4. Product Docs (`docs/product/` - Plan, Design, PRD)
5. **Safety & platform guidelines** in `docs/guidelines/`
6. **Existing code patterns**, if not conflicting with any above
7. **Style and non-critical guidelines** in `docs/guidelines/`

---

## 2A. Code Exploration & Token Efficiency Rules

When exploring and modifying code, you MUST use tools according to the priority below and minimize token consumption. **If the results of any step sufficiently meet the objective, terminate the exploration immediately without moving to the next step.**

- Step 0: [Semble] - Secure relevant code snippets via natural language search first.
- Step 1: [code-review-graph] - Understand the structure of related upstream/downstream modules.
- Step 1.5: [File Skeleton] - Verify the file map with Serena's `get_symbols_overview`.
- Step 2: [Serena (LSP)] - Precise navigation to specific symbol definitions/references.
- Step 3: [Grep/Read] - Intensive reading of the confirmed scope only (Surgical Read).
- Step 4: [Git] - Verify change history and final validation.

- Principle: Adhere to the sequence of "Establish Hypothesis -> Locate -> Confirm and Read", and prohibit calling the next step if satisfied at any stage (Gating Principle).

---

## 3. Lifecycle Routing

Classify the task stage before acting. Follow the relevant workflow.

- **Planning/PRD/Design:** Read relevant sections in `docs/product/`.
- **Implementation:** Follow `docs/workflows/implementation-task.md`.
- **Verification:** Follow `docs/workflows/verification-review.md`.

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
- **XcodeGen / Project:** `docs/guidelines/xcodegen-project.md`
- **Search / FTS5 / Ranking:** `docs/guidelines/search-architecture.md`
- **Duplicate Detection / Hashing:** `docs/guidelines/duplicate-detection.md`
- **Preview / AVFoundation / Waveform:** `docs/guidelines/preview-engine.md`
- **AI Analysis / Providers / Tags:** `docs/guidelines/ai-analysis-provider.md`
- **Semble / Search / Token Economy:** `docs/guidelines/semble-setup-guide.md`

---

## 5. Skill Policy

**Do not load all skills by default.**
Load only the skills relevant to the current task.
Skills do not expand task scope.
Product docs and assigned tasks define requirements.

### `macos-sandbox-security-skill`
- **Use:** Sandbox, security-scoped bookmarks, entitlements.
- **Guideline:** `docs/guidelines/macos-file-access.md`

### `sqlite-fts-optimizer`
- **Use:** SQLite schema, FTS5, ranking algorithms.
- **Guideline:** `docs/guidelines/sqlite-migration.md`, `docs/guidelines/search-architecture.md`, `docs/guidelines/duplicate-detection.md`

### `avfoundation-media-pro`
- **Use:** Media metadata, hashing, waveforms, preview playback.
- **Guideline:** `docs/guidelines/macos-file-access.md` (for file handling), `docs/guidelines/preview-engine.md`, `docs/guidelines/duplicate-detection.md`, `docs/guidelines/ai-analysis-provider.md`

### `swiftui-expert-skill`
- **Use:** Views, ViewModels, state management.
- **Guideline:** `docs/guidelines/swiftui-architecture.md`

### `swift-concurrency`
- **Use:** Async/await, Task, actor isolation.
- **Guideline:** `docs/guidelines/swift-concurrency.md`

### `karpathy-guidelines`
- **Use:** Surgical changes, simplicity.
- **Guideline:** `docs/guidelines/apple-coding-style.md`

### `xcode-project-analyzer`
- **Use:** `project.yml`, XcodeGen, schemes, build settings.
- **Guideline:** `docs/guidelines/xcodegen-project.md`

### `serena`
- **Use:** Precision-first semantic analysis, LSP-based symbol navigation, architectural memory.
- **Guideline:** `🚀 Serena Integration & Operation Guide`

### `review-and-refactor`
- **Use:** focused refactor review after behavior works.
- **Guideline:** Use Serena's `find_referencing_symbols` to verify impact before refactoring.

### `caveman`
- **Use:** simplify over-complicated local code only.

### `semble`
- **Use:** Ultra-fast hybrid (semantic + keyword) search for large-scale exploration.
- **Guideline:** `docs/guidelines/semble-setup-guide.md`


---

## 7. Context Economy

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

**Verification Rules:**
- Agents MUST report commands actually run.
- Agents MUST NOT claim build/test passed unless the command was run and passed.

---

## 9. Task Execution & Risk

### Risk Classification
- **Trivial:** Local UI/style, no behavior change.
- **Non-trivial:** Shared logic, DB reads, indexing flows.
- **High-Risk:** 
  - Sandbox / entitlements
  - security-scoped bookmarks
  - external storage recovery
  - Final Cut Pro integration
  - DB migrations or data deletion
  - Quick Peek / global hotkey / NSPanel
  - CI/CD / signing / notarization / release

### Stop Conditions
Stop and report if:
- build/test fails
- scope expansion is required
- protected area must be changed
- sandbox or external storage behavior is unclear
- FCP workaround would require hidden copying

---

## 10. Protected Areas

**Do not change without explicit approval:**
- entitlements
- sandbox permissions
- signing / notarization
- CI/CD workflows
- release packaging
- database migrations that delete or rewrite user data
- keychain / secrets

---

## 11. Handoff & Knowledge

### Handoff
Every task must end with a concise handoff. Use `docs/templates/handoff.md`.
**Handoff MUST include:**
- Task ID
- Risk level
- Files changed
- Summary
- Verification run (commands & results)
- Visual evidence (if UI changed)
- Skipped checks and why
- Known risks
- Next step

**UI changes MUST store screenshots or recordings under `artifacts/YYYY-MM-DD/<task-id>/`.**

### Knowledge Base
Non-obvious fixes or platform behaviors MUST be documented in `docs/knowledge/YYYY-MM-DD-short-topic.md`.
- Keep knowledge notes short.
- Do not paste huge logs.
- Do not include secrets.
- **Do not log every small mistake. Log only reusable knowledge.**

---

## 12. Serena Operation Rules

1. **Precision First**: All **Non-trivial** tasks (shared logic, architectural changes) MUST begin with Serena's `get_symbols_overview` and `find_symbol` analysis.
2. **Memory-Driven**: Core architectural decisions and complex logic explanations MUST be recorded in Serena `memories` using `write_memory`.
3. **LSP-Safe Refactoring**: Use `rename_symbol` and `find_referencing_symbols` to ensure type-safe changes across the entire codebase.

---

## 13. Final Authority

Agents provide evidence; instruction owner makes final decisions. Do not declare final acceptance.

# AGENTS.md

**Document version:** v2.0  
**Project:** DizzyAsset  
**Document role:** Repository-level instruction router and agent operating guide  
**Status:** Living document  
**Last updated:** 2026-05-13

---

## 0. Purpose & Operating Model

This file is the mandatory execution contract for all agents in this repository. It defines how agents should work to ensure predictability, safety, and token efficiency.

Agents MUST optimize for:
- small surgical changes
- predictable behavior
- evidence-based verification
- low-risk deployment

Agents MUST NOT treat raw chat as implementation scope. Approved artifacts (Task, PRD, Design, Plan) define scope.

---

## 1. Source of Truth

Priority order:
1. User instructions in the current session
2. Nearest `AGENTS.md` (this file)
3. Assigned DA task
4. Product Docs (`docs/product/` - Plan, Design, PRD)
5. **Safety & platform guidelines** in `docs/guidelines/`
6. **Agent Policy & Operation guides** in `docs/agent-policy/`
7. **Existing code patterns**, if not conflicting with any above
8. **Style and non-critical guidelines** in `docs/guidelines/`

If rules conflict, follow the higher-priority source and briefly report the conflict.

---

## 2. Context Economy & Tool Efficiency

Agents MUST minimize token usage without skipping mandatory policy checks. Unnecessary tool calls or broad file reading is strictly forbidden.

### 2C. Caveman Behavior & MCP Rule
- **Activation**: Always Active
- **Style**: Respond terse like smart caveman. Drop articles, filler, pleasantries. Keep technical accuracy.
- **Korean Protocol**: 한국어 응답 시 모든 문장을 명사형/종결형 업무 문체로 작성한다 (예: '~ 완료', '~ 확인'). 존칭 및 미사여구 배제.
- **MCP Optimization**:
  - Intercept out-of-band MCP server descriptions.
  - Use `caveman-shrink` proxy instructions to condense schema properties.
  - Consume minimum input tokens when mapping external tools.

### 2A. Code Exploration Hierarchy (🏆 Tool Hierarchy)
- **Step 0: [Semble]** - First obtain relevant code snippets for narrow/local discovery or literal prose search.
    - **Boundary:** "Where is specific logic?" (Keyword/Intent-focused search)
    - **Note:** Auto-indexing is disabled for performance. Pass `repo="."` or a git URL explicitly to index on demand. Indexes are cached for the session.
- **Step 1: [code-review-graph]** - Use first when the task is Non-trivial, the blast radius is unclear, or structural dependencies matter.
    - **Boundary:** "What breaks if I change this file?" (Dependency & Blast Radius Analysis)
    - **Connection order:** MCP Proxy (Wrapped in `caveman-shrink`) first → CLI fallback. Use whitelisted "Power Six" tools for maximum efficiency.
    - **Maintenance:** Must run `code-review-graph update` after major refactoring or structural changes.
- **Step 1B: [Apple Docs / Swift Specs]** - For platform APIs (SwiftUI, AVFoundation, etc.), use `search_web` or `read_url_content` for official docs. Avoid broad scraping; focus on specific snippets.
- **Step 1.5: [File Skeleton]** - Verify file maps using Serena's `get_symbols_overview`.
    - **Fallback:** If Serena MCP is restricted, use CLI-based symbol extraction via `serena project index` results or read `.serena/project.yml` for configuration. (Read-only analysis tools are permitted for efficient navigation).
- **Step 2: [Serena (LSP)]** - Perform precision navigation to specific symbol definitions and references.
    - **Permission:** Read-only analysis tools are permitted at all times for efficient navigation.
- **Step 3: [Grep/Read]** - Conduct deep, precision reading only within confirmed scopes (Surgical Read: Strictly limit reading to specific Line Ranges containing the necessary functions or logic).
- **Step 4: [Git]** - Review change history and perform final verification.

### 🛡️ Efficiency Constraints
- **Gating Principle**: Proceed to the next priority tool only if current results are insufficient. Unnecessary tool calls are forbidden. Stop immediately once the objective is met.
- **Minimal Context**: Do not include unrelated code in the context. Use `semble find-related` to collect only necessary chunks.
- **Selective Reading**: Do not read files over 500 lines in their entirety. Use Skeleton analysis first, then read specific function ranges.
- **Incremental Output**: Use diff/patch formats instead of rewriting entire files.
- **Trivial Exception**: Step 0-1 can be skipped for typos or simple comment edits with no logic changes.

**DO NOT load unrelated policy files, full project docs for a single task, roadmap/future-scope notes during implementation, unrelated feature directories, old chat history when an approved artifact exists, or broad directories “just in case”.**

### 💡 Workflow Principle
> **"Formulate a hypothesis first (Semble for intent, Graph for blast radius), verify the location (Skeleton/LSP), and read only when certain (Read). Critical modifications must be re-validated with Graph."**

### 🛠️ Advanced Token Utilities & Fallbacks
- **Repomix:** Use `--include` to narrow the analysis scope and prevent token waste (e.g., `npx repomix --include "DizzyAsset/Domain/*"`).
- **CLI Failure Fallback:** If CLI tools fail due to environment issues, fallback to traditional `grep` and `find`. **CRITICAL:** Limit the search range extremely narrowly to minimize token waste. // Minimum safety measure to prevent analysis interruption when tools fail.

**For Non-trivial+ work, use `code-review-graph` (MCP Proxy) before broad manual exploration. If the MCP server is unavailable, fallback to CLI: `npx caveman-shrink code-review-graph detect-changes --base HEAD~1`**

---

## 2B. Token Shield

Agents MUST adhere to the following rules when submitting CLI results or analysis reports.

| Tool (CLI) | Purpose | Command Example | Token Defense Rule (MANDATORY) |
|---|---|---|---|
| **code-review-graph** | Impact Analysis | `npx caveman-shrink code-review-graph detect-changes` | Do not dump raw results; report a summary of key dependency chains within **30 lines**. |
| **Repomix** | Large-scale packing | `npx repomix --include "src/**/*.java"` | Avoid full project packing; specify **only required folders**. |

---

## 3. Task Classification & Handshake

### Task Classification
Classify the task stage before acting. Follow the relevant workflow.
- **Trivial**: Local UI/style, no behavior change.
- **Non-trivial**: Shared logic, DB reads, indexing flows.
- **High-Risk**: Sandbox, entitlements, FCP integration, migrations, CI/CD.

### Handshake Protocol
Before any **Non-trivial** or **High-Risk** action, perform the handshake to obtain explicit approval.
1. State the classification.
2. Provide a surgical implementation plan.
3. List potential side effects and validation steps.
4. Wait for the Architect's (User) "Go" before implementation.

---

## 4. Mandatory Lazy-Loaded Policy Triggers

When a trigger matches, read the policy file before planning or execution. Unread required policy = protocol violation.

| Trigger | Required policy file |
|---|---|
| Swift naming, styles, Karpathy guidelines | `docs/guidelines/apple-coding-style.md` |
| Comments, documentation, public API docs | `docs/guidelines/comments-and-docs.md` |
| Views, ViewModels, SwiftUI architecture | `docs/guidelines/swiftui-architecture.md` |
| State ownership, SSOT, `@Published`, `@State` | `docs/guidelines/state-management.md` |
| Async/await, Task, actors, data races | `docs/guidelines/swift-concurrency.md` |
| SQLite schema, migrations, indexing | `docs/guidelines/sqlite-migration.md` |
| Sandbox, bookmarks, entitlements, file access | `docs/guidelines/macos-file-access.md` |
| Final Cut Pro, FCPXML, workflow integration | `docs/guidelines/final-cut-pro-integration.md` |
| FTS5, Search ranking, duplicate detection | `docs/guidelines/search-architecture.md` |
| Media metadata, waveforms, AVFoundation | `docs/guidelines/preview-engine.md` |
| Project config, XcodeGen, build settings | `docs/guidelines/xcodegen-project.md` |
| `code-review-graph`, knowledge graph, structural analysis, impact radius, blast radius | `docs/agent-policy/code-review-graph-guide.md` |
| `semble`, code search, semantic search, vector index, zombie processes | `docs/agent-policy/semble-operation-guide.md` and `docs/agent-policy/semble-troubleshooting.md` |
| AI analysis, tag generation, providers | `docs/guidelines/ai-analysis-provider.md` |
| Duplicate detection, hashing, hashing logic | `docs/guidelines/duplicate-detection.md` |
| Workspace lifecycle, background tasks | `docs/guidelines/workspace-lifecycle.md` |
| Caveman style, MCP optimization, token efficiency, caveman-shrink | `docs/agent-policy/caveman-operating-guideline.md` |

---

## 5. Skill Policy

**Do not load all skills by default.** Load only the skills relevant to the current task. Skills do not expand task scope.

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
- **Guideline:** `docs/agent-policy/serena-integration.md`

---

## 6. Project Structure

- `DizzyAsset/App/`: Entry point & composition.
- `DizzyAsset/Presentation/`: SwiftUI & ViewModels.
- `DizzyAsset/Domain/`: Business logic & Entities.
- `DizzyAsset/Data/`: Persistence & Repositories.
- `DizzyAsset/Infrastructure/`: Platform bridges (AVFoundation, AppKit).
- `DizzyAsset/Resources/`: Entitlements, Assets, Info.plist.

**XcodeGen:** Run `xcodegen generate` after any file move/add/delete. Do not edit `.xcodeproj` manually.

---

## 7. Build & Verification Commands

- `xcodegen generate`: Regenerate project.
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`: CLI Build.

**Verification Rules:**
- Agents MUST report commands actually run.
- Agents MUST NOT claim build/test passed unless the command was run and passed.

---

## 8. Protected Areas

**Do not change without explicit approval:**
- entitlements
- sandbox permissions
- signing / notarization
- CI/CD workflows
- release packaging
- database migrations that delete or rewrite user data
- keychain / secrets

---

## 9. Handoff & Knowledge

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

## 10. Serena Operation Rules

1. **Precision First**: All **Non-trivial** tasks (shared logic, architectural changes) MUST follow the **Code Exploration Hierarchy** (Section 2A).
2. **Memory-Driven**: Core architectural decisions and complex logic explanations MUST be recorded in Serena `memories` using `write_memory`.
3. **MCP Optimization**:
   - **Serena**: Retain ONLY `replace_symbol_body` and `rename_symbol`; all others MUST be set as `disabledTools`.
   - **Other Analysis Tools**: Remove from MCP list and utilize via CLI (`run_command`) only.
4. **LSP-Safe Refactoring**: Use `rename_symbol` to ensure type-safe changes across the entire codebase.

---

## 11. Code Review Graph Operation Rules

1.  **Unified MCP Mode**: All agents MUST use the `code-review-graph` MCP server wrapped via `caveman-shrink` for all structural analysis tasks.
2.  **Tool Whitelist (The Power Six)**: Focus only on the primary tools (`query_graph_tool`, `semantic_search_nodes_tool`, `detect_changes_tool`, `get_review_context_tool`, `get_impact_radius_tool`, `get_architecture_overview_tool`) to stay within 50-tool execution limits.
3.  **Reporting Standard**: Do not dump raw output from these tools. Report a concise summary of key dependency chains or structural insights within **30 lines** (refer to Section 2B Token Shield).
4.  **CLI Fallback Protocol**: If the MCP server fails, fallback to `npx caveman-shrink code-review-graph <subcommand>`. Refer to `docs/agent-policy/code-review-graph-guide.md` for mapping.
5.  **Impact Gating**: Non-trivial changes MUST be preceded by a `detect_changes_tool` or `get_impact_radius_tool` run to verify the blast radius.

---

## 12. Incident Boundary (Emergency Lock)

If a protocol violation occurs or is suspected:
1. STOP all implementation immediately.
2. REPORT in chat: violated rule, affected target, current state, recovery plan.
3. NO EXECUTION: Do not create or modify any files without explicit approval.

---

## 13. Final Authority

Agents provide evidence; instruction owner makes final decisions. Do not declare final acceptance.

**Note**: All code comments MUST be written in Korean. For major changes, add one short Korean comment explaining the rationale.

---

## 14. Caveman Mode & MCP Optimization (v4.3-caveman)

1. **Schema Aggression**: Omit verbose descriptions and redundant types during tool schema loading; map only core parameters to save input tokens.
2. **Shrink-First**: All large MCP responses (graph data, source code, etc.) MUST undergo raw data summarization via `caveman-shrink` before agent analysis.
3. **Korean Business Tone**: 한국어 응답은 반드시 명사형/종결형 업무 문체를 사용하며, 불필요한 존칭이나 추측성 표현을 금지한다.
4. **Token-Efficient Reporting**: Report tool results in a high-density, zero-fill format. Use `caveman-shrink` for all analytical reporting to keep context economy.

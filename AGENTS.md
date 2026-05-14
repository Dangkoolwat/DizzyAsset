# AGENTS.md

**Document version:** v2.1  
**Project:** DizzyAsset  
**Document role:** Repository-level instruction router and agent operating guide  
**Status:** Living document  
**Last updated:** 2026-05-14

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
4. Product Docs (`docs/product/dizzyasset_development_plan.md`, `docs/product/dizzyasset_design_doc.md`, `docs/product/dizzyasset_v1_prd.md`)
5. **Safety & platform guidelines** in `docs/guidelines/`
6. **Agent Policy & Operation guides** in `docs/agent-policy/`
7. **Existing code patterns**, if not conflicting with any above
8. **Style and non-critical guidelines** in `docs/guidelines/`

If rules conflict, follow the higher-priority source and briefly report the conflict.

---

## 2. Context Economy & Tool Efficiency

Agents MUST minimize token usage without skipping mandatory policy checks. Unnecessary tool calls or broad file reading is strictly forbidden. Treat context as limited and expensive.

### Explicit Context Boundaries
- **Read Only What Is Needed**: `AGENTS.md`, assigned task prompt, affected files, nearby local patterns, and required guide documents.
- **Do Not Read By Default**: Full PRD, full Design Doc, full Development Plan, unrelated lifecycle docs, unrelated feature folders, old chat history, or superseded artifacts. Load broader context only when necessary and explain why.

### 2A. 3-Stage Exploration Pipeline (🏆 Swift-Adapted MCP-Only Workflow)

**MUST READ BEFORE NON-TRIVIAL TASKS:** `docs/agent-policy/3-stage-pipeline.md`

- **Stage 1 (Discovery):** `semble_rs search` ONLY (AST commands prohibited for Swift).
- **Stage 2 (Impact Analysis):** Use `code-review-graph` and `Serena` MCP tools.
- **Stage 3 (Verification):** Surgical read and LSP-based symbol navigation.
- **Rule:** Do not read full files > 500 lines. Stop immediately once the objective is met.

### 2B. Token Shield

Agents MUST adhere to the following rules when submitting CLI results or analysis reports.

| Tool (CLI) | Purpose | Command Example | Token Defense Rule (MANDATORY) |
|---|---|---|---|
| **code-review-graph** | Impact Analysis | `npx caveman-shrink code-review-graph detect-changes` | Do not dump raw results; report a summary of key dependency chains within **30 lines**. |
| **Repomix** | Large-scale packing | `npx repomix --include "DizzyAsset/Domain/**"` | Avoid full project packing; specify **only required folders**. |

### 2C. Caveman Behavior & MCP Rule

> **This rule is always active. No trigger required.** See Section 4 for deeper Caveman style guidance (`docs/agent-policy/caveman-operating-guideline.md`).

- **Activation**: Always Active
- **Style**: Respond terse like smart caveman. Drop articles, filler, pleasantries. Keep technical accuracy.
- **Korean Protocol**: 한국어 응답 시 모든 문장을 명사형/종결형 업무 문체로 작성한다 (예: '~ 완료', '~ 확인'). 존칭 및 미사여구 배제.
- **MCP Optimization**:
  - Intercept out-of-band MCP server descriptions.
  - Use `caveman-shrink` proxy instructions to condense schema properties.
  - Consume minimum input tokens when mapping external tools.

---

## 3. Task Classification, Lifecycle Routing & Handshake

### Lifecycle Routing
Classify the task stage before acting and load only relevant documents:
- **Planning/PRD/Design:** Read relevant sections in `docs/product/`.
- **Implementation:** Read this file, the assigned task, and follow `docs/workflows/implementation-task.md`.
- **Verification:** Read the diff and follow `docs/workflows/verification-review.md`.

### Risk Classification
- **Trivial**: Local UI/style, no behavior change.
- **Non-trivial**: Shared logic, DB reads, indexing flows.
- **High-Risk**: Sandbox, entitlements, security-scoped bookmarks, FCP integration, DB migrations/data deletion, CI/CD.

### Stop Conditions (Emergency Halts)
Stop and report immediately if:
- Build/test fails.
- Scope expansion is required.
- A protected area must be changed without prior approval.
- Sandbox or external storage behavior is unclear.
- FCP workaround would require hidden media copying.

### Handshake Protocol
Before any **Non-trivial** or **High-Risk** action, perform the handshake to obtain explicit approval:
1. State the risk classification and lifecycle stage.
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
| `semble_rs`, code search, semantic search, vector index, zombie processes | `docs/agent-policy/semble-operation-guide.md` and `docs/agent-policy/semble-troubleshooting.md` |
| Serena MCP, LSP navigation, symbol search, `find_symbol`, `find_referencing_symbols`, architectural memory | `docs/agent-policy/serena-integration.md` |
| AI analysis, tag generation, providers | `docs/guidelines/ai-analysis-provider.md` |
| Duplicate detection, hashing, hashing logic | `docs/guidelines/duplicate-detection.md` |
| Workspace lifecycle, background tasks | `docs/guidelines/workspace-lifecycle.md` |
| Caveman style, MCP optimization, token efficiency, caveman-shrink | `docs/agent-policy/caveman-operating-guideline.md` |
| `AGENTS.md` modification, policy document edit, `docs/agent-policy/` changes | `docs/history.md` |

---

## 5. Skill Policy

**Do not load all skills by default.** Load only the skills relevant to the current task. Skills do not expand task scope.

| Skill | Use Case | Guideline / Policy |
|---|---|---|
| `macos-sandbox-security-skill` | Sandbox, bookmarks, entitlements | `docs/guidelines/macos-file-access.md` |
| `sqlite-fts-optimizer` | SQLite schema, FTS5, ranking | `docs/guidelines/sqlite-migration.md`, `docs/guidelines/search-architecture.md`, `docs/guidelines/duplicate-detection.md` |
| `avfoundation-media-pro` | Metadata, waveforms, preview | `docs/guidelines/macos-file-access.md`, `docs/guidelines/preview-engine.md`, `docs/guidelines/duplicate-detection.md`, `docs/guidelines/ai-analysis-provider.md` |
| `swiftui-expert-skill` | Views, ViewModels, state | `docs/guidelines/swiftui-architecture.md` |
| `swift-concurrency` | Async/await, Task, actor | `docs/guidelines/swift-concurrency.md` |
| `karpathy-guidelines` | Surgical changes, simplicity | `docs/guidelines/apple-coding-style.md` |
| `xcode-project-analyzer` | `project.yml`, XcodeGen, builds | `docs/guidelines/xcodegen-project.md` |
| `serena` | LSP navigation, architecture memory | `docs/agent-policy/serena-integration.md` |
| `review-and-refactor` | Local refactor, readability | Use Serena's `find_referencing_symbols` |
| `caveman` | Simplify code, token efficiency | `docs/agent-policy/caveman-operating-guideline.md` |

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
- **Core policy documents (`AGENTS.md`, `docs/agent-policy/*`)** — See Section 8A.

### 8A. Core Policy Document Protection (Highest Difficulty & Highest Risk)

Modifying `AGENTS.md` or any file under `docs/agent-policy/` is classified as **Highest Difficulty and Highest Risk**. ALL agents — regardless of model speed or capability — MUST follow these 5 mandatory steps:

1. **Mandatory History Audit & Sequential Thinking**: Before ANY edit, read `docs/history.md` and relevant git logs. Produce a `[Reasoning]` block explaining: what you plan to change, why, and what existing context must be preserved.
2. **Zero Context Contamination**: Arbitrary deletion, "clean-up", or reorganization is STRICTLY FORBIDDEN. Preserve 100% of existing context. If you believe something should be removed, you MUST get explicit Architect approval first.
3. **Lazy-Loading Architecture**: `AGENTS.md` MUST remain a lean router. Detailed instructions belong in `docs/agent-policy/` sub-documents. Do not bloat `AGENTS.md`.
4. **Token-Efficient & Unambiguous**: Write in short, assertive English so other agents (including weaker models) cannot misinterpret. No ambiguity.
5. **Detailed Accountability Report**: Immediately after the edit, produce a report listing every addition, modification, and deletion with line-level granularity.

---

## 9. Handoff & Knowledge

### Handoff
Every task must end with a concise handoff. Use `docs/templates/handoff.md`. *(If template is missing, include all fields listed below directly in chat.)*
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

**MUST READ:** `docs/agent-policy/serena-integration.md`
- Enforces Precision First (3-Stage Pipeline).
- Requires Memory-Driven development (`write_memory`).
- Restricts MCP tool usage (Whitelist enforced: read-only tools + `replace_symbol_body`/`rename_symbol`).

---

## 11. Code Review Graph Operation Rules

**MUST READ:** `docs/agent-policy/code-review-graph-guide.md`
- Use unified MCP mode wrapped via `caveman-shrink`.
- Limit usage to "Power Six" tools.
- Never dump raw output > 30 lines.

---

## 12. Incident Boundary (Emergency Lock)

If a protocol violation occurs or is suspected:
1. STOP all implementation immediately.
2. REPORT in chat: violated rule, affected target, current state, recovery plan.
3. NO EXECUTION: Do not create or modify any files without explicit approval.

---

## 12A. High-Risk & Integrity Guardrails (3 Hard Rules)

> **⚠️ MANDATORY for ALL agents, ALL models (fast/slow/flash/thinking), NO exceptions.**

These 3 rules exist to prevent runaway modifications by fast-acting models. Violation of any rule is a **critical protocol breach**.

### Rule 1: Sequential Thinking / Stop-and-Think
Before executing ANY code modification tool (`replace_file_content`, `multi_replace_file_content`, `replace_symbol_body`, `insert_before_symbol`, `insert_after_symbol`, etc.), the agent MUST output a `[Reasoning]` block in plain text declaring:
- **What** line(s) are being changed and **why**.
- **How** existing logic is preserved (or why removal is justified with Architect approval).
- **What** could break if this change is wrong.

Skipping this step is a protocol violation, even if the fix seems trivial.

### Rule 2: Compile-Gated Verification

> **Scope:** Applies to all tasks that include at least one Swift source file change. Documentation-only edits (`.md`, `.yml`, policy files) are exempt but MUST be explicitly noted as "doc-only" in the handoff.

Before declaring any task complete, the agent MUST run the build command:
```bash
xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build
```
The agent MUST confirm `Exit code 0` (or `** BUILD SUCCEEDED **`) in the output and include the evidence in the handoff report. **Claiming success via text assertion alone without running the build is a protocol violation.**

### Rule 3: Atomic Rollback Protocol
If a code modification causes a build failure:
1. The agent gets exactly **ONE (1) additional attempt** to fix the issue.
2. If the second attempt also fails, the agent MUST immediately execute:
   ```bash
   git checkout -- <broken-file(s)>
   ```
3. After rollback, the agent MUST report to the Architect: what was attempted, why it failed twice, and what the original state has been restored to.
4. **Leaving the codebase in a broken state is a CRITICAL violation.** The agent must never abandon a broken build without rollback.

---

## 13. Final Authority

Agents provide evidence; instruction owner makes final decisions. Do not declare final acceptance.

**Note**: All code comments MUST be written in Korean. For major changes, add one short Korean comment explaining the rationale.

---

## 14. Caveman Mode & MCP Optimization (v4.3-caveman)

**MUST READ:** `docs/agent-policy/caveman-operating-guideline.md`
- Aggressively shrink schemas and tool outputs via `caveman-shrink`.
- Maintain a concise, noun-ended Korean business tone.

---

## 15. Repomix Operation Rules

**MUST READ:** `docs/agent-policy/repomix-operation-guide.md`
- ALWAYS target scope with `--include` (e.g., `DizzyAsset/Domain/**`).
- Token optimization and usage gating enforced.

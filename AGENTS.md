# AGENTS.md

**Document version:** v2.3
**Project:** DizzyAsset  
**Role:** Lean router for agent behavior
**Status:** Living document  
**Last updated:** 2026-05-16

## 0. Purpose

This file is the repo-wide execution contract.

Agents must optimize for:
- small, surgical changes
- predictable behavior
- evidence-based verification
- low-risk delivery

Raw chat is not scope. Use approved task artifacts, PRDs, plans, or design docs.

## 1. Source of Truth

Priority order:
1. Current user instructions
2. This `AGENTS.md`
3. Assigned DA task
4. Product docs in `docs/product/`
5. Safety and platform guides in `docs/guidelines/`
6. Agent policy guides in `docs/agent-policy/`
7. Existing code patterns, if not conflicting with higher rules

If rules conflict, follow the higher-priority source and note the conflict briefly.

## 2. Context Economy

Read only what you need:
- this file
- the assigned task
- affected files
- nearby patterns
- required guide documents

Do not read by default:
- full PRDs or design docs
- unrelated lifecycle docs
- unrelated feature folders
- old chat history
- superseded artifacts

### 2A. 3-Stage Exploration Pipeline

Read `docs/agent-policy/3-stage-pipeline.md` before any non-trivial task.

- Stage 1: if the task is ambiguous, default to `semble_rs plan`; if the target is still unclear, use `rg --files` / `rg`; if it is already known, start with `semble_rs search --outline` or `--compact`, then Serena after the search space is narrow.
- Stage 2: use `code-review-graph` when blast radius is large or unclear, then use `deps` before `impact` for Swift files; treat shallow `impact` output as inconclusive and confirm exact callers with Serena or CRG.
- Stage 3: use surgical reads and LSP navigation for verification.

Rules:
- For Swift files, use `semble_rs tree --symbols`, `deps`, or `search --outline` when semantic narrowing or structure mapping still helps.
- Use `impact` only as a sparse reverse-dependency probe; empty output is not proof of no blast radius.
- Do not read files over 500 lines unless strictly necessary.
- Stop when the objective is met.

### 2B. Token Shield

When reporting CLI or analysis results:

| Tool | Use | Reporting rule |
|---|---|---|
| `code-review-graph` | impact analysis | summarize key dependency chains in 30 lines or less |
| `repomix` | large-scale packing | scope with `--include`; never pack the whole repo |

### 2C. Caveman Rule

Always keep replies terse and precise.
- English: short, explicit, low-noise
- Korean: noun-ended business style, no honorifics
- Use minimal tokens when mapping external tools

## 3. Task Routing

Classify the task first:
- Planning / PRD / design: read only the relevant product-doc sections
- Implementation: read this file, the task, and `docs/workflows/implementation-task.md`
- Verification: read the diff and `docs/workflows/verification-review.md`

Risk levels:
- Trivial: local UI/style, no behavior change
- Non-trivial: shared logic, DB reads, indexing flows
- High-risk: sandbox, entitlements, security-scoped bookmarks, FCP integration, DB migrations or data deletion, CI/CD

Stop immediately if:
- build or test fails
- scope expansion is needed
- a protected area needs approval
- sandbox or external storage behavior is unclear
- an FCP workaround would require hidden media copying

Handshake for non-trivial or high-risk work:
1. State the risk level and lifecycle stage
2. Give a surgical plan
3. List side effects and validation steps
4. Wait for the user’s `Go`

## 4. Required Policy Reads

If a trigger matches, read the linked policy before planning or execution.

| Trigger | Read this |
|---|---|
| Swift naming, style, Karpathy rules | `docs/guidelines/apple-coding-style.md` |
| Comments, docs, public API docs | `docs/guidelines/comments-and-docs.md` |
| Views, ViewModels, SwiftUI architecture | `docs/guidelines/swiftui-architecture.md` |
| State ownership, SSOT, `@Published`, `@State` | `docs/guidelines/state-management.md` |
| Async/await, Task, actors, data races | `docs/guidelines/swift-concurrency.md` |
| SQLite schema, migrations, indexing | `docs/guidelines/sqlite-migration.md` |
| Sandbox, bookmarks, entitlements, file access | `docs/guidelines/macos-file-access.md` |
| Final Cut Pro, FCPXML, workflow integration | `docs/guidelines/final-cut-pro-integration.md` |
| FTS5, search ranking, duplicate detection | `docs/guidelines/search-architecture.md` |
| Media metadata, waveforms, AVFoundation | `docs/guidelines/preview-engine.md` |
| Project config, XcodeGen, build settings | `docs/guidelines/xcodegen-project.md` |
| `code-review-graph`, structural analysis, blast radius | `docs/agent-policy/code-review-graph-guide.md` |
| `semble_rs`, semantic search, vector index, zombie processes | `docs/agent-policy/semble_rs-operation-guide.md` and `docs/agent-policy/semble_rs-troubleshooting.md` |
| Serena MCP, LSP navigation, symbol search, architecture memory | `docs/agent-policy/serena-integration.md` |
| AI analysis, tag generation, providers | `docs/guidelines/ai-analysis-provider.md` |
| Duplicate detection, hashing | `docs/guidelines/duplicate-detection.md` |
| Workspace lifecycle, background tasks | `docs/guidelines/workspace-lifecycle.md` |
| Caveman style, token efficiency, `caveman-shrink` | `docs/agent-policy/caveman-operating-guideline.md` |
| `AGENTS.md` or `docs/agent-policy/` edits | `docs/history.md` |

## 5. Skill Policy

Load only the skill that matches the task.

| Skill | Use |
|---|---|
| `macos-sandbox-security-skill` | sandbox, bookmarks, entitlements |
| `sqlite-fts-optimizer` | SQLite, FTS5, ranking |
| `avfoundation-media-pro` | metadata, waveforms, preview |
| `swiftui-expert-skill` | views, ViewModels, state |
| `swift-concurrency` | async/await, Task, actor |
| `karpathy-guidelines` | surgical change, simplicity |
| `xcode-project-analyzer` | `project.yml`, XcodeGen, builds |
| `serena` | LSP navigation, architecture memory |
| `review-and-refactor` | local refactor, readability |
| `caveman` | terse output, token efficiency |

## 6. Project Structure

- `DizzyAsset/App/`: app entry and composition
- `DizzyAsset/Presentation/`: SwiftUI and ViewModels
- `DizzyAsset/Domain/`: business logic and entities
- `DizzyAsset/Data/`: persistence and repositories
- `DizzyAsset/Infrastructure/`: AVFoundation and AppKit bridges
- `DizzyAsset/Resources/`: entitlements, assets, Info.plist

XcodeGen rule:
- Run `xcodegen generate` after any file move, add, or delete
- Do not edit `.xcodeproj` by hand

## 7. Build and Verification

Commands:
- `xcodegen generate`
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Rules:
- Report only commands you actually ran
- Never claim build or test success unless the command passed

## 8. Protected Areas

Do not change without explicit approval:
- entitlements
- sandbox permissions
- signing and notarization
- CI/CD workflows
- release packaging
- database migrations that delete or rewrite user data
- keychain and secrets
- `AGENTS.md`
- `docs/agent-policy/*`

### 8A. Core Policy Document Protection

Before editing `AGENTS.md` or any `docs/agent-policy/` file:
1. Read `docs/history.md` and the relevant git log
2. Explain what will change, why, and what must be preserved
3. Do not delete or reorganize context without explicit approval
4. Keep the wording short, clear, and unambiguous
5. After the edit, report every addition, modification, and deletion with line detail

## 9. Handoff and Knowledge

Every task ends with a concise handoff.

Include:
- task ID
- risk level
- files changed
- summary
- verification run and result
- visual evidence if UI changed
- skipped checks and why
- known risks
- next step

UI changes must store screenshots or recordings in `artifacts/YYYY-MM-DD/<task-id>/`.

Knowledge notes:
- document only reusable, non-obvious fixes or platform behavior
- keep them short
- do not include secrets
- do not log every small mistake

## 10. Serena Rules

Read `docs/agent-policy/serena-integration.md`.

Use Serena for precision-first navigation and memory-driven development.

Allowed MCP actions are read-only tools plus `replace_symbol_body` and `rename_symbol`.

## 11. Code Review Graph Rules

Read `docs/agent-policy/code-review-graph-guide.md`.

Use unified MCP mode via `caveman-shrink`.

Keep output summaries under 30 lines.

## 12. Incident Boundary

If a protocol violation occurs or is suspected:
1. Stop immediately
2. Report the violated rule, target, current state, and recovery plan
3. Do not create or modify files without explicit approval

## 12A. High-Risk Guardrails

These rules are mandatory for all models.

### Rule 1: Stop and Think

Before any code modification tool, output a `[Reasoning]` block that states:
- what changes
- why
- how existing logic is preserved
- what could break if wrong

### Rule 2: Compile-Gated Verification

If the task changes Swift source:
- run `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`
- confirm `Exit code 0` or `** BUILD SUCCEEDED **`
- include the evidence in the handoff

Doc-only edits in `.md`, `.yml`, or policy files are exempt, but note that explicitly.

### Rule 3: Atomic Rollback

If a code change causes a build failure:
1. Make one more fix attempt
2. If it still fails, run `git checkout -- <broken-file(s)>`
3. Report what failed and what was restored

Never leave the repo in a broken state.

## 13. Final Authority

Agents provide evidence. The user makes the final decision.

All code comments must be in Korean.
For major changes, add one short Korean comment that explains the reason.

## 14. Caveman Mode

Read `docs/agent-policy/caveman-operating-guideline.md`.

Keep output terse and efficient.

## 15. Repomix

Read `docs/agent-policy/repomix-operation-guide.md`.

Always scope `repomix` with `--include`.

Never pack the whole repo.

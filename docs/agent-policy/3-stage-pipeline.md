# 3-Stage Exploration Pipeline (Swift-Adapted MCP-Only Workflow)

> **⚠️ CRITICAL (Swift Limitation):** This is a Swift project. `semble_rs` AST-based dependency analysis (`deps`, `impact` subcommands) does NOT work for Swift. Only `semble_rs search` is permitted. All impact analysis MUST use CRG MCP or Serena MCP.

---

## Stage 1: Discovery (Fast Text Search)

- **Tool:** `semble_rs search --compact` ONLY.
- **Purpose:** Locate candidate files, symbols, and code snippets via keyword/intent-based search.
- **Note:** Auto-indexing is disabled for performance. Pass `repo="."` or a git URL explicitly to index on demand. Indexes are cached for the session.
- **Prohibited:** Do NOT use `semble_rs deps`, `semble_rs impact`, or any AST-dependent subcommand.

---

## Stage 2: Impact Analysis (Structural & Semantic)

- **Primary Tool:** `code-review-graph` MCP (`get_impact_radius_tool`, `query_graph_tool`).
- **Secondary Tool:** `Serena` MCP (`get_symbols_overview`, `find_symbol`, `find_referencing_symbols`).
- **Supplementary:** For platform APIs (SwiftUI, AVFoundation, etc.), use `search_web` or `read_url_content` for official Apple docs.
- **Connection order:** MCP Proxy (Wrapped in `caveman-shrink`) first → CLI fallback. Use whitelisted "Power Six" tools for maximum efficiency.
- **Maintenance:** Must run `code-review-graph update` after major refactoring or structural changes.

---

## Stage 3: Verification & Review

- **Primary Tool:** `Serena` (LSP) for precision symbol navigation and definition/reference verification.
- **Validation Tool:** `code-review-graph` MCP (`detect_changes_tool`) to confirm blast radius post-modification.
- **Surgical Read:** `Grep/Read` — deep, precision reading only within confirmed scopes. Strictly limit to specific Line Ranges.
- **History:** `Git` — review change history for final verification.

---

## Efficiency Constraints

- **Gating Principle**: Proceed to the next Stage only if current results are insufficient. Unnecessary tool calls are forbidden. Stop immediately once the objective is met.
- **Minimal Context**: Do not include unrelated code in the context.
- **Selective Reading**: Do not read files over 500 lines in their entirety. Use Skeleton analysis first, then read specific function ranges.
- **Incremental Output**: Use diff/patch formats instead of rewriting entire files.
- **Trivial Exception**: Stages 1-2 can be skipped for typos or simple comment edits with no logic changes.

**DO NOT load unrelated policy files, full project docs for a single task, roadmap/future-scope notes during implementation, unrelated feature directories, old chat history when an approved artifact exists, or broad directories "just in case".**

---

## Workflow Principle

> **"Discover with semble_rs (search only), Analyze impact with CRG/Serena (MCP), Verify with LSP and re-validate with CRG detect_changes. No exceptions."**

---

## Advanced Token Utilities & Fallbacks

- **Repomix:** Use `--include` to narrow the analysis scope and prevent token waste (e.g., `npx repomix --include "DizzyAsset/Domain/**"`).
- **CLI Failure Fallback:** If CLI tools fail due to environment issues, fallback to traditional `grep` and `find`. **CRITICAL:** Limit the search range extremely narrowly to minimize token waste.

**For Non-trivial+ work, use `code-review-graph` (MCP Proxy) before broad manual exploration. If the MCP server is unavailable, fallback to CLI: `npx caveman-shrink code-review-graph detect-changes --base HEAD~1`**

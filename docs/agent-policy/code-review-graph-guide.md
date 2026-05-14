# Code-Review-Graph MCP & CLI Operation Guide

This guide defines the standard procedure for using `code-review-graph` to maximize token efficiency and structural analysis accuracy in the DizzyAsset project.

---

## 1. Primary Mode: MCP Proxy (High Performance)

All agents MUST use the `code-review-graph` MCP server wrapped by `caveman-shrink`. This ensures all outputs are compressed, saving up to 75% in token costs while maintaining full technical accuracy.

### Whitelisted Tools (The Power Six)
To maintain the 50-tool execution limit and optimize performance, only the following core tools are exposed:

1.  **`query_graph_tool`**: Explore relationships (callers, callees, imports, etc.).
2.  **`semantic_search_nodes_tool`**: Find code entities by natural language or keywords.
3.  **`detect_changes_tool`**: Analyze the impact of current changes vs base branch.
4.  **`get_review_context_tool`**: Generate focused context for comprehensive code reviews.
5.  **`get_impact_radius_tool`**: Identify the blast radius of modifications.
6.  **`get_architecture_overview_tool`**: Understand high-level community structure and coupling.

---

## 2. Fallback Mode: CLI (Diagnostic & Maintenance)

If the MCP server is unavailable or fails due to environment restrictions, use the CLI via `caveman-shrink`.

### CLI Subcommand Mapping
| MCP Tool Name | CLI Fallback Command |
|---|---|
| `query_graph_tool` | `npx caveman-shrink code-review-graph query-graph` |
| `semantic_search_nodes_tool` | `npx caveman-shrink code-review-graph semantic-search` |
| `detect_changes_tool` | `npx caveman-shrink code-review-graph detect-changes` |
| `get_review_context_tool` | `npx caveman-shrink code-review-graph get-review-context` |
| `get_impact_radius_tool` | `npx caveman-shrink code-review-graph get-impact-radius` |
| `get_architecture_overview_tool` | `npx caveman-shrink code-review-graph get-architecture-overview` |

---

## 3. Maintenance Commands

For administrative tasks not covered by MCP tools, use these CLI commands:

- **Graph Health Check**: `npx caveman-shrink code-review-graph status`
- **Rebuild/Update Graph**: `npx caveman-shrink code-review-graph update`
  - *Note: Run this after major refactoring or any structural file changes (add/delete/move).*

---

## 4. Trigger Scenarios & Protocol

1.  **Non-trivial Task**: Use `detect_changes_tool` or `get_impact_radius_tool` before planning. Identify downstream impacts.
2.  **Code Review**: Use `get_review_context_tool` to gather necessary snippets and relationship data.
3.  **Refactoring**: Use `query_graph_tool` to trace dependency chains.
4.  **Validation**: Re-run impact analysis after modification to verify no unintended side effects.

### 🛡️ Token Defense Rule
Do not dump raw output from these tools if they exceed 30 lines. Summarize key dependency chains and structural insights for the Architect.

---

## 5. Mandatory Operation Rules (from AGENTS.md Section 11)

These rules are authoritative and enforced by `AGENTS.md`.

1. **Unified MCP Mode**: All agents MUST use the `code-review-graph` MCP server wrapped via `caveman-shrink` for all structural analysis tasks.
2. **Tool Whitelist (The Power Six)**: Focus only on the primary tools (`query_graph_tool`, `semantic_search_nodes_tool`, `detect_changes_tool`, `get_review_context_tool`, `get_impact_radius_tool`, `get_architecture_overview_tool`) to stay within 50-tool execution limits.
3. **Reporting Standard**: Do not dump raw output. Report a concise summary of key dependency chains within **30 lines** (refer to `AGENTS.md` Section 2B Token Shield).
4. **CLI Fallback Protocol**: If the MCP server fails, fallback to `npx caveman-shrink code-review-graph <subcommand>`. See Section 2 above for mapping.
5. **Impact Gating**: Non-trivial changes MUST be preceded by a `detect_changes_tool` or `get_impact_radius_tool` run to verify the blast radius.


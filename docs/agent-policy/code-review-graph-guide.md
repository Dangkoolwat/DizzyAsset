# Code-Review-Graph MCP & CLI Guide

Use `code-review-graph` for structural analysis and blast-radius checks.

## 1. Primary Mode

- Use the MCP server wrapped by `caveman-shrink`.
- Primary tools:
  1. `query_graph_tool`
  2. `semantic_search_nodes_tool`
  3. `detect_changes_tool`
  4. `get_review_context_tool`
  5. `get_impact_radius_tool`
  6. `get_architecture_overview_tool`

## 2. CLI Fallback

If MCP is unavailable, use `npx caveman-shrink code-review-graph <subcommand>`.

Common mappings:
- `query_graph_tool` -> `query-graph`
- `semantic_search_nodes_tool` -> `semantic-search`
- `detect_changes_tool` -> `detect-changes`
- `get_review_context_tool` -> `get-review-context`
- `get_impact_radius_tool` -> `get-impact-radius`
- `get_architecture_overview_tool` -> `get-architecture-overview`

## 3. Maintenance

- `status` checks graph health.
- `update` rebuilds the graph after major refactors or file moves.

## 4. Protocol

- Use impact analysis before non-trivial work.
- Use review context for code reviews.
- Use graph queries for dependency tracing.
- Re-run change analysis after modification.
- Never dump raw output over 30 lines.

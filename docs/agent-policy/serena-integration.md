# Serena Integration & Operation Guide

This guide defines the standard Serena workflow for this repository.

## 1. Setup

When starting Serena on a project:

1. Activate the project with `activate_project`.
2. Run `onboarding`.
3. Store core project facts in `memories`.

## 2. Shared State

- Commit `.serena/project.yml`.
- Commit `.serena/memories/`.
- Ignore `/cache`, `/project.local.yml`, and `/logs` in `.serena/.gitignore`.

## 3. Prompt Pattern

- Analysis: use `find_symbol` and `find_referencing_symbols` for implementation and references.
- Refactor: use `rename_symbol` for LSP-safe renames.
- Memory: use `write_memory` after major implementation or architecture decisions.

## 4. Operating Rules

- Non-trivial work uses the 3-stage pipeline from `docs/agent-policy/3-stage-pipeline.md`.
- Read file structure first with symbol overview tools before reading bodies.
- Record durable architecture decisions in Serena memories.

## 5. Troubleshooting

- If no project is active, check registration and run `activate_project` again.
- If analysis is slow, narrow scope with `get_symbols_overview` depth or a smaller path.

## 6. MCP Rules

- Keep only read-only tools plus `replace_symbol_body` and `rename_symbol`.
- Treat all other analysis tools as excluded from the MCP whitelist.

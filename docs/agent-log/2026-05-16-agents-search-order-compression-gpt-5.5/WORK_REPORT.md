# Work Report

- Task ID: `agents-search-order-compression`
- Risk: Non-trivial
- Scope: shorten search-order wording without changing meaning

## What changed

- Compressed the search-order rules in `AGENTS.md`.
- Updated `docs/agent-policy/3-stage-pipeline.md` to match the same meaning.
- Added a history note in `docs/history.md`.

## Why

- Keep the router shorter without losing context.
- Preserve the same three conditions:
  - unclear target -> `rg --files` / `rg`
  - known symbol -> `Serena`
  - large or unclear blast radius -> `code-review-graph`

## Verification

- `git diff --check`

## Risks

- Low risk.
- This is wording compression only.

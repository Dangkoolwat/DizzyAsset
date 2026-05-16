# 3-Stage Exploration Pipeline

This pipeline is mandatory for non-trivial Swift work.

## Stage 1: Discovery

- If the target is unclear, start with `rg --files` / `rg`.
- If the target is already known at symbol level, go straight to Serena.
- Use `semble_rs search` only when semantic narrowing still helps.
- Pass `repo="."` or a git URL when indexing on demand.
- Do not use `semble_rs deps`, `semble_rs impact`, or any AST-based command.

## Stage 2: Impact Analysis

- Primary: `code-review-graph` when blast radius is large or unclear.
- Secondary: Serena for exact symbol checks.
- Use CRG for blast radius and dependency chains.
- Use Serena for symbol overview, definitions, and references.
- Use official Apple docs only when platform API confirmation is needed.
- Wrap MCP access with `caveman-shrink` when available.
- Run `code-review-graph update` after major structural changes.

## Stage 3: Verification

- Use Serena for precision navigation and reference checks.
- Re-run CRG change analysis after edits.
- Read only the exact lines and scopes you need.
- Use Git history only for final confirmation.

## Efficiency Rules

- Move to the next stage only if the current stage is insufficient.
- Stop when the objective is met.
- Do not read unrelated files or files over 500 lines in full.
- Use diff or patch output instead of rewriting entire files.
- Skip stages 1-2 only for trivial typo or comment-only edits.

## Workflow Rule

If the target is unclear, discover with `rg --files` / `rg` first. If it is already known, use Serena directly. Then use CRG only when blast radius is large or unclear, and verify with LSP reads.

## Fallback Rule

If CRG CLI is needed, use `npx caveman-shrink code-review-graph <subcommand>`.

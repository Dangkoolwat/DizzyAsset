# 3-Stage Exploration Pipeline

This pipeline is mandatory for non-trivial Swift work.

## Stage 1: Discovery

- If the task is ambiguous, start with `semble_rs plan`.
- If the target is still unclear after planning, use `rg --files` / `rg`.
- If the target is already known at symbol level, start with `semble_rs search --outline` or `--compact`, then Serena after the search space is narrow.
- For Swift files, use `semble_rs tree --symbols`, `deps`, or `search --outline` when semantic narrowing or structure mapping still helps.
- Pass `repo="."` or a git URL when indexing on demand.
- Use `impact` only as a sparse reverse-dependency probe; empty output is not proof of no blast radius.

## Stage 2: Impact Analysis

- Primary: `code-review-graph` when blast radius is large or unclear.
- Secondary: Serena for exact symbol checks.
- For Swift files, use `deps` before `impact`; treat shallow or empty `impact` output as inconclusive.
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

If the task is ambiguous, discover with `semble_rs plan` first. If the target is still unclear, use `rg --files` / `rg`. If it is already known, start with `semble_rs search --outline` or `--compact`, then use Serena after the search space is narrow. For Swift files, use `tree --symbols`, `deps`, or `search --outline` before deep reads. Then use CRG only when blast radius is large or unclear, and verify with LSP reads.

## Fallback Rule

If CRG CLI is needed, use `npx caveman-shrink code-review-graph <subcommand>`.

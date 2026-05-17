# semble_rs Operation Guide

`semble_rs` is the first discovery tool for this project. CLI only.

## 1. Purpose

- Use `semble_rs search` for narrow code search and candidate discovery.
- Use `tree --symbols` for a fast project map.
- Use `deps` to confirm the direct imports and symbols of a Swift file.
- Use `ast-grep` when the pattern is already known and syntax-aware narrowing helps.
- Confirm exact source lines with regular reads after search.
- When the task is ambiguous, default to `plan` before deeper search.

## 2. Swift Rule

- Swift supports `tree --symbols`, `deps`, and `search --outline`.
- Use `impact` only as a quick reverse-dependency probe.
- Treat empty `impact` output as inconclusive.
- If a broader structural view is needed, switch to CRG or Serena.
- For Swift dependency checks, prefer `deps` before `impact`.

## 3. Usage

- Search by symbol, keyword, or intent.
- Narrow scope early.
- Avoid broad directory scans when the target is known.
- Prefer `search --outline` before `search --compact` when the candidate set is still large.
- If the target is already known, start with `search --outline` or `search --compact` instead of broad planning.

## 4. Tool Order

- `semble_rs` first for discovery.
- CRG or Serena next for impact or symbol precision.
- Use `rg` only as a fallback when `semble_rs` is unavailable or already exhausted.

## 5. Default Values When Unclear

- Ambiguous task framing: default to `plan`.
- Known target or symbol: start with `search --outline` or `search --compact`.
- Swift dependency uncertainty: default to `deps`, then `impact`, then CRG or Serena for exact caller checks.
- Noisy or long build/test output: keep only the relevant error lines in the task context.

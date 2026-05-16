# semble_rs Operation Guide

`semble_rs` is the first discovery tool for this project. CLI only.

## 1. Purpose

- Use `semble_rs search` for narrow code search and candidate discovery.
- Use `tree --symbols` for a fast project map.
- Use `deps` to confirm the direct imports and symbols of a Swift file.
- Confirm exact source lines with regular reads after search.

## 2. Swift Rule

- Swift supports `tree --symbols`, `deps`, and `search --outline`.
- Use `impact` only as a quick reverse-dependency probe.
- Treat empty `impact` output as inconclusive.
- If a broader structural view is needed, switch to CRG or Serena.

## 3. Usage

- Search by symbol, keyword, or intent.
- Narrow scope early.
- Avoid broad directory scans when the target is known.
- Prefer `search --outline` before `search --compact` when the candidate set is still large.

## 4. Tool Order

- `semble_rs` first for discovery.
- CRG or Serena next for impact or symbol precision.
- Use `rg` only as a fallback when `semble_rs` is unavailable or already exhausted.

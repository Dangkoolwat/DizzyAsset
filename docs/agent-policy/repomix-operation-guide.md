# Repomix Operation Guide

This document defines the operational rules for using Repomix in the DizzyAsset project.

---

## 1. Scope Targeting

ALWAYS use the `--include` flag to specify only the relevant modules or directories.

```bash
npx repomix --include "DizzyAsset/Domain/**"
```

Do NOT run Repomix without `--include`. Full project packing is forbidden.

---

## 2. Ignore Patterns

Use `--ignore` or ensure `.repomixignore` excludes non-source files:
- `.xcodeproj`
- `.xcassets`
- `DerivedData`
- `.git`
- `build/`

---

## 3. Token Efficiency

If the output is still too large after `--include`, combine with `caveman-shrink` for further compression.

---

## 4. Usage Gating

Only use Repomix when the prioritized hierarchy (semble_rs → CRG → Serena) is insufficient for comprehensive context. Repomix is a last-resort bulk context tool.

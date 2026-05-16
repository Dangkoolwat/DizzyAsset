# Repomix Operation Guide

Use Repomix only when narrower discovery tools are not enough.

## 1. Scope

- Always use `--include`.
- Target only the relevant modules or directories.
- Never run Repomix on the full repo.

Example:

```bash
npx repomix --include "DizzyAsset/Domain/**"
```

## 2. Ignore Patterns

Exclude non-source paths with `--ignore` or `.repomixignore`:
- `.xcodeproj`
- `.xcassets`
- `DerivedData`
- `.git`
- `build/`

## 3. Efficiency

- If output is still too large, combine Repomix with `caveman-shrink`.
- Use Repomix as a last-resort bulk context tool.

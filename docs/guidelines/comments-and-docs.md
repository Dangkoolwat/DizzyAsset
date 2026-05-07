# Comments and Documentation

**Document:** `docs/guidelines/comments-and-docs.md`

## 1. Documentation Strategy
- Use comments for **why**, not what.
- Public or cross-module APIs SHOULD use documentation comments (`///`).

## 2. When to Comment
- Non-obvious decisions.
- Platform workarounds (macOS/AppKit/Sandbox).
- Permission edge cases.
- Concurrency assumptions.
- Migration risks.
- Temporary MVP shortcuts.

## 3. TODO and FIXME
- Use TODO/FIXME only with a specific reason and task ID if available.
- **Format:** `// TODO(DA-XXX): <Reason>`
- **Bad:** `// TODO: fix later`
- **Good:** `// TODO(DA-020): Replace LIKE query with normalized token search after search index task lands.`

# Semble Operation Guide (Installation & Setup)

This document outlines the installation and maintenance procedures for **Semble**, the ultra-efficient code exploration tool used in this project.

> **⚠️ CRITICAL (Swift Project Limitation):** This is a Swift/Xcode project. `semble_rs` AST-based dependency analysis (`deps`, `impact` subcommands) does **NOT** work for Swift. Only `semble_rs search` (and `search --compact`) is permitted. All structural/impact analysis MUST use `code-review-graph` MCP or `Serena` MCP instead. See `AGENTS.md` Section 2A for the 3-Stage Pipeline.

## Permitted Commands
| Command | Status | Notes |
|---|---|---|
| `semble_rs search --compact` | ✅ Allowed | Primary discovery tool (Stage 1) |
| `semble_rs search` | ✅ Allowed | Verbose variant |
| `semble_rs deps` | ❌ **PROHIBITED** | AST-based, does not support Swift |
| `semble_rs impact` | ❌ **PROHIBITED** | AST-based, does not support Swift |

---

## 1. Installation

We recommend using `uv` to manage the Semble installation to avoid polluting the system Python environment.

```bash
# Install Semble with MCP support
uv tool install "semble[mcp]" --force
```

---

## 2. ⚠️ Intel Mac & Python Compatibility Patch (Mandatory)

On Intel Mac (x86_64) environments, an `ImportError: cannot import name 'manifest_languages'` may occur. A manual patch is required.

### Target File Path
`~/.local/share/uv/tools/semble/lib/python3.13/site-packages/semble/chunking/core.py`
*(Note: Python version may vary, e.g., 3.14)*

### Patch Details
**Before Patch:**
```python
from tree_sitter_language_pack import SupportedLanguage, get_parser, manifest_languages
_TREE_SITTER_LANGUAGES: frozenset[str] = frozenset(manifest_languages())
```

**After Patch:**
```python
from tree_sitter_language_pack import SupportedLanguage, get_parser
_TREE_SITTER_LANGUAGES: frozenset[str] = frozenset([
    'bash', 'c', 'cpp', 'csharp', 'css', 'go', 'html', 'java', 'javascript',
    'json', 'kotlin', 'lua', 'markdown', 'objc', 'ocaml', 'perl', 'php',
    'python', 'ruby', 'rust', 'scala', 'swift', 'toml', 'tsx', 'typescript', 'yaml'
])
```

---

## 3. MCP Configuration

The MCP configuration MUST point to the patched local executable with `args: []`.

### Antigravity (`mcp_config.json`)
```json
"semble": {
  "command": "/Users/sanghyoukjin/.local/bin/semble",
  "args": []
}
```

---

## 4. Verification

To verify functionality, run a search query manually:
```bash
semble search "test query"
```

---

## 5. Performance & Stability
For handling zombie processes and heavy indexing issues, refer to:
- `docs/agent-policy/semble-troubleshooting.md`

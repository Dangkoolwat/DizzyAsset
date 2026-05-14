# Semble Operation Guide (Installation & Setup)

This document outlines the installation and maintenance procedures for **Semble**, the ultra-efficient code exploration tool used in this project.

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

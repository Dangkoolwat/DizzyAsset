# Semble Operation Guide (Agent Policy)

This document outlines the installation and maintenance procedures for **Semble**, the ultra-efficient code exploration tool used in this project.

## 1. Installation

We recommend using `uv` to manage the Semble installation to avoid polluting the system Python environment.

```bash
# Install Semble with MCP support
uv tool install "semble[mcp]" --force
```

## 2. ⚠️ Intel Mac & Python Compatibility Patch (Mandatory)

On Intel Mac (x86_64) environments, an `ImportError` related to `manifest_languages` may occur in the `tree-sitter-language-pack` library. A manual patch is required for the Semble source code.

### Target File Path
`~/.local/share/uv/tools/semble/lib/python3.13/site-packages/semble/chunking/core.py`
*(Note: The Python version in the path may vary depending on your environment, e.g., python3.14)*

### Patch Details
Remove the `manifest_languages` import and replace the dynamic language detection with a hardcoded list of supported languages.

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

## 3. MCP Configuration

The `mcp_config.json` (usually located in the Antigravity app data directory) should point to the patched local executable.

```json
"semble": {
  "command": "/Users/sanghyoukjin/.local/bin/semble"
}
```

## 4. Verification

To verify that the patch is correctly applied and Semble is functional, run a search query:

```bash
semble search "test query"
```

If the command returns results without an `ImportError`, the setup is successful.

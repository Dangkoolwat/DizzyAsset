# Semble Operation Guide (Agent Policy)

This document outlines the installation, troubleshooting, and maintenance procedures for **Semble**, the ultra-efficient code exploration tool used in this project.

---

## 1. Installation

We recommend using `uv` to manage the Semble installation to avoid polluting the system Python environment.

```bash
# Install Semble with MCP support
uv tool install "semble[mcp]" --force
```

---

## 2. ⚠️ Intel Mac & Python Compatibility Patch (Mandatory)

On Intel Mac (x86_64) environments, an `ImportError: cannot import name 'manifest_languages'` may occur in the `tree-sitter-language-pack` library. A manual patch is required.

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

---

## 3. MCP Configuration

The MCP configuration for various tools should point to the **patched local executable**. The `args` should be set to `[]` (empty array) to prevent automatic indexing on startup, which can cause performance issues in large projects.

### Antigravity (`mcp_config.json`)
```json
"semble": {
  "command": "/Users/sanghyoukjin/.local/bin/semble",
  "args": []
}
```

### Codex (`~/.codex/config.toml`)
```toml
[mcp_servers.semble]
command = "/Users/sanghyoukjin/.local/bin/semble"
args = []
```

### OpenCode (`~/.config/opencode/opencode.json`)
```json
"semble": {
  "type": "local",
  "enabled": true,
  "command": ["/Users/sanghyoukjin/.local/bin/semble"]
}
```

---

## 4. Heavy Loading & Zombie Processes (Mandatory Operational Policy)

In large projects (e.g., massive `.git` folders or many binaries), automatic indexing and file watching can cause significant system overhead or "Python zombie processes".

### Handling Strategy
1. **Disabled Auto-Indexing**: Always keep `args: []` in the MCP config.
2. **On-Demand Indexing**: Explicitly pass the repository path (e.g., `repo="."`) only when calling the `search` tool for the first time in a session.
3. **Zombie Cleanup**: If the system becomes unresponsive or many `semble` processes are seen, run the following in the terminal:
   ```bash
   pkill -f "semble"
   ```

---

## 5. Verification

To verify that the patch is correctly applied and Semble is functional, run a search query manually:

```bash
semble search "test query"
```

If the command returns results without an `ImportError`, the setup is successful.


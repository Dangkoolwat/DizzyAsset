# Semble Troubleshooting & Optimization Guide

This document defines the protocols for handling performance issues and system overhead caused by Semble in large-scale projects.

---

## 1. Heavy Loading & System Overhead

In large projects (e.g., massive `.git` folders, many binary assets), automatic indexing and file watching can cause significant system lag or "Python zombie processes".

### Operational Policy
1.  **Strictly Disabled Auto-Indexing**: The MCP configuration MUST always keep `args: []` (empty array). Automatic indexing on startup is forbidden.
2.  **On-Demand Indexing**: Explicitly pass the repository path (e.g., `repo="."`) only when calling the `search` tool for the first time in a session. Subsequent calls will use the cached index.
3.  **Scope Limitation**: When possible, restrict search scope to specific directories to minimize token waste and analysis time.

---

## 2. Zombie Process Management

If the system becomes unresponsive or you detect multiple `semble` processes consuming high CPU/Memory, follow the cleanup protocol.

### Cleanup Command
Run the following in the terminal to immediately terminate all Semble-related processes:
```bash
pkill -f "semble"
```

### Prevention
- Avoid repeated failed indexing attempts.
- If a repository fails to index, report it to the user instead of retrying indefinitely.

---

## 3. Vector Indexing Failures

If semantic search fails to return results or errors out:
- Verify that the Intel Mac compatibility patch (detailed in `semble-operation-guide.md`) is correctly applied.
- Ensure `uv` is used for tool management to prevent dependency conflicts.

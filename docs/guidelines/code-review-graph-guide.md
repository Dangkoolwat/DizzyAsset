# Code-Review-Graph CLI Operation Guide

This guide defines the standard procedure for using `code-review-graph` via CLI to maximize token efficiency and structural analysis accuracy in the DizzyAsset project.

---

## 1. Rationale: CLI over MCP
To reduce system prompt overhead, `code-review-graph` is operated as a CLI tool rather than an always-on MCP server. This saves significant tokens per dialogue turn and prevents context saturation.

## 2. Standard Command Prefix
All agents MUST use the following prefix to ensure output is optimized for LLM consumption:
```bash
npx caveman-shrink code-review-graph [command]
```

## 3. Core Commands & Usage

### A. `status` (Graph Health Check)
- **Use when:** Verifying if the graph is up-to-date or checking project scale.
- **Command:** `npx caveman-shrink code-review-graph status`

### B. `detect-changes` (Impact Analysis)
- **Use when:** Before proposing a plan for Non-trivial or High-Risk tasks. This is MANDATORY for identifying the "Blast Radius".
- **Command:** `npx caveman-shrink code-review-graph detect-changes --base HEAD~1`

### C. `build` / `update` (Maintenance)
- **Use when:** Significant file changes have occurred (add, delete, rename) and the graph needs synchronization.
- **Command:** `npx caveman-shrink code-review-graph update`

## 4. Trigger Scenarios
- **Non-trivial Task:** Run `detect-changes` to identify affected downstream modules.
- **New Feature:** Run `status` to ensure current architectural context is loaded.
- **Validation Phase:** Run `detect-changes` again after modification to verify no unintended side effects.

## 5. Protocol Adherence
Agents must report the results of these CLI calls in their handshake or validation reports as evidence of structural verification. Failure to update the graph after structural changes is a protocol violation.

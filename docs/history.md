# AGENTS.md Change History

This document tracks the evolution of `AGENTS.md` and core policy documents.  
**Purpose:** Agents MUST read this file before modifying any core policy document (see Section 8A).

---

## v2.1 — 2026-05-14

**Scope:** Zero Trust Architecture upgrade.

### Changes
1. **Section 2A restructured**: Step 0–4 linear hierarchy → 3-Stage Pipeline (Discovery / Impact / Review).
   - Swift limitation explicitly declared: `semble_rs deps` and `impact` PROHIBITED.
   - MCP-only workflow enforced (CRG + Serena).
2. **Section 8 enhanced**: Protected Areas now includes core policy documents (`AGENTS.md`, `docs/agent-policy/*`).
   - New Section 8A: 5-step mandatory process for editing policy documents (History Audit, Zero Context Contamination, Lazy-Loading, Unambiguous English, Accountability Report).
3. **Section 12A added**: 3 Hard Guardrails.
   - Rule 1: Sequential Thinking / Stop-and-Think (`[Reasoning]` block required before code edits).
   - Rule 2: Compile-Gated Verification (`xcodebuild` must succeed before task completion).
   - Rule 3: Atomic Rollback Protocol (1 retry, then `git checkout`).
4. **`docs/agent-policy/semble-operation-guide.md`**: Swift limitation warning and prohibited commands table added.
5. **Context Economy (Section 2)**: Explicit read whitelist/blacklist restored from git history.
6. **Lifecycle Routing & Stop Conditions (Section 3)**: Restored from git history.
7. **Skill Policy (Section 5)**: `review-and-refactor` and `caveman` skills restored from git history.
8. **Version**: v2.0 → v2.1. Last updated: 2026-05-14.

---

## v2.0 — 2026-05-13

**Scope:** Major restructuring from lean router (v1.x) to mandatory execution contract.

### Changes
1. Merged Section 0 (Purpose) and Section 1 (Operating Model) into unified "Purpose & Operating Model".
2. Source of Truth reordered: User instructions > AGENTS.md > DA task > Product Docs > Guidelines > Code patterns.
3. Tool hierarchy introduced as Section 2A with Steps 0–4 (Semble → CRG → Skeleton → Serena → Grep → Git).
4. Section 2B Token Shield added with CLI result reporting rules.
5. Task Classification & Handshake merged into Section 3.
6. Section 4 converted from static list to Lazy-Loaded Policy Trigger table.
7. Context Economy rules inlined into Section 2 (previously standalone Section 7).
8. Sections renumbered: old 7–13 became 6–13.
9. Added Sections 10 (Serena Operation Rules), 11 (CRG Operation Rules), 12 (Incident Boundary).
10. Caveman Mode (Section 14) and Repomix Rules (Section 15) added.

---

## v1.7 — 2026-05-13

### Changes
1. Token Shield table (Section 2B) introduced.
2. code-review-graph guide reference added to Section 4.
3. Serena Operation Rules updated: MCP Optimization with `disabledTools` directive.
4. Step descriptions compressed (Step 0–3 reworded).

---

## v1.6 — 2026-05-07

### Changes
1. New guideline references: search-architecture, duplicate-detection, preview-engine, ai-analysis-provider.
2. sqlite-fts-optimizer skill expanded with 3 guideline references.
3. avfoundation-media-pro skill expanded with 4 guideline references.

---

## v1.5.2 — 2026-05-07

### Changes
1. Source of Truth: "Safety & platform guidelines" split from "Style and non-critical guidelines" (priority 5 vs 7).

---

## v1.5.1 — 2026-05-07

### Changes
1. Product Docs consolidated into single line reference.
2. Lifecycle Routing: Added workflow file references (`implementation-task.md`, `verification-review.md`).
3. Handoff template reference added (`docs/templates/handoff.md`).

---

## v1.5 — 2026-05-07

Version bump only.

---

## v1.4.1 — 2026-05-07

### Changes
1. Skill Policy expanded: Added `xcode-project-analyzer`, `code-review-graph`, `review-and-refactor`, `caveman` skills.
2. Verification Rules added to Build section.
3. Risk Classification expanded with detailed High-Risk categories.
4. Stop Conditions added.
5. Protected Areas (Section 10) split from Task Execution.
6. Handoff format expanded with 9 required fields.
7. Knowledge Base rules added (keep short, no logs, no secrets, reusable only).

---

## v1.4 — 2026-05-07

### Changes
1. Major restructuring: inlined technical guidelines converted to `docs/guidelines/` router pattern.
2. Document declared as "lean router" — technical details moved to external files.
3. Sections reduced from ~1400 lines to ~160 lines.

---

## v1.3 and earlier

Initial versions. Full inline technical guidelines covering Swift style, SwiftUI architecture, concurrency, SQLite, sandbox, FCP integration, and more. All subsequently extracted to `docs/guidelines/`.

- 2026-05-16 | agents-search-order-compression | shortened the search-order wording in AGENTS.md and 3-stage-pipeline while keeping the same rg-unclear, Serena-known, CRG-large-or-unclear meaning

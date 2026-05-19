# AGENTS.md Change History

This document tracks the evolution of `AGENTS.md` and core policy documents.  
**Purpose:** Agents MUST read this file before modifying any core policy document (see Section 8A).

---

## v3.2 — 2026-05-19

**Scope:** Make review routing and audit trail hints more visible.

### Changes
1. **Section 4 clarified**: `AGENTS.md` / `docs/agent-policy/` edits now point to `docs/history.md` and the relevant git log.
2. **Section 9 clarified**: implementation handoffs stay separate from review reports, and review tasks now point to `docs/templates/review-report.md`.
3. **Version**: v3.1 → v3.2. Last updated: 2026-05-19.

---

## v3.1 — 2026-05-18

**Scope:** Fix section ordering after the guardrail split.

### Changes
1. **Section 13/14 swapped**: High-Risk Guardrails now comes before Final Authority.
2. **Version**: v3.0 → v3.1. Last updated: 2026-05-18.

---

## v3.0 — 2026-05-18

**Scope:** Normalize guardrail numbering and improve handoff traceability.

### Changes
1. **Section 9 expanded**: Handoff now includes a `diff reference or commit hash` field.
2. **Section 14 renamed**: High-Risk Guardrails moved from `12A` to `14` for a cleaner section ladder.
3. **Version**: v2.9 → v3.0. Last updated: 2026-05-18.

---

## v2.9 — 2026-05-18

**Scope:** Close the remaining AGENTS policy gaps from review.

### Changes
1. **Section 2B clarified**: added a cross-reference so `caveman-shrink` stays anchored to Section 11 instead of drifting into a second rule source.
2. **Section 5 expanded**: `find-skills` was added to Skill Policy.
3. **Section 7 expanded**: test verification now includes `xcodebuild test` and a coverage reporting note.
4. **Section 8 expanded**: `project.yml` was added to Protected Areas.
5. **Section 13 clarified**: inline code comments, test comments, and TODO/FIXME comments must be Korean; documentation comments may be English when clearer for public or cross-module APIs.
6. **Version**: v2.8 → v2.9. Last updated: 2026-05-18.

---

## v2.6 — 2026-05-17

**Scope:** Make the remaining guardrail tradeoffs explicit and narrow the fast-path exceptions.

### Changes
1. **Section 8A clarified**: typo-only or comment-only edits may skip the first two protection steps when the change is clearly local and low risk.
2. **Section 9 clarified**: trivial tasks may use task ID, risk level, and summary only, while non-trivial and high-risk tasks keep the full handoff list.
3. **Section 12A clarified**: the Reasoning block now has a fixed template with `what`, `why`, `preserved`, and `risk`.
4. **Version**: v2.5 → v2.6. Last updated: 2026-05-17.

---

## v2.5 — 2026-05-17

**Scope:** Align versioning and tighten the remaining guardrail wording.

### Changes
1. **Section 8A clarified**: core policy protection is explicitly marked as a protection path, not a routine checklist.
2. **Section 9/12A clarified**: handoff items are framed as concise required fields, and the Reasoning block now has an explicit completeness check.
3. **Section 12A clarified**: stop-condition recovery now states that resumption needs explicit approval or a clear scope change.
4. **Version**: v2.4 → v2.5. Last updated: 2026-05-17.

---

## v2.4 — 2026-05-17

**Scope:** Clarify the feedback trail language in the handoff section.

### Changes
1. **Section 9 clarified**: recurring friction now maps to a reporting trail in `docs/history.md` and the task log, not a full feedback loop claim.
2. **Version**: v2.3 → v2.4. Last updated: 2026-05-17.

---

## v2.3 — 2026-05-17

**Scope:** Reduce redundant router text while preserving mandatory checks.

### Changes
1. **Section 3 clarified**: task routing now states that Section 4 adds mandatory policy reads and that matching policy files must all be read.
2. **Section 4 expanded**: `review-and-refactor` and `superpower` were added to the trigger table so the skill table and trigger table no longer drift apart.
3. **Sections 10/11/12A/14/15 tightened**: Serena and CRG sections were shortened, stop conditions now point to the incident boundary, build verification points back to Section 7, and Caveman/Repomix duplicates were removed.
4. **Version**: v2.2 → v2.3. Last updated: 2026-05-17.

---

## v2.2 — 2026-05-17

**Scope:** Clarify stage roles for other agents.

### Changes
1. **Section 2A clarified**: Stage 1/2/3 were labeled as discovery, impact analysis, and verification so the router reads the same way as the pipeline.
2. **Version**: v2.1 → v2.2. Last updated: 2026-05-17.

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
- 2026-05-16 | dizzyasset-semble-rs-swift-support | Updated AGENTS and semble_rs routing for Swift AST discovery, kept CRG/Serena as validation, and documented the impact caveat
- 2026-05-16 | dizzyasset-semble-rs-default-rules | added conditional defaults for plan/search/deps/impact across AGENTS.md and semble_rs docs to keep the workflow deterministic for ambiguous tasks
- 2026-05-16 | dizzyasset-docs-routing-cache | added a docs-analysis cache and repo-local sync script for the docs layout
- 2026-05-17 | dizzyasset-ast-grep-aux-search | added ast-grep as an optional syntax-aware refinement step while keeping rg and Serena as the main discovery path
- 2026-05-18 | dizzyasset-model-guides-routing | Added Gemini, GPT 5.4 Mini, GPT 5.x Codex, and generic fallback prompt guides and routed them from AGENTS.md
- 2026-05-18 | agents-md-context-preservation | Clarified that AGENTS policy text should stay concise, preserve context, and keep conditions explicit for other agents
- 2026-05-19 | dizzyasset-gemini-prompt-guides-refresh | Refreshed Gemini Flash/Pro prompt guides with sequential-thinking, safety, digest, and work-report wording to match the latest model guide style

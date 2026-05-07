# DA-023 Verification Harness / Manual QA Checklist — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-023  
**Task name:** Verification Harness / Manual QA Checklist  
**Project:** DizzyAsset  
**Lifecycle stage:** Verification / Process  
**Risk level:** Low  
**Target repo path:** `docs/task/DA-023-verification-harness-manual-qa-checklist.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Create the first verification harness and manual QA checklist foundation for DizzyAsset.

This task creates process artifacts and repeatable verification structure.

It does not implement product UI or product behavior.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-023 task prompt
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Safety/platform guidelines in `docs/guidelines/`
8. Existing code patterns

Raw chat is not implementation scope.

---

## 3. Required Reading

Always read:

- `AGENTS.md`
- this task prompt
- `docs/workflows/implementation-task.md`
- `docs/workflows/verification-review.md`
- `docs/templates/handoff.md`

Read if needed:

- relevant `docs/guidelines/*` files for checklist coverage

---

## 4. Relevant Skills

Use only if relevant:

- `code-review-graph`
  - review scope and affected areas

- `review-and-refactor`
  - process document cleanup

- `karpathy-guidelines`
  - keep checklists simple

Skills do not expand scope.

---

## 5. In Scope

Implement or verify process documents such as:

- manual QA checklist
- release-blocking verification checklist
- high-risk task verification checklist
- UI visual evidence checklist
- file access verification checklist
- database migration verification checklist
- Final Cut Pro manual verification checklist

Possible paths:

- `docs/workflows/manual-qa-checklist.md`
- `docs/workflows/high-risk-verification.md`
- `docs/workflows/release-readiness.md`

Keep documents short and usable.

---

## 6. Out of Scope

Do not implement:

- product UI
- app code
- CI/CD automation
- release publishing
- signing/notarization
- automated test framework unless explicitly assigned
- broad documentation rewrite

Do not change protected areas.

---

## 7. Manual QA Coverage

Checklist should cover:

- app launch
- main window
- import scan
- duplicate detection
- search
- preview
- tag/category assignment
- right panel
- Quick Peek
- Final Cut Pro drag
- external drive offline/reconnect
- workspace setup
- preferences
- database migration if changed

---

## 8. High-Risk Verification Coverage

High-risk checklist should cover:

- sandbox
- entitlements
- security-scoped bookmarks
- external storage recovery
- Final Cut Pro integration
- Quick Peek focus/global hotkey
- database migration
- data deletion behavior
- CI/CD/signing/release

---

## 9. Evidence Rules

Verification documents should require:

- command run
- result
- skipped checks
- visual evidence for UI changes
- manual environment notes
- known risks
- instruction owner final decision

Do not allow vague claims.

---

## 10. Verification

Process verification should include:

- document exists
- checklist is readable
- checklist maps to AGENTS.md
- checklist covers high-risk areas
- checklist references handoff template
- no conflicting rules introduced

No app build is required unless source files are changed.

If only docs changed, report build not applicable.

---

## 11. Stop Conditions

Stop and report if:

- verification rules conflict with AGENTS.md
- checklist implies agents can approve final acceptance
- release automation is introduced without approval
- protected process is changed
- task expands into CI/CD or release implementation

---

## 12. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-023
- Risk level: Low
- files changed
- checklists created
- high-risk areas covered
- build run:
  - not applicable or result
- verification run
- skipped checks
- known risks
- next suggested task

---

## 13. Expected Completion Criteria

DA-023 is complete when:

- verification checklist foundation exists
- high-risk areas are covered
- evidence requirements are clear
- final authority remains with instruction owner
- handoff is produced

---

## 14. Suggested Next Step

After DA-023:

- start actual implementation from DA-001
- or refine task prompts based on repo state

Do not start implementation in this process task unless explicitly assigned.

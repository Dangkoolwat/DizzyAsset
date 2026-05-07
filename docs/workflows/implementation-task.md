# Implementation Task Workflow

Use this workflow when implementing an assigned DA task or a clearly scoped code change.

Do not implement from raw chat.
Do not expand scope.
Prefer small, surgical changes.

---

## 1. Start

Before editing code:

- read `AGENTS.md`
- identify the assigned task
- identify lifecycle stage
- classify risk
- confirm scope
- identify protected areas

If no task is assigned, stop and ask for a task.

---

## 2. Load Context

Load only the smallest useful context.

Always read:

- `AGENTS.md`
- assigned task prompt
- relevant DA task

Read product docs only if needed:

- `docs/product/dizzyasset_development_plan.md`
- `docs/product/dizzyasset_design_doc.md`
- `docs/product/dizzyasset_v1_prd.md`

Read guidelines only when relevant:

- `docs/guidelines/apple-coding-style.md`
- `docs/guidelines/comments-and-docs.md`
- `docs/guidelines/swiftui-architecture.md`
- `docs/guidelines/state-management.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/final-cut-pro-integration.md`
- `docs/guidelines/workspace-lifecycle.md`
- `docs/guidelines/xcodegen-project.md`

Do not read all documents by default.

---

## 3. Use Skills

Do not load all skills.

Use only relevant skills:

- SwiftUI UI work:
  - `swiftui-expert-skill`

- async or concurrency work:
  - `swift-concurrency`

- sandbox, bookmarks, entitlements:
  - `macos-sandbox-security-skill`

- SQLite, FTS5, ranking:
  - `sqlite-fts-optimizer`

- media metadata, preview, AVFoundation:
  - `avfoundation-media-pro`

- XcodeGen or project settings:
  - `xcode-project-analyzer`

- non-trivial or high-risk review:
  - `code-review-graph`

- local cleanup after behavior works:
  - `review-and-refactor`

- simplify over-complicated code:
  - `caveman`

Skills do not expand scope.

---

## 4. Plan Minimal Change

Before editing:

- list affected files
- identify current local pattern
- choose smallest safe change
- avoid repo-wide refactor
- avoid speculative abstraction
- preserve existing behavior unless assigned

If the task requires a protected area, stop.

---

## 5. Implement

During implementation:

- change one scope at a time
- keep layers separated
- keep SwiftUI Views small
- keep business logic out of Views
- keep persistence out of Views
- use async work off the main thread
- preserve original files
- avoid hidden file copying
- surface permission failures

If scope expands, stop and report.

---

## 6. XcodeGen Rule

If files are added, deleted, or moved:

- update `project.yml` if required
- run `xcodegen generate`
- do not edit `.xcodeproj` manually

If project generation fails, stop and report.

---

## 7. Verification

Run verification appropriate to risk.

Minimum verification may include:

- build
- focused manual check
- focused unit test
- changed path inspection

Full verification is required for high-risk work.

High-risk work includes:

- sandbox
- entitlements
- security-scoped bookmarks
- external storage recovery
- Final Cut Pro integration
- Quick Peek
- database migration
- data deletion
- CI/CD
- signing
- release

Report commands actually run.

Do not claim unrun checks.

---

## 8. Visual Evidence

For UI changes:

- create screenshot or recording when possible
- store under `artifacts/YYYY-MM-DD/<task-id>/`
- include path in handoff

If visual evidence cannot be created, explain why.

---

## 9. Knowledge Capture

Create a knowledge note only for reusable knowledge.

Use:

- `docs/knowledge/YYYY-MM-DD-short-topic.md`

Create a note for:

- non-obvious fix
- tricky platform behavior
- sandbox or bookmark issue
- XcodeGen issue
- Swift concurrency issue
- Final Cut Pro drag issue
- external storage recovery issue

Do not log every small mistake.

Do not paste huge logs.

Do not include secrets.

---

## 10. Handoff

End every task with a handoff.

Use:

- `docs/templates/handoff.md`

Include:

- task ID
- risk level
- files changed
- summary
- verification run
- skipped checks
- visual evidence if UI changed
- knowledge note if created
- known risks
- next step

Do not declare final acceptance.
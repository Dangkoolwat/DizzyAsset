# Implementation Task Workflow

**Workflow:** `docs/workflows/implementation-task.md`

## 1. Preparation
1. Read `AGENTS.md` and the assigned task.
2. Read relevant product documents in `docs/product/`.
3. Load specific guidelines from `docs/guidelines/` based on task type.
4. Verify the current build status.

## 2. Analysis & Planning
1. Identify the surgical change points.
2. Check for legacy impact (call sites, dependencies).
3. If high-risk, draft a plan and wait for approval.

## 3. Execution
1. Perform small, incremental edits.
2. If files are added/moved/deleted, run `xcodegen generate`.
3. Adhere to all technical guidelines (concurrency, naming, etc.).

## 4. Verification
1. Run local builds.
2. Perform manual verification of the specific logic.
3. Capture visual evidence for UI changes.

## 5. Handoff
1. Fill out the `docs/templates/handoff.md`.
2. Commit and push changes.
3. Log any reusable knowledge in `docs/knowledge/`.

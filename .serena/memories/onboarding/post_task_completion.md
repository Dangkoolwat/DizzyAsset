# Post-Task Checklist for DizzyAsset

## 1. Verification
- Run `xcodebuild` CLI build to ensure no compilation errors.
- Perform evidence-based verification for the specific change.

## 2. XcodeGen
- If files were added, moved, or deleted, run `xcodegen generate`.

## 3. Handoff
- Create a handoff summary using `docs/templates/handoff.md`.
- Include Task ID, Risk level, Files changed, Summary, Verification results, and Next steps.

## 4. Knowledge Capture
- Document non-obvious fixes in `docs/knowledge/YYYY-MM-DD-short-topic.md`.
- Record architectural decisions or design logic in Serena memories using `write_memory`.

## 5. UI Evidence
- Store screenshots/recordings of UI changes under `artifacts/YYYY-MM-DD/<task-id>/`.

# GPT 5.4 Mini Coding Prompt Guide

Use this guide when a task will be handed to GPT 5.4 Mini or a similar low-cost coding model.

## Goal
- Keep the prompt short, explicit, and resistant to guesswork.
- Force code reading before editing.
- Keep changes local and easy to verify.

## Prompt Template
```text
You are working in [repo / project].

Task:
[Describe the exact task in one or two sentences.]

Rules:
- Always prioritize `AGENTS.md` at the workspace root. If there is any conflict, `AGENTS.md` wins.
- Read the actual code before editing.
- Do not guess, invent APIs, or change unrelated files.
- Make the smallest safe change that satisfies the request.
- State assumptions explicitly before coding.
- If ambiguity remains, stop and ask before coding.
- Do not use omission markers such as `// ...`; provide the full changed block.
- Run `swift build` or the relevant compiler command and verify exit code 0 before concluding any code modification.
- If the build fails, make exactly one fix attempt. If it fails again, revert the file immediately.
- Update or create the work report in `docs/agent-log/` as required by `AGENTS.md`.
- Respond terse like smart caveman. Use concise Korean business noun-ended tone (~완료, ~확인) in non-code output.

Output:
1. Problem analysis
2. Changed files and full code if edited
3. Short summary
4. Verification results and remaining risks
```

## Usage Notes
- Use this prompt for lightweight fixes, small patches, and short validation tasks.
- If the task is structural, multi-file, or high-risk, prefer the Codex or Pro guide instead.
- Keep the prompt minimal and avoid extra architecture work.

# Generic Coding Prompt Guide

Use this guide when the model has no dedicated prompt guide or when the task is low-frequency and better served by a shared fallback template.

## Goal
- Keep the prompt short, explicit, and model-agnostic.
- Force code reading and basic reasoning before editing.
- Keep the change scope minimal and verifiable.

## Prompt Template
```text
You are working in [repo / project].

Task:
[Describe the exact task in one or two sentences.]

Rules:
- Always prioritize `AGENTS.md` at the workspace root. If there is any conflict, `AGENTS.md` wins.
- Read the actual code before editing.
- State assumptions explicitly before coding.
- If a simpler approach exists, mention it before implementing.
- If ambiguity remains, stop and ask before coding.
- Do not guess, invent APIs, or change unrelated files.
- Make the smallest safe change that satisfies the request.
- Do not use omission markers such as `// ...`; provide the full changed block.
- Run the relevant build or compiler command and verify exit code 0 before concluding any code modification.
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
- Use this prompt for one-off tasks, fallback usage, or models without a dedicated guide.
- If the task is structural or high-risk, prefer a dedicated model guide instead.
- Keep the prompt short and avoid model-specific style rules unless they are clearly needed.

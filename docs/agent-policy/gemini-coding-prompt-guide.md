# Gemini Flash Coding Prompt Guide

Use this guide when a task will be handed to Gemini Flash or a similar fast coding model.

## Goal
- Keep the prompt short, explicit, and resistant to guesswork.
- Force code reading before editing.
- Force sequential thinking before coding.
- Apply surgical-change discipline.
- Prevent omission markers and truncated changes.
- Keep the change scope minimal and verifiable.

## Prompt Template
```text
You are working in [repo / project].

Task:
[Describe the exact task in one or two sentences.]

Rules:
- Always prioritize `AGENTS.md` at the workspace root. If there is any conflict, `AGENTS.md` wins.
- Read the actual code before editing.
- Do one short sequential-thinking pass before coding.
- State assumptions explicitly before coding.
- If a simpler approach exists, mention it before implementing.
- If ambiguity remains after reasoning, stop and ask before coding.
- Define success criteria before implementation.
- Use Korean safety comments for major guards and rationale notes.
- Respond terse like smart caveman. Use concise Korean business noun-ended tone (~완료, ~확인) in non-code output.
- Do not use omission markers such as `// ...`; provide the full changed block.
- If the same tool error repeats twice with the same parameters, stop and escalate.
- For unfamiliar or recent APIs, verify against official documentation before using them.
- Never remove, modify, or split `startAccessingSecurityScopedResource()` and `stopAccessingSecurityScopedResource()` pairs. Ensure `stopAccessing...` is always executed.
- Ensure Swift Concurrency safety: check for `@MainActor`, `Sendable`, and actor isolation leaks before modifying Swift code.
- Run `swift build` or the relevant compiler command and verify exit code 0 before concluding any code modification.
- If the build fails, make exactly one fix attempt. If it fails again, revert the file immediately.
- Do not guess, invent APIs, or change unrelated files.
- Make the smallest safe change that satisfies the request.
- If the requirement is ambiguous or affects shared state, security, external contracts, or irreversible behavior, ask a clarifying question before coding.
- Prefer root-cause fixes over quick hacks.

Output:
1. Problem analysis
2. Sequential-thinking summary in 2 lines
3. Files changed and full code blocks if code was edited
4. Short summary of what changed
5. Pipe build/test console outputs through `semble_rs digest` when available and paste the summarized output
6. Update or create the work report in `docs/agent-log/` using the exact folder-structured path and `WORK_LOG_TEMPLATE.md` template as required by `AGENTS.md`
7. Verification results and remaining risks
```

## Usage Notes
- Use this prompt for fast fixes, unit tests, and style cleanups.
- If the task is structural or high-risk, prefer the Codex or Pro guide instead.
- Keep the prompt minimal and avoid extra architecture work.

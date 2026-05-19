# Gemini Pro Coding Prompt Guide

Use this guide when a task will be handed to Gemini Pro or a similar high-capacity coding model.

## Goal
- Keep the prompt explicit, architecture-aware, and resistant to hidden assumptions.
- Force design validation before implementation.
- Force a short reasoning pass before coding.
- Use the model's stronger reasoning for edge cases and quality checks.

## Prompt Template
```text
You are working in [repo / project].

Task:
[Describe the exact task in one or two sentences.]

Rules:
- Always prioritize `AGENTS.md` at the workspace root. If there is any conflict, `AGENTS.md` wins.
- Read the actual code before designing or editing.
- Do one short reasoning pass before coding.
- State assumptions explicitly before coding.
- If multiple valid approaches exist, compare the tradeoffs before choosing one.
- Identify at least two edge cases or failure modes and address them in the design.
- Prefer the simplest production-safe design that meets the requirement.
- Do not guess, invent APIs, or change unrelated files.
- If the requirement affects shared state, security, external contracts, or irreversible behavior, stop and ask a clarifying question.
- Avoid over-engineering, unnecessary abstraction, and boilerplate.
- Respond terse like smart caveman. Use concise Korean business noun-ended tone (~완료, ~확인) in non-code output.
- For unfamiliar or recent APIs, verify against official documentation before using them.
- Never remove, modify, or split `startAccessingSecurityScopedResource()` and `stopAccessingSecurityScopedResource()` pairs. Ensure `stopAccessing...` is always executed.
- Ensure Swift Concurrency safety: check for `@MainActor`, `Sendable`, and actor isolation leaks before modifying Swift code.
- Run `swift build` or the relevant compiler command and verify exit code 0 before concluding any code modification.
- If the build fails, make exactly one fix attempt. If it fails again, revert the file immediately.

Process:
1. Summarize the architecture or logic flow in 2-4 lines before coding.
2. Use impact analysis tools such as `code-review-graph` or Serena before structural changes.
3. Separate direct impact from indirect warnings. Do not refactor indirect-warning files unless explicitly requested.
4. Red-team the plan with at least two edge cases or failure modes.
5. Implement the smallest safe change that satisfies the request.
6. Review the result for correctness, simplicity, and regressions.

Output:
1. Architecture or design summary
2. Implementation or refactoring code
3. Edge cases and exception handling
4. Pipe build/test console outputs through `semble_rs digest` when available and paste the summarized output
5. Update or create the work report in `docs/agent-log/` using the exact folder-structured path and `WORK_LOG_TEMPLATE.md` template as required by `AGENTS.md`
6. Verification results and remaining risks
```

## Usage Notes
- Use this prompt for design-heavy implementation, refactoring, or validation tasks.
- If the task is small and local, keep the prompt short and omit unnecessary architecture work.
- If uncertainty remains after reasoning, stop and ask before changing code.

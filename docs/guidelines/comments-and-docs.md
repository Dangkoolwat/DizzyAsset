# Comments and Documentation Guideline

Use this guideline for comments, TODOs, documentation comments, handoff notes, and knowledge notes.

Write comments that help future agents and the instruction owner.

Do not write comments that only restate the code.

---

## 1. Comment Philosophy

Comments should explain why.

Code should explain what.

Good comments explain:

- intent
- tradeoff
- platform behavior
- permission behavior
- concurrency assumption
- migration risk
- temporary limitation
- verification requirement

Bad comments repeat obvious syntax.

Bad:

- `// increment count`
- `// create array`
- `// return result`

Good:

- `// Keep this state recoverable because external drives may reconnect later.`
- `// MainActor is required because AVPlayer state is reflected directly in the UI.`
- `// Do not remove this fallback until DA-021 bookmark recovery is implemented.`

---

## 2. When to Comment

Add comments for:

- non-obvious decisions
- macOS sandbox behavior
- security-scoped bookmark behavior
- external drive recovery behavior
- Final Cut Pro drag behavior
- Swift concurrency boundaries
- database migration risks
- data safety assumptions
- performance tradeoffs
- temporary MVP shortcuts

Do not comment every line.

---

## 3. Documentation Comments

Use documentation comments for public or cross-module APIs.

Use documentation comments when a type or method is used outside its local feature.

Preferred format:

- brief purpose
- important behavior
- failure behavior if relevant

Example style:

    /// Resolves stored security-scoped bookmarks for known asset locations.
    /// Does not delete records when resolution fails.
    /// Failed locations are returned as recoverable status values.

Do not write long essays in API docs.

Keep documentation comments accurate when behavior changes.

---

## 4. TODO and FIXME

TODO and FIXME must be specific.

MUST include:

- task ID when possible
- reason
- expected follow-up

Preferred format:

    // TODO(DA-021): Retry stale bookmark resolution after external drive reconnect support is added.

    // FIXME(DA-016): Validate drag payload with Final Cut Pro before marking this flow verified.

Bad:

    // TODO: fix later

    // FIXME: broken

Do not leave vague TODOs.

---

## 5. Temporary Workarounds

Temporary workaround comments MUST explain:

- why it exists
- when it can be removed
- what task should replace it

Example:

    // Temporary MVP fallback.
    // Remove after DA-020 introduces normalized search indexing.

If a workaround affects product behavior, mention it in handoff.

---

## 6. Verification-Sensitive Comments

Use comments when code behavior must be manually verified.

Good candidates:

- FCP drag payload
- Quick Peek focus behavior
- external SSD reconnect
- stale bookmark refresh
- destructive migration prevention
- workspace cleanup safety

Example:

    // Verification required:
    // This branch handles stale bookmarks after a volume reconnect.

Keep these comments short.

---

## 7. Comments for User Data Safety

When code avoids deletion or destructive behavior, a short comment is useful.

Example:

    // Preserve the asset record.
    // The source may be on an offline external drive.

Do not remove user-data safety comments unless the code becomes obvious or the policy moves to a clearer location.

---

## 8. Logging Notes

If a failure is logged, the log message should be useful.

Good log message includes:

- area
- short failure reason
- recoverability if known

Avoid:

- huge logs
- raw private user content
- secrets
- full bookmark data

Good:

    Bookmark restore failed for asset location. Marking as volumeOffline.

Bad:

    Error happened.

---

## 9. Handoff Writing

Handoff should be factual.

MUST include:

- what changed
- files changed
- verification actually run
- skipped checks
- known risks
- next step

MUST NOT:

- claim final acceptance
- hide failures
- overstate verification
- include huge logs
- write a story

Use `docs/templates/handoff.md`.

---

## 10. Knowledge Notes

Use knowledge notes for reusable lessons.

Path:

    docs/knowledge/YYYY-MM-DD-short-topic.md

Create a note when:

- fix was non-obvious
- platform behavior was surprising
- tool failure is likely to recur
- bookmark or sandbox issue was tricky
- Final Cut Pro drag issue required trial and error
- Swift concurrency issue was subtle

Do not create a knowledge note for every small mistake.

Knowledge notes should be short.

Recommended sections:

- Context
- Symptom
- Root cause
- Fix or workaround
- Verification
- Future warning

Do not include secrets.

Do not paste huge logs.

---

## 11. Markdown Style

Use Markdown for docs.

Prefer:

- short sections
- short bullets
- clear headings
- direct rules
- simple English

Avoid:

- nested complexity
- long essays
- duplicate rules
- ambiguous language

Use MUST, MUST NOT, SHOULD, and MAY when rule strength matters.

---

## 12. Updating Documentation

When updating docs:

- preserve existing intent
- avoid unnecessary rewrite
- add a short version note when useful
- keep language simple
- avoid duplicate guidance
- move detailed rules to focused files

If a document is a router, keep it short.

If a document is a guideline, it may be longer.
# Agent Knowledge Base

This folder stores reusable knowledge discovered while working on DizzyAsset.

Use this folder for lessons that can save future agents time.

Do not use this folder as a normal task log.

Task logs belong in:

    docs/agent-log/

---

## Purpose

The knowledge base exists to prevent repeated mistakes.

Write a knowledge note when an agent discovers:

- a non-obvious fix
- a tricky macOS behavior
- a Swift concurrency issue
- an XcodeGen or build issue
- a sandbox or bookmark issue
- an external drive recovery issue
- a Final Cut Pro drag issue
- an AVFoundation preview issue
- a SQLite migration or FTS5 issue
- a tool failure pattern that may happen again

Do not write a knowledge note for every small mistake.

Only write reusable knowledge.

---

## File Naming

Use this format:

    YYYY-MM-DD-short-topic.md

Examples:

    2026-05-07-stale-bookmark-reconnect.md
    2026-05-07-xcodegen-target-membership.md
    2026-05-07-avplayer-stale-preview.md

Keep names short.

Use lowercase words.

Use hyphens.

---

## Required Format

Each knowledge note SHOULD use this structure:

    # Short topic

    ## Context

    What task or area was being worked on.

    ## Symptom

    What failed or behaved unexpectedly.

    ## Root Cause

    What caused the issue, if known.

    ## Fix or Workaround

    What solved the issue.

    ## Verification

    What command or manual check confirmed the fix.

    ## Future Warning

    What future agents should avoid or remember.

---

## Rules

MUST:

- keep notes short
- write reusable facts
- include verification when available
- link to task ID when relevant
- mention affected files when useful
- mention related guideline if useful

MUST NOT:

- paste huge logs
- include secrets
- include raw bookmark data
- include private credentials
- include unrelated chat
- duplicate normal handoff content
- log every small mistake

---

## Relationship to Handoff

Handoff is for the current task.

Knowledge notes are for future reuse.

If a knowledge note is created, mention it in the handoff.

Example handoff field:

    Knowledge note created:
    - docs/knowledge/2026-05-07-stale-bookmark-reconnect.md

---

## When Not to Create a Note

Do not create a knowledge note when:

- the issue was obvious
- the issue was already documented
- the fix was a normal typo fix
- the failure was caused only by incomplete task scope
- the information is useful only for the current task
- the handoff is enough

---

## Review

Before adding a note, ask:

- Will this help a future agent?
- Is it shorter than the time it saves?
- Is it factual?
- Is it verified or clearly marked as uncertain?
- Does it avoid secrets and private data?

If not, do not add the note.
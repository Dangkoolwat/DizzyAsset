# [WORK LOG] 2026-05-18-dizzyasset-model-guides-routing-gpt-5.5

## Task

- Task ID: N/A
- Lifecycle stage: Policy Update
- Risk level: High-risk
- Date: 2026-05-18
- Agent/tool: Codex

## Scope

- In scope:
  - port model-specific prompt guide structure from `fcpx-auto-captions`
  - add AGENTS routing rows for Gemini and GPT model families
  - update history and docs routing cache
- Out of scope:
  - app code changes
  - AI analysis provider behavior
  - template or review-doc format changes

## Actions Taken

- Added model-specific prompt guide docs under `docs/agent-policy/`.
- Updated `AGENTS.md` to route to the new guides.
- Recorded the change in `docs/history.md`.
- Created this work report for the routing update.

## Files Changed

- `AGENTS.md`
  - added model-specific policy trigger rows
  - bumped document version and last-updated date
- `docs/agent-policy/gemini-coding-prompt-guide.md`
  - added a Gemini Flash guide
- `docs/agent-policy/gemini-pro-coding-prompt-guide.md`
  - added a Gemini Pro guide
- `docs/agent-policy/gpt-5-4-mini-coding-prompt-guide.md`
  - added a GPT 5.4 Mini guide
- `docs/agent-policy/gpt-5-x-codex-coding-prompt-guide.md`
  - added a GPT 5.x Codex guide
- `docs/agent-policy/generic-coding-prompt-guide.md`
  - added a shared fallback guide
- `docs/history.md`
  - added one summary line for the routing update

## Commands Run

- `sed -n` / `nl -ba` on `AGENTS.md`, `docs/history.md`, and policy files
  - result: confirmed current routing and history layout before edit

## Verification

- verified:
  - new prompt guides exist and are linked from `AGENTS.md`
  - change remains docs-only
- not verified:
  - build/test run not applicable
- skipped checks:
  - `xcodebuild` / `swift build`, because no code changed

## Issues

- issue: none
- status: none

## Artifacts

- path: `docs/superpowers/plans/2026-05-18-dizzyasset-model-guides-routing.md`

## Knowledge Notes

- path: none

## Handoff Summary

- summary: model-specific guide routing from `AGENTS.md` is now mirrored in `DizzyAsset`
- next step: refresh docs routing cache and verify the final diff

# Verification Review Workflow

Use this workflow after an implementation, refactor, or high-risk change.

The reviewer checks evidence.
The instruction owner decides final acceptance.

---

## 1. Inputs

Read:

- handoff
- diff
- changed files
- assigned task
- relevant DA task
- relevant guideline files only when needed

Do not reread the whole repository by default.

---

## 2. Scope Check

Check:

- Does the change match the assigned task?
- Did the agent avoid raw chat scope?
- Were unrelated files changed?
- Were protected areas touched?
- Were product behaviors changed without approval?
- Was scope expansion reported?

If scope drift exists, mark as follow-up or reject.

---

## 3. Risk Check

Confirm risk level:

- Trivial
- Non-trivial
- High-Risk

High-risk areas include:

- sandbox
- entitlements
- bookmarks
- external storage
- Final Cut Pro integration
- Quick Peek
- database migration
- data deletion
- CI/CD
- signing
- release

If risk was under-classified, require stronger verification.

---

## 4. Evidence Check

Check handoff evidence.

Verify:

- commands actually run
- build result
- tests or checks run
- skipped checks explained
- manual checks described
- UI artifacts included when UI changed
- knowledge note included when reusable issue was found

Do not accept claims without evidence.

---

## 5. Code Review Check

Check changed files for:

- small surgical changes
- clear naming
- layer separation
- no business logic in SwiftUI Views
- no persistence in SwiftUI Views
- no hidden global state
- no unnecessary EnvironmentObject
- no speculative abstraction
- no unrelated refactor
- no hidden media copying
- no silent permission failure
- no destructive data behavior

Use `code-review-graph` for non-trivial or high-risk changes.

---

## 6. Product Check

Check product principles:

- original files stay where they are
- no forced copying
- no automatic original deletion
- workspace output is separate
- search, preview, drag, use flow is preserved
- Final Cut Pro drag behavior is not weakened
- editor-language tagging direction is preserved
- category depth rule is preserved

If a change conflicts with product principles, reject or request follow-up.

---

## 7. UI Review

For UI changes, check:

- visual evidence exists
- screenshot or recording path is valid
- UI matches expected flow
- keyboard flow is not broken
- layout is not obviously degraded
- right panel remains useful
- Quick Peek does not create focus problems

If visual evidence is missing, request it unless impossible.

---

## 8. File Access Review

For file access changes, check:

- bookmark state is handled
- stale bookmark path is considered
- external drive offline state is visible
- permission denied state is visible
- asset records are preserved
- no silent deletion occurs
- reconnect path is considered

Require full verification for this area.

---

## 9. Database Review

For database changes, check:

- migration is safe
- no user data is deleted without approval
- repository boundary is preserved
- schema change is documented
- affected queries are considered
- tests or manual checks exist

Require full verification for destructive or relationship-changing migrations.

---

## 10. Decision

Use one of:

- Accept
- Needs follow-up
- Reject
- Blocked

Decision meanings:

- Accept:
  - evidence is sufficient
  - scope is correct
  - known risks are acceptable

- Needs follow-up:
  - implementation is usable
  - minor issue remains
  - follow-up task is required

- Reject:
  - scope drift
  - unverified high-risk behavior
  - product conflict
  - unsafe change
  - build or test failure

- Blocked:
  - missing environment
  - missing permission
  - unclear product decision
  - required tool unavailable

Agents do not make final acceptance.

Instruction owner decides.
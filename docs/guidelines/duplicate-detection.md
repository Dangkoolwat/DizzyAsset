# Duplicate Detection Guideline

Use this guideline when changing duplicate detection, hashing, import duplicate handling, full duplicate rescan, duplicate UI, or duplicate database records.

DizzyAsset detects duplicates.

DizzyAsset does not delete original files automatically.

---

## 1. Core Principles

MUST:

- detect path duplicates
- detect content duplicates
- keep import fast
- avoid unnecessary full hashing
- preserve original files
- report duplicates clearly
- keep deletion user-controlled

MUST NOT:

- auto-delete original files
- silently merge unrelated files
- block import with expensive full hash when not needed
- treat same path and same content as identical concepts
- hide duplicate status from the user

---

## 2. Duplicate Types

### Path Duplicate

Same file path is already registered.

Behavior:

- do not register duplicate asset by default
- show existing asset if useful
- allow rescan if metadata changed
- preserve existing tags/categories

### Content Duplicate

Different path but same file content.

Behavior:

- show duplicate status
- allow user decision
- default may skip new registration or link additional location depending on task
- preserve both physical paths if recorded

Path duplicate and content duplicate are different.

---

## 3. Detection Stages

Use staged detection.

### Stage 1: Quick Check

Use:

- path
- file size
- extension
- modified date

Purpose:

- fast import
- cheap candidate reduction

### Stage 2: Partial Hash

Use:

- first 8KB
- middle 8KB
- last 8KB

Purpose:

- reduce full hash work
- identify likely content duplicates

### Stage 3: Full Hash

Use only when needed.

Purpose:

- confirm content duplicate
- resolve ambiguous candidates

Full hash can be expensive for large video files.

Do not compute full hash for every file unless assigned.

---

## 4. Hash Storage

Potential stored values:

- quickFingerprint
- partialHash
- fullHash
- hashStatus

Possible hash statuses:

- notComputed
- partialComputed
- fullComputed
- failed
- unavailable

Rules:

- hash failure should not delete asset
- hash failure should be visible in scan result if relevant
- full hash may be computed in background
- partial hash should be enough for candidate detection, not final proof

---

## 5. Import-Time Duplicate Detection

Import-time detection must be fast.

Flow:

1. scan file
2. build candidate metadata
3. check path duplicate
4. check quick fingerprint
5. compute partial hash if needed
6. queue full hash only if needed
7. insert, skip, or mark duplicate according to policy
8. report summary

Import should report:

- total found
- imported
- skipped duplicates
- failed
- needs review

Do not stop whole import because one duplicate check fails.

---

## 6. Full Duplicate Rescan

Full duplicate rescan is user-triggered.

Possible entry points:

- Settings
- Tools
- Library maintenance

Possible scopes:

- whole library
- selected folder
- selected storage location
- category
- project

Rules:

- run in background
- show progress
- allow cancellation if practical
- do not delete files
- produce report
- preserve existing metadata

---

## 7. Duplicate Groups

Duplicate groups may store:

- group id
- canonical asset id
- duplicate asset id
- confidence
- detection type
- scan session id
- created at
- review status

Detection types:

- path
- partialHashCandidate
- fullHashConfirmed
- manualMarked

Do not force canonical selection without policy.

---

## 8. User Interface

Duplicate UI should explain:

- why it is considered duplicate
- where each file is located
- file size
- modified date
- hash status
- confidence
- available actions

User actions may include:

- view existing asset
- keep both
- link location
- ignore
- mark as not duplicate
- reveal in Finder

Delete action, if ever added, must be explicit and user-confirmed.

---

## 9. External Storage

Duplicates may live across external drives.

Rules:

- offline drive does not mean duplicate is gone
- unavailable file should not be removed from duplicate group automatically
- duplicate scan should handle missing/offline files
- bookmark recovery may be needed before full hash

Do not require all drives to be online for basic duplicate reporting.

---

## 10. Performance

Duplicate detection must avoid expensive work when possible.

Rules:

- use quick check first
- use partial hash before full hash
- compute full hash only for candidates
- batch database reads
- do hashing off main thread
- support cancellation for full rescan
- avoid blocking UI

Large media files require special care.

---

## 11. Error Handling

Duplicate detection errors should be recoverable.

Possible errors:

- file missing
- permission denied
- volume offline
- hash read failed
- unsupported file
- database write failed

Rules:

- report failed file
- continue other files when safe
- preserve asset record
- avoid deleting duplicate records without reason

---

## 12. Testing and Verification

Duplicate verification should include:

- same path import
- same content different path
- different content same size if sample exists
- partial hash candidate
- full hash confirmation
- missing/offline file state
- permission denied state if possible
- full rescan over sample library
- cancellation if implemented

Report what was not tested.

---

## 13. Stop Conditions

Stop and report if:

- implementation might delete original files
- duplicate policy is unclear
- canonical asset selection is unclear
- full hash performance is unacceptable
- database relation semantics are unclear
- offline external drive behavior is unclear
- user-facing delete action is requested without explicit approval

Do not guess deletion or merge policy.

---

## 14. Handoff Requirements

For duplicate detection work, handoff must include:

- files changed
- detection stage touched
- hash behavior changed:
  - yes/no
- database records changed:
  - yes/no
- import behavior changed:
  - yes/no
- full rescan behavior changed:
  - yes/no
- samples tested
- performance notes
- skipped checks
- known risks
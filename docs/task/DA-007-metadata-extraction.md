# DA-007 Metadata Extraction — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-007  
**Task name:** Metadata Extraction  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation  
**Risk level:** Medium  
**Target repo path:** `docs/task/DA-007-metadata-extraction.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Implement the first metadata extraction foundation for supported media files.

Metadata extraction should provide useful asset information for indexing and display.

This task prepares metadata for later search, preview, filtering, and right panel display.

Original files must not be modified.

---

## 2. Source of Truth

Follow:

1. Explicit implementation request
2. `AGENTS.md`
3. This DA-007 task prompt
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Safety/platform guidelines in `docs/guidelines/`
8. Existing code patterns

Raw chat is not implementation scope.

---

## 3. Required Reading

Always read:

- `AGENTS.md`
- this task prompt
- `docs/guidelines/macos-file-access.md`
- `docs/guidelines/preview-engine.md`
- `docs/guidelines/swift-concurrency.md`
- `docs/guidelines/apple-coding-style.md`
- `docs/templates/handoff.md`

Read if needed:

- `docs/guidelines/sqlite-migration.md`
- `docs/guidelines/ai-analysis-provider.md`
- `docs/guidelines/xcodegen-project.md`

---

## 4. Relevant Skills

Use only if relevant:

- `avfoundation-media-pro`
  - media metadata, duration, AVFoundation behavior

- `macos-sandbox-security-skill`
  - file access and permission behavior

- `swift-concurrency`
  - async metadata loading

- `karpathy-guidelines`
  - scoped implementation

- `xcode-project-analyzer`
  - only for project changes

Skills do not expand scope.

---

## 5. In Scope

Implement or verify:

- metadata extraction service boundary
- basic file metadata extraction
- media type detection refinement if needed
- duration extraction for audio/video if practical
- file size
- extension
- created/modified dates where available
- safe failure result
- repository update hook if database supports it

Possible output model:

- fileName
- fileExtension
- fileSize
- mediaType
- duration
- createdAt
- modifiedAt
- metadataStatus
- failureReason

---

## 6. Out of Scope

Do not implement:

- waveform generation
- preview playback
- silence detection
- Speech/Vision analysis
- LLM classification
- tag/category suggestion
- full search indexing
- Quick Peek
- Final Cut Pro integration
- destructive media edits
- release/signing/notarization

Do not change protected areas.

---

## 7. Implementation Guidance

Possible components:

- `MetadataExtractor`
- `AssetMetadata`
- `MetadataExtractionResult`
- `MediaType`
- repository update method if available

Use AVFoundation only where needed.

Keep file access failure recoverable.

Do not block the main thread for heavy metadata loading.

---

## 8. File Access Rules

Before extracting metadata:

- resolve file access if needed
- check existence
- check permission
- handle missing/offline state
- do not modify file

Possible failures:

- missing
- volumeOffline
- permissionDenied
- unsupportedFile
- extractionFailed

---

## 9. AVFoundation Rules

Use AVFoundation carefully.

Rules:

- isolate AVFoundation code in infrastructure
- load metadata asynchronously where possible
- handle unsupported formats
- handle slow external storage
- report AVFoundation failures
- avoid leaking AVFoundation objects into domain/UI

Do not make metadata extraction required for app launch.

---

## 10. Database Rules

If database supports metadata fields:

- update only relevant metadata fields
- preserve existing user data
- avoid destructive migration
- use repository boundary

If database fields are missing:

- return metadata result
- report persistence limitation in handoff

---

## 11. Verification

Run when possible:

- `xcodegen generate` if project structure changed
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`

Metadata verification should include:

- audio file metadata if sample exists
- video file metadata if sample exists
- image file basic metadata if sample exists
- unsupported file handling
- missing file handling if practical
- external SSD file if available
- no original file modification

Report skipped checks.

---

## 12. Stop Conditions

Stop and report if:

- AVFoundation behavior is unclear
- metadata extraction would block UI
- file access requires entitlement change
- database migration becomes destructive
- original file modification is required
- task expands into preview, waveform, silence, or AI analysis

---

## 13. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:

- Task ID: DA-007
- Risk level: Medium
- files changed
- metadata fields extracted
- AVFoundation touched:
  - yes/no
- database updated:
  - yes/no
- sample files tested
- verification run
- skipped checks
- known risks
- next suggested task

---

## 14. Expected Completion Criteria

DA-007 is complete when:

- metadata extraction foundation exists
- supported media metadata can be extracted safely
- failures are represented clearly
- original files are not modified
- verification is reported
- handoff is produced

---

## 15. Suggested Next Task

After DA-007:

- DA-008 Asset List UI

Do not start DA-008 in this task.

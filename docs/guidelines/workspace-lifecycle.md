# Workspace Lifecycle Guideline

Use this guideline when changing workspace setup, generated files, derived assets, preview cache, temp cleanup, analysis output, or workspace migration.

DizzyAsset separates original files from workspace output.

Original files stay where they are.

---

## 1. Core Principles

MUST:

- keep original files separate
- preserve original files
- classify workspace files by type
- avoid destructive cleanup
- preserve derived asset relationships
- keep cleanup safe
- support workspace relocation

MUST NOT:

- store app memory in workspace
- store original files in workspace by default
- delete original files
- delete user-valuable derived output automatically
- mix temp cleanup with derived cleanup
- assume workspace is always local disk

---

## 2. Default Locations

App internal data:

    ~/Library/Application Support/DizzyAsset/

Workspace:

    ~/DizzyAsset/

App internal data may include:

- database
- settings
- index
- bookmarks
- internal metadata

Workspace may include:

- Derived
- Generated
- Analysis
- Temp

---

## 3. Workspace Structure

Default structure:

    ~/DizzyAsset/
      Derived/
        Trimmed/
        Converted/
        Proxy/
      Generated/
        Preview/
        Export/
      Analysis/
        Waveforms/
        Speech/
        Vision/
      Temp/

Do not change this structure casually.

If structure changes, update product docs or design docs if needed.

---

## 4. Workspace Relocation

Workspace location may be changed by the user.

Possible locations:

- home directory
- external SSD
- NAS
- user-selected folder

User choices may include:

- move existing workspace files
- use new location only
- cancel

Rules:

- preserve settings
- validate new location
- handle permission errors
- handle external volume offline
- avoid partial migration
- report migration state

Workspace relocation is non-trivial.

---

## 5. Workspace Item Types

Classify files.

Suggested types:

- temp
- previewCache
- analysisOutput
- derivedAsset
- exportOutput
- proxy
- unknown

Each type should have a cleanup policy.

Do not cleanup unknown files automatically.

---

## 6. Temp Files

Temp files are cleanup-safe only when known.

Rules:

- temp cleanup must be explicit
- never cleanup outside workspace temp path
- do not follow unsafe symlinks
- avoid deleting files still in use
- log cleanup summary

Temp cleanup may be automatic only after policy exists.

---

## 7. Preview Cache

Preview cache is regeneratable.

Examples:

- thumbnails
- lightweight preview files
- cached waveform preview if designed as cache

Rules:

- may be size-limited
- may be regenerated
- cleanup should not affect original assets
- missing preview cache should trigger regeneration

Do not treat preview cache as canonical data.

---

## 8. Analysis Output

Analysis output may include:

- waveforms
- speech transcript
- vision result
- sound analysis result

Rules:

- some output may be regenerated
- some output may be expensive to regenerate
- keep metadata linking output to analyzer version
- preserve user-confirmed analysis or edits
- do not delete analysis output without policy

---

## 9. Derived Assets

Derived assets may include:

- trimmed audio
- converted format
- proxy media
- normalized audio
- export output

Derived assets are more valuable than cache.

Rules:

- link derived asset to source asset
- preserve source relation
- do not delete automatically
- mark orphan state if source is missing
- show relationship in Asset Information Hub

Do not confuse derived asset with original file.

---

## 10. Orphan Handling

A derived asset may become orphaned when:

- source file is missing
- source drive is offline
- source permission is denied
- source asset was removed from library

Rules:

- mark orphaned
- mark missing-source if applicable
- preserve derived file
- allow user recovery
- avoid automatic deletion

---

## 11. Cleanup Policy

Cleanup must be conservative.

Cleanup-safe:

- known temp files
- regeneratable preview cache
- failed partial temp output

Not cleanup-safe by default:

- original files
- derived assets
- exports
- user-created output
- unknown files
- confirmed analysis results

Cleanup should report:

- files scanned
- files deleted
- bytes freed
- skipped files
- errors

---

## 12. Workspace Database Records

Workspace-related records may include:

- workspace root
- workspace item path
- item type
- source asset id
- derived asset id
- status
- created at
- last accessed at

Possible statuses:

- active
- stale
- orphaned
- missingSource
- recoverable
- cleanupCandidate

Do not rely only on file path.

---

## 13. External Workspace

Workspace may live on external storage.

Handle:

- volume offline
- permission denied
- slow access
- reconnect
- stale bookmark
- partial availability

Do not assume workspace is always available.

Show clear state if workspace is unavailable.

---

## 14. User Interface

Preferences should show:

- current workspace location
- change workspace action
- cache cleanup action
- storage usage if available
- workspace unavailable state
- reconnect action if needed

Asset Information Hub may show:

- source asset
- derived assets
- generated previews
- analysis output
- orphan status

---

## 15. Verification

Workspace verification should include:

- default folder creation
- app restart persistence
- workspace location change
- invalid location handling
- external workspace if available
- temp cleanup simulation
- preview cache regeneration
- derived asset relation saved
- orphan state recorded

Report what was not tested.

---

## 16. Stop Conditions

Stop and report if:

- cleanup may delete original files
- cleanup may delete derived assets unexpectedly
- workspace migration may lose files
- permission behavior is unclear
- external workspace behavior cannot be verified
- symlink behavior is unclear
- unknown files would be deleted
- database relation would be broken

Do not guess with user files.

---

## 17. Handoff Requirements

For workspace work, handoff must include:

- files changed
- workspace paths touched
- cleanup behavior changed
- migration behavior changed
- derived relation changed
- external workspace tested:
  - yes/no
- deletion behavior:
  - none/temp/cache/other
- verification run
- skipped checks
- known risks
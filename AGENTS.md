# AGENTS.md

**Document version:** v1.3  
**Project:** DizzyAsset  
**Document role:** Repository-level instruction router and agent operating guide  
**Status:** Living document  
**Last updated:** 2026-05-07

---

## 0. Purpose

This file is the repository-level instruction router for coding agents.

It defines how agents should work in this repository.

It is allowed to be long in this version because the project is still stabilizing its workflow rules.

Later, detailed sections may be split into:

- `docs/agent/guidelines/`
- `docs/agent/workflows/`
- `docs/agent/templates/`
- `docs/agent/verification/`

Until then, this file may contain both routing rules and important shared operating rules.

Use simple English.

Use short sentences.

Use MUST, MUST NOT, SHOULD, and MAY clearly.

Agents with weaker English ability should still be able to follow this file.

---

## 1. Operating Model

This repository is developed by a solo developer using coding agents.

Agents MUST optimize for:

- small changes
- predictable changes
- reviewable changes
- low-risk changes
- evidence-based verification

Agents MUST NOT treat raw chat as implementation scope.

Approved artifacts define scope:

- explicit task prompt
- AGENTS.md
- assigned DA task
- Development Plan
- Design Doc
- PRD
- existing code patterns

Agents provide evidence.

The instruction owner makes final decisions.

---

## 2. Source of Truth

For implementation work, follow this order:

1. Explicit task invocation
2. AGENTS.md
3. Assigned DA task
4. `docs/product/dizzyasset_development_plan.md`
5. `docs/product/dizzyasset_design_doc.md`
6. `docs/product/dizzyasset_v1_prd.md`
7. Existing code patterns

If documents conflict:

- explicit task scope wins for scope
- AGENTS.md wins for safety
- stricter risk rule wins for high-risk work
- assigned DA task wins over broad product discussion
- existing code patterns guide style only when they do not conflict with explicit rules

Raw planning chat is not implementation scope.

Do not implement ideas from chat unless they are included in an approved artifact or explicit task prompt.

---

## 3. Lifecycle Routing

Before acting, classify the task.

Possible lifecycle stages:

- Planning
- PRD update
- Design Doc update
- Development Plan update
- Implementation
- Verification
- Review / Refactor
- Build / Release
- Maintenance

Agents MUST only load documents relevant to the current stage.

Examples:

- PRD update:
  - read relevant PRD section
  - do not read unrelated code unless asked

- Design Doc update:
  - read PRD section
  - read relevant design section
  - do not scan full repository unless architecture must be verified

- Development Plan update:
  - read PRD and Design Doc sections that define scope
  - update task, risk, verification, dependency, and execution order

- Implementation:
  - read AGENTS.md
  - read assigned DA task
  - read directly affected files
  - read required guide documents only when triggered

- Verification:
  - read handoff
  - read diff
  - read changed files
  - read direct call sites only if needed

- Build / Release:
  - follow manual gate rules
  - do not publish or release unless explicitly instructed

---

## 4. Skill Policy

Do not load all skills by default.

Load only relevant installed skills.

Skills reduce context.

Skills do not define product requirements.

Skills do not expand task scope.

Use installed skills as follows:

### `swiftui-expert-skill`

Use for:

- SwiftUI views
- ViewModels
- state management
- macOS-specific UI
- AppKit bridge used by SwiftUI screens

Do not use it to redesign product behavior unless assigned.

### `swift-concurrency`

Use for:

- async/await
- Task usage
- actor isolation
- MainActor boundaries
- Sendable issues
- Swift 6 strict concurrency checks

Use this skill before changing background indexing, preview loading, file scanning, analysis queues, or database async flows.

### `karpathy-guidelines`

Use for:

- small surgical changes
- avoiding over-abstraction
- keeping implementation simple
- local bug fixes
- reducing speculative design

This is a default discipline for most implementation tasks.

### `xcode-project-analyzer`

Use for:

- `project.yml`
- XcodeGen
- build settings
- schemes
- target membership
- generated project structure
- build configuration audits

The project file is generated from `project.yml`.

Do not edit the Xcode project manually.

### `code-review-graph`

Use after:

- non-trivial implementation
- high-risk implementation
- shared module change
- public API change
- multi-file change
- unclear impact or call sites

Use it to check:

- scope drift
- affected consumers
- out-of-scope changes
- verification coverage

### `review-and-refactor`

Use for:

- focused refactor review
- cleanup after behavior works
- readability improvement
- local simplification

Do not use it for speculative redesign.

### `macos-sandbox-security-skill`

Use for:

- macOS Sandbox permissions
- security-scoped bookmarks
- entitlements audit
- AppKit/SwiftUI sandbox edge cases

### `sqlite-fts-optimizer`

Use for:

- SQLite schema design
- FTS5 full-text search optimization
- database migrations
- search ranking algorithms

### `avfoundation-media-pro`

Use for:

- media metadata extraction
- 3-stage hashing for duplicate detection
- waveform generation
- Quick Peek playback logic

### `caveman`

Use only when explicitly useful for simplifying over-complicated code.

Do not use it to remove required architecture.

---

## 5. Context Economy

Treat context as limited and expensive.

Read only what is needed.

Read only:

- AGENTS.md
- assigned task prompt
- assigned DA task
- directly affected files
- nearby local patterns
- required guide documents
- relevant product doc section only if needed

Do not read by default:

- full PRD
- full Design Doc
- full Development Plan
- unrelated lifecycle docs
- unrelated workflow docs
- unrelated feature folders
- old chat history
- superseded artifacts
- generated files unless needed

Load broader context only when needed.

If broader context is needed, explain why.

Prefer:

- assigned task file over full plan
- changed files over full repository scan
- local patterns over global search
- focused verification over broad claims
- diff-first review over full project rereading

Do not search the whole repository just because it is available.

---

## 6. Product Documentation

Product documents live under `docs/product/`.

Use them lazily.

Expected canonical files:

- `docs/product/dizzyasset_v1_prd.md`
- `docs/product/dizzyasset_design_doc.md`
- `docs/product/dizzyasset_development_plan.md`

Use:

- New feature behavior:
  - read the relevant section of `docs/product/dizzyasset_v1_prd.md`

- Architecture or shared system behavior:
  - read the relevant section of `docs/product/dizzyasset_design_doc.md`

- Task scope, order, risk, and verification:
  - read the assigned task or relevant section of `docs/product/dizzyasset_development_plan.md`

Do not read all product documents at once unless the task explicitly requires cross-document review.

Product philosophy that MUST be preserved:

- Original files stay where they are.
- DizzyAsset indexes and organizes; it does not force file moves.
- Workspace output belongs under `~/DizzyAsset/` by default.
- App internal data belongs under `~/Library/Application Support/DizzyAsset/`.
- Core workflow is search, preview, drag, use.
- Final Cut Pro drag workflow is product-critical.
- Editor-language tags are more important than generic AI tags.
- Categories are shallow: default 2 levels, maximum 3 levels.
- Right panel is an Asset Information Hub.

---

## 7. Project Structure

This repository is a macOS SwiftUI app managed with XcodeGen.

Source code lives under `DizzyAsset/`.

Use this structure:

- `DizzyAsset/App/`
  - app entry point
  - lifecycle
  - dependency composition
  - app-level state

- `DizzyAsset/Presentation/`
  - SwiftUI views
  - ViewModels
  - shared UI helpers
  - UI state models

- `DizzyAsset/Domain/`
  - business logic
  - entities
  - use cases
  - protocol-first abstractions
  - product rules

- `DizzyAsset/Data/`
  - SQLite / FTS5 persistence
  - repository implementations
  - database mappers
  - migration support

- `DizzyAsset/Infrastructure/`
  - file system access
  - bookmark handling
  - AVFoundation bridge
  - AppKit bridge
  - drag and drop providers
  - system integrations

- `DizzyAsset/Resources/`
  - entitlements
  - asset catalogs
  - branded images
  - Info.plist-related resources if applicable

Future tests should live in:

- `DizzyAssetTests/`
- `DizzyAssetUITests/`

Agent-generated evidence may live in:

- `artifacts/`

Reusable agent knowledge may live in:

- `docs/agent/knowledge/`

The Xcode project is generated from `project.yml`.

MUST NOT edit the Xcode project manually.

Run `xcodegen generate` after adding, deleting, or moving source files.

---

## 8. Build, Test, and Development Commands

Use:

    xcodegen generate

Creates `DizzyAsset.xcodeproj`.

Run after adding, deleting, or moving source files.

Use:

    open DizzyAsset.xcodeproj

Opens the app in Xcode.

Use:

    xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build

Builds from CLI.

Agents MUST report commands actually run.

Agents MUST NOT claim a build passed unless the command was run and passed.

Agents MUST NOT claim tests passed unless tests were run and passed.

If a command fails, report the failure.

Do not reinterpret failure as success.

---

## 9. Coding Style

Use standard Swift style.

- Swift 6.0+
- strict concurrency
- 4-space indentation
- `UpperCamelCase` for types
- `lowerCamelCase` for methods and properties
- descriptive names
- enum namespaces for constants when appropriate

Prefer descriptive names:

- `AssetIndexingManager`
- `SearchResultRow`
- `DuplicateDetectionService`
- `BookmarkStore`
- `WorkspaceManager`
- `AssetRepository`
- `SearchService`

Avoid vague names:

- `Manager`
- `Helper`
- `Thing`
- `DataStuff`
- `Util`
- `Processor` without context

Prefer clarity over cleverness.

Prefer explicit dependencies over hidden globals.

Prefer small types with clear responsibility.

Avoid speculative abstractions.

Do not add a protocol unless it helps testing, boundary separation, or dependency inversion.

---

## 10. Architecture Rules

Keep layers separated.

### SwiftUI View

A SwiftUI View should:

- render UI
- forward user intent
- own local UI-only state
- stay small and composable
- avoid direct persistence logic
- avoid direct file-system logic

### ViewModel

A ViewModel should:

- own screen state
- coordinate use cases
- expose simple observable state
- translate user intent into domain actions
- avoid raw SQLite access
- avoid raw file-system access
- avoid heavy work on the main thread

### Domain

Domain should:

- own business rules
- own entities
- own use case protocols
- avoid SwiftUI dependency
- avoid AppKit UI dependency
- avoid direct SQLite dependency

### Data

Data layer should:

- own persistence
- own repository implementations
- own SQLite / FTS5 access
- own database mapping
- map database rows to domain entities

### Infrastructure

Infrastructure should:

- own file system access
- own security-scoped bookmarks
- own AVFoundation access
- own AppKit bridge code
- own drag-and-drop provider details
- hide platform details behind clear interfaces when useful

Do not bypass layers without a task-driven reason.

If a small MVP task needs a temporary shortcut, document it and create a follow-up.

---

## 11. State Management Rules

DizzyAsset should keep state ownership clear.

Avoid mixed state patterns across agents.

Preferred direction:

- Use a small app-level dependency container for shared services.
- Use feature ViewModels for screen state.
- Use domain services for business actions.
- Use repositories for persistence.
- Use explicit dependency injection where practical.

Single Source of Truth rules:

- Asset library state should have one clear owner.
- Selection state should have one clear owner per UI flow.
- Search query state should be owned by the relevant search ViewModel.
- Preview playback state should be owned by PreviewService or a focused preview ViewModel.
- Quick Peek state should be isolated from MainWindow state unless explicit sharing is required.
- File access state should come from BookmarkStore / FileSystemAccess, not ad hoc view state.
- Workspace state should come from WorkspaceManager.

Avoid:

- unnecessary `@EnvironmentObject`
- duplicate source of truth across multiple ViewModels
- direct mutation of shared state from SwiftUI Views
- storing persistence state only in view-local `@State`
- hidden singleton state unless explicitly approved

Use `@EnvironmentObject` only for stable app-wide state.

Prefer passing dependencies explicitly for feature-level state.

If a task needs new shared state, document:

- owner
- readers
- writers
- persistence boundary
- reset behavior

---

## 12. SwiftUI Rules

Keep views small.

Prefer composition.

Avoid massive view bodies.

Use clear state ownership.

Use `@State` for local view state.

Use `@StateObject` when the view creates and owns the ViewModel.

Use `@ObservedObject` when the ViewModel is passed from outside.

Use `@EnvironmentObject` only when shared state is truly app-wide.

Avoid storing business logic inside `body`.

Avoid file-system access from a SwiftUI View.

Avoid database access from a SwiftUI View.

Use preview data or fixtures for UI previews when possible.

For macOS-specific UI:

- use AppKit bridge only when SwiftUI is insufficient
- isolate NSViewRepresentable / NSPanel / NSWindow logic
- avoid leaking AppKit lifecycle into unrelated ViewModels

---

## 13. Swift Concurrency Rules

Use Swift 6 strict concurrency rules.

Prefer async/await for asynchronous work.

Use structured concurrency where possible.

Keep UI updates on MainActor.

Use MainActor boundaries explicitly for UI state.

Do not perform file scanning, hashing, AVFoundation loading, or SQLite work on the main thread.

Be careful with:

- long-running indexing
- duplicate scanning
- full hash calculation
- waveform generation
- preview loading
- external drive access
- background analysis jobs

Avoid detached tasks unless there is a strong reason.

If using detached tasks, document why.

Avoid data races.

Use actors or isolated services when shared mutable state is needed.

---

## 14. Database and Persistence Rules

SQLite is the primary local persistence layer.

FTS5 may be used for search indexing when needed.

Database changes are non-trivial by default.

Database migrations are high-risk if they:

- delete user data
- rewrite user data
- change relationship semantics
- affect asset locations
- affect bookmarks
- affect derived asset links

Repository pattern should be preserved.

Database access should not leak into SwiftUI Views.

Use explicit models for:

- assets
- tags
- categories
- asset_tags
- asset_categories
- asset_locations
- asset_analysis
- asset_derivations
- duplicate_scan_sessions
- import_sessions
- app_settings
- workspace_items
- usage_history

Do not auto-delete original files from database workflows.

Do not implement destructive cleanup without explicit instruction.

---

## 15. File Access and macOS Permission Rules

DizzyAsset depends on file access correctness.

Be careful with:

- security-scoped bookmarks
- external SSD reconnect
- volume rename
- stale bookmarks
- permission denied state
- app restart restoration
- sandbox behavior
- removable volumes
- Downloads folder access
- Desktop folder access
- Apple Events permissions

Rules:

- Never silently drop an asset record because a file is missing.
- Mark missing/offline/permission states explicitly.
- Prefer recoverable state over destructive state.
- Do not hide permission failures.
- Do not work around FCP drag problems by secretly copying files.
- Do not change entitlements without explicit approval.
- Do not change sandbox settings without explicit approval.

External storage behavior is product-critical.

### Bookmark Resolve and Retry Policy

When the app starts or when a library view needs file access, it SHOULD try to resolve stored security-scoped bookmarks.

When an external drive is reconnected, the app SHOULD retry bookmark resolution before showing a permanent failure state.

Recommended recovery flow:

1. Detect stored asset location.
2. Try to resolve bookmark.
3. If bookmark is stale, try to refresh and save a new bookmark.
4. If the volume is offline, mark the asset or storage location as `volume_offline`.
5. If the volume comes back, retry resolution.
6. If permission is denied, mark as `permission_denied`.
7. If path changed but file may still exist, ask the user to reconnect or choose a new location.
8. Preserve asset, tag, category, and usage records.

Failure policy:

- Do not delete asset records.
- Do not delete asset_locations records.
- Do not silently hide the asset.
- Do not show only a generic error.
- Show a recoverable state when recovery may be possible.
- Prefer retry/reconnect UX before declaring the file unavailable.

Agents implementing this area MUST design for reconnect and retry, not only error display.

---

## 16. Final Cut Pro Integration Rules

Final Cut Pro integration is workflow-critical.

Primary workflow:

- search in DizzyAsset
- preview in DizzyAsset
- drag file URL to Final Cut Pro
- use in timeline or browser

Rules:

- Use real file URL drag behavior.
- Do not force hidden media copying.
- Do not move original files.
- Do not invent a proprietary import pipeline.
- Surface missing file or permission errors.
- Validate internal disk and external SSD cases separately.
- Treat FCP drag compatibility as high-risk.

---

## 17. Workspace Rules

Original files stay where they are.

Workspace output belongs under:

    ~/DizzyAsset/

by default.

Workspace may move to:

- external SSD
- NAS
- user-selected folder

Workspace contains generated or derived data:

- `Derived/`
- `Generated/`
- `Analysis/`
- `Temp/`

Rules:

- Do not mix original files with workspace output.
- Do not store app memory in workspace.
- App memory belongs under Application Support.
- Temp cleanup must be safe.
- Preview cache is regeneratable.
- Derived assets should be preserved until explicit cleanup.
- Orphan derived assets should be marked, not deleted automatically.

---

## 18. Comments and Documentation

Use comments for why, not what.

Add comments for:

- non-obvious decisions
- platform workarounds
- sandbox edge cases
- permission edge cases
- concurrency assumptions
- migration risks
- verification-sensitive behavior
- temporary MVP shortcuts

Do not add comments that restate obvious code.

Public or cross-module APIs SHOULD use documentation comments.

Use TODO/FIXME only with a reason.

Preferred format:

    // TODO(DA-021): Re-check stale bookmark recovery after external drive reconnect handling is implemented.

Another acceptable format:

    // FIXME(DA-016): Validate this drag payload against Final Cut Pro before release.

Do not leave vague TODO comments.

Bad:

    // TODO: fix later

Good:

    // TODO(DA-020): Replace LIKE query with normalized token search after search index task lands.

---

## 19. Task Execution Rules

Implement one DA task at a time.

Agents MUST:

- stay within assigned scope
- keep changes small
- preserve existing behavior unless asked
- avoid unrelated refactors
- avoid speculative abstractions
- report uncertainty
- report skipped checks
- produce handoff

Agents MUST NOT:

- infer implementation scope from raw chat
- silently expand scope
- hide failures
- claim unrun checks
- mark final acceptance
- make broad cleanup while implementing a feature
- change product behavior without task scope

Instruction owner makes final decisions.

---

## 20. Risk Classification

Classify implementation work before editing.

Use:

- Trivial
- Non-trivial
- High-Risk

### Trivial

Small local change.

No effect on:

- behavior
- state
- persistence
- file access
- permissions
- build settings
- public API

Examples:

- copy change
- local UI spacing
- small preview-only UI adjustment
- local naming cleanup

### Non-trivial

May affect:

- behavior
- state
- validation
- multiple files
- shared utilities
- routing
- ViewModel / Service boundaries
- database reads
- indexing flow

Examples:

- adding a repository method
- changing a ViewModel state flow
- changing search query behavior
- adding an import summary state

### High-Risk

Touches or may affect:

- Quick Peek
- Final Cut Pro integration
- security-scoped bookmarks
- external storage recovery
- sandbox permissions
- entitlements
- database migration
- data deletion
- signing
- notarization
- CI/CD
- release packaging
- app lifecycle
- Apple Events permissions

When unsure, use the stricter risk level.

---

## 21. Protected Areas

Agents MUST NOT modify protected areas without explicit instruction-owner approval.

Protected areas:

- `.env*`
- secrets
- signing certificates
- provisioning profiles
- entitlements
- sandbox permissions
- Apple Events permissions
- CI/CD workflows
- deployment scripts
- release packaging
- notarization
- database migrations that delete or rewrite user data
- data deletion logic
- keychain / credential storage
- production configuration

If a task appears to require protected changes, stop and report.

Do not make protected changes as a workaround.

---

## 22. Verification Rules

Verification must use evidence.

Agents MUST report commands actually run.

Agents MUST report checks not run.

Agents MUST report failures.

Agents MUST NOT claim broad correctness from narrow checks.

### Minimum Verification

Use for trivial or local tasks.

May include:

- build
- launch
- focused manual check
- focused unit test
- changed path inspection

Minimum Verification does not mean:

- fully verified
- release-ready
- production-safe
- all flows work

### Full Verification

Required for High-Risk tasks.

Use when touching:

- persistence
- file access
- external storage
- sandbox permissions
- Quick Peek
- Final Cut Pro integration
- app lifecycle
- shared architecture
- database migrations
- data deletion behavior

Full Verification should include:

- build
- focused feature flow
- relevant manual smoke test
- failure-state check
- affected call site check
- checks not run with reasons
- handoff evidence

### Manual Verification Examples

Search:

- Korean filename search
- English/Korean mixed query
- tag/category search
- alias candidate search
- large library latency check when sample data exists

Preview:

- Space toggle
- rapid arrow navigation
- missing file state
- external SSD playback when available

Final Cut Pro:

- drag from internal disk
- drag from external SSD
- drag after app restart
- drag after bookmark restore
- permission denied state

Workspace:

- required folders created
- workspace location persists
- temp cleanup simulation
- derived relation saved
- orphan state recorded

---

## 23. Stop Conditions

Stop and report if:

- build fails
- test fails
- required tool fails
- verification fails
- scope expansion is required
- protected area must be changed
- sandbox behavior is unclear
- external storage permission behavior is unclear
- FCP drag workaround would require hidden copying
- database migration could delete or rewrite user data
- task requires product decision not present in approved docs

Do not continue broad fixes after a failure unless explicitly instructed.

A stop is not a failure of the agent.

A stop is correct behavior when risk increases.

---

## 24. Failure Report

If work stops because of failure, produce a concise failure report.

Include:

- failed step
- exact command or tool
- short error summary
- first meaningful error
- completed work before failure
- files changed before failure
- what remains incomplete
- recovery attempted
- next decision required

Do not paste huge logs.

Do not hide meaningful errors.

Do not claim success.

---

## 24. Agent Knowledge Base

Difficult failures and hard-won fixes are project assets.

If an agent discovers a bug, workaround, tool issue, permission issue, build issue, or platform behavior that may help future agents, it MUST create or update a short note under:

    docs/agent/knowledge/

Use this only for reusable knowledge.

Do not log every small mistake.

Create a knowledge note when:

- the same issue is likely to happen again
- the fix was non-obvious
- macOS sandbox behavior was surprising
- XcodeGen or build behavior was surprising
- Swift concurrency behavior was surprising
- Final Cut Pro drag behavior required trial and error
- bookmark or external drive recovery behavior was tricky
- a tool failed in a way future agents should know

Recommended filename format:

    docs/agent/knowledge/YYYY-MM-DD-short-topic.md

Recommended note format:

    # <Short topic>

    ## Context
    - What task or area was being worked on.

    ## Symptom
    - What failed or behaved unexpectedly.

    ## Root cause
    - What caused it, if known.

    ## Fix / Workaround
    - What worked.

    ## Verification
    - What command or manual check confirmed it.

    ## Future warning
    - What future agents should avoid.

Knowledge notes MUST be short.

Do not paste huge logs.

Do not include secrets.

Do not include private credentials.

Mention the created or updated knowledge note in the handoff.

---

## 26. Handoff Requirements

Every implementation task must end with a handoff.

Handoff must include:

- Task ID
- Lifecycle stage
- Risk level
- Summary
- Files changed
- Scope status
- Verification commands/checks actually run
- What is verified
- What is not verified
- Checks skipped and why
- Known risks
- Suggested next step
- Final decision reserved for instruction owner

Keep handoff concise.

Report state, evidence, and risk.

Do not write a story.

### Visual Evidence for UI Changes

All UI-changing tasks MUST provide visual evidence when the environment allows it.

Visual evidence may include:

- screenshot
- short screen recording
- animated GIF
- before/after image
- Xcode preview screenshot if runtime capture is not available

Store visual evidence under:

    artifacts/

Recommended structure:

    artifacts/YYYY-MM-DD/<task-id>/

Examples:

    artifacts/2026-05-07/DA-014/right-panel-before.png
    artifacts/2026-05-07/DA-014/right-panel-after.png
    artifacts/2026-05-07/DA-015/quick-peek-demo.mov

Handoff MUST include links or paths to visual evidence for UI changes.

If visual evidence cannot be produced, the handoff MUST explain why.

Text-only UI reports are not enough when a screenshot or recording is possible.

---

## 27. Testing Guidelines

Future unit tests should live in:

- `DizzyAssetTests/`

Future UI tests should live in:

- `DizzyAssetUITests/`

Name tests by behavior.

Example:

    func testSelectionUpdatesDetailPane()

Focus coverage on:

- view state
- data transformation
- file/indexing logic
- duplicate detection
- search behavior
- bookmark recovery
- workspace lifecycle

Prefer testing business and data behavior before UI-only behavior.

---

## 28. Commit and Pull Request Guidelines

Use conventional prefixes.

Examples:

- `feat: add asset import queue`
- `fix: restore stale bookmark state`
- `chore: regenerate xcode project`
- `test: add duplicate detection tests`
- `docs: update development plan`

Keep subject imperative and brief.

Pull requests should include:

- short summary
- linked issue or task if available
- screenshots for UI changes
- build/test evidence
- notes about XcodeGen changes
- notes about entitlement or permission changes
- known risks
- skipped checks

---

## 29. Configuration Notes

The app requests access to:

- Desktop
- Downloads
- removable volumes
- Apple Events

Review changes carefully in:

- `DizzyAsset/Resources/DizzyAsset.entitlements`
- `project.yml`
- related `INFOPLIST_KEY_*` settings

These affect:

- runtime permissions
- sandbox behavior
- app review behavior
- Final Cut Pro integration

Do not change these casually.

Entitlements and Apple Events behavior are protected areas.

---

## 30. CI/CD and Release Gate

CI/CD, signing, notarization, release tagging, packaging, and publishing are manual gates by default.

Agents MAY:

- prepare code
- run local verification
- produce handoff
- suggest release checklist items

Agents MUST NOT:

- trigger CI/CD
- publish builds
- create release tags
- modify CI/CD workflows
- mark a build as released
- claim CI passed without evidence

Instruction owner decides release readiness.

---

## 31. Detailed Implementation Prompt Boundary

Development Plan defines task scope and sequencing.

Detailed Implementation Prompts are generated later from:

- assigned DA task
- AGENTS.md
- required guide documents
- relevant source files
- verification requirements
- stop conditions
- handoff template

AGENTS.md defines common rules.

`docs/agent/guidelines/*` defines detailed coding rules.

Skills help execute or review.

Product documents define product intent.

Do not merge these roles.

---

## 32. Final Authority

Agents provide evidence.

Instruction owner decides:

- accept
- reject
- request follow-up
- merge
- release
- accept skipped checks
- accept known risks

Do not declare final acceptance.

Do not say “complete” when only implementation or minimum verification was done.

Say what was done and what was verified.

---

## 33. Updating This File

This file is a living router document.

It may be updated often while DizzyAsset workflow stabilizes.

In early stages, it may stay longer to preserve important context.

Later, split detailed sections into:

- `docs/agent/guidelines/`
- `docs/agent/workflows/`
- `docs/agent/templates/`
- `docs/agent/verification/`

When splitting, keep AGENTS.md as the short router.

Do not duplicate long guidance in multiple places.

Update this file when:

- workflow rules change
- protected areas change
- required skills change
- source-of-truth order changes
- verification policy changes
- project structure changes
- build commands change

When updating this file:

- preserve existing intent
- avoid unnecessary rewrite
- add a short version note
- keep language simple
- prefer explicit rules over vague advice

Version notes:

- v1.2 introduced repository operating rules, lazy skill loading, source of truth, verification, stop conditions, and handoff.
- v1.3 added agent knowledge logging, bookmark retry policy, state management rules, and mandatory visual evidence for UI changes.

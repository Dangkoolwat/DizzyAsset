# Apple Coding Style Guideline

Use this guideline for all Swift, SwiftUI, AppKit bridge, model, service, repository, and utility code in DizzyAsset.

Keep code simple.
Keep changes small.
Prefer clarity over cleverness.

---

## 1. Core Principles

MUST:

- follow standard Swift style
- prefer readable names
- keep types focused
- keep functions short when practical
- preserve existing behavior unless assigned
- avoid unrelated refactors
- avoid speculative abstraction

MUST NOT:

- add architecture for imagined future use
- hide side effects
- use vague names
- mix UI, domain, and persistence logic
- make broad style-only rewrites during feature work

---

## 2. Naming

Use:

- `UpperCamelCase` for types
- `lowerCamelCase` for methods, properties, and variables
- descriptive names
- domain language from DizzyAsset product docs

Good names:

- `AssetImportService`
- `DuplicateDetectionService`
- `BookmarkStore`
- `WorkspaceManager`
- `SearchService`
- `AssetRepository`
- `SearchResultRow`
- `QuickPeekViewModel`

Avoid vague names:

- `Manager`
- `Helper`
- `Processor`
- `Thing`
- `DataStuff`
- `Util`

Generic names are allowed only when the surrounding type gives clear meaning.

Example:

- `AssetImportService.processCandidate`
- `SearchService.Result`

---

## 3. File Names

File names SHOULD match the primary type.

Examples:

- `AssetImportService.swift`
- `SearchService.swift`
- `BookmarkStore.swift`
- `AssetListView.swift`
- `AssetListViewModel.swift`

Avoid placing many unrelated types in one file.

Small private helper types may live near their owner.

---

## 4. Type Organization

Recommended order inside a Swift type:

1. nested types
2. constants
3. stored properties
4. computed properties
5. initializer
6. public/internal methods
7. private helpers

Keep private helpers near the behavior they support when that improves readability.

Use `private` by default when a member does not need wider access.

Use `internal` only when needed across module files.

Use `public` only when required.

---

## 5. Access Control

Default to the narrowest access level.

MUST:

- mark helpers `private` when possible
- avoid exposing mutable state
- expose intent methods instead of raw mutable properties

Prefer:

- `private(set) var`
- immutable `let`
- clear method names for mutation

Avoid:

- public mutable arrays
- public mutable dictionaries
- cross-layer mutable state

---

## 6. Optionals

Use optionals to model real absence.

MUST NOT use optionals to hide unclear state.

Prefer explicit state enums when there are several possible states.

Good examples:

- `AssetLocationStatus.available`
- `AssetLocationStatus.volumeOffline`
- `AssetLocationStatus.permissionDenied`
- `AssetLocationStatus.missing`

Avoid:

- `nil` meaning many different things

---

## 7. Error Handling

Prefer typed errors for domain or infrastructure failures.

Use clear error names.

Examples:

- `AssetImportError.unsupportedFileType`
- `BookmarkError.staleBookmark`
- `WorkspaceError.locationUnavailable`
- `PreviewError.permissionDenied`

MUST:

- surface user-relevant failures to ViewModel/UI
- preserve technical context for logging or handoff
- avoid swallowing errors silently

MUST NOT:

- catch and ignore errors
- convert all failures into generic strings too early
- hide permission failures
- delete records because an error occurred

---

## 8. Constants

Use enum namespaces for grouped constants when useful.

Example names:

- `WorkspacePaths`
- `SearchDefaults`
- `PreviewDefaults`
- `ImportLimits`

Avoid magic numbers.

If a number is product-sensitive, name it.

Examples:

- partial hash chunk size
- preview latency target
- max category depth
- cache size limit

---

## 9. Dependency Style

Prefer explicit dependencies.

Good:

- pass services into ViewModels
- pass repositories into services
- use a small app-level container for composition

Avoid:

- hidden singleton dependencies
- global mutable state
- service lookup from random views
- creating infrastructure objects deep inside UI code

Singletons MAY be used only for stable platform adapters when explicitly justified.

---

## 10. Protocols

Use protocols when they provide value.

Good reasons:

- testing
- dependency inversion
- platform boundary
- repository abstraction
- provider abstraction

Bad reasons:

- every type automatically gets a protocol
- imagined future flexibility
- style preference only

Do not create protocol noise.

---

## 11. Functions

Functions SHOULD do one clear thing.

Prefer:

- clear input
- clear output
- minimal side effects
- early return for invalid states

Avoid:

- very long functions
- deeply nested conditionals
- hidden mutation
- mixed UI and business logic

If a function is hard to name, it probably does too much.

---

## 12. Data Transformation

Keep mapping code explicit.

Mapping between layers should be easy to inspect.

Examples:

- database row to domain entity
- domain entity to UI model
- file metadata to asset candidate

Avoid implicit conversion magic.

Avoid lossy conversion unless intentional and documented.

---

## 13. Logging

Use logging for useful diagnostic events.

Log:

- import failures
- bookmark restore failures
- duplicate scan summaries
- workspace cleanup results
- FCP drag failures
- database migration failures

Do not log:

- secrets
- full bookmark data
- private user content unnecessarily
- huge raw payloads

Logs should help future debugging.

---

## 14. User Data Safety

DizzyAsset must be conservative with user data.

MUST NOT:

- delete original files automatically
- move original files automatically
- rewrite original files automatically
- silently drop asset records
- perform destructive database migration without explicit approval

Prefer:

- mark missing
- mark offline
- mark permission denied
- create recoverable state
- ask user to reconnect

---

## 15. Imports

Keep imports minimal.

Do not import AppKit into pure domain types.

Do not import SwiftUI into domain or data layers.

Do not import SQLite or database implementation details into SwiftUI Views.

Platform imports belong near platform boundary code.

---

## 16. Formatting

Use:

- 4-space indentation
- one primary type per file when practical
- blank lines to separate logical sections
- trailing commas only where project style supports them

Avoid large formatting-only diffs.

Do not reformat unrelated code during feature work.

---

## 17. Reviews

Before finishing a code task, check:

- Is the change small?
- Is naming clear?
- Is access control narrow?
- Are errors visible?
- Are side effects clear?
- Did I avoid unrelated refactor?
- Did I preserve original files?
- Did I report verification honestly?
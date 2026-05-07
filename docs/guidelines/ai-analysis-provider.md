# AI Analysis Provider Guideline

Use this guideline when changing filename analysis, folder-name analysis, metadata analysis, Sound Analysis, Vision, Speech, LLM providers, tag suggestions, category suggestions, or analysis result storage.

AI is an assistant.

The editor controls final organization.

---

## 1. Core Principles

MUST:

- preserve user control
- keep AI suggestions editable
- store raw and normalized results separately
- keep providers replaceable
- avoid blocking core import flow
- map AI output to editor-language tags
- keep MVP scope clear

MUST NOT:

- force AI categories
- overwrite confirmed user tags silently
- make AI required for search
- make AI required for preview
- block import on heavy AI analysis
- treat AI output as ground truth

---

## 2. v1.0 Scope

v1.0 may include:

- filename analysis
- folder-name analysis
- metadata analysis
- suggested tags
- suggested categories
- analysis result storage structure

Out of v1.0 unless assigned:

- full Vision analysis
- full Speech transcription
- LLM automatic classification
- cloud AI workflows
- recommendation systems

Provider structure may be prepared before runtime provider is enabled.

---

## 3. Provider Architecture

Analysis providers should be replaceable.

Possible providers:

- FilenameAnalyzer
- FolderNameAnalyzer
- MetadataAnalyzer
- SoundAnalysisProvider
- VisionAnalysisProvider
- SpeechAnalysisProvider
- LocalLLMProvider
- CloudLLMProvider

Provider interface may include:

- canAnalyze
- analyze
- providerIdentifier
- providerVersion

Providers should not own UI state.

Providers should not directly mutate user-confirmed tags.

---

## 4. Raw and Normalized Results

Store both:

- raw result
- normalized result

Raw result:

- original provider output
- useful for debugging
- provider-specific

Normalized result:

- editor-language tags
- category suggestions
- confidence
- source
- provider version

Do not discard raw results if they are useful for future reprocessing.

Do not expose raw provider noise directly to users unless needed.

---

## 5. Suggested vs Confirmed

AI output should start as suggested.

User action may convert it to confirmed.

Suggested data:

- can be hidden
- can be rejected
- can be replaced
- may have confidence

Confirmed data:

- user-approved
- should rank higher
- should not be overwritten silently
- should be preserved through reanalysis

---

## 6. Editor-Language Mapping

AI should map to editor language.

Prefer tags users actually search for.

Examples:

- 예능 / Funny
- 긴장 / Tension
- 타격 / Impact
- 전환 / Transition
- 쇼츠 / Shorts
- 실패 / Fail
- 리액션 / Reaction
- 밈 / Meme

Avoid generic research-only labels unless useful.

Bad examples when used alone:

- object
- sound
- audio
- human
- scene
- file

AI should improve search feel, not create academic labels.

---

## 7. Confidence

Confidence should be used carefully.

Rules:

- weak suggestions should remain suggested
- low confidence should not auto-apply
- user-confirmed choices override AI confidence
- confidence scale should be documented if used

Do not fake precision.

Do not show overly technical confidence unless useful.

---

## 8. Background Analysis

Heavy analysis should run in background.

Examples:

- waveform
- Sound Analysis
- Vision
- Speech
- LLM classification

Rules:

- do not block import completion
- do not block preview
- store analysis status
- allow retry if practical
- show pending state if user-visible
- handle cancellation

---

## 9. Local vs Cloud

Local analysis is preferred for privacy when possible.

Cloud analysis is high-risk and out of MVP unless assigned.

Cloud workflows require explicit approval.

If cloud analysis is introduced, consider:

- user consent
- data sent
- privacy
- cost
- failure mode
- offline behavior

Do not add cloud calls casually.

---

## 10. Speech and Vision

Speech and Vision are future provider areas unless assigned.

Speech may support:

- transcript
- Korean search
- dialogue-based tags

Vision may support:

- visual description
- scene tags
- object tags
- meme context

Rules:

- do not make them required for MVP
- keep storage structure ready
- keep provider optional
- avoid blocking core workflow

---

## 11. Analysis Storage

Analysis records may include:

- asset id
- analyzer type
- analyzer version
- raw result JSON
- normalized result JSON
- confidence
- created at
- status

Status may include:

- pending
- running
- succeeded
- failed
- skipped
- cancelled

Do not overwrite previous meaningful analysis without versioning or policy.

---

## 12. Search Interaction

AI may support search.

Examples:

- suggested tags
- normalized aliases
- transcript search
- visual tags

Rules:

- filename search must still work
- user-confirmed tags should rank higher
- AI suggestions should not dominate exact matches
- rejected suggestions should not keep affecting search

---

## 13. UI Interaction

UI should clearly distinguish:

- suggested tag
- confirmed tag
- rejected suggestion
- analysis pending
- analysis failed

User should be able to:

- accept suggestion
- reject suggestion
- edit tag
- hide AI suggestion if needed

Do not make AI feel mandatory.

---

## 14. Error Handling

AI analysis errors should be non-fatal.

Possible errors:

- provider unavailable
- unsupported file
- timeout
- model failure
- permission denied
- file missing
- cancelled

Rules:

- record failure status
- keep asset usable
- keep search/preview usable
- allow retry if practical
- do not remove existing confirmed tags

---

## 15. Testing and Verification

AI analysis verification should include:

- filename analyzer
- folder-name analyzer
- metadata analyzer
- suggested tag creation
- suggested vs confirmed behavior
- raw and normalized result storage
- failed provider state
- reanalysis behavior if changed

If heavy providers are not enabled, report not tested.

---

## 16. Stop Conditions

Stop and report if:

- AI would overwrite confirmed user tags
- cloud provider is needed without approval
- analysis blocks import or preview
- provider output schema is unclear
- confidence policy is unclear
- user consent is required but missing
- storage migration is required and risky

Do not guess AI product policy.

---

## 17. Handoff Requirements

For AI analysis work, handoff must include:

- files changed
- provider touched
- runtime provider enabled:
  - yes/no
- raw result changed:
  - yes/no
- normalized result changed:
  - yes/no
- suggested/confirmed behavior changed:
  - yes/no
- search ranking affected:
  - yes/no
- verification run
- skipped checks
- known risks
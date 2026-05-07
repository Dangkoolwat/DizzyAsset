# DA-026 Visual Excellence & UI Polish — Detailed Implementation Prompt

**Document type:** Detailed implementation prompt  
**Task ID:** DA-026  
**Task name:** Visual Excellence & UI Polish  
**Project:** DizzyAsset  
**Lifecycle stage:** Implementation / Polish  
**Risk level:** Low  
**Target repo path:** `docs/task/DA-026-visual-excellence-ui-polish.md`  
**Status:** Ready for implementation  
**Last updated:** 2026-05-07

---

## 1. Task Goal

Transform the DizzyAsset UI from a functional prototype to a premium, "wow-factor" macOS application.
The goal is to implement modern design aesthetics including glassmorphism, dynamic hover states, and vibrant micro-interactions.

---

## 2. Source of Truth

Follow:
1. Explicit implementation request
2. `AGENTS.md`
3. This DA-026 task prompt
4. `docs/guidelines/swiftui-architecture.md`
5. Standard Apple Human Interface Guidelines (HIG)

---

## 3. Required Reading

Always read:
- `AGENTS.md`
- `docs/guidelines/swiftui-architecture.md`
- `docs/templates/handoff.md`

---

## 4. In Scope

- **Hover Effects:** Add `.onHover` effects to `AssetRowView` for subtle background highlights.
- **Glassmorphism:** Apply `.background(.thinMaterial)` to the Sidebar and Right Panel.
- **Typography:** Refine font weights and sizes for better hierarchy.
- **Vibrant Iconography:** Use colored SF Symbols for media types (Video = Purple, Audio = Blue, Photo = Green).
- **Micro-animations:** Add subtle `.animation` for selection changes and hover transitions.
- **Spacing:** Standardize padding and spacing across all views for a "breathable" layout.

---

## 5. Out of Scope

- Changing the core 3-column layout.
- Adding new functional features (Search, Import, etc.).
- Custom font file integration (use system fonts for now).
- Dark mode specific overrides (ensure it looks good in both).

---

## 6. Implementation Guidance

### Hover & Selection
In `AssetRowView`, use a local `@State private var isHovered = false` to trigger background changes.
Use `.scaleEffect(isHovered ? 1.01 : 1.0)` for a subtle "pop" effect.

### Glassmorphism
Update the `background` of the detail panel and sidebar in `MainWindowView`.
```swift
.background(.thinMaterial)
```

### Vibrant Icons
Map `mediaType` to colors:
```swift
var typeColor: Color {
    switch mediaType {
    case "video": return .purple
    case "audio": return .blue
    default: return .secondary
    }
}
```

---

## 7. Verification

- `xcodegen generate`
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`
- Verify:
  - Hovering over a row shows a subtle highlight.
  - Sidebar and Right Panel have a frosted glass effect.
  - Icon colors are vibrant and correctly mapped.
  - Overall UI feels more premium and responsive.

---

## 8. Handoff Requirements

Use `docs/templates/handoff.md`.

Include:
- Summary of visual changes.
- **Screenshots or Recording** under `artifacts/2026-05-07/DA-026/`.
- Verification results.
- Next suggested task.

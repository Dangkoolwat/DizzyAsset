# Apple Coding Style & Naming

**Document:** `docs/guidelines/apple-coding-style.md`  
**Related Skill:** `karpathy-guidelines`

## 1. Core Principles
- Use standard Swift style.
- Prefer clarity over cleverness.
- Keep implementation simple and surgical.
- Avoid speculative abstractions.

## 2. Naming Conventions
- **Types:** `UpperCamelCase` (e.g., `AssetRepository`).
- **Methods/Properties:** `lowerCamelCase` (e.g., `fetchAssets()`).
- **Descriptive Names:** Avoid vague names like `Manager`, `Helper`, or `Util`. 
    - Prefer: `AssetIndexingManager`, `SearchResultRow`, `DuplicateDetectionService`.
- **Enum Namespaces:** Use enums for constants and namespaces to avoid global clutter.

## 3. Formatting
- **Indentation:** 4-space indentation.
- **Protocol Usage:** Do not add a protocol unless it helps testing, boundary separation, or dependency inversion.
- **Dependency Injection:** Prefer explicit dependencies over hidden globals.

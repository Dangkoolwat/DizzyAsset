# Final Cut Pro Integration

**Document:** `docs/guidelines/final-cut-pro-integration.md`

## 1. Integration Standards
- The primary workflow is dragging file URLs from DizzyAsset to Final Cut Pro.
- Use standard file URL drag behavior (`public.file-url`).

## 2. Forbidden Actions
- **Do not** force hidden media copying to "fix" FCP import issues.
- **Do not** move original files to a proprietary import folder.
- **Do not** bypass sandbox restrictions by secretly duplicating media.

## 3. Compatibility
- Validate drag payload against both internal disk and external SSD scenarios.
- Surface permission or missing file errors clearly to the user.

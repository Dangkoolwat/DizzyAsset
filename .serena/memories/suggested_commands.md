# Suggested Commands for DizzyAsset

## Project Configuration
- `xcodegen generate`: Regenerate the Xcode project after any file changes (add/move/delete).

## Build
- `xcodebuild -project DizzyAsset.xcodeproj -scheme DizzyAsset -configuration Debug build`: CLI Build of the main application.

## Verification
- Agents MUST report commands actually run.
- Agents MUST NOT claim build/test passed unless the command was run and passed.

## System Utilities
- `git`: Version control.
- `ls`, `cd`, `grep`, `find`: Standard Darwin/Unix file system utilities.

# Release Readiness Checklist

**Document version:** v1.0  
**Project:** DizzyAsset  
**Document role:** Pre-release quality gate  
**Status:** Required for V1.0 and beyond  
**Last updated:** 2026-05-07

---

## 0. Purpose

This document defines the final quality gates that must be passed before a build of DizzyAsset is considered "Release Ready."

---

## 1. Build & Packaging
- [ ] **Clean Build:** `xcodebuild clean build` succeeds with zero errors.
- [ ] **XcodeGen:** `xcodegen generate` produces a project matching the current repository structure.
- [ ] **Code Signing:** App is correctly signed for Development/Distribution.
- [ ] **Notarization:** (For Production) App bundle is successfully notarized by Apple.

## 2. Performance & Stability
- [ ] **Startup Time:** App launches and shows Main Window within < 1.5s on target hardware.
- [ ] **Memory Usage:** No significant leaks observed during 5-minute heavy import/preview usage.
- [ ] **Concurrency:** No Thread Sanitizer warnings or race conditions detected.
- [ ] **Search Latency:** FTS5 results for 1000+ assets return in < 100ms.

## 3. Data Integrity
- [ ] **Schema Check:** Database schema matches `Schema.swift` exactly.
- [ ] **Migration Check:** Upgrading from the last stable release preserves all user tags and categories.
- [ ] **Asset Safety:** Verified that original files are untouched across all app operations.

## 4. Documentation & Compliance
- [ ] **Handoffs:** All DA tasks in the current release cycle have completed handoffs.
- [ ] **Legal/About:** Version number and copyrights are up to date.
- [ ] **Privacy:** App behavior matches the reported Sandbox/Entitlement profile.

---

## 5. Acceptance Procedure

1. **Agent Audit:** Perform a full sweep of the Manual QA and High-Risk checklists.
2. **Result Compilation:** Summarize all verification results in a "Release Audit" artifact.
3. **Submission:** Present the Audit to the Instruction Owner.
4. **Final Acceptance:** Release is triggered only upon explicit "GO" from the User.

# High-Risk Verification Checklist

**Document version:** v1.0  
**Project:** DizzyAsset  
**Document role:** Security and integrity verification guide  
**Status:** Mandatory for high-risk tasks  
**Last updated:** 2026-05-07

---

## 0. Purpose

This document defines mandatory verification steps for tasks classified as **High-Risk** in `AGENTS.md`. These areas have direct impact on user data integrity, security, or system-level permissions.

---

## 1. High-Risk Scopes

### [ ] macOS Sandbox & Entitlements
- [ ] Verify `com.apple.security.app-sandbox` is enabled.
- [ ] Verify file access is restricted to user-selected folders and app container.
- [ ] Ensure no unauthorized network or system-wide permissions are requested.

### [ ] Security-Scoped Bookmarks
- [ ] Verify bookmarks are correctly persisted as BLOBs in the database.
- [ ] Test bookmark resolution after system restart.
- [ ] Verify "Offline" status detection for disconnected volumes.
- [ ] Ensure `startAccessingSecurityScopedResource()` and `stopAccessingSecurityScopedResource()` are called in pairs.

### [ ] Database Migrations
- [ ] Verify migration script does not delete or rewrite user metadata without backup.
- [ ] Test upgrade path from previous DB version to new schema.
- [ ] Ensure foreign key constraints (ON DELETE CASCADE/SET NULL) are correctly enforced.

### [ ] Final Cut Pro Integration
- [ ] Verify that external drive assets are resolved correctly before FCP drag.
- [ ] Ensure FCP integration does not involve hidden file copying or temp moving.
- [ ] Verify FCP Pasteboard data integrity.

### [ ] Workspace & File Deletion
- [ ] **STRICT:** Verify no original user files are deleted by any app logic.
- [ ] Ensure "Cleanup" logic only targets known `temp` or `previewCache` files.
- [ ] Test "Orphaned" status for derived assets when source media is deleted.

---

## 2. Verification Protocol

1. **Pre-Implementation:** Review `docs/guidelines/` relevant to the risk area.
2. **Implementation:** Follow "Surgical Changes" principle.
3. **Verification:** 
    - Perform all relevant checks in this document.
    - Provide raw CLI build output.
    - Provide logs of database queries verifying schema state.
    - Provide visual evidence of UI status indicators for error states.
4. **Handoff:** Explicitly list remaining risks and verification results in the `DA` handoff.

---

## 3. Final Authority

**Agents provide evidence; the Instruction Owner (User) makes the final decision.** 
Do not declare a high-risk task as "accepted" until the user has reviewed the evidence.

# SQLite and Migrations

**Document:** `docs/guidelines/sqlite-migration.md`  
**Related Skill:** `sqlite-fts-optimizer`

## 1. Persistence Standards
- SQLite is the primary persistence layer.
- FTS5 is used for search indexing (using `unicode61` tokenizer).
- Follow the Repository pattern for all data access.

## 2. Migration Governance (High-Risk)
- **Forbidden:** Deleting or rewriting user data (tags, categories, custom metadata) without explicit instruction.
- All migrations MUST be wrapped in transactions.
- Verify migrations against a sample database with existing data.

## 3. Performance
- Use explicit models for all tables (Assets, Tags, Categories, etc.).
- Ensure foreign keys have indexes.
- Never block the main thread for DB operations.

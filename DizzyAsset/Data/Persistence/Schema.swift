import Foundation

enum Schema {
    static let version = 2
    
    static let createMigrationsTable = """
    CREATE TABLE IF NOT EXISTS schema_migrations (
        version INTEGER PRIMARY KEY,
        applied_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    """
    
    static let createAssetsTable = """
    CREATE TABLE IF NOT EXISTS assets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        filename TEXT NOT NULL,
        fingerprint TEXT,
        size INTEGER NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    """
    
    static let createAssetLocationsTable = """
    CREATE TABLE IF NOT EXISTS asset_locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        asset_id INTEGER NOT NULL,
        url TEXT NOT NULL,
        bookmark_data BLOB,
        status TEXT NOT NULL,
        last_seen_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
    );
    """
    
    static let createTagsTable = """
    CREATE TABLE IF NOT EXISTS tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
    );
    """
    
    static let createAssetTagsTable = """
    CREATE TABLE IF NOT EXISTS asset_tags (
        asset_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        PRIMARY KEY (asset_id, tag_id),
        FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
    );
    """
    
    static let createCategoriesTable = """
    CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        parent_id INTEGER,
        FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
    );
    """
    
    static let createAssetCategoriesTable = """
    CREATE TABLE IF NOT EXISTS asset_categories (
        asset_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        PRIMARY KEY (asset_id, category_id),
        FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
    );
    """
    
    static let createDuplicateScanSessionsTable = """
    CREATE TABLE IF NOT EXISTS duplicate_scan_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        completed_at DATETIME,
        status TEXT NOT NULL,
        summary TEXT
    );
    """
    
    static let createAppSettingsTable = """
    CREATE TABLE IF NOT EXISTS app_settings (
        key TEXT PRIMARY KEY,
        value TEXT,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    """
    
    static let createTechnicalMetadataTable = """
    CREATE TABLE IF NOT EXISTS technical_metadata (
        asset_id INTEGER PRIMARY KEY,
        duration REAL,
        width INTEGER,
        height INTEGER,
        codec TEXT,
        frame_rate REAL,
        FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
    );
    """
    
    static let createAssetAnalysisTable = """
    CREATE TABLE IF NOT EXISTS asset_analysis (
        asset_id INTEGER PRIMARY KEY,
        front_silence_duration REAL DEFAULT 0,
        tail_silence_duration REAL DEFAULT 0,
        analyzed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        analyzer_version TEXT,
        status TEXT,
        FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
    );
    """
    
    static let createAssetAIResultsTable = """
    CREATE TABLE IF NOT EXISTS asset_ai_results (
        asset_id INTEGER PRIMARY KEY,
        provider_id TEXT NOT NULL,
        provider_version TEXT,
        raw_json TEXT,
        normalized_json TEXT,
        confidence REAL,
        status TEXT,
        analyzed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
    );
    """
    
    static let createSuggestedTagsTable = """
    CREATE TABLE IF NOT EXISTS suggested_tags (
        asset_id INTEGER NOT NULL,
        tag_name TEXT NOT NULL,
        confidence REAL,
        source TEXT,
        PRIMARY KEY (asset_id, tag_name),
        FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
    );
    """
    
    static let createAssetDerivationsTable = """
    CREATE TABLE IF NOT EXISTS asset_derivations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_asset_id INTEGER NOT NULL,
        derived_asset_id INTEGER,
        derivation_type TEXT NOT NULL,
        derived_file_path TEXT,
        status TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (source_asset_id) REFERENCES assets(id) ON DELETE CASCADE,
        FOREIGN KEY (derived_asset_id) REFERENCES assets(id) ON DELETE SET NULL
    );
    """
    
    static let createSearchIndexTable = """
    CREATE VIRTUAL TABLE IF NOT EXISTS asset_search_index USING fts5(
        asset_id UNINDEXED,
        filename,
        tags,
        categories,
        aliases
    );
    """
    
    static let createSearchAliasesTable = """
    CREATE TABLE IF NOT EXISTS search_aliases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        term TEXT NOT NULL,
        alias TEXT NOT NULL,
        language TEXT DEFAULT 'en',
        UNIQUE(term, alias)
    );
    """
    
    static let createWorkspaceItemsTable = """
    CREATE TABLE IF NOT EXISTS workspace_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        asset_id INTEGER,
        file_path TEXT NOT NULL UNIQUE,
        item_type TEXT NOT NULL,
        status TEXT NOT NULL,
        size_bytes INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
    );
    """
}

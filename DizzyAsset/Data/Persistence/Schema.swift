import Foundation

enum Schema {
    static let version = 1
    
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
}

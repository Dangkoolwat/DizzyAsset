import Foundation
import SQLite3

enum SQLiteError: Error {
    case openDatabase(message: String)
    case prepare(message: String)
    case step(message: String)
    case bind(message: String)
}

class SQLiteConnector {
    private var db: OpaquePointer?
    
    init(path: String) throws {
        if sqlite3_open(path, &db) != SQLITE_OK {
            defer { sqlite3_close(db) }
            let message = String(cString: sqlite3_errmsg(db))
            throw SQLiteError.openDatabase(message: message)
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    func execute(sql: String, parameters: [Any] = []) throws {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(db))
            throw SQLiteError.prepare(message: message)
        }
        
        defer { sqlite3_finalize(statement) }
        
        try bindParameters(statement: statement!, parameters: parameters)
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let message = String(cString: sqlite3_errmsg(db))
            throw SQLiteError.step(message: message)
        }
    }
    
    func query(sql: String, parameters: [Any] = []) throws -> [[String: Any]] {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(db))
            throw SQLiteError.prepare(message: message)
        }
        
        defer { sqlite3_finalize(statement) }
        
        try bindParameters(statement: statement!, parameters: parameters)
        
        var results: [[String: Any]] = []
        let columnCount = sqlite3_column_count(statement)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            var row: [String: Any] = [:]
            for i in 0..<columnCount {
                let name = String(cString: sqlite3_column_name(statement, i))
                let type = sqlite3_column_type(statement, i)
                
                switch type {
                case SQLITE_INTEGER:
                    row[name] = Int(sqlite3_column_int64(statement, i))
                case SQLITE_FLOAT:
                    row[name] = sqlite3_column_double(statement, i)
                case SQLITE_TEXT:
                    if let cString = sqlite3_column_text(statement, i) {
                        row[name] = String(cString: cString)
                    } else {
                        row[name] = NSNull()
                    }
                case SQLITE_BLOB:
                    let data = sqlite3_column_blob(statement, i)
                    let size = sqlite3_column_bytes(statement, i)
                    row[name] = Data(bytes: data!, count: Int(size))
                case SQLITE_NULL:
                    row[name] = NSNull()
                default:
                    break
                }
            }
            results.append(row)
        }
        
        return results
    }
    
    private func bindParameters(statement: OpaquePointer, parameters: [Any]) throws {
        for (index, parameter) in parameters.enumerated() {
            let bindIndex = Int32(index + 1)
            
            if let value = parameter as? Int {
                sqlite3_bind_int64(statement, bindIndex, Int64(value))
            } else if let value = parameter as? Int64 {
                sqlite3_bind_int64(statement, bindIndex, value)
            } else if let value = parameter as? Double {
                sqlite3_bind_double(statement, bindIndex, value)
            } else if let value = parameter as? String {
                sqlite3_bind_text(statement, bindIndex, value, -1, SQLITE_TRANSIENT)
            } else if let value = parameter as? Data {
                _ = value.withUnsafeBytes { bytes in
                    sqlite3_bind_blob(statement, bindIndex, bytes.baseAddress, Int32(value.count), SQLITE_TRANSIENT)
                }
            } else if parameter is NSNull {
                sqlite3_bind_null(statement, bindIndex)
            } else {
                // For other types, try string conversion or bind null
                sqlite3_bind_text(statement, bindIndex, "\(parameter)", -1, SQLITE_TRANSIENT)
            }
        }
    }
    
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    func lastInsertId() -> Int64 {
        return sqlite3_last_insert_rowid(db)
    }
    
    func beginTransaction() throws {
        try execute(sql: "BEGIN TRANSACTION")
    }
    
    func commitTransaction() throws {
        try execute(sql: "COMMIT")
    }
    
    func rollbackTransaction() throws {
        try execute(sql: "ROLLBACK")
    }
}

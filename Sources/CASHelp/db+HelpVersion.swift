/*-------------------------------------------------------------------------------------------------------------------------
     File: db+HelpVersion.swift
   Author: Kevin Messina
  Created: 9/11/25
 Modified: 08/23/2026 09:55 AM EDT
  Version: 4
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.

©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import GRDB
import CASExternalFoundations

public struct HelpVersion: Codable, Equatable, Hashable, Identifiable, FetchableRecord, MutablePersistableRecord {
    public var id: Int64?
    public var version: Int = 0
    
    public static let databaseTableName = "Version"
    public var dbTableName: String { Self.databaseTableName }
    
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let version = Column(CodingKeys.version)
    }
    
    public init(
        id: Int64? = nil,
        version: Int = 0
    ) {
        self.id = id
        self.version = version
    }
    
    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    // MARK: - *** DB Functions ***
    public func getFromID(
        _ id: Int64,
        dbQueue: DatabaseQueue,
        logLFFL: String
    ) -> HelpVersion {
        var rec: HelpVersion = HelpVersion()
        
        do {
            try dbQueue.read { dbTable in
                try rec = HelpVersion.fetchOne(dbTable, id: id) ?? HelpVersion()
            }
            
            SimPrint.Info("HELP VERSION: Fetched record ID: \(id) from \(dbTableName).", action: .success, log: logLFFL)
        } catch {
            SimPrint.Info("HELP VERSION: Fetch failed for \(dbTableName).", action: .error, errorMsg: error.localizedDescription, log: logLFFL)
        }
        
        return rec
    }
    
    public func getLatestVersion(
        dbQueue: DatabaseQueue,
        logLFFL: String
    ) -> Double {
        var rec: HelpVersion = HelpVersion()
        
        do {
            try dbQueue.read { dbTable in
                try rec = HelpVersion.fetchOne(dbTable) ?? HelpVersion()
            }
            
            SimPrint.Info("HELP VERSION: Fetched latest version from \(dbTableName).", action: .success, log: logLFFL)
        } catch {
            SimPrint.Info("HELP VERSION: Fetch latest failed for \(dbTableName).", action: .error, errorMsg: error.localizedDescription, log: logLFFL)
        }
        
        return Double(rec.version)
    }
    
    public func getAll(
        dbQueue: DatabaseQueue,
        logLFFL: String
    ) -> [HelpVersion] {
        var recs: [HelpVersion] = []
        
        do {
            try dbQueue.read { dbTable in
                try recs = HelpVersion.order(Columns.version.asc).fetchAll(dbTable)
            }
            
            SimPrint.Info("HELP VERSION: Fetched \(recs.count) records from \(dbTableName).", action: .success, log: logLFFL)
        } catch {
            SimPrint.Info("HELP VERSION: Fetch all failed for \(dbTableName).", action: .error, errorMsg: error.localizedDescription, log: logLFFL)
        }
        
        return recs
    }
    
    @discardableResult
    public func saveUpdate(
        _ item: HelpVersion,
        dbQueue: DatabaseQueue,
        logLFFL: String
    ) -> Bool {
        do {
            try dbQueue.write { dbTable in
                try item.update(dbTable)
            }
            
            SimPrint.Info("HELP VERSION: Updated record in \(dbTableName).", action: .success, log: logLFFL)
        } catch {
            SimPrint.Info("HELP VERSION: Update failed for \(dbTableName).", action: .error, errorMsg: error.localizedDescription, log: logLFFL)
            return false
        }
        
        return true
    }
    
    @discardableResult
    public func delete(
        id: Int64,
        dbQueue: DatabaseQueue,
        logLFFL: String
    ) -> Bool {
        do {
            try dbQueue.write { dbTable in
                try HelpVersion.deleteOne(dbTable, id: id)
            }
            
            SimPrint.Info("HELP VERSION: Deleted record ID: \(id) from \(dbTableName).", action: .success, log: logLFFL)
        } catch {
            SimPrint.Info("HELP VERSION: Delete failed for \(dbTableName).", action: .error, errorMsg: error.localizedDescription, log: logLFFL)
            return false
        }
        
        return true
    }
    
    @discardableResult
    public func addNew(
        _ item: HelpVersion,
        dbQueue: DatabaseQueue,
        logLFFL: String
    ) -> (success: Bool, id: Int64) {
        var newItem = item
        var newID: Int64 = -1
        
        do {
            try dbQueue.write { dbTable in
                try newItem.insert(dbTable)
                newID = dbTable.lastInsertedRowID
            }
            
            SimPrint.Info("HELP VERSION: Inserted record ID: \(newID) into \(dbTableName).", action: .success, log: logLFFL)
        } catch {
            SimPrint.Info("HELP VERSION: Insert failed for \(dbTableName).", action: .error, errorMsg: error.localizedDescription, log: logLFFL)
            return (success: false, id: -1)
        }
        
        return (success: true, id: newID)
    }
}

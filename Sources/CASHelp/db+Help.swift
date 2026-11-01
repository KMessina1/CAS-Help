/*-------------------------------------------------------------------------------------------------------------------------
     File: db+Help.swift
   Author: Kevin Messina
  Created: 6/9/24
 Modified: 11/01/2026 11:54 AM EST
  Version: 2
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.

©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import GRDB

///Usage:
///do {
///    try db.Queue().Queue_Help.read { dbTable in
///        let all = try Help.fetchAll(dbTable)
///        let oneDraft = try Help.fetchOne(dbTable)
///        let tenDrafts = try Help.limit(10).fetchAll(dbTable)
///        let draftsCount = try Help.fetchCount(dbTable)
///    }
///} catch {
///    print("\(error)")
///}
struct HelpItem: Codable, Equatable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var section: String
    var sortOrder: Int
    var title: String
    var subTitle: String
    var detail: String
    var notes: String

    static let databaseTableName = "Help"
    var dbTableName: String { Self.databaseTableName }

    internal enum Columns {
        static let id = Column(CodingKeys.id)
        static let section = Column(CodingKeys.section)
        static let sortOder = Column(CodingKeys.sortOrder)
        static let title = Column(CodingKeys.title)
        static let subTitle = Column(CodingKeys.subTitle)
        static let detail = Column(CodingKeys.detail)
        static let notes = Column(CodingKeys.notes)
    }
    
    static func ordered(_ items: [HelpItem]) -> [HelpItem] {
        items.sorted {
            if $0.title != $1.title { return $0.title < $1.title }
            if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
            return ($0.id ?? Int64.max) < ($1.id ?? Int64.max)
        }
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

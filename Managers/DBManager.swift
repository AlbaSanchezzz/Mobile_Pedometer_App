import Foundation
import SQLite

/// Singleton to manage SQLite DB of step records
class DBManager {
    static let shared = DBManager()
    private let db: Connection
    private let stepsTable = Table("steps")
    private let id = Expression<Int64>("id")
    private let count = Expression<Int>("count")
    private let timestamp = Expression<Date>("timestamp")

    private init() {
        // Create or open the DB in Documents folder
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: true)
            .appendingPathComponent("steps.sqlite3")
        db = try! Connection(fileURL.path)
        
        // Create table if not exists
        try! db.run(stepsTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(count)
            t.column(timestamp)
        })
    }

    /// Insert a new step record
    func insertStep(count: Int, timestamp: Date = Date()) {
        let insert = stepsTable.insert(self.count <- count, self.timestamp <- timestamp)
        do {
            try db.run(insert)
            print("✅ Saved step record: \(count) at \(timestamp)")
        } catch {
            print("❌ DB insert error:", error)
        }
    }

    /// Fetch all step records
    func fetchAllSteps() -> [ (count: Int, date: Date) ] {
        do {
            return try db.prepare(stepsTable).map { row in
                (row[count], row[timestamp])
            }
        } catch {
            print("❌ DB fetch error:", error)
            return []
        }
    }
}

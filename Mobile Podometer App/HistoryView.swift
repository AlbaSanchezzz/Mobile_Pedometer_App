import SwiftUI

/// Displays all saved step records from SQLite
struct HistoryView: View {
    @State private var records: [(count: Int, date: Date)] = []

    var body: some View {
        List(records, id: \.date) { record in
            HStack {
                Text("\(record.count) steps")
                Spacer()
                Text(record.date, style: .time)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Step History")
        .onAppear {
            // Fetch from SQLite when this view appears
            records = DBManager.shared.fetchAllSteps()
        }
    }
}

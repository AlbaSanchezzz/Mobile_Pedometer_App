import SwiftUI
import Charts

enum Aggregation: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    var id: String { rawValue }
}

struct StepChartView: View {
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: .now)!
    @State private var endDate: Date = .now
    @State private var aggregation: Aggregation = .daily
    @State private var data: [(label: String, count: Int)] = []

    var body: some View {
        VStack {
            // Date range pickers
            HStack {
                DatePicker("From", selection: $startDate, displayedComponents: .date)
                DatePicker("To",   selection: $endDate, displayedComponents: .date)
            }
            .padding(.horizontal)

            // Aggregation picker
            Picker("View", selection: $aggregation) {
                ForEach(Aggregation.allCases) { agg in
                    Text(agg.rawValue).tag(agg)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            // Chart
            Chart(data, id: \.label) { item in
                BarMark(
                    x: .value("Period", item.label),
                    y: .value("Steps", item.count)
                )
            }
            .chartXAxisLabel(aggregation.rawValue)
            .frame(height: 300)
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Steps Chart")
        .onAppear(perform: loadData)
        .onChange(of: startDate) { _ in loadData() }
        .onChange(of: endDate)   { _ in loadData() }
        .onChange(of: aggregation) { _ in loadData() }
    }

    private func loadData() {
        // Fetch raw records from SQLite
        let raw = DBManager.shared.fetchAllSteps()
            .filter { $0.date >= startDate && $0.date <= endDate }

        // Group depending on aggregation
        let calendar = Calendar.current
        let grouped: [Date: Int] = Dictionary(
            grouping: raw,
            by: { rec in
                switch aggregation {
                case .daily:
                    return calendar.startOfDay(for: rec.date)
                case .weekly:
                    return calendar.date(
                        from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: rec.date)
                    )!
                case .monthly:
                    return calendar.date(
                        from: calendar.dateComponents([.year, .month], from: rec.date)
                    )!
                }
            }
        )
        .mapValues { list in list.last!.count }  // use the last count for each period

        // Sort and format for display
        data = grouped
            .sorted { $0.key < $1.key }
            .map { (date, count) in
                let formatter = DateFormatter()
                switch aggregation {
                case .daily:
                    formatter.dateFormat = "MMM d"
                case .weekly:
                    formatter.dateFormat = "'W'w yyyy"
                case .monthly:
                    formatter.dateFormat = "MMM yyyy"
                }
                return (formatter.string(from: date), count)
            }
    }
}

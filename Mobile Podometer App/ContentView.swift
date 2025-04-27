import SwiftUI
import MessageUI

struct ContentView: View {
    @EnvironmentObject var pedometerManager: PedometerManager
    @State private var phoneNumber = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title and step count
                Text("Step Counter")
                    .font(.largeTitle)
                    .padding(.top)

                Text("\(pedometerManager.steps)")
                    .font(.system(size: 48, weight: .bold))
                    .padding()

                // Reset button
                Button("Reset Count") {
                    pedometerManager.resetSteps()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)

                Divider().padding(.vertical)

                // Phone number input
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Send SMS button
                Button("Send Steps via SMS") {
                    let messageBody = "I have taken \(pedometerManager.steps) steps so far!"
                    if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                        MessagingManager.shared.sendSMS(
                            withBody: messageBody,
                            recipients: [phoneNumber],
                            from: rootVC
                        )
                    }
                }
                .disabled(phoneNumber.isEmpty)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)

                // Print DB History button
                Button("Print DB History") {
                    let history = DBManager.shared.fetchAllSteps()
                    history.forEach { record in
                        print("Step: \(record.count) @ \(record.date)")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

                // Navigate to on-screen history list
                NavigationLink("Show Step History", destination: HistoryView())
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(8)

                // Navigate to chart view
                NavigationLink("Show Steps Chart", destination: StepChartView())
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(8)

                Spacer()
            }
            .padding()
            .navigationTitle("Step Counter")
        }
    }
}


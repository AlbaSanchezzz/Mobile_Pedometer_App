import SwiftUI

/// Main view showing step count and a reset button
struct ContentView: View {
    @EnvironmentObject var pedometerManager: PedometerManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Step Counter")
                .font(.largeTitle)
                .padding(.top)

            Text("\(pedometerManager.steps)")
                .font(.system(size: 48, weight: .bold))
                .padding()

            Button("Reset Count") {
                pedometerManager.resetSteps()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
    }
}


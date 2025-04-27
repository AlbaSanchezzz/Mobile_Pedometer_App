import Foundation
import CoreMotion
import Combine

/// Manages real and simulated step counting, and persists reads into SQLite
class PedometerManager: ObservableObject {
    private let pedometer = CMPedometer()
    private var timer: Timer?                // holds the simulation timer
    @Published var steps: Int = 0

    /// Starts pedometer or simulated updates
    func startUpdates() {
        #if targetEnvironment(simulator)
        print("Simulator: starting fake step timer")
        // Invalidate any existing timer first
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.steps += 1
                print("Simulated step count:", self.steps)
                // Persist simulated count if you like:
                DBManager.shared.insertStep(count: self.steps)
            }
        }
        #else
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting NOT available on this device")
            return
        }
        print("▶️ Starting real CMPedometer updates…")
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            if let error = error {
                print("Pedometer error:", error.localizedDescription)
                return
            }
            guard let self = self, let data = data else {
                print("No data received in handler")
                return
            }
            let newCount = data.numberOfSteps.intValue
            DispatchQueue.main.async {
                self.steps = newCount
                print("New step count:", newCount)
                // Persist the real count
                DBManager.shared.insertStep(count: newCount)
            }
        }
        #endif
    }

    /// Stops pedometer or simulation timer
    func stopUpdates() {
        #if targetEnvironment(simulator)
        print("Simulator: invalidating fake timer")
        timer?.invalidate()
        timer = nil
        #else
        pedometer.stopUpdates()
        #endif
    }

    /// Resets the step count to zero and restarts updates
    func resetSteps() {
        DispatchQueue.main.async { self.steps = 0 }
        stopUpdates()
        startUpdates()
    }
}

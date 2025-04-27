import SwiftUI
import CoreMotion
import Charts


@main
struct StepCounterApp: App {
    @StateObject private var pedometerManager = PedometerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pedometerManager)
                .onAppear {
                    //Print current Motion & Fitness authorization status
                    let authStatus = CMMotionActivityManager.authorizationStatus()
                    print("Motion authorization status is:", authStatus.rawValue)
                    
                    //Start pedometer updates
                    pedometerManager.startUpdates()
                }
                .onDisappear {
                    pedometerManager.stopUpdates()
                }
        }
    }
}


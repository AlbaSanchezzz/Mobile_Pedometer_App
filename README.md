# StepCounterApp

**StepCounterApp** is an iOS app that uses the device’s motion sensors to count your steps, stores them locally in SQLite, and lets you visualize your walking history in interactive charts.
You can also export your step count via SMS.


## 🚀 Features

- **Real‐time step counting** with `CMPedometer` (or simulated +1/sec in Simulator)  
- **Local storage** in SQLite via [SQLite.swift]  
- **History list** of all recordings  
- **Interactive Charts** powered by Apple’s [Charts] framework  
  - Filter by **date range**  
  - Switch between **Daily**, **Weekly** or **Monthly** views  
- **Export via SMS** to any phone number  


## 📦 Installation

1. Clone the repo  
   ```bash
   git clone https://github.com/<tuUsuario>/StepCounterApp.git
   cd StepCounterApp  
2. Open StepCounterApp.xcodeproj in Xcode 14+.
3. Under **File → Swift Packages → Add Package Dependency…**, ensure SQLite.swift and Charts are added.
4. Select your development team under **Signing & Capabilities**.
5. Build & run on a **real device** (to enable CMPedometer and SMS).
   

## 📖 Usage

1. On first launch, accept the **Motion & Fitness** permission.
2. **Step Counter** tab shows your live step count and **Reset** button.
3. **History** tab lists every saved reading.
4. **Chart** tab lets you pick a date range and aggregation.
5. **SMS** section sends your current count to any number.


## 🛠 Architecture

- `PedometerManager` (ObservableObject) → handles motion updates & publishes `steps`.
- `DBManager` (singleton) → wraps SQLite, stores & retrieves `(count, timestamp)`` records.
- `ContentView` → main UI, SMS export, navigation.
- `HistoryView` → SwiftUI `List` of all records.
- `StepChartView` → `Charts`‐based visualization with filters.
- `MessagingManager` → wraps `MFMessageComposeViewController` for SMS.


 ## 📄 License

MIT © Alba Sánchez Santiago

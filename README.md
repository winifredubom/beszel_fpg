# Beszel FPG

A Flutter-based server monitoring dashboard application that connects to [Beszel](https://github.com/henrygd/beszel) - a lightweight server monitoring hub. This mobile/desktop client provides real-time monitoring of your servers with a beautiful Cupertino-styled interface.

## 📱 Screenshots

*Coming soon*

## ✨ Features

### Dashboard & Monitoring
- **Real-time Server Monitoring** - Live updates via SSE (Server-Sent Events) from PocketBase backend
- **System Metrics Display** - CPU usage, memory, disk, GPU, network bandwidth, and temperature
- **Server Status Indicators** - Visual online/offline status with color-coded badges
- **Docker Container Stats** - Monitor container CPU and memory usage with charts

### User Experience
- **Responsive Design** - Adaptive layouts for mobile, tablet, and desktop (1/2/3 column grids)
- **Dark/Light Theme** - Full theme support with system preference detection
- **Multi-language Support** - Internationalization with locale management.   **Coming Soon**
- **Pull-to-Refresh** - Swipe down to reconnect and refresh data
- **Swipe Navigation** - Gesture-based navigation between screens

### Server Management
- **Pin Servers** - Pin important servers to the top of the list (persisted locally)
- **Sort & Filter** - Sort by name, status, CPU, memory, disk; filter by search text
- **View Options** - Toggle visible metrics (CPU, memory, disk, GPU, network, temperature)
- **Detailed System View** - Tap any server for detailed stats with historical charts

### Charts & Visualization
- **Time-Series Charts** - CPU, memory, disk, bandwidth, and disk I/O over time
- **Container Charts** - Docker container resource usage visualization
- **Configurable Time Periods** - View stats for different time ranges

### Authentication
- **PocketBase Auth** - Secure login with email/password
- **Persistent Sessions** - Stay logged in across app restarts
- **Forgot Password** - Password recovery support

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core utilities & configuration
│   ├── config/                  # App configuration
│   ├── constants/               # App constants & dimensions
│   ├── language/                # Localization manager
│   ├── navigation/              # GoRouter setup
│   ├── network/                 # API clients & realtime service
│   ├── storage/                 # Local storage (Hive)
│   ├── theme/                   # Theme configuration
│   └── utils/                   # Helpers & responsive utilities
├── features/                    # Feature modules
│   ├── authentication/          # Login, forgot password
│   └── dashboard/               # Main dashboard & system details
│       ├── data/                # Models, providers, services
│       └── presentation/        # Pages & widgets
└── shared/                      # Shared components & widgets
```

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.8+ |
| **UI Style** | Cupertino (iOS-style) |
| **State Management** | Riverpod |
| **Navigation** | GoRouter |
| **Local Storage** | Hive, SharedPreferences |
| **Networking** | Dio, PocketBase SDK |
| **Charts** | FL Chart |
| **Backend** | PocketBase (Beszel) |

## 📦 Dependencies

```yaml
# Core
flutter_riverpod: ^3.0.3
go_router: ^13.2.0
dio: ^5.9.0
pocketbase: ^0.23.0+1

# Storage
hive: ^2.2.3
hive_flutter: ^1.1.0
shared_preferences: ^2.2.2

# UI
cupertino_icons: ^1.0.8
fl_chart: ^0.69.0

# Utilities
intl: ^0.20.2
url_launcher: ^6.2.5
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.8.1
- Dart SDK ^3.8.1
- A running [Beszel](https://github.com/henrygd/beszel) server instance

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd beszel_fpg
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure the backend URL**
   
   Update the PocketBase URL in `lib/core/network/pocketbase_provider.dart`:
   ```dart
   final pb = PocketBase('https://your-beszel-server.com');
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# macOS
flutter build macos --release
```

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Android | ✅ Supported |
| iOS | ✅ Supported |
| Web | ✅ Supported |
| macOS | ✅ Supported |
| Windows | ✅ Supported |
| Linux | ✅ Supported |

## 🔧 Configuration

### Environment Setup

The app connects to a Beszel/PocketBase backend. Make sure your server is:
- Running and accessible
- Has the `systems` collection with realtime enabled
- Has proper CORS settings for your client origin

### Responsive Breakpoints

| Device | Width | Grid Columns |
|--------|-------|--------------|
| Mobile | < 600px | 1 |
| Tablet | 600-900px | 2 |
| Desktop | > 900px | 3 |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Beszel](https://github.com/henrygd/beszel) - The lightweight server monitoring hub this app connects to
- [PocketBase](https://pocketbase.io/) - The backend powering Beszel
- [Flutter](https://flutter.dev/) - The UI framework

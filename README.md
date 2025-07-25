# Yuyutsu

> A modern, multi-platform e-reader application built with Flutter, featuring cross-platform database synchronization and responsive design.

[![build-test-deploy](https://github.com/manastalukdar/yuyutsu/actions/workflows/main.yml/badge.svg)](https://github.com/manastalukdar/yuyutsu/actions/workflows/main.yml)
[![Lint Code Base](https://github.com/manastalukdar/yuyutsu/actions/workflows/linter.yml/badge.svg)](https://github.com/manastalukdar/yuyutsu/actions/workflows/linter.yml)
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/github/license/manastalukdar/yuyutsu)
![GitHub repo size](https://img.shields.io/github/repo-size/manastalukdar/yuyutsu)

## 🚀 Features

### ✅ **Current Capabilities**

- **Multi-Platform Support**: Native apps for iOS, Android, macOS, and Web
- **Cross-Platform Database**: Drift-powered SQLite with web IndexedDB fallback
- **Responsive Design**: Adaptive layouts for mobile, tablet, and desktop
- **Modern Architecture**: Clean architecture with Riverpod state management
- **Platform-Specific Services**: Conditional file handling and permissions
- **Material Design 3**: Beautiful, consistent UI across all platforms

### 🚧 **In Development**

- **Multi-Format Support**: EPUB, PDF, TXT, and MOBI readers
- **Reading Progress**: Bookmarks, highlights, and reading statistics
- **Cloud Integration**: Google Drive synchronization
- **Search & Organization**: Full-text search and library management

### 📋 **Planned Features**

- **Advanced Reading**: Text-to-speech, customizable themes, font options
- **Cross-Device Sync**: Reading progress synchronization across devices
- **Offline Reading**: Complete offline functionality
- **Accessibility**: Screen reader support and keyboard navigation

## 🏗️ Architecture

```
yuyutsu/
├── app/                      # Multi-platform Flutter e-reader
│   ├── lib/
│   │   ├── core/             # Constants, themes, utilities
│   │   ├── data/             # Models, database, services
│   │   │   ├── database/     # Drift database with DAOs
│   │   │   ├── models/       # Data models (Book, Bookmark, etc.)
│   │   │   └── services/     # Platform-specific services
│   │   └── presentation/     # UI screens, widgets, providers
│   ├── android/              # Android platform files
│   ├── ios/                  # iOS platform files
│   ├── macos/                # macOS platform files
│   ├── web/                  # Web platform files
│   └── test/                 # Unit and widget tests
├── website/                  # Node.js web application
└── documentation/            # Comprehensive project docs
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.32.7+
- **Language**: Dart 3.8.1+
- **Database**: Drift (cross-platform SQLite)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **E-Reader Engines**: epub_view, Syncfusion PDF
- **Platform Services**: Conditional imports for IO/Web
- **Responsive Design**: ScreenUtil

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK** (3.32.7 or later)
- **Platform-specific tools**:
  - **macOS**: Xcode for iOS/macOS builds
  - **Android**: Android Studio or Android SDK
  - **Web**: Chrome for debugging

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/manastalukdar/yuyutsu.git
   cd yuyutsu
   ```

2. **Set up Git submodules**:

   ```bash
   make git
   ```

3. **Navigate to the Flutter app**:

   ```bash
   cd app
   ```

4. **Install dependencies**:

   ```bash
   flutter pub get
   ```

5. **Generate database code**:

   ```bash
   dart run build_runner build
   ```

### Platform Setup

**Enable desktop and web platforms**:

```bash
flutter config --enable-macos-desktop
flutter config --enable-web
flutter config --enable-windows-desktop
flutter config --enable-linux-desktop
```

### Running the App

```bash
# Mobile (iOS/Android)
flutter run

# Desktop
flutter run -d macos           # macOS
flutter run -d windows         # Windows
flutter run -d linux           # Linux

# Web
flutter run -d chrome          # Chrome browser
flutter run -d web-server      # Local web server
```

### Building for Release

```bash
# Mobile
flutter build apk             # Android APK
flutter build ios             # iOS (requires macOS)

# Desktop
flutter build macos           # macOS app bundle
flutter build windows         # Windows executable
flutter build linux           # Linux executable

# Web
flutter build web             # Progressive Web App
```

## 🎯 Platform Support

| Platform    | Status    | Database  | File Access  | Features              |
| ----------- | --------- | --------- | ------------ | --------------------- |
| **Android** | ✅ Ready   | SQLite    | Native FS    | Full functionality    |
| **iOS**     | ✅ Ready   | SQLite    | Native FS    | Full functionality    |
| **macOS**   | ✅ Ready   | SQLite    | Native FS    | Desktop optimizations |
| **Web**     | ✅ Working | IndexedDB | LocalStorage | Cloud storage focus   |
| **Windows** | 🚧 Ready   | SQLite    | Native FS    | Awaiting testing      |
| **Linux**   | 🚧 Ready   | SQLite    | Native FS    | Awaiting testing      |

## 🏛️ Project Structure

### Core Components

- **`lib/core/`**: Application constants, themes, and utilities
- **`lib/data/`**: Data layer with models, database, and services
  - **`database/`**: Drift database with platform-specific connections
  - **`services/`**: Platform-aware file and permission handling
- **`lib/presentation/`**: UI layer with screens, widgets, and state management

### Platform-Specific Features

- **Mobile**: Touch gestures, bottom navigation, full-screen reading
- **Desktop**: Menu integration, keyboard shortcuts, multi-column text
- **Web**: Responsive grids, browser storage, Progressive Web App

### Database Architecture

The app uses **Drift** for cross-platform database support:
- **Mobile/Desktop**: SQLite with native file system
- **Web**: IndexedDB with browser storage fallback
- **Features**: Type-safe queries, migrations, real-time updates

## 📚 Documentation

| Document                                                           | Description                    |
| ------------------------------------------------------------------ | ------------------------------ |
| [CLAUDE.md](./CLAUDE.md)                                           | AI development assistant guide |
| [Installation](./documentation/product/installation.md)            | Detailed setup instructions    |
| [Architecture](./documentation/development/design-architecture.md) | System design and patterns     |
| [Development](./documentation/development/development.md)          | Developer workflow             |
| [Testing](./documentation/development/testing.md)                  | Testing strategies             |
| [CI/CD](./documentation/development/ci-cd.md)                      | Build and deployment           |

## 🤝 Contributing

We welcome contributions! This project follows clean architecture principles and modern Flutter best practices.

### Development Workflow

1. Check the [development documentation](./documentation/development/)
2. Follow the [contributing guidelines](.github/CONTRIBUTING.md)
3. Use the provided [CLAUDE.md](./CLAUDE.md) for AI-assisted development
4. Run tests and ensure builds pass on all platforms

### Key Development Commands

```bash
# Code generation (after model changes)
flutter packages pub run build_runner build

# Clean builds (when switching platforms)
flutter clean && flutter pub get

# Analysis and linting
flutter analyze
flutter test
```

## 📊 Project Status

**Overall Progress**: 🚧 In Active Development

- ✅ **Foundation**: Multi-platform setup, architecture, database
- 🚧 **Core Features**: E-reader engines, file management
- 📋 **Advanced Features**: Cloud sync, advanced reading features

## 🔗 Links

- **Project Management**: [GitHub Projects](https://github.com/manastalukdar/yuyutsu/projects)
- **Code Analysis**: [Sourcegraph](https://sourcegraph.com/github.com/manastalukdar/yuyutsu/)
- **Build Status**: [GitHub Actions](https://github.com/manastalukdar/yuyutsu/actions)

## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev) for cross-platform development
- Database powered by [Drift](https://drift.simonbinder.eu/) for type-safe SQL
- E-reader functionality from [epub_view](https://pub.dev/packages/epub_view) and [Syncfusion](https://pub.dev/packages/syncfusion_flutter_pdf)
- State management with [Riverpod](https://riverpod.dev/)

---

**Made with ❤️ for book lovers everywhere**

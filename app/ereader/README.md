# Yuyutsu E-Reader

A cross-platform e-reader application built with Flutter, supporting Windows, Mac, Linux, Android, and iOS.

## Features

### Current Implementation
- **Multi-platform Support**: Single codebase for all 5 platforms
- **Responsive Design**: Adaptive layouts for mobile, tablet, and desktop
- **Modern UI**: Material Design 3 with dark/light themes
- **Book Library**: Grid and list views with progress tracking
- **Reading Interface**: Full-screen reader with controls
- **Settings**: Comprehensive customization options

### Supported Formats (Planned)
- EPUB
- PDF  
- TXT
- MOBI

## Architecture

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── constants/           # App constants and configuration
│   ├── theme/              # Theme definitions
│   └── utils/              # Utility functions
├── data/
│   ├── models/             # Data models (Book, Bookmark, etc.)
│   ├── repositories/       # Data access layer
│   └── services/          # External services
└── presentation/
    ├── screens/           # UI screens
    ├── widgets/           # Reusable widgets
    └── providers/         # State management
```

## Key Dependencies

- **flutter_riverpod**: State management
- **go_router**: Navigation
- **epub_view**: EPUB reading support
- **syncfusion_flutter_pdf**: PDF viewing
- **flutter_screenutil**: Responsive design
- **shared_preferences**: Local storage
- **sqflite**: Database for bookmarks/progress

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Platform-specific development tools

### Installation
1. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. Run on desired platform:
   ```bash
   # Mobile
   flutter run
   
   # Desktop
   flutter run -d macos
   flutter run -d windows  
   flutter run -d linux
   
   # Web
   flutter run -d chrome
   ```

## Platform-Specific Features

### Mobile (iOS/Android)
- Touch gestures for page navigation
- Bottom navigation bar
- Full-screen reading mode

### Tablet
- Side navigation drawer
- Two-pane layouts
- Floating action buttons

### Desktop (Windows/Mac/Linux)
- Menu bar integration
- Keyboard shortcuts
- Multi-column text display
- Mouse interactions

### Web
- Responsive grid layouts
- Browser-optimized controls

## Development Status

✅ **Completed**:
- Project structure setup
- Basic navigation system
- Responsive UI framework
- Core data models
- Settings screen
- Library grid/list views

🚧 **In Progress**:
- EPUB/PDF integration
- File picker implementation
- Database setup
- Reading progress tracking

📋 **Planned**:
- Book import/export
- Bookmarks and highlights
- Text search functionality
- Cross-device sync
- Accessibility features

## Contributing

This is part of the Yuyutsu project. See the main repository documentation for contribution guidelines.

## License

MIT License - see main repository for details.
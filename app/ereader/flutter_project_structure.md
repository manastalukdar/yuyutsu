# Flutter E-Reader Project Structure

## Recommended Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # E-reader packages
  epub_view: ^3.0.0  # Pure Flutter EPUB reader
  syncfusion_flutter_pdf: ^24.0.0  # Professional PDF viewer
  
  # State management
  flutter_riverpod: ^2.4.0  # or provider, bloc
  
  # Navigation
  go_router: ^12.0.0
  
  # Storage
  shared_preferences: ^2.2.0
  path_provider: ^2.1.0
  sqflite: ^2.3.0  # for bookmarks, reading progress
  
  # File handling
  file_picker: ^6.0.0
  permission_handler: ^11.0.0
  
  # UI
  flutter_screenutil: ^5.9.0  # responsive design
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## Project Structure

```
app/ereader/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── utils/
│   │   └── theme/
│   ├── data/
│   │   ├── models/
│   │   │   ├── book.dart
│   │   │   ├── reading_progress.dart
│   │   │   └── bookmark.dart
│   │   ├── repositories/
│   │   └── services/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── library/
│   │   │   ├── reader/
│   │   │   └── settings/
│   │   ├── widgets/
│   │   └── providers/
│   └── shared/  # Link to ../shared for cross-platform code
├── pubspec.yaml
├── android/
├── ios/
├── web/
├── windows/
├── macos/
└── linux/
```

## Key Features to Implement

### Core Reading Features

- Multi-format support (EPUB, PDF, TXT)
- Reading progress tracking
- Bookmarks and highlights
- Customizable themes (dark/light/sepia)
- Font size and family adjustment
- Page/scroll modes

### Library Management

- Book scanning and import
- Collections/categories
- Search functionality
- Reading statistics

### Cross-Platform Considerations

- Responsive design for different screen sizes
- Platform-specific file access patterns
- Shared preferences sync across devices (future)

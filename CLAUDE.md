# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Yuyutsu is a multi-platform project containing:

- **Flutter e-reader app** (`app/`) - Multi-platform e-reader supporting EPUB and PDF formats
  - **Mobile**: iOS and Android support
  - **Desktop**: macOS and Linux support (Windows ready)
  - **Web**: Browser-based e-reader with local storage
- **Website** (`website/`) - JavaScript/Node.js web application
- **Documentation** (`documentation/`) - Comprehensive project documentation
- **Template repository structure** with CI/CD workflows and development guidelines

## Development Commands

### Primary Build System

The project uses a **Makefile** as the primary build orchestrator:

```bash
# Run all build tasks (recommended for full project setup)
make all

# Individual components
make backend    # Backend development (WIP)
make cli        # CLI development (WIP) 
make frontend   # Frontend development (WIP)
make code       # All code tasks

# Git operations
make git                    # Setup git and submodules
make git-get-submodules    # Update submodules
make git-submodules-setup  # Initialize submodules
```

### Flutter E-reader App

Navigate to `app/` for Flutter development:

```bash
cd app/

# Install dependencies
flutter pub get

# Generate code (required for Drift database)
flutter packages pub run build_runner build

# Run the app (specify platform)
flutter run                    # Default (mobile/desktop)
flutter run -d chrome          # Web browser
flutter run -d macos           # macOS desktop
flutter run -d linux           # Linux desktop
flutter run -d ios             # iOS simulator
flutter run -d android         # Android emulator

# Build for release
flutter build apk              # Android
flutter build ios              # iOS (requires macOS)
flutter build macos            # macOS desktop app
flutter build linux            # Linux desktop app
flutter build web              # Web application

# Clean build (use when switching platforms)
flutter clean && flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Website Development

Navigate to `website/` for web development:

```bash
cd website/

# Install dependencies (inferred from package_json structure)
npm install

# Linting (based on ESLint configuration)
npm run lint    # or npx eslint .
```

## Architecture

### Flutter E-reader App Structure

- **State Management**: Flutter Riverpod for reactive state management
- **Navigation**: GoRouter for declarative routing
- **File Formats**: EPUB (epub_view) and PDF (Syncfusion) support
- **Database**: Drift for cross-platform SQL database (mobile, desktop, web)
- **Storage**: Platform-specific file handling with fallback to browser storage
- **Cloud Integration**: Google Drive API integration for cloud storage
- **Permissions**: Platform-aware permission handling
- **Responsive Design**: ScreenUtil for cross-device compatibility

Key directories:

- `lib/core/` - App constants, themes, utilities
- `lib/data/` - Models, repositories, services, database layer
  - `database/` - Drift database setup with DAOs
  - `services/` - Platform-specific file and permission services
- `lib/presentation/` - UI screens, widgets, and providers
- `assets/` - Sample books and images

**Platform-Specific Features:**
- **Mobile/Desktop**: File system access, native permissions
- **Web**: IndexedDB storage, LocalStorage for files, browser-based permissions

### Project Structure

```plaintext
app/                       # Multi-platform Flutter e-reader application
website/                   # Web application  
documentation/             # Project documentation
├── development/           # Development guides, CI/CD
├── product/              # Installation, usage guides
└── project/              # Project metadata
```

## Testing

- **Flutter**: Use `flutter test` in the e-reader directory
- **VSCode tasks**: Available for language-specific testing (via .vscode folder)
- **Makefile**: Provides test orchestration tasks
- **CI/CD**: GitHub Actions run comprehensive testing across platforms

## CI/CD Workflows

The project uses GitHub Actions with multiple workflows:

- **main.yml**: Multi-platform build/test/deploy (Ubuntu, macOS, Windows)
- **linter.yml**: Code quality checks using GitHub Super Linter
- **codeql-analysis.yml**: Security analysis
- **ossar-analysis.yml**: Security scanning

## Development Environment

- **Flutter SDK** (latest stable) with platform support enabled:
  - `flutter config --enable-macos-desktop`
  - `flutter config --enable-linux-desktop`
  - `flutter config --enable-web`
- **Platform Requirements:**
  - **macOS**: Xcode for iOS builds, Xcode Command Line Tools for macOS builds
  - **Linux**: CMake, Ninja build system, GTK development libraries
  - **Android**: Android Studio or Android SDK
  - **Web**: Chrome for debugging and testing
- **Java 16+** for Android builds
- **Python 3.9+** with requirements.txt dependencies
- **Node.js 15+** for web development
- **Git submodules** - Run `make git` to properly initialize

**Important Notes:**
- Run `flutter packages pub run build_runner build` after dependency changes
- Use `flutter clean` when switching between platforms
- Web builds require Chrome for optimal debugging experience

## File Organization

- Documentation follows a structured approach in `documentation/` with separate directories for development, product, and project concerns
- Mobile app follows Flutter best practices with clear separation of concerns
- Template repository structure provides consistent project organization patterns

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Yuyutsu is a multi-platform project containing:
- **Flutter mobile e-reader app** (`app/mobile/ereader/`) - Cross-platform e-reader supporting EPUB and PDF formats
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
Navigate to `app/mobile/ereader/` for Flutter development:

```bash
cd app/mobile/ereader/

# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for release
flutter build apk          # Android
flutter build ios          # iOS (requires macOS)

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
- **Storage**: SQLite (sqflite) for local data, SharedPreferences for settings
- **Cloud Integration**: Google Drive API integration for cloud storage
- **Responsive Design**: ScreenUtil for cross-device compatibility

Key directories:
- `lib/core/` - App constants, themes, utilities
- `lib/data/` - Models, repositories, services (file handling, cloud services)
- `lib/presentation/` - UI screens, widgets, and providers
- `assets/` - Sample books and images

### Project Structure
```
app/
├── mobile/ereader/        # Flutter e-reader application
└── shared/                # Shared components
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

- **Java 16+** for Android builds
- **Python 3.9+** with requirements.txt dependencies
- **Node.js 15+** for web development
- **Flutter SDK** for mobile development
- **Git submodules** - Run `make git` to properly initialize

## File Organization

- Documentation follows a structured approach in `documentation/` with separate directories for development, product, and project concerns
- Mobile app follows Flutter best practices with clear separation of concerns
- Template repository structure provides consistent project organization patterns
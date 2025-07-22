# Responsive UI Design Plan for Cross-Platform E-Reader

## Screen Size Categories

### Mobile (< 600dp)

- **Portrait Mode Primary**
- Single-pane layout
- Bottom navigation
- Collapsible panels

### Tablet (600-900dp)

- **Both orientations supported**
- Side navigation drawer
- Two-pane layouts (library + details)
- Floating action buttons

### Desktop (> 900dp)

- **Landscape Primary**
- Persistent navigation rail
- Multi-pane layouts
- Mouse/keyboard shortcuts
- Toolbar-based actions

## Adaptive Layouts

### Library Screen

```dart
// Mobile: List view
// Tablet: Grid view (2-3 columns)
// Desktop: Grid view (4-6 columns) + sidebar
```

### Reader Screen

```dart
// Mobile: Full screen, system UI overlay
// Tablet: Optional side panels for TOC/notes
// Desktop: Always-visible controls, multi-column text
```

### Settings Screen

```dart
// Mobile: Single column list
// Tablet: Two-column layout
// Desktop: Tabbed interface with panels
```

## Responsive Breakpoints

```dart
class ScreenBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}
```

## Flutter Implementation Strategy

### 1. LayoutBuilder + MediaQuery

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < ScreenBreakpoints.mobile) {
      return MobileLayout();
    } else if (constraints.maxWidth < ScreenBreakpoints.tablet) {
      return TabletLayout();  
    } else {
      return DesktopLayout();
    }
  }
)
```

### 2. Responsive Widgets

- `flutter_screenutil` for consistent sizing
- `Expanded`/`Flexible` for adaptive layouts
- `Wrap` for responsive grids
- `NavigationRail`/`BottomNavigationBar` switching

### 3. Platform-Specific Adaptations

```dart
// iOS: Cupertino design elements
// Android: Material design 3
// Desktop: Platform-native menus and shortcuts
// Web: Responsive grid layouts
```

## Key Considerations

### Reading Experience

- **Mobile**: Optimal for single-column text, page-flip gestures
- **Tablet**: Choice between single/dual column, good for PDFs  
- **Desktop**: Multi-column text support, precise cursor interactions

### Navigation Patterns

- **Mobile**: Bottom tabs, swipe gestures
- **Tablet**: Side drawer, long-press context menus
- **Desktop**: Menu bar, keyboard shortcuts, right-click menus

### Text Rendering

- Dynamic font scaling based on screen DPI
- Comfortable reading distances per device type
- Platform-appropriate font families

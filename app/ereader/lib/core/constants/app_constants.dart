class AppConstants {
  // App info
  static const String appName = 'Yuyutsu E-Reader';
  static const String appVersion = '1.0.0';
  
  // Supported file formats
  static const List<String> supportedFormats = [
    'epub',
    'pdf',
    'txt',
    'mobi',
  ];
  
  // Reading settings defaults
  static const double defaultFontSize = 16.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 32.0;
  
  static const String defaultFontFamily = 'System';
  static const List<String> availableFonts = [
    'System',
    'Serif',
    'Open Sans',
    'Roboto',
    'Merriweather',
  ];
  
  // Screen breakpoints for responsive design
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // Storage keys
  static const String storageKeyBooks = 'user_books';
  static const String storageKeyReadingProgress = 'reading_progress';
  static const String storageKeySettings = 'app_settings';
  static const String storageKeyBookmarks = 'bookmarks';
  
  // Database
  static const String databaseName = 'yuyutsu_ereader.db';
  static const int databaseVersion = 1;
}
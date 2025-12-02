# Theme System Documentation

## Overview
The Beszel app now features a complete dark/light theme switching system with persistent storage.

## Components

### 1. ThemeManager (`lib/core/theme/theme_manager.dart`)
- Singleton pattern for global theme management
- Automatic theme persistence using SharedPreferences
- Notifies listeners when theme changes
- Methods:
  - `toggleTheme()`: Switch between dark and light mode
  - `setTheme(bool isDark)`: Set specific theme mode
  - `isDarkMode`: Current theme state getter

### 2. AppTheme (`lib/core/theme/app_theme.dart`)
- Contains both light and dark Cupertino theme definitions
- Centralized color management through AppColors class
- Supports Material themes for compatibility

### 3. Theme Extensions (`lib/core/theme/theme_extensions.dart`)
- Extension on BuildContext for easy theme access
- Properties like `context.backgroundColor`, `context.textColor`, etc.
- Simplifies theme-dependent UI code

### 4. ThemeToggleButton (`lib/features/dashboard/presentation/widgets/theme_toggle_button.dart`)
- Reusable theme toggle widget
- Automatically updates icon based on current theme
- Can be customized with size, color, and padding

## Usage

### In main.dart
```dart
// Initialize theme manager in main()
await ThemeManager.instance.init();

// Use ListenableBuilder to rebuild app on theme changes
ListenableBuilder(
  listenable: ThemeManager.instance,
  builder: (context, child) {
    return CupertinoApp.router(
      theme: ThemeManager.instance.isDarkMode 
          ? AppTheme.darkCupertinoTheme 
          : AppTheme.lightCupertinoTheme,
      // ... other properties
    );
  },
);
```

### In UI Components
```dart
// Using theme extensions
Container(
  color: context.backgroundColor,
  child: Text(
    'Hello',
    style: TextStyle(color: context.textColor),
  ),
)

// Using theme toggle button
const ThemeToggleButton()

// Manual theme toggle
ThemeManager.instance.toggleTheme()
```

### In ListenableBuilder widgets
```dart
ListenableBuilder(
  listenable: ThemeManager.instance,
  builder: (context, child) {
    return Container(
      color: context.backgroundColor,
      child: widget,
    );
  },
)
```

## Navigation Bar Implementation
The dashboard navigation bar now includes:
- **Left**: "Beszel" title
- **Center**: Dark mode toggle, Settings icon, Person icon
- **Right**: Add button with primary color styling

All elements automatically adapt to the current theme with proper color changes.

## Theme Persistence
- Themes are automatically saved to device storage
- App remembers user's theme preference across sessions
- Default theme can be configured in `AppConfig.isDarkModeDefault`

## Color System
- `AppColors.backgroundLight/Dark`: Main background colors
- `AppColors.surfaceLight/Dark`: Card and surface colors  
- `AppColors.textPrimary/Dark`: Main text colors
- `AppColors.textSecondary/Dark`: Secondary text colors
- `AppColors.borderLight/Dark`: Border colors
- Status colors (success, warning, error) remain consistent across themes

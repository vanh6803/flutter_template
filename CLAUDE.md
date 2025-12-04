# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Generate assets (flutter_gen) and localization
flutter pub run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart
```

## Architecture Overview

This is a Flutter template project using **MVVM pattern** with Provider for state management and GetIt for dependency injection.

### Project Structure

```
lib/
├── app/              # App initialization (bootstrap, DI, MaterialApp)
├── core/             # Shared infrastructure
│   ├── base/         # BaseState, BaseDialog - widget lifecycle management
│   ├── navigation/   # NavigationManager singleton with transition system
│   ├── network/      # API client and auth helpers
│   ├── theme/        # AppTheme, AppColors, AppTypography
│   └── extensions/   # Dart extension methods
├── gen/              # Generated code (flutter_gen for assets)
├── generated/        # Generated localization code
├── l10n/             # Localization ARB files
└── src/
    ├── models/       # Data models
    ├── view_models/  # ViewModels for MVVM
    ├── screens/      # Feature screens
    └── widgets/      # Reusable widgets
```

### Key Patterns

**BaseState Widget System** (`lib/core/base/base_widget.dart`):
- Extend `BaseStatefulWidget` and `BaseState<T>` instead of raw StatefulWidget/State
- Use `onInitSync()` for init without context, `onReady()` for context-dependent logic after first frame
- Override `buildView(context)` instead of `build()`
- Built-in lifecycle hooks: `onResume`, `onPause`, `onDispose`, etc.
- Set `keepAlive => true` to preserve state in TabView/PageView

**Navigation System** (`lib/core/navigation/`):
- Use `NavigationManager.instance` singleton for all navigation
- Always connect `NavigationManager.instance.navigatorKey` to MaterialApp
- Supports 20+ transition types via `TransitionType` enum
- Methods: `navigateTo`, `navigateAndReplace`, `navigateAndClearAll`, `goBack`, `popToRoot`

**BaseDialog System** (`lib/core/base/base_dialog.dart`):
- Extend `BaseDialog<T>` for type-safe dialog results
- Call `show(context: context)` to display, `close(context, result)` to dismiss
- Supports blur barrier via `barrierBlurSigma`

**Dependency Injection**:
- `ServiceLocator.instance` wraps GetIt
- Register dependencies in `lib/app/service_locator.dart`
- Access via `ServiceLocator.instance.get<T>()`

### Asset Generation

Uses `flutter_gen` for type-safe asset access. After adding assets to `assets/` folders, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
Generated code appears in `lib/gen/assets.gen.dart`.

### Localization

Uses `flutter_intl` with ARB files in `lib/l10n/`. Add strings to `.arb` files and access via generated `S.of(context).key`.

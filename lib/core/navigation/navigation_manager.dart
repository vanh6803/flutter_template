import 'package:flutter/material.dart';

class NavigationManager {
  // Singleton instance
  static final NavigationManager instance = NavigationManager._internal();
  NavigationManager._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get context => navigatorKey.currentContext;

  // --- Navigation ---
  Future<T?> navigateTo<T>(Widget screen) {
    return navigatorKey.currentState!.push<T>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void goBack<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState!.pop<T>(result);
    }
  }

  Future<T?> navigateAndReplace<T>(Widget screen) {
    return navigatorKey.currentState!.pushReplacement<T, Object?>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<T?> navigateAndClearAll<T>(Widget screen) {
    return navigatorKey.currentState!.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => screen),
          (route) => false,
    );
  }

  // --- Dialog ---
  Future<T?> showCustomDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    if (context == null) return Future.value(null);

    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (_) => dialog,
    );
  }

  void dismissDialog([dynamic result]) {
    if (context != null && Navigator.of(context!).canPop()) {
      Navigator.of(context!).pop(result);
    }
  }

  // --- Bottom Sheet ---
  Future<T?> showBottomSheet<T>({
    required Widget content,
    bool isDismissible = true,
    bool enableDrag = true,
    double? elevation,
    ShapeBorder? shape,
    Color? backgroundColor,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
  }) {
    if (context == null) return Future.value(null);

    return showModalBottomSheet<T>(
      context: context!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      elevation: elevation,
      shape: shape,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      builder: (_) => content,
    );
  }

  PersistentBottomSheetController showPersistentBottomSheet({
    required Widget content,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
  }) {
    if (context == null) {
      throw Exception('Context is null, cannot show persistent bottom sheet');
    }

    return Scaffold.of(context!).showBottomSheet(
          (_) => content,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
    );
  }

  void dismissBottomSheet([dynamic result]) {
    if (context != null && Navigator.of(context!).canPop()) {
      Navigator.of(context!).pop(result);
    }
  }

  // --- Snackbar ---
  void showMessage(
      String message, {
        Duration duration = const Duration(seconds: 3),
        Color? backgroundColor,
        SnackBarAction? action,
      }) {
    if (context == null) return;

    ScaffoldMessenger.of(context!).hideCurrentSnackBar();
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }
}

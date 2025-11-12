import 'package:flutter/material.dart';
import 'transition_type.dart';
import 'route_builder.dart';

/// Quản lý điều hướng trong ứng dụng
///
/// Sử dụng pattern Singleton để đảm bảo chỉ có một instance duy nhất
/// quản lý navigation state trong toàn bộ ứng dụng.
class NavigationManager {
  // Singleton instance
  static final NavigationManager instance = NavigationManager._internal();
  NavigationManager._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get context => navigatorKey.currentContext;

  // ==================== NAVIGATION ====================

  /// Chuyển đến màn hình mới - giữ lại màn hình cũ trong stack
  ///
  /// Example:
  /// ```dart
  /// // Stack: [A] → navigateTo(B) → [A, B]
  /// NavigationManager.instance.navigateTo(ScreenB());
  ///
  /// // Với hiệu ứng transition
  /// NavigationManager.instance.navigateTo(
  ///   ScreenC(),
  ///   transition: TransitionType.slideUp,
  /// );
  /// ```
  Future<T?> navigateTo<T>(
    Widget screen, {
    TransitionType? transition,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final route = RouteBuilder.buildRoute<T>(screen, transition, duration);
    return navigatorKey.currentState!.push<T>(route);
  }

  /// Thay thế màn hình hiện tại bằng màn hình mới
  /// Màn hình cũ sẽ bị xóa khỏi stack
  ///
  /// Example:
  /// ```dart
  /// // Stack: [A, B, C] → navigateAndReplace(D) → [A, B, D]
  /// NavigationManager.instance.navigateAndReplace(ScreenD());
  ///
  /// // Với hiệu ứng transition
  /// NavigationManager.instance.navigateAndReplace(
  ///   ScreenD(),
  ///   transition: TransitionType.fade,
  /// );
  /// ```
  Future<T?> navigateAndReplace<T>(
    Widget screen, {
    TransitionType? transition,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final route = RouteBuilder.buildRoute<T>(screen, transition, duration);
    return navigatorKey.currentState!.pushReplacement<T, Object?>(route);
  }

  /// Xóa tất cả màn hình cũ và chuyển đến màn hình mới
  /// Thường dùng khi logout hoặc reset app
  ///
  /// Example:
  /// ```dart
  /// // Stack: [A, B, C, D] → navigateAndClearAll(Login) → [Login]
  /// NavigationManager.instance.navigateAndClearAll(LoginScreen());
  ///
  /// // Với hiệu ứng transition
  /// NavigationManager.instance.navigateAndClearAll(
  ///   LoginScreen(),
  ///   transition: TransitionType.fade,
  /// );
  /// ```
  Future<T?> navigateAndClearAll<T>(
    Widget screen, {
    TransitionType? transition,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final route = RouteBuilder.buildRoute<T>(screen, transition, duration);
    return navigatorKey.currentState!.pushAndRemoveUntil<T>(
      route,
      (route) => false,
    );
  }

  /// Chuyển màn hình mới và xóa màn hình cũ cho đến khi gặp điều kiện
  ///
  /// Example:
  /// ```dart
  /// // Stack: [A, B, C, D] → navigateAndRemoveUntil(E, isFirst) → [A, E]
  /// NavigationManager.instance.navigateAndRemoveUntil(
  ///   ScreenE(),
  ///   (route) => route.isFirst, // Giữ lại màn đầu tiên
  /// );
  ///
  /// // Với hiệu ứng transition
  /// NavigationManager.instance.navigateAndRemoveUntil(
  ///   ScreenE(),
  ///   (route) => route.isFirst,
  ///   transition: TransitionType.slideLeft,
  /// );
  /// ```
  Future<T?> navigateAndRemoveUntil<T>(
    Widget screen,
    bool Function(Route<dynamic>) predicate, {
    TransitionType? transition,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final route = RouteBuilder.buildRoute<T>(screen, transition, duration);
    return navigatorKey.currentState!.pushAndRemoveUntil<T>(route, predicate);
  }

  /// Quay lại màn hình trước đó
  /// Có thể trả về kết quả cho màn hình trước
  ///
  /// Example:
  /// ```dart
  /// // Stack: [A, B, C, D] → goBack() → [A, B, C]
  /// NavigationManager.instance.goBack();
  ///
  /// // Trả về kết quả cho màn trước
  /// NavigationManager.instance.goBack<String>('result_data');
  ///
  /// // Màn trước nhận kết quả:
  /// final result = await NavigationManager.instance.navigateTo<String>(ScreenD());
  /// print(result); // "result_data"
  /// ```
  void goBack<T>([T? result]) {
    if (canPop()) {
      navigatorKey.currentState!.pop<T>(result);
    }
  }

  /// Quay lại cho đến khi gặp điều kiện
  ///
  /// Example:
  /// ```dart
  /// // Stack: [A, B, C, D, E] → popUntil(isFirst) → [A]
  /// NavigationManager.instance.popUntil((route) => route.isFirst);
  ///
  /// // Pop đến khi gặp route có name cụ thể
  /// NavigationManager.instance.popUntil(
  ///   (route) => route.settings.name == '/home',
  /// );
  /// ```
  void popUntil(bool Function(Route<dynamic>) predicate) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  /// Quay về màn hình đầu tiên (root)
  ///
  /// Example:
  /// ```dart
  /// // Stack: [A, B, C, D, E] → popToRoot() → [A]
  /// NavigationManager.instance.popToRoot();
  /// ```
  void popToRoot() {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  /// Kiểm tra có thể quay lại màn hình trước không
  ///
  /// Example:
  /// ```dart
  /// // Stack: [A, B, C] → canPop() = true
  /// // Stack: [A] → canPop() = false
  ///
  /// if (NavigationManager.instance.canPop()) {
  ///   NavigationManager.instance.goBack();
  /// }
  /// ```
  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
}

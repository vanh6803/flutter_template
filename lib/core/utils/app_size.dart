import 'package:flutter/material.dart';
import '../navigation/navigation_manager.dart';

class AppSize {
  // Singleton instance
  static final AppSize instance = AppSize._internal();
  AppSize._internal();

  MediaQueryData? get _mediaQuery {
    final context = NavigationManager.instance.context;
    if (context == null) return null;
    return MediaQuery.of(context);
  }

  // ==================== SIZE ====================

  double get width => _mediaQuery?.size.width ?? 0;

  double get height => _mediaQuery?.size.height ?? 0;

  Size get size => _mediaQuery?.size ?? Size.zero;

  // ==================== PADDING ====================

  EdgeInsets get padding => _mediaQuery?.padding ?? EdgeInsets.zero;

  double get paddingTop => _mediaQuery?.padding.top ?? 0;

  double get paddingBottom => _mediaQuery?.padding.bottom ?? 0;

  // ==================== VIEW INSETS ====================

  EdgeInsets get viewInsets => _mediaQuery?.viewInsets ?? EdgeInsets.zero;

  double get keyboardHeight => _mediaQuery?.viewInsets.bottom ?? 0;

  bool get isKeyboardVisible => keyboardHeight > 0;

  // ==================== DEVICE INFO ====================

  double get devicePixelRatio => _mediaQuery?.devicePixelRatio ?? 1;

  double get textScaleFactor => _mediaQuery?.textScaler.scale(1) ?? 1;

  Orientation get orientation => _mediaQuery?.orientation ?? Orientation.portrait;

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  // ==================== STATIC METHODS ====================

  static double widthOf(BuildContext context) => MediaQuery.of(context).size.width;

  static double heightOf(BuildContext context) => MediaQuery.of(context).size.height;

  static Size sizeOf(BuildContext context) => MediaQuery.of(context).size;

  static EdgeInsets paddingOf(BuildContext context) =>
      MediaQuery.of(context).padding;
}

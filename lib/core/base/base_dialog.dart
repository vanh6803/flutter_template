import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

abstract class BaseDialog<T> {
  BaseDialog({
    this.barrierDismissible = true,
    this.barrierColor = const Color(0x80000000),
    this.barrierLabel,
    this.barrierBlurSigma,
    this.useRootNavigator = true,
    this.routeSettings,
    this.transitionDuration = const Duration(milliseconds: 200),
    this.reverseTransitionDuration = const Duration(milliseconds: 150),
    this.onCompleted,
    this.onPopped,
  });

  // ===== Config =====
  final bool barrierDismissible;
  final Color barrierColor;
  final String? barrierLabel;
  final double? barrierBlurSigma;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final VoidCallback? onCompleted;
  final void Function(bool didPop, T? result)? onPopped;

  // ===== State =====
  bool _isShowing = false;
  Completer<T?>? _completer;

  // ===== UI =====
  @protected
  Widget build(BuildContext context);

  @protected
  Widget transitionBuilder(BuildContext c, Animation<double> a1, Animation<double> a2, Widget child) {
    return FadeTransition(opacity: a1, child: child);
  }

  // Custom transition builder cho blur - chỉ animate content, không animate blur
  Widget _blurTransitionBuilder(BuildContext c, Animation<double> a1, Animation<double> a2, Widget content) {
    return FadeTransition(
      opacity: a1,
      child: content,
    );
  }

  Future<T?> show({BuildContext? context, GlobalKey<NavigatorState>? navigatorKey}) async {
    if (_isShowing) return _completer?.future;
    _isShowing = true;
    _completer = Completer<T?>();

    final ctx = _resolveContext(context, navigatorKey);
    final hasBlur = (barrierBlurSigma ?? 0) > 0;

    // Label cho trợ năng (khi cần)
    final String? resolvedBarrierLabel = barrierDismissible
        ? (barrierLabel ?? _tryMaterialLabel(ctx) ?? 'Dismiss')
        : null;

    try {
      final result = await showGeneralDialog<T?>(
        context: ctx,
        barrierDismissible: hasBlur ? false : barrierDismissible,
        barrierColor: hasBlur ? Colors.transparent : barrierColor,
        barrierLabel: hasBlur ? null : resolvedBarrierLabel,

        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        transitionDuration: transitionDuration,
        transitionBuilder: (c, a1, a2, child) {
          // Khi có blur, child đã bao gồm animation rồi, không cần wrap thêm
          return hasBlur ? child : transitionBuilder(c, a1, a2, child);
        },
        pageBuilder: (c, a1, a2) {
          final content = build(ctx);

          final overlay = hasBlur
              ? Stack(
            children: [
              // BackdropFilter xuất hiện ngay, không animate
              Positioned.fill(
                child: RepaintBoundary(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: barrierBlurSigma!,
                      sigmaY: barrierBlurSigma!,
                    ),
                    child: Container(color: barrierColor),
                  ),
                ),
              ),
              // ModalBarrier xuất hiện ngay, không animate
              Positioned.fill(
                child: ModalBarrier(
                  dismissible: barrierDismissible,
                  color: Colors.transparent,
                  semanticsLabel: resolvedBarrierLabel,
                  barrierSemanticsDismissible: barrierDismissible,
                ),
              ),
              // Chỉ animate content
              _blurTransitionBuilder(c, a1, a2, content),
            ],
          )
              : content;

          return PopScope(
            canPop: barrierDismissible,
            onPopInvokedWithResult: (didPop, raw) =>
                onPopped?.call(didPop, raw is T ? raw : null),
            child: overlay,
          );
        },
      );

      _completer?.complete(result);
      return result;
    } catch (e, s) {
      _completer?.completeError(e, s);
      rethrow;
    } finally {
      _isShowing = false;
      onCompleted?.call();
    }
  }

  Future<void> close(BuildContext context, [T? result]) async {
    if (!_isShowing) return;
    Navigator.of(context, rootNavigator: useRootNavigator).pop<T?>(result);
  }

  BuildContext _resolveContext(BuildContext? ctx, GlobalKey<NavigatorState>? key) {
    if (ctx != null) return ctx;
    final kctx = key?.currentContext;
    assert(kctx != null, 'Provide either context or navigatorKey.currentContext');
    return kctx!;
  }

  String? _tryMaterialLabel(BuildContext ctx) {
    try { return MaterialLocalizations.of(ctx).modalBarrierDismissLabel; }
    catch (_) { return null; }
  }
}

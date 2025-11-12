import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'transition_type.dart';

/// Helper class để build routes với các hiệu ứng transition
class RouteBuilder {
  /// Tạo route với hiệu ứng transition
  static Route<T> buildRoute<T>(
    Widget screen,
    TransitionType? transition,
    Duration duration,
  ) {
    // Nếu không chỉ định transition, dùng MaterialPageRoute mặc định
    if (transition == null) {
      return MaterialPageRoute(builder: (_) => screen);
    }

    // Cupertino transition (iOS style)
    if (transition == TransitionType.cupertino) {
      return CupertinoPageRoute(builder: (_) => screen);
    }

    // Custom transition
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _getTransition(transition, animation, child);
      },
      transitionDuration: duration,
    );
  }

  /// Lấy hiệu ứng transition theo type
  static Widget _getTransition(
    TransitionType type,
    Animation<double> animation,
    Widget child,
  ) {
    switch (type) {
      // Slide transitions
      case TransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      case TransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      case TransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      case TransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );

      // Basic transitions
      case TransitionType.fade:
        return FadeTransition(opacity: animation, child: child);
      case TransitionType.scale:
        return ScaleTransition(scale: animation, child: child);

      // Rotation transitions
      case TransitionType.rotation:
        return RotationTransition(
          turns: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      case TransitionType.rotationY:
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final value = animation.value * 3.14159 / 2; // 90 degrees
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(value),
              alignment: Alignment.center,
              child: child,
            );
          },
        );

      // Combined transitions
      case TransitionType.slideAndFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      case TransitionType.scaleAndFade:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      case TransitionType.slideAndRotate:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: RotationTransition(
            turns: Tween<double>(begin: 0.1, end: 0.0).animate(animation),
            child: child,
          ),
        );

      // Zoom transitions
      case TransitionType.zoom:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      case TransitionType.zoomIn:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 1.5,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      case TransitionType.zoomOut:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );

      // Size transition
      case TransitionType.size:
        return Align(
          child: SizeTransition(sizeFactor: animation, child: child),
        );

      // Slide diagonal transitions
      case TransitionType.slideTopLeft:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1, -1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      case TransitionType.slideTopRight:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, -1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      case TransitionType.slideBottomLeft:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      case TransitionType.slideBottomRight:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );

      case TransitionType.cupertino:
        // Không bao giờ đến đây vì đã xử lý ở buildRoute
        return child;
    }
  }
}

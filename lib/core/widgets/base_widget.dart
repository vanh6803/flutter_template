import 'package:flutter/material.dart';
import 'tracking_mixin.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class BaseState<T extends BaseStatefulWidget> extends State<T>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin<T>,
        TrackingMixin<T> {
  /// Có giữ state khi trong Tab/PageView/List hay không
  @protected
  bool get keepAlive => false;

  /// Có gọi onReady() bằng post-frame hay không (mặc định có)
  @protected
  bool get usePostFrameOnReady => true;

  /// Placeholder hiển thị 1 lần nếu bạn cần chờ onReady() (mặc định null -> render UI ngay)
  @protected
  Widget? get placeholderWhilePreparing => null;

  /// Có tự động track screen view hay không (mặc định có)
  @protected
  bool get autoTrackScreenView => true;

  @protected
  void onInitSync() {} // chạy ngay trong initState (không cần context)
  @protected
  void onReady() {} // chạy sau frame đầu (có context)
  @protected
  void onDispose() {} // chạy trước dispose

  // App lifecycle
  @protected
  void onAppLifecycleStateChanged(AppLifecycleState state) {}
  @protected
  void onResume() {}
  @protected
  void onPause() {}
  @protected
  void onInactive() {}
  @protected
  void onDetached() {}
  @protected
  void onHidden() {}

  // Environment changes
  @protected
  void onMemoryWarning() {}
  @protected
  void onPlatformBrightnessChanged() {}
  @protected
  void onTextScaleFactorChanged() {}
  @protected
  void onLocalesChanged(List<Locale>? locales) {}

  // Debug hot-reload
  @protected
  void onReassemble() {}

  /// Bắt buộc màn hình con override hàm này thay vì build()
  @protected
  Widget buildView(BuildContext context);

  // ====== Internal state ======
  bool _readyCalled = false; // đảm bảo onReady() gọi đúng 1 lần
  bool _firstBuildDone = false; // điều khiển placeholder nếu cần

  // ====== AutomaticKeepAliveClientMixin ======
  @override
  bool get wantKeepAlive => keepAlive;

  /// Nếu điều kiện keepAlive đổi theo runtime, gọi hàm này
  @protected
  @mustCallSuper
  void notifyKeepAliveChanged() => updateKeepAlive();

  // ====== Lifecycle wiring ======
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onInitSync();

    if (usePostFrameOnReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_readyCalled) {
          _readyCalled = true;
          onReady();

          // Auto track screen view if enabled
          if (autoTrackScreenView) {
            trackScreenView();
          }

          if (!_firstBuildDone) {
            // Sau onReady có thể cần render lại lần đầu
            setState(() {});
          }
        }
      });
    }
  }

  @override
  void dispose() {
    onDispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context); // cần cho keepAlive
    // Nếu muốn chặn 1 frame để chạy onReady trước khi hiển thị
    if (placeholderWhilePreparing != null && !_readyCalled) {
      return placeholderWhilePreparing!;
    }
    _firstBuildDone = true;
    return buildView(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onAppLifecycleStateChanged(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }

  @override
  void didHaveMemoryPressure() => onMemoryWarning();

  @override
  void didChangePlatformBrightness() => onPlatformBrightnessChanged();

  @override
  void didChangeTextScaleFactor() => onTextScaleFactorChanged();

  @override
  void didChangeLocales(List<Locale>? locales) => onLocalesChanged(locales);

  @override
  void reassemble() {
    super.reassemble();
    onReassemble();
  }
}

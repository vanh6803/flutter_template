import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/base_widget.dart';

class SplashScreen extends BaseStatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen> {
  @override
  bool get keepAlive => true;

  @override
  void onInitSync() {
    // TODO: init không cần context (controller/di/stream...)
  }

  @override
  void onReady() {
    // TODO: logic cần context sau frame đầu (SnackBar/Dialog/Provider.read...)
  }

  @override
  Widget buildView(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SplashScreen')),
    );
  }
}
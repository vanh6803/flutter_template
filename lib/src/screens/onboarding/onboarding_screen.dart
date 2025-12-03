import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/base_widget.dart';

class OnboardingScreen extends BaseStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends BaseState<OnboardingScreen> {
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
      body: Center(child: Text('OnboardingScreen')),
    );
  }
}
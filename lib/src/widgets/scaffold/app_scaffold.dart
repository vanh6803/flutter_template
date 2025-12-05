import 'package:ads_tracking_plugin/ads_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/app_size.dart';

class AppScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final bool? resizeToAvoidBottomInset;
  final Widget? drawer;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffold({
    super.key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.extendBody = false,
    this.resizeToAvoidBottomInset,
    this.drawer,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            // gradient: AppColors.backgroundGradient
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar,
            body: body,
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
            extendBody: extendBody,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            drawer: drawer,
            floatingActionButtonLocation: floatingActionButtonLocation,
          ),
        ),
        // Listen to app open ad loading state
        ValueListenableBuilder<bool>(
          valueListenable: AdsManager.instance.isAppOpenAdLoadingNotifier,
          builder: (context, isLoading, child) {
            print("AppScaffold: isAppOpenAdLoading = $isLoading");
            if (!isLoading) return const SizedBox.shrink();

            return Container(
              width: AppSize.instance.width,
              height: AppSize.instance.height,
              color: Colors.white,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 16),
                  Text("Welcome back!"),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

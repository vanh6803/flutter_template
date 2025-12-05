import 'package:ads_tracking_plugin/ads_manager.dart';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/base_widget.dart';
import 'package:flutter_template/core/config/ad_config.dart';
import 'package:flutter_template/core/constants/app_spacing.dart';
import 'package:flutter_template/core/navigation/navigation_manager.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/utils/app_size.dart';
import 'package:flutter_template/core/utils/locator_support.dart';
import 'package:flutter_template/src/screens/home/home_screen.dart';
import 'package:flutter_template/src/screens/language/language_screen.dart';
import 'package:flutter_template/src/view_models/ads_view_model.dart';
import 'package:flutter_template/src/view_models/app_view_model.dart';
import 'package:flutter_template/src/widgets/scaffold/app_scaffold.dart';
import 'package:provider/provider.dart';

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
    // disable ads on resume
    AdsManager.instance.setResumeAdState(true);
  }

  @override
  void onReady() {
    // TODO: logic cần context sau frame đầu (SnackBar/Dialog/Provider.read...)
    startScreen();
  }

  void startScreen() async {
    final appViewModel = context.read<AppViewModel>();

    // Wait for ads initialization to complete
    final isAdsInitialized = await appViewModel.waitForInit();

    if (isAdsInitialized && appViewModel.shouldShowAds) {
      await _preloadLanguageAds();
      await _loadingEnd();
    } else {
      // Skip ads flow if init failed or ads disabled
      _navigate();
    }
  }

  Future<void> _preloadLanguageAds() async {
    final appViewModel = context.read<AppViewModel>();
    final isFistOpenApp = await appViewModel.getFirstLaunch();

    if (!isFistOpenApp || !appViewModel.shouldShowAds) {
      return;
    }

    try {
      await AdsManager.instance.preload(name: AdName.nativeLanguageAd);
      await AdsManager.instance.preload(name: AdName.nativeLanguageClickAd);
    } catch (e) {
      debugPrint("preload native language error: $e");
    }
  }

  Future<void> _loadingEnd() async {
    final appViewModel = context.read<AppViewModel>();

    if (!appViewModel.shouldShowAds) {
      _navigate();
      return;
    }

    await requestEuConsent(
      onResult: (bool canShowAds) async {
        if (canShowAds && appViewModel.shouldShowAds) {
          final adsProvider = Provider.of<AdsViewModel>(context, listen: false);
          await adsProvider.showSplashInterAd(
            name: AdName.interSplashAd,
            callback: () {},
          );
        }
        _navigate();
      },
    );
  }

  void _navigate() async {
    final isFistOpenApp = await context.read<AppViewModel>().getFirstLaunch();
    if (isFistOpenApp) {
      NavigationManager.instance.navigateTo(LanguageScreen(fromSetting: false));
    } else {
      AdsManager.instance.setResumeAdState(false);
      NavigationManager.instance.navigateTo(HomeScreen());
    }
  }

  @override
  Widget buildView(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              AppSpacing.h56,
              AppSpacing.h56,
              AppSpacing.h20,
              Container(
                height: AppSize.instance.width * 0.29,
                width: AppSize.instance.width * 0.29,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(17),
                ),
                // child: Assets.images.splash.image(),
              ),
              AppSpacing.h32,
              Text(
                "App name",
                style: AppTypography.caption1.copyWith(
                  // color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              CircularProgressIndicator.adaptive(),
              AppSpacing.h12,
              Text(
                context.locale.just_waiting_a_few_seconds,
                style: AppTypography.caption1.copyWith(
                  color: Color(0xFF9A9A9A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

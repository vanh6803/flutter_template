import 'dart:io';

import 'package:ads_tracking_plugin/ad_config.dart';
import 'package:flutter_template/core/config/app_remote_config.dart';

String bannerAdUnitId = Platform.isAndroid
    ? "ca-app-pub-3940256099942544/9214589741"
    : "ca-app-pub-3940256099942544/2934735716";
String interstitialAdUnitId = Platform.isAndroid
    ? "ca-app-pub-3940256099942544/1033173712"
    : "ca-app-pub-3940256099942544/4411468910";
String nativeAdUnitId = Platform.isAndroid
    ? "ca-app-pub-3940256099942544/2247696110"
    : "ca-app-pub-3940256099942544/3986624511";
String rewardedAdUnitId = Platform.isAndroid
    ? "ca-app-pub-3940256099942544/5224354917"
    : "ca-app-pub-3940256099942544/1712485313";
String openAdUnitId = Platform.isAndroid
    ? "/21775744923/example/app-open"
    : "ca-app-pub-3940256099942544/5575463023";
String collapsibleBannerAdUnitId = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/2014213617'
    : 'ca-app-pub-3940256099942544/8388050270';

class AdUnitId {
  static bool devMode = true; // Todo: false is production, true is development

  static String interSplashAdUnitId = devMode
      ? interstitialAdUnitId
      : "ad id production";

  static String nativeLanguageAdUnitId = devMode
      ? nativeAdUnitId
      : "ad id production";

  static String nativeOnboardingPage1AdUnitId = devMode
      ? nativeAdUnitId
      : "ad id production";
  static String nativeOnboardingPage4AdUnitId = devMode
      ? nativeAdUnitId
      : "ad id production";

  static String openAppAdUnitId = devMode ? openAdUnitId : "ad id production";
}

class AdName {
  static const String interSplashAd = "inter_splash";
  static const String interHomeAd = "inter_home";

  static const String nativeLanguageAd = "native_language";
  static const String nativeLanguageClickAd = "native_language_click";
  static const String nativeOnboardingPage1Ad = "native_onboarding_page_1";
  static const String nativeOnboardingPage4Ad = "native_onboarding_page_4";

  static const String openAppAd = "open_resume";
}

List<AdConfiguration> getAdConfigurations() {
  double ctaCornerRadius = 16;
  double ctaHeight = AppRemoteConfig.instance.ctaNativeHeight;
  final ctaColor = "#1F80FF";
  String textColor = "#000000";

  return [
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.interSplashAdUnitId),
      name: AdName.interSplashAd,
      format: AdFormat.interstitial,
      loadTimeOut: 35,
    ),

    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeLanguageAdUnitId),
      name: AdName.nativeLanguageAd,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdLarge,
      nativeCustomOptions: NativeCustomOptions(
        textColor: textColor,
        ctaColor: ctaColor,
        ctaCornerRadius: ctaCornerRadius,
        ctaHeight: ctaHeight,
      ),
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeLanguageAdUnitId),
      name: AdName.nativeLanguageClickAd,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdLarge,
      nativeCustomOptions: NativeCustomOptions(
        textColor: textColor,
        ctaColor: ctaColor,
        ctaCornerRadius: ctaCornerRadius,
        ctaHeight: ctaHeight,
      ),
    ),

    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeOnboardingPage1AdUnitId),
      name: AdName.nativeOnboardingPage1Ad,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutMediumCtaFullBottom,
      nativeCustomOptions: NativeCustomOptions(
        textColor: textColor,
        ctaColor: ctaColor,
        ctaCornerRadius: ctaCornerRadius,
        ctaHeight: ctaHeight,
      ),
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeOnboardingPage4AdUnitId),
      name: AdName.nativeOnboardingPage4Ad,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutMediumCtaFullBottom,
      nativeCustomOptions: NativeCustomOptions(
        textColor: textColor,
        ctaColor: ctaColor,
        ctaCornerRadius: ctaCornerRadius,
        ctaHeight: ctaHeight,
      ),
    ),

    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.openAppAdUnitId),
      name: AdName.openAppAd,
      format: AdFormat.appOpen,
    ),
  ];
}

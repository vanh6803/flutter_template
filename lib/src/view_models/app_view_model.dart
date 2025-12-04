import 'package:ads_tracking_plugin/ads_manager.dart';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/service_locator.dart';
import 'package:flutter_template/core/config/ad_config.dart';
import 'package:flutter_template/core/constants/app_key.dart';
import 'package:flutter_template/src/view_models/ads_view_model.dart';
import 'package:flutter_template/src/view_models/purchase_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppViewModel extends ChangeNotifier {
  final _sharedPrefs = ServiceLocator.instance.get<SharedPreferences>();

  AdsViewModel adsProvider;
  PurchaseViewModel purchaseProvider;

  AppViewModel(this.adsProvider, this.purchaseProvider) {
      // purchaseProvider.loadSubscription().then((_) {
      if(shouldShowAds) init();
      // });
  }

  bool _isFirstLaunch = true;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get shouldShowAds => adsProvider.adsEnabled && !purchaseProvider.isSubscribed;

  void updateDependencies(AdsViewModel ads, PurchaseViewModel purchase) {
    adsProvider = ads;
    purchaseProvider = purchase;
    notifyListeners();
  }

  Future init() async {
    // await AdsManager.instance.initialize(
    //   configurations: getAdConfigurations(),
    //   analyticsTracker: AnalyticsTracker.instance,
    //   remoteConfig: RemoteConfig.instance,
    //   adjustConfig: AdjustConfig('3ben8e8vhpz4', AdjustEnvironment.sandbox),
    // );
  }

  bool getFirstLaunch() {
    _isFirstLaunch = _sharedPrefs.getBool(AppKey.FIRST_LAUNCH) ?? true;
    notifyListeners();
    return _isFirstLaunch;
  }

  void setFirstLaunch(bool value) {
    _isFirstLaunch = value;
    _sharedPrefs.setBool(AppKey.FIRST_LAUNCH, value);
    notifyListeners();
  }
}
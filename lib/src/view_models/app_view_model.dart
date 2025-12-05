import 'dart:async';

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
      // if(shouldShowAds)
      init();
      // });
  }

  bool _isFirstLaunch = true;
  bool _isLoadingInit = false;
  bool _isInitialized = false;
  Completer<bool>? _initCompleter;

  bool get isFirstLaunch => _isFirstLaunch;
  bool get isLoadingInit => _isLoadingInit;
  bool get isInitialized => _isInitialized;

  /// Wait for ads initialization to complete
  /// Returns true if init succeeded, false otherwise
  Future<bool> waitForInit() async {
    if (_isInitialized) return true;
    if (_initCompleter != null) return _initCompleter!.future;
    // If not loading and not initialized, return false
    if (!_isLoadingInit) return false;
    // Wait for current init to complete
    _initCompleter = Completer<bool>();
    return _initCompleter!.future;
  }

  bool get shouldShowAds => adsProvider.adsEnabled && !purchaseProvider.isSubscribed;

  void updateDependencies(AdsViewModel ads, PurchaseViewModel purchase) {
    adsProvider = ads;
    purchaseProvider = purchase;
    notifyListeners();
  }

  Future init() async {
    if(_isInitialized || _isLoadingInit) return;
    _isLoadingInit = true;
    _initCompleter = Completer<bool>();
    notifyListeners();
    try{
      await AdsManager.instance.initialize(
        configurations: getAdConfigurations(),
        // analyticsTracker: AnalyticsTracker.instance,
        // remoteConfig: RemoteConfig.instance,
        // adjustConfig: AdjustConfig('3ben8e8vhpz4', AdjustEnvironment.sandbox),
      );
      _isInitialized = true;
      adsProvider.updateAdsState(true);
      _initCompleter?.complete(true);
      notifyListeners();
    }catch(e){
      _isInitialized = false;
      adsProvider.updateAdsState(false);
      _initCompleter?.complete(false);
      notifyListeners();
    }finally{
      _isLoadingInit = false;
      notifyListeners();
    }
  }

  Future<bool> getFirstLaunch() async {
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
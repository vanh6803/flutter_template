import 'package:ads_tracking_plugin/ads_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_template/core/config/app_remote_config.dart';
import 'package:flutter_template/core/utils/app_logger.dart';

class AdsViewModel extends ChangeNotifier {

  bool _adsEnabled = true;
  DateTime? _lastAdTime;
  bool _isLoading = false;

  bool get adsEnabled => _adsEnabled;

  void updateAdsState(bool isEnabled) {
    _adsEnabled = isEnabled;
    notifyListeners();
  }

  void showInterAd({
    required String name,
    Function()? callback,
    bool indicator = false,
  }) {
    if (_isLoading) return;
    final now = DateTime.now();
    final time = AppRemoteConfig.instance.timeBetweenInterAds;
    if (_lastAdTime == null || now.difference(_lastAdTime!).inSeconds >= time) {
      if (!indicator) {
        callback?.call();
      }
      try {
        AdsManager.instance.interstitialAd
            .showAd(
          name,
          onLoadingStateChanged: (isLoading, [_]) {
            if (isLoading) {
              EasyLoading.show(
                indicator: CircularProgressIndicator.adaptive(strokeWidth: 2,),
                status: "Loading...",
                maskType: EasyLoadingMaskType.black,
                dismissOnTap: false,
              );
            } else {
              EasyLoading.dismiss();
            }
            _isLoading = isLoading;
            notifyListeners();
          },
          onFullScreenAdDismissed: (_) async {
            _lastAdTime = DateTime.now();
            if (indicator) {
              callback?.call();
            }
          },
        )
            .then((_) {})
            .catchError((e) {
          if (indicator) {
            callback?.call();
          }
        });
      } catch (e) {
        print('cant callback');
        callback?.call();
      }
    } else {
      callback?.call();
    }
  }

  void showSplashInterAd({
    required String name,
    Function()? callback,
  }) {
    if (_isLoading) return;
    try {
      AdsManager.instance.interstitialAd.showAd(
        name,
        onLoadingStateChanged: (isLoading, [_]) {
          _isLoading = isLoading;
          notifyListeners();
        },
        onFullScreenAdDismissed: (_) async {
          callback?.call();
        },
      )
          .then((_) {})
          .catchError((e) {
        callback?.call();
      });
    } catch (e) {
      print('cant callback');
      callback?.call();
    }
  }

  Future<void> showRewardAd({
    required BuildContext context,
    required String adName,
    required Function() onUserEarnedReward,
    Function? onAdDismissedFullScreenContent,
  }) async {
    if (_isLoading) return;
    try {
      await AdsManager.instance.rewardedAd.showAd(
        adName,
        onLoadingStateChanged: (isLoading, [_]) {
          if (isLoading) {
            EasyLoading.show(
              indicator: CircularProgressIndicator.adaptive(strokeWidth: 2,),
              status: "Loading...",
              maskType: EasyLoadingMaskType.black,
              dismissOnTap: false,
            );
          } else {
            EasyLoading.dismiss();
          }
          _isLoading = isLoading;
          notifyListeners();
        },

        onRewardEarned: (ad, reward) {
          onUserEarnedReward();
        },
        onFullScreenAdDismissed: (ad) {
          onAdDismissedFullScreenContent?.call();
        },
      );
    } catch (e) {
      onUserEarnedReward();
      print('Error showing rewarded ad: $e');
    }
  }
}
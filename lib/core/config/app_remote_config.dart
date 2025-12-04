import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:flutter_template/core/utils/app_logger.dart';

class AppRemoteConfig {
  AppRemoteConfig._();

  static AppRemoteConfig? _instance;
  static AppRemoteConfig get instance {
    _instance ??= AppRemoteConfig._();
    return _instance!;
  }

  final _remoteConfig = RemoteConfig.instance;

  double get ctaNativeHeight => _remoteConfig.getCtaNativeHeight();

  int _reloadTimeBannerHome = 60;
  bool _isCollapsibleBannerCameraBottom = true;
  bool _customRateEnabled = true;
  int _timeBetweenInterAds = 35;

  int get reloadTimeBannerHome => _reloadTimeBannerHome;

  int get timeBetweenInterAds => _timeBetweenInterAds;

  bool get isCollapsibleBannerCameraBottom => _isCollapsibleBannerCameraBottom;
  bool get customRateEnabled => _customRateEnabled;

  void init() {
    _reloadTimeBannerHome = _remoteConfig.getActionIntRemoteConfig(
      'reload_time_banner_home',
      defaultValue: 60,
    );
    _isCollapsibleBannerCameraBottom = _remoteConfig.getActionBoolRemoteConfig(
      'collapsible_banner_camera_bottom',
      defaultValue: true,
    );
    _customRateEnabled = _remoteConfig.getActionBoolRemoteConfig(
      'custom_rate_enabled',
      defaultValue: true,
    );
    _timeBetweenInterAds = _remoteConfig.getActionIntRemoteConfig(
      'time_between_inter_ads',
      defaultValue: 35,
    );

    AppLogger.debug('AppRemoteConfig initialized:) '
        'reloadTimeBannerHome=$_reloadTimeBannerHome, '
        'isCollapsibleBannerCameraBottom=$_isCollapsibleBannerCameraBottom, '
        'timeBetweenInterAds=$_timeBetweenInterAds');
  }
}

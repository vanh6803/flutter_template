import 'package:flutter/material.dart';
import 'package:flutter_template/app/service_locator.dart';
import 'package:flutter_template/core/constants/app_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider extends ChangeNotifier {
  final _sharedPrefs = ServiceLocator.instance.get<SharedPreferences>();

  AppStateProvider(){
    getFirstLaunch();
  }

  bool _isFirstLaunch = true;
  bool get isFirstLaunch => _isFirstLaunch;

  bool get isAccessFunction => true;

  void getFirstLaunch() {
    _isFirstLaunch = _sharedPrefs.getBool(AppKey.FIRST_LAUNCH) ?? true;
    notifyListeners();
  }

  void setFirstLaunch(bool value) {
    _isFirstLaunch = value;
    _sharedPrefs.setBool(AppKey.FIRST_LAUNCH, value);
    notifyListeners();
  }
}
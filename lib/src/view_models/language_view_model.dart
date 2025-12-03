import 'package:flutter/material.dart';
import 'package:flutter_template/app/service_locator.dart';
import 'package:flutter_template/core/constants/app_key.dart';
import 'package:flutter_template/core/enums/language_enum.dart';
import 'package:flutter_template/core/extensions/language_ext.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageViewModel extends ChangeNotifier {
  final _prefs = ServiceLocator.instance.get<SharedPreferences>();

  LanguageEnum _currentLanguage = LanguageEnum.en;
  LanguageEnum? _selectedLanguage;

  Locale get locale => _currentLanguage.toLocale();

  LanguageEnum get currentLanguage => _currentLanguage;

  LanguageEnum? get selectedLanguage => _selectedLanguage;

  void selectLanguage(LanguageEnum language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void saveLanguage() {
    if (_selectedLanguage == null || !isLanguageSupported(_selectedLanguage!)) {
      return;
    }
    _currentLanguage = _selectedLanguage!;
    _prefs.setString(AppKey.CURRENT_LANGUAGE, _currentLanguage.code);
    notifyListeners();
  }

  bool isLanguageSupported(LanguageEnum language) {
    return AppLocalizations.supportedLocales.contains(language.toLocale());
  }
}

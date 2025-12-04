import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';

extension LocatorSupport on BuildContext{
  AppLocalizations get locale {
    AppLocalizations? locate = AppLocalizations.of(this);
    if(locate == null){
      throw Exception('AppLocalizations not found');
    }
    return locate;
  }
}
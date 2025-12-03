import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/enums/language_enum.dart';
import 'package:flutter_template/gen/assets.gen.dart';

extension LanguageExt on LanguageEnum {
  String get displayName {
    switch (this) {
      case LanguageEnum.en:
        return 'English';
      case LanguageEnum.es:
        return 'Spanish';
      case LanguageEnum.fr:
        return 'French';
      case LanguageEnum.hi:
        return 'Hindi';
      case LanguageEnum.de:
        return 'German';
    }
  }

  String get code {
    return name;
  }

  Widget get getFlag {
    switch (this) {
      case LanguageEnum.en:
        return Assets.icons.language.unitedStates.svg(
            width: 32, height: 32
        );
      case LanguageEnum.de:
        return Assets.icons.language.german.svg(
            width: 32, height: 32
        );
      case LanguageEnum.es:
        return Assets.icons.language.spanish.svg(
            width: 32, height: 32
        );
      case LanguageEnum.fr:
        return Assets.icons.language.french.svg(
            width: 32, height: 32
        );
      case LanguageEnum.hi:
        return Assets.icons.language.hindi.svg(
            width: 32, height: 32
        );
      default:
        return Assets.icons.language.unitedStates.svg(
            width: 32, height: 32
        );
    }
  }

  Locale toLocale() {
    return Locale(code);
  }
}

extension StringToLanguageEnum on String {
  LanguageEnum? toLanguageEnum() {
    try {
      return LanguageEnum.values.firstWhere((e) => e.name == this);
    } catch (_) {
      return null;
    }
  }
}

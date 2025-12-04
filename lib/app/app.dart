import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_template/core/navigation/navigation_manager.dart';
import 'package:flutter_template/core/theme/app_theme.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/src/screens/splash/splash_screen.dart';
import 'package:flutter_template/src/view_models/language_view_model.dart';
import 'package:provider/provider.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<LanguageViewModel, Locale>(
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Template',
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          home: SplashScreen(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorKey: NavigationManager.instance.navigatorKey,
          builder: EasyLoading.init(),
        );
      },
      selector: (context, value) => value.locale,
    );
  }
}

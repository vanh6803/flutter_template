import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_template/core/navigation/navigation_manager.dart';
import 'package:flutter_template/core/theme/app_theme.dart';
import 'package:flutter_template/src/screens/language/language_screen.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Template',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: LanguageScreen(),
      navigatorKey: NavigationManager.instance.navigatorKey,
      builder: EasyLoading.init(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_template/core/navigation/navigation_manager.dart';
import 'package:flutter_template/core/theme/app_theme.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drive One',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      // home: SplashScreen(),
      navigatorKey: NavigationManager.instance.navigatorKey,
      builder: EasyLoading.init(),
    );
  }
}

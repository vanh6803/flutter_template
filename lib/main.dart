import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/app/bootstap.dart';
import 'package:flutter_template/src/view_models/ads_view_model.dart';
import 'package:flutter_template/src/view_models/app_view_model.dart';
import 'package:flutter_template/src/view_models/language_view_model.dart';
import 'package:flutter_template/src/view_models/purchase_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bootstrap();

  final purchaseProvider = PurchaseViewModel();
  final adProvider = AdsViewModel();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageViewModel()),
      ChangeNotifierProvider<AdsViewModel>(create: (_) => adProvider,),
      ChangeNotifierProvider<PurchaseViewModel>(create: (_) => purchaseProvider,),
      ChangeNotifierProxyProvider2<AdsViewModel, PurchaseViewModel, AppViewModel>(
        create: (_) => AppViewModel(adProvider, purchaseProvider),
        update: (_, ads, purchase, appState) {
          appState?.updateDependencies(ads, purchase);
          return appState ?? AppViewModel(ads, purchase);
        },
      ),
    ],
    child: const MyApplication(),
  ),);
}
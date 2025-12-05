import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:flutter_template/app/service_locator.dart';

Future<void> bootstrap() async {
  // init firebase and dependency injection here

  // await requestATT(
  //   onResult: (granted) {
  //     print('ATT tracking granted: $granted');
  //   },
  // );

  await ServiceLocator.instance.initialise();
}
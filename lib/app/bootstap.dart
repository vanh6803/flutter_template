import 'package:flutter_template/app/service_locator.dart';

Future<void> bootstrap() async {
  // init firebase and dependency injection here
  await ServiceLocator.instance.initialise();
}
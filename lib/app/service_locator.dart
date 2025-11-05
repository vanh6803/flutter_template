import 'package:get_it/get_it.dart';
import '../domain/services/firebase_tracking_service.dart';
import '../domain/services/app_tracking_service.dart';

final GetIt serviceLocator = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Register Firebase Tracking Service
    serviceLocator.registerLazySingleton<FirebaseTrackingService>(
      () => FirebaseTrackingServiceImpl(),
    );

    // Register App Tracking Service
    serviceLocator.registerLazySingleton<AppTrackingService>(
      () => AppTrackingService(),
    );

    // Initialize App Tracking Service
    final appTrackingService = serviceLocator.get<AppTrackingService>();
    final firebaseTrackingService = serviceLocator
        .get<FirebaseTrackingService>();
    await appTrackingService.initialize(firebaseTrackingService);
  }

  static T get<T extends Object>() => serviceLocator.get<T>();
}

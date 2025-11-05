import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/constants/tracking_constants.dart';
import '../../firebase_options.dart';
import 'firebase_tracking_service.dart';

class AppTrackingService {
  static final AppTrackingService _instance = AppTrackingService._internal();
  factory AppTrackingService() => _instance;
  AppTrackingService._internal();

  late final FirebaseTrackingService _trackingService;
  bool _initialized = false;

  /// Initialize Firebase and tracking services
  Future<void> initialize(FirebaseTrackingService trackingService) async {
    if (_initialized) return;

    try {
      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _trackingService = trackingService;
      await _trackingService.initialize();

      // Set up app-level user properties
      await _setAppUserProperties();

      _initialized = true;

      if (kDebugMode) {
        print('App Tracking Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize App Tracking Service: $e');
      }
      rethrow;
    }
  }

  /// Set app-level user properties
  Future<void> _setAppUserProperties() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      await _trackingService.setUserProperty(
        UserProperties.appVersion,
        packageInfo.version,
      );

      await _trackingService.setUserProperty(
        UserProperties.platform,
        defaultTargetPlatform.name,
      );

      final now = DateTime.now();
      await _trackingService.setUserProperty(
        UserProperties.firstLaunchDate,
        now.toIso8601String(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set app user properties: $e');
      }
    }
  }

  /// Track app lifecycle events
  void trackAppLifecycle(AppLifecycleState state) {
    if (!_initialized) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _trackingService.logEvent(TrackingEvents.appForeground, {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
        break;
      case AppLifecycleState.paused:
        _trackingService.logEvent(TrackingEvents.appBackground, {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., incoming call)
        break;
      case AppLifecycleState.hidden:
        // App is hidden but still running
        break;
    }
  }

  /// Track user login
  Future<void> trackUserLogin(String userId, String method) async {
    if (!_initialized) return;

    await _trackingService.setUserId(userId);
    await _trackingService.logEvent(TrackingEvents.userLogin, {
      TrackingParameters.userId: userId,
      'login_method': method,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track user logout
  Future<void> trackUserLogout(String userId) async {
    if (!_initialized) return;

    await _trackingService.logEvent(TrackingEvents.userLogout, {
      TrackingParameters.userId: userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    // Reset analytics data after logout
    await _trackingService.resetAnalyticsData();
  }

  /// Track user signup
  Future<void> trackUserSignUp(String userId, String method) async {
    if (!_initialized) return;

    await _trackingService.setUserId(userId);
    await _trackingService.logEvent(TrackingEvents.userSignUp, {
      TrackingParameters.userId: userId,
      'signup_method': method,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track app opening
  Future<void> trackAppOpen() async {
    if (!_initialized) return;

    await _trackingService.logEvent(TrackingEvents.appOpen, {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Set user type (e.g., 'premium', 'free', 'trial')
  Future<void> setUserType(String userType) async {
    if (!_initialized) return;

    await _trackingService.setUserProperty(UserProperties.userType, userType);
  }

  /// Set user language
  Future<void> setUserLanguage(String language) async {
    if (!_initialized) return;

    await _trackingService.setUserProperty(UserProperties.language, language);
  }

  /// Set user theme preference
  Future<void> setUserTheme(String theme) async {
    if (!_initialized) return;

    await _trackingService.setUserProperty(UserProperties.theme, theme);
  }

  /// Log global errors
  Future<void> logGlobalError(
    dynamic error,
    StackTrace stackTrace, {
    String? context,
  }) async {
    if (!_initialized) return;

    await _trackingService.logError(error, stackTrace, reason: context);
  }

  /// Track performance metrics
  Future<void> trackPerformanceMetric(
    String metricName,
    int valueMs, {
    Map<String, Object>? additionalParams,
  }) async {
    if (!_initialized) return;

    final params = <String, Object>{
      'metric_name': metricName,
      'value_ms': valueMs,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParams,
    };

    await _trackingService.logEvent(TrackingEvents.performanceIssue, params);
  }
}

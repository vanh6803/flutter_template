import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class FirebaseTrackingService {
  /// Initialize Firebase services
  Future<void> initialize();

  /// Log custom events
  Future<void> logEvent(String name, Map<String, Object>? parameters);

  /// Log screen views
  Future<void> logScreenView(String screenName, String screenClass);

  /// Set user properties
  Future<void> setUserProperty(String name, String value);

  /// Set user ID for tracking
  Future<void> setUserId(String userId);

  /// Log errors
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
  });

  /// Log custom errors with context
  Future<void> logCustomError(String message, Map<String, dynamic>? context);

  /// Reset analytics data (useful for logout)
  Future<void> resetAnalyticsData();
}

class FirebaseTrackingServiceImpl implements FirebaseTrackingService {
  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;

  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;

      // Enable crashlytics collection
      await _crashlytics.setCrashlyticsCollectionEnabled(true);

      // Set up Flutter error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        _crashlytics.recordFlutterFatalError(details);
      };

      // Set up Dart error handling
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      _initialized = true;

      if (kDebugMode) {
        print('Firebase Tracking Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize Firebase Tracking Service: $e');
      }
      // Don't rethrow to prevent app crashes during initialization
    }
  }

  @override
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    if (!_initialized) return;

    try {
      await _analytics.logEvent(name: name, parameters: parameters);

      if (kDebugMode) {
        print('Analytics Event: $name with parameters: $parameters');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log event $name: $e');
      }
    }
  }

  @override
  Future<void> logScreenView(String screenName, String screenClass) async {
    if (!_initialized) return;

    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );

      if (kDebugMode) {
        print('Screen View: $screenName ($screenClass)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log screen view $screenName: $e');
      }
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    if (!_initialized) return;

    try {
      await _analytics.setUserProperty(name: name, value: value);
      await _crashlytics.setUserIdentifier(value);

      if (kDebugMode) {
        print('User Property Set: $name = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set user property $name: $e');
      }
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    if (!_initialized) return;

    try {
      await _analytics.setUserId(id: userId);
      await _crashlytics.setUserIdentifier(userId);

      if (kDebugMode) {
        print('User ID Set: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set user ID: $e');
      }
    }
  }

  @override
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    if (!_initialized) return;

    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: false,
      );

      if (kDebugMode) {
        print('Error logged: $exception');
        if (reason != null) print('Reason: $reason');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log error: $e');
      }
    }
  }

  @override
  Future<void> logCustomError(
    String message,
    Map<String, dynamic>? context,
  ) async {
    if (!_initialized) return;

    try {
      // Set custom keys for better context
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }

      // Record the custom error
      await _crashlytics.recordError(
        Exception(message),
        StackTrace.current,
        reason: 'Custom Error',
        fatal: false,
      );

      if (kDebugMode) {
        print('Custom Error: $message');
        if (context != null) print('Context: $context');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log custom error: $e');
      }
    }
  }

  @override
  Future<void> resetAnalyticsData() async {
    if (!_initialized) return;

    try {
      await _analytics.resetAnalyticsData();

      if (kDebugMode) {
        print('Analytics data reset');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to reset analytics data: $e');
      }
    }
  }
}

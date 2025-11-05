import '../../domain/services/firebase_tracking_service.dart';
import '../../domain/services/app_tracking_service.dart';
import '../../app/service_locator.dart';
import '../constants/tracking_constants.dart';

/// Utility class for common tracking operations
/// Use this for tracking events that don't belong to a specific screen
class TrackingUtils {
  static FirebaseTrackingService get _firebaseTracking =>
      ServiceLocator.get<FirebaseTrackingService>();

  static AppTrackingService get _appTracking =>
      ServiceLocator.get<AppTrackingService>();

  /// Track API calls and their results
  static Future<void> trackApiCall(
    String endpoint,
    String method,
    int statusCode,
    int durationMs,
  ) async {
    await _firebaseTracking.logEvent('api_call', {
      'endpoint': endpoint,
      'method': method,
      'status_code': statusCode,
      'duration_ms': durationMs,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track API errors with detailed context
  static Future<void> trackApiError(
    String endpoint,
    String method,
    int statusCode,
    String errorMessage,
  ) async {
    await _firebaseTracking.logEvent(TrackingEvents.apiError, {
      TrackingParameters.errorCode: statusCode.toString(),
      TrackingParameters.errorMessage: errorMessage,
      'endpoint': endpoint,
      'method': method,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track form submissions
  static Future<void> trackFormSubmission(
    String formName,
    bool isSuccessful, {
    Map<String, Object>? additionalParams,
  }) async {
    final params = <String, Object>{
      'form_name': formName,
      'is_successful': isSuccessful,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParams,
    };

    await _firebaseTracking.logEvent('form_submission', params);
  }

  /// Track deep link opens
  static Future<void> trackDeepLink(String link, String source) async {
    await _firebaseTracking.logEvent('deep_link_open', {
      'link': link,
      'source': source,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track push notification interactions
  static Future<void> trackPushNotification(
    String action, // 'received', 'opened', 'dismissed'
    String notificationType, {
    Map<String, Object>? additionalParams,
  }) async {
    final params = <String, Object>{
      'action': action,
      'notification_type': notificationType,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParams,
    };

    await _firebaseTracking.logEvent('push_notification', params);
  }

  /// Track purchase events
  static Future<void> trackPurchase(
    String productId,
    double amount,
    String currency, {
    String? transactionId,
  }) async {
    await _firebaseTracking.logEvent('purchase', {
      'product_id': productId,
      'amount': amount,
      'currency': currency,
      if (transactionId != null) 'transaction_id': transactionId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track subscription events
  static Future<void> trackSubscription(
    String action, // 'subscribe', 'cancel', 'renew'
    String planId, {
    double? amount,
    String? currency,
  }) async {
    final params = <String, Object>{
      'action': action,
      'plan_id': planId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    if (amount != null) params['amount'] = amount;
    if (currency != null) params['currency'] = currency;

    await _firebaseTracking.logEvent('subscription', params);
  }

  /// Track sharing events
  static Future<void> trackShare(
    String contentType,
    String contentId,
    String shareMethod,
  ) async {
    await _firebaseTracking.logEvent(TrackingEvents.share, {
      'content_type': contentType,
      'content_id': contentId,
      TrackingParameters.shareMethod: shareMethod,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track onboarding progress
  static Future<void> trackOnboardingStep(
    int stepNumber,
    String stepName,
    String action, // 'view', 'complete', 'skip'
  ) async {
    await _firebaseTracking.logEvent('onboarding_step', {
      'step_number': stepNumber,
      'step_name': stepName,
      'action': action,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track tutorial interactions
  static Future<void> trackTutorial(String action, String tutorialName) async {
    String eventName;
    switch (action) {
      case 'begin':
        eventName = TrackingEvents.tutorialBegin;
        break;
      case 'complete':
        eventName = TrackingEvents.tutorialComplete;
        break;
      default:
        eventName = 'tutorial_$action';
    }

    await _firebaseTracking.logEvent(eventName, {
      'tutorial_name': tutorialName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track content views (articles, videos, etc.)
  static Future<void> trackContentView(
    String contentType,
    String contentId,
    String contentTitle, {
    int? viewDurationSeconds,
  }) async {
    final params = <String, Object>{
      'content_type': contentType,
      'content_id': contentId,
      'content_title': contentTitle,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    if (viewDurationSeconds != null) {
      params['view_duration_seconds'] = viewDurationSeconds;
    }

    await _firebaseTracking.logEvent('content_view', params);
  }

  /// Track app settings changes
  static Future<void> trackSettingChange(
    String settingName,
    String oldValue,
    String newValue,
  ) async {
    await _firebaseTracking.logEvent('setting_change', {
      'setting_name': settingName,
      'old_value': oldValue,
      'new_value': newValue,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track performance benchmarks
  static Future<void> trackPerformanceBenchmark(
    String operation,
    int durationMs, {
    String? category,
    Map<String, Object>? context,
  }) async {
    await _appTracking.trackPerformanceMetric(
      operation,
      durationMs,
      additionalParams: {
        if (category != null) 'category': category,
        ...?context,
      },
    );
  }

  /// Track user engagement milestones
  static Future<void> trackEngagementMilestone(
    String milestone,
    int value,
  ) async {
    await _firebaseTracking.logEvent('engagement_milestone', {
      'milestone': milestone,
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}

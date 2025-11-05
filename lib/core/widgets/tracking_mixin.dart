import 'package:flutter/material.dart';
import '../../app/service_locator.dart';
import '../../domain/services/firebase_tracking_service.dart';
import '../constants/tracking_constants.dart';

/// Mixin to add tracking capabilities to widgets
mixin TrackingMixin<T extends StatefulWidget> on State<T> {
  late final FirebaseTrackingService _trackingService;

  @override
  void initState() {
    super.initState();
    _trackingService = ServiceLocator.get<FirebaseTrackingService>();
  }

  /// Get the screen name for tracking (override in child classes)
  String get screenName => widget.runtimeType.toString();

  /// Get the screen class for tracking (override in child classes)
  String get screenClass => widget.runtimeType.toString();

  /// Track screen view automatically
  void trackScreenView() {
    _trackingService.logScreenView(screenName, screenClass);
  }

  /// Track button taps
  void trackButtonTap(
    String buttonName, {
    Map<String, Object>? additionalParams,
  }) {
    final params = <String, Object>{
      TrackingParameters.buttonName: buttonName,
      TrackingParameters.screenName: screenName,
      ...?additionalParams,
    };
    _trackingService.logEvent(TrackingEvents.buttonTap, params);
  }

  /// Track item selection
  void trackItemSelect(
    String itemId,
    String itemName, {
    String? category,
    Map<String, Object>? additionalParams,
  }) {
    final params = <String, Object>{
      TrackingParameters.itemId: itemId,
      TrackingParameters.itemName: itemName,
      TrackingParameters.screenName: screenName,
      if (category != null) TrackingParameters.itemCategory: category,
      ...?additionalParams,
    };
    _trackingService.logEvent(TrackingEvents.itemSelect, params);
  }

  /// Track search events
  void trackSearch(
    String searchTerm, {
    int? resultCount,
    Map<String, Object>? additionalParams,
  }) {
    final params = <String, Object>{
      TrackingParameters.searchTerm: searchTerm,
      TrackingParameters.screenName: screenName,
      if (resultCount != null) 'result_count': resultCount,
      ...?additionalParams,
    };
    _trackingService.logEvent(TrackingEvents.search, params);
  }

  /// Track feature usage
  void trackFeatureUsed(
    String featureName, {
    Map<String, Object>? additionalParams,
  }) {
    final params = <String, Object>{
      TrackingParameters.featureName: featureName,
      TrackingParameters.screenName: screenName,
      ...?additionalParams,
    };
    _trackingService.logEvent(TrackingEvents.featureUsed, params);
  }

  /// Track navigation events
  void trackNavigation(
    String destination, {
    String? method,
    Map<String, Object>? additionalParams,
  }) {
    final params = <String, Object>{
      TrackingParameters.source: screenName,
      TrackingParameters.destination: destination,
      if (method != null) TrackingParameters.navigationMethod: method,
      ...?additionalParams,
    };
    _trackingService.logEvent(TrackingEvents.navigationStart, params);
  }

  /// Track errors that occur in the screen
  void trackError(
    String errorType,
    String errorMessage, {
    String? errorCode,
    Map<String, Object>? additionalParams,
  }) {
    final params = <String, Object>{
      TrackingParameters.errorType: errorType,
      TrackingParameters.errorMessage: errorMessage,
      TrackingParameters.screenName: screenName,
      if (errorCode != null) TrackingParameters.errorCode: errorCode,
      ...?additionalParams,
    };
    _trackingService.logEvent(TrackingEvents.errorOccurred, params);
  }

  /// Track custom events
  void trackCustomEvent(String eventName, Map<String, Object>? parameters) {
    final params = <String, Object>{
      TrackingParameters.screenName: screenName,
      ...?parameters,
    };
    _trackingService.logEvent(eventName, params);
  }

  /// Track performance issues
  void trackPerformance(
    String operation,
    int durationMs, {
    Map<String, Object>? additionalParams,
  }) {
    final params = <String, Object>{
      'operation': operation,
      TrackingParameters.loadTimeMs: durationMs,
      TrackingParameters.screenName: screenName,
      ...?additionalParams,
    };
    _trackingService.logEvent(TrackingEvents.loadTime, params);
  }
}

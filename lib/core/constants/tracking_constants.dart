/// Predefined tracking events for common use cases
class TrackingEvents {
  // Screen events
  static const String screenView = 'screen_view';

  // User interaction events
  static const String buttonTap = 'button_tap';
  static const String itemSelect = 'item_select';
  static const String search = 'search';
  static const String share = 'share';

  // Navigation events
  static const String navigationStart = 'navigation_start';
  static const String navigationComplete = 'navigation_complete';

  // User lifecycle events
  static const String userLogin = 'login';
  static const String userLogout = 'logout';
  static const String userSignUp = 'sign_up';

  // App lifecycle events
  static const String appOpen = 'app_open';
  static const String appBackground = 'app_background';
  static const String appForeground = 'app_foreground';

  // Feature usage events
  static const String featureUsed = 'feature_used';
  static const String tutorialBegin = 'tutorial_begin';
  static const String tutorialComplete = 'tutorial_complete';

  // Error events
  static const String errorOccurred = 'error_occurred';
  static const String apiError = 'api_error';

  // Performance events
  static const String performanceIssue = 'performance_issue';
  static const String loadTime = 'load_time';
}

/// Common parameter keys for tracking events
class TrackingParameters {
  // Screen parameters
  static const String screenName = 'screen_name';
  static const String screenClass = 'screen_class';
  static const String previousScreen = 'previous_screen';

  // User parameters
  static const String userId = 'user_id';
  static const String userType = 'user_type';

  // Item parameters
  static const String itemId = 'item_id';
  static const String itemName = 'item_name';
  static const String itemCategory = 'item_category';
  static const String itemValue = 'item_value';

  // Action parameters
  static const String actionType = 'action_type';
  static const String buttonName = 'button_name';
  static const String searchTerm = 'search_term';
  static const String shareMethod = 'share_method';

  // Error parameters
  static const String errorCode = 'error_code';
  static const String errorMessage = 'error_message';
  static const String errorType = 'error_type';
  static const String errorContext = 'error_context';

  // Performance parameters
  static const String loadTimeMs = 'load_time_ms';
  static const String featureName = 'feature_name';

  // Navigation parameters
  static const String source = 'source';
  static const String destination = 'destination';
  static const String navigationMethod = 'navigation_method';
}

/// User properties for analytics
class UserProperties {
  static const String userType = 'user_type';
  static const String appVersion = 'app_version';
  static const String platform = 'platform';
  static const String language = 'language';
  static const String theme = 'theme';
  static const String firstLaunchDate = 'first_launch_date';
}

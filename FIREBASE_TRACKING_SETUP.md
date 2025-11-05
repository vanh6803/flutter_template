# Firebase Tracking Setup

This document describes how to set up Firebase tracking in your Flutter project.

## Firebase Configuration

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable Analytics and Crashlytics

### 2. Add Firebase Configuration Files

#### For Android:

1. Add your Android app in Firebase Console
2. Download `google-services.json`
3. Place it in `android/app/google-services.json`

#### For iOS:

1. Add your iOS app in Firebase Console
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/GoogleService-Info.plist`

#### For Web:

1. Add your Web app in Firebase Console
2. Copy the Firebase config
3. Update `web/index.html` with Firebase SDK

### 3. Enable Required Services

In Firebase Console:

- Enable **Analytics**
- Enable **Crashlytics**

## Available Tracking Features

### Automatic Tracking

- **Screen Views**: Automatically tracked when using `BaseState`
- **App Lifecycle**: Tracks app foreground/background states
- **Crashes**: Automatically captures and reports crashes

### Manual Tracking

All tracking methods are available through the `TrackingMixin`:

```dart
// Button taps
trackButtonTap('button_name');

// Feature usage
trackFeatureUsed('feature_name');

// Item selection
trackItemSelect('item_id', 'item_name');

// Search events
trackSearch('search_term');

// Navigation
trackNavigation('destination_screen');

// Errors
trackError('error_type', 'error_message');

// Custom events
trackCustomEvent('event_name', {'param': 'value'});
```

### User Management

```dart
final appTracking = ServiceLocator.get<AppTrackingService>();

// Set user ID
await appTracking.trackUserLogin('user_id', 'login_method');

// Set user properties
await appTracking.setUserType('premium');
await appTracking.setUserLanguage('en');

// Track user logout
await appTracking.trackUserLogout('user_id');
```

## Architecture

### Services

- `FirebaseTrackingService`: Core Firebase integration
- `AppTrackingService`: App-level tracking management
- `TrackingMixin`: Widget-level tracking helpers

### Constants

- `TrackingEvents`: Predefined event names
- `TrackingParameters`: Standard parameter keys
- `UserProperties`: User property names

### Base Integration

All screens extending `BaseState` automatically get:

- Screen view tracking
- Access to tracking methods via `TrackingMixin`
- Lifecycle management

## Usage Examples

### Screen Tracking

```dart
class MyScreenState extends BaseState<MyScreen> {
  @override
  String get screenName => 'MyScreen';

  @override
  String get screenClass => 'MyScreenWidget';

  // Screen view automatically tracked in onReady()
}
```

### Event Tracking

```dart
void _onButtonPressed() {
  // Your business logic
  setState(() {
    // Update UI
  });

  // Track the action
  trackButtonTap('my_button', additionalParams: {
    'screen_section': 'header',
    'user_type': 'premium',
  });
}
```

### Error Tracking

```dart
try {
  // Risky operation
  await riskyOperation();
} catch (e) {
  // Track the error
  trackError('api_error', e.toString(), errorCode: 'API001');

  // Handle the error
  showErrorMessage();
}
```

## Best Practices

1. **Consistent Naming**: Use predefined constants from `TrackingEvents` and `TrackingParameters`
2. **Meaningful Parameters**: Include context that helps with analysis
3. **Screen Names**: Use descriptive, consistent screen names
4. **Error Context**: Always include relevant context when tracking errors
5. **User Privacy**: Ensure compliance with privacy regulations

## Testing

The tracking system includes debug logging. In debug mode, all tracking calls will print to console for verification.

## Debugging

1. Check Firebase Console for real-time events
2. Use Firebase DebugView for testing
3. Monitor console logs in debug mode
4. Verify configuration files are properly placed

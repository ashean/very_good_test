# Application Logging

This directory contains logging utilities for consistent error reporting and debugging.

## Overview

The app uses a multi-layered logging approach:

1. **BlocObserver**: Automatically logs all bloc state changes and errors (configured in `bootstrap.dart`)
2. **FlutterError.onError**: Logs global Flutter framework errors
3. **AppLogger**: Custom utility for manual error logging in business logic

## AppLogger Usage

### Error Logging
```dart
import 'package:my_app/core/logging/app_logger.dart';

try {
  await riskyOperation();
} on Exception catch (e, stackTrace) {
  AppLogger.logError(
    'Operation failed',
    e,
    stackTrace,
    'MyClass', // Context for easier debugging
  );
  // Still show user-friendly error in UI
  showErrorDialog('Something went wrong');
}
```

### Other Log Levels
```dart
AppLogger.logWarning('Deprecated API used', 'UserService');
AppLogger.logInfo('User logged in', 'AuthService');
AppLogger.logDebug('Cache hit', 'DataManager');
```

## Viewing Logs

### During Development
```bash
# Start the app with logging
flutter run --target lib/main_development.dart -d chrome --web-port=8080

# In another terminal, view logs in real-time
flutter logs -d chrome
```

### Log Levels
- **ERROR (1000)**: Critical errors that need immediate attention
- **WARNING (900)**: Potential issues that should be investigated
- **INFO (800)**: General application flow information
- **DEBUG (700)**: Detailed debugging information

## Benefits

1. **Database Errors**: Migration and query errors are now logged to console
2. **Debugging**: Easier to diagnose issues during development
3. **Monitoring**: Centralized error tracking for future monitoring integration
4. **Context**: Each log includes the source class/component for easier debugging

## Implementation Notes

- Uses `dart:developer` log() function (same as bootstrap.dart)
- Maintains existing UI error display for users
- Includes stack traces for errors
- Contextual information helps identify error sources
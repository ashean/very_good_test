import 'dart:developer';

class AppLogger {
  static void logError(
    String message,
    Object error, [
    StackTrace? stackTrace,
    String? context,
  ]) {
    final logMessage = context != null ? '[$context] $message' : message;
    log(
      logMessage,
      error: error,
      stackTrace: stackTrace,
      level: 1000, // ERROR level
    );
  }

  static void logWarning(String message, [String? context]) {
    final logMessage = context != null ? '[$context] $message' : message;
    log(logMessage, level: 900); // WARNING level
  }

  static void logInfo(String message, [String? context]) {
    final logMessage = context != null ? '[$context] $message' : message;
    log(logMessage, level: 800); // INFO level
  }

  static void logDebug(String message, [String? context]) {
    final logMessage = context != null ? '[$context] $message' : message;
    log(logMessage, level: 700); // DEBUG level
  }
}

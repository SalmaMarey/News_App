// ignore_for_file: avoid_print

class ErrorHandler {
  static void handleError(dynamic error, [String message = 'Error']) {
    print('$message: $error');
  }
}

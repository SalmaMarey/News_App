// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
class APIResult {
  String error;
  bool hasError;
  dynamic data;
  APIResult({
    required this.error,
    required this.hasError,
    required this.data,
  });
}

class Failure {
  int code;
  String message;
  Failure({
    required this.code,
    required this.message,
  });
}

class AppConstants {
  static const int RESPONSE_CODE_SUCCESS = 200;
  static const int ERROR_NO_CONNECTION_CODE = 1000;
  static const int ERROR_NO_BODY_PARSING_CODE = 2000;
}

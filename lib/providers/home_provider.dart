import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/api_request.dart';
import '../models/news_model.dart';
import 'error_handler.dart';

class HomeProvider extends ChangeNotifier {
  List<Article> _news = [];
  List<Article> get news => _news;

  APIResult result = APIResult(
    error: '',
    hasError: false,
    data: null,
  );

  Future<void> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/top-headlines?country=us&apiKey=4de527cd36004c32a7690d285a34b5dd'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic>? articleList = responseBody['articles'];

        if (articleList != null) {
          _news = articleList.map((json) => Article.fromJson(json)).toList();
          result.hasError = false;
          result.data = _news;
          notifyListeners();
        } else {
          handleFetchError('No articles found in the response');
        }
      } else {
        handleFetchError(
          'Failed to load news',
        );
      }
    } on SocketException {
      handleFetchError('Connection failed',
          errorCode: AppConstants.ERROR_NO_CONNECTION_CODE);
    } catch (e) {
      ErrorHandler.handleError(e, 'Error');
    }
  }

  String? formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return null;
    final parsedDateTime = DateTime.parse(dateTimeString);
    return DateFormat.yMMMd().add_jm().format(parsedDateTime);
  }

  void handleFetchError(String errorMessage, {int? errorCode}) {
    result.hasError = true;
    result.error = errorMessage;
    notifyListeners();
    if (errorCode != null) {
      ErrorHandler.handleError(errorCode, errorMessage);
    } else {
      ErrorHandler.handleError(errorMessage);
    }
  }
}

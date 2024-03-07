// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model.dart';

import '../models/api_request.dart';
import 'error_handler.dart';

class SearchProvider extends ChangeNotifier {
  List<Article> _displayedArticles = [];
  final TextEditingController searchController = TextEditingController();

  List<Article> get displayedArticles => _displayedArticles;
  APIResult result = APIResult(
    error: '',
    hasError: false,
    data: null,
  );

  Future<void> fetchSearch(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/everything?q=$query&apiKey=4de527cd36004c32a7690d285a34b5dd'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('articles') &&
            responseBody['articles'] is List<dynamic>) {
          final List<dynamic> articleList = responseBody['articles'];
          _displayedArticles =
              articleList.map((json) => Article.fromJson(json)).toList();
          result.hasError = false;
          result.data = articleList;
        } else {
          print('Invalid response format: Expected a list of articles');
        }
      } else {
        handleFetchError(
          'Failed to load sources',
        );
      }
      notifyListeners();
    } on SocketException {
      handleFetchError('Connection failed',
          errorCode: AppConstants.ERROR_NO_CONNECTION_CODE);
    } catch (e) {
      ErrorHandler.handleError(e, 'Error');
    }
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

  void filterSearch(String query) {
    if (query.isEmpty) {
      _displayedArticles = [];
    } else {
      fetchSearch(query);
    }
  }
}

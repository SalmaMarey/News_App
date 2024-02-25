// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/news_model.dart';

class HomeProvider extends ChangeNotifier {
  List<Article> _news = [];

  List<Article> get news => _news;
  Future<void> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/top-headlines?country=us&apiKey=4de527cd36004c32a7690d285a34b5dd'),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic>? articleList = responseBody['articles'];

        if (articleList != null) {
          _news = List<Article>.from(
            articleList.map((json) => Article.fromJson(json)),
          );
          notifyListeners();
        } else {
          print('No articles found in the response');
        }
      } else {
        print('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

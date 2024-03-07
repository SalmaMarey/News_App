// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/api_request.dart';
import '../models/source_model.dart';
import 'error_handler.dart';

class SourceProvider extends ChangeNotifier {
  List<Sources> _sources = [];

  List<Sources> get sources => _sources;
  APIResult result = APIResult(
    error: '',
    hasError: false,
    data: null,
  );

  Future<void> fetchSources() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/top-headlines/sources?apiKey=4de527cd36004c32a7690d285a34b5dd'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic>? sourcesList = responseBody['sources'];

        if (sourcesList != null) {
          _sources = sourcesList.map((json) => Sources.fromJson(json)).toList();
          result.hasError = false;
          result.data = sources;
          notifyListeners();
        } else {
          print('No sources found in the response');
        }
      } else {
        ErrorHandler.handleError(
            'Failed to load sources', 'Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        ErrorHandler.handleError(
            'Connection failed', 'Please check your internet connection.');
      } else if (e is FormatException) {
        ErrorHandler.handleError(e, 'Format Exception');
      } else {
        ErrorHandler.handleError(e, 'Error');
      }
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
}

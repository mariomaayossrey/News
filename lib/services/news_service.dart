import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const apiKey = '88f48644c2c140a6ac94f0900aa50608';

  Future<NewsResponse> fetchNews({String query = 'Updated', int page = 1}) async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=$query&page=$page&pageSize=10&apiKey=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return NewsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
}
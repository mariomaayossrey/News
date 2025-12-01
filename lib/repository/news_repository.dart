import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../models/news_model.dart';

const apiKey = '88f48644c2c140a6ac94f0900aa50608';

class NewsRepository {
  late final Dio _dio;

  NewsRepository() {
    _dio = Dio();
    (_dio.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<NewsResponse> fetchNews({
    String query = 'technology',
    int page = 1,
  }) async {
    print('Fetching news');
    print('Query: $query');
    print('Page: $page');

    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': query,
          'page': page,
          'pageSize': 10,
          'apiKey': apiKey,
        },
      );

      print('\n================ RAW RESPONSE ================');
      print(' Status Code: ${response.statusCode}');
      print(' Data: ${response.data}');
      print('==============================================\n');

      return NewsResponse.fromJson(response.data);

    } on DioException catch (e) {
      print('\n================ DIO ERROR ================');
      print(' Message: ${e.message}');
      print(' Type: ${e.type}');
      print(' URI: ${e.requestOptions.uri}');
      print(' Data: ${e.response?.data}');
      print('============================================');

      throw Exception('Failed to load news: ${e.message}');
    }
  }
}

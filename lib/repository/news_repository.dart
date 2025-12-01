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
    print('Fetching news for query: $query, page: $page');

    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': query,
          'page': page,
          'pageSize': 10,
          'apiKey': apiKey,
          'language': 'en', // Add language parameter
          'sortBy': 'publishedAt', // Add sort parameter
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      print('\nRAW RESPONSE');
      print(' Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is! Map<String, dynamic>) {
          throw Exception('Invalid API response format');
        }

        if (data['status'] != 'ok') {
          final errorMessage = data['message'] ?? 'Unknown API error';
          throw Exception('API Error: $errorMessage');
        }

        return NewsResponse.fromJson(data);
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }

    } on DioException catch (e) {
      print('\n DIO ERROR ');
      print(' Message: ${e.message}');
      print(' Type: ${e.type}');
      print(' URI: ${e.requestOptions.uri}');
      print(' Response: ${e.response?.data}');

      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorMessage = errorData['message'] ?? e.message ?? 'Network error';
        throw Exception('Failed to load news: $errorMessage');
      }

      throw Exception('Failed to load news: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
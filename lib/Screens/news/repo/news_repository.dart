import 'package:dio/dio.dart';
import '../../../Errors/errors_rseponse.dart';
import 'models/news_model.dart';

class NewsRepository {
  final Dio _dio;

  NewsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<NewsResponse> fetchEverythingNews({
    String query = 'technology',
    String? language = 'en',
    String? sortBy = 'publishedAt',
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'apiKey': '88f48644c2c140a6ac94f0900aa50608',
          'q': query,
          'language': language,
          'sortBy': sortBy,
          'pageSize': pageSize,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return NewsResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          error: 'Failed to fetch news',
          description: 'Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ErrorResponse(
        error: 'Network error',
        description: e.message ?? 'Unknown error occurred',
      );
    } catch (e) {
      throw ErrorResponse(
        error: 'Unexpected error',
        description: e.toString(),
      );
    }
  }
}
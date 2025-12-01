class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    try {
      List<Article> articlesList = [];

      if (json['articles'] != null && json['articles'] is List) {
        final articlesJson = json['articles'] as List;

        for (var articleJson in articlesJson) {
          try {
            if (articleJson is Map<String, dynamic>) {
              articlesList.add(Article.fromJson(articleJson));
            }
          } catch (e) {
            print('Error parsing article: $e');
            // Skip invalid articles
          }
        }
      }

      return NewsResponse(
        status: json['status']?.toString() ?? 'unknown',
        totalResults: json['totalResults'] is int ? json['totalResults'] : 0,
        articles: articlesList,
      );
    } catch (e) {
      print('Error parsing NewsResponse: $e');
      // Return empty response instead of crashing
      return NewsResponse(
        status: 'error',
        totalResults: 0,
        articles: [],
      );
    }
  }
}

class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source'] ?? {}),
      author: json['author']?.toString() ?? 'Unknown Author',
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      urlToImage: json['urlToImage']?.toString() ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt']?.toString() ?? '') ??
          DateTime.now(),
      content: json['content']?.toString() ?? '',
    );
  }
}

class Source {
  final String id;
  final String name;

  Source({
    required this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Source',
    );
  }
}
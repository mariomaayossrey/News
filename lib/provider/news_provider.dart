import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/news_model.dart';
import '../repository/news_repository.dart';
import 'base_state.dart';
import 'base_viewmodel.dart';

class NewsViewModel extends BaseViewModel<List<Article>> {
  final NewsRepository repository;
  final String query;

  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;
  List<Article> _allArticles = [];

  NewsViewModel(this.repository, this.query) : super() {
    loadInitialNews();
  }

  Future<void> loadInitialNews() async {
    print('Loading initial news for: $query');

    setLoading();

    try {
      currentPage = 1;
      final response = await repository.fetchNews(query: query, page: currentPage);

      _allArticles = response.articles;

      if (_allArticles.isEmpty) {
        setData([]);
        hasMore = false;
        print('No articles found for query: $query');
      } else {
        setData(_allArticles);
        hasMore = response.articles.length == 10;
        print('Initial load complete: ${_allArticles.length} articles');
      }
    } catch (e) {
      print('Error in loadInitialNews: $e');
      setError(AppError(error: e.toString()));
    }
  }

  Future<void> loadMoreNews() async {
    if (!hasMore || isLoadingMore || state.isLoading) return;

    print('Loading more news... page ${currentPage + 1}');
    isLoadingMore = true;

    try {
      final nextPage = currentPage + 1;
      final response = await repository.fetchNews(query: query, page: nextPage);

      if (response.articles.isEmpty) {
        hasMore = false;
        print('No more articles available');
      } else {
        _allArticles = [..._allArticles, ...response.articles];
        setData(_allArticles);
        currentPage = nextPage;
        hasMore = response.articles.length == 10;
        print('Loaded ${response.articles.length} more articles');
      }
    } catch (e) {
      print('Error loading more news: $e');
      // Don't set error here to keep showing existing articles
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> refreshNews() async {
    print('Refreshing news...');
    await loadInitialNews();
  }
}

final newsRepositoryProvider = Provider((ref) => NewsRepository());

final newsProvider = StateNotifierProvider.autoDispose.family<NewsViewModel, BaseViewState<List<Article>>, String>(
      (ref, query) {
    final repository = ref.read(newsRepositoryProvider);
    return NewsViewModel(repository, query);
  },
);
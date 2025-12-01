import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/news_model.dart';
import '../repository/news_repository.dart';

class NewsNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  final NewsRepository repository;
  final String query;

  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  NewsNotifier(this.repository, this.query) : super(const AsyncValue.loading()) {
    loadInitialNews();
  }

  Future<void> loadInitialNews() async {
    print('🔄 Loading initial news...');
    state = const AsyncValue.loading();
    try {
      currentPage = 1;
      final response = await repository.fetchNews(query: query, page: currentPage);
      state = AsyncValue.data(response.articles);
      hasMore = response.articles.length == 10;
      print('Initial load complete: ${response.articles.length} articles');
    } catch (e, stackTrace) {
      print('Error in loadInitialNews: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loadMoreNews() async {
    if (!hasMore || isLoadingMore) return;

    print('📄 Loading more news... page ${currentPage + 1}');
    isLoadingMore = true;
    try {
      final nextPage = currentPage + 1;
      final response = await repository.fetchNews(query: query, page: nextPage);

      if (response.articles.isEmpty) {
        hasMore = false;
        print('⚠️ No more articles available');
      } else {
        final currentArticles = state.value ?? [];
        final newArticles = [...currentArticles, ...response.articles];
        state = AsyncValue.data(newArticles);
        currentPage = nextPage;
        hasMore = response.articles.length == 10;
        print('Loaded ${response.articles.length} more articles');
      }
    } catch (e) {
      print('Error loading more news: $e');
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

final newsProvider = StateNotifierProvider.autoDispose.family<NewsNotifier, AsyncValue<List<Article>>, String>(
      (ref, query) {
    final repository = ref.read(newsRepositoryProvider);
    return NewsNotifier(repository, query);
  },
);
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/news_model.dart';
import '../provider/news_provider.dart';
import '../widgets/news_card.dart';

class NewsScreen extends ConsumerStatefulWidget {
  final String query;

  const NewsScreen({super.key,  this.query='Updated'});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final notifier = ref.read(newsProvider(widget.query).notifier);
      notifier.loadMoreNews();
    }
  }

  Future<void> _onRefresh() async {
    try {
      await ref.read(newsProvider(widget.query).notifier).refreshNews();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider(widget.query));
    final notifier = ref.read(newsProvider(widget.query).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.query} News'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(newsState, notifier),
    );
  }

  Widget _buildBody(AsyncValue<List<Article>> state, NewsNotifier notifier) {
    return state.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading news...'),
          ],
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'Error Loading News',
              style: TextStyle(fontSize: 20, color: Colors.redAccent),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: notifier.refreshNews,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
      data: (articles) {
        if (articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.newspaper, size: 64, color: Colors.grey),
                const SizedBox(height: 20),
                const Text(
                  'No News Available',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Try refreshing or check your connection',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: notifier.refreshNews,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          enablePullDown: true,
          enablePullUp: true,
          onLoading: () async {
            await notifier.loadMoreNews();
            _refreshController.loadComplete();
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: articles.length + 1,
            itemBuilder: (context, index) {
              if (index < articles.length) {
                return NewsCard(article: articles[index]);
              } else {
                return notifier.hasMore
                    ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No more articles',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

}
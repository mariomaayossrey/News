import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Base/base_state.dart';
import '../Screens/news/repo/models/news_model.dart';
import '../Screens/news/repo/news_repository.dart';
import '../Screens/news/view_model/NewsViewModel.dart';


final newsProvider = Provider<NewsRepository>((ref) {
  return NewsRepository();
});

final newsViewModelProvider = StateNotifierProvider<NewsViewModel, BaseViewState<NewsResponse>>(
      (ref) {
    final repository = ref.watch(newsProvider);
    return NewsViewModel(repository);
  },
);
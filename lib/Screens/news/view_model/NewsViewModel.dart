import '../../../Base/base_state.dart';
import '../../../Base/base_viewmodel.dart';
import '../../../Errors/errors_rseponse.dart';
import '../repo/models/news_model.dart';
import '../repo/news_repository.dart';

class NewsViewModel extends BaseViewModel<NewsResponse> {
  final NewsRepository _repository;

  NewsViewModel(this._repository) : super(BaseViewState(data:null));

  List<Article> get articles => state.data?.articles ?? [];

  Future<void> fetchEverythingNews({
    String query = 'technology',
    String? language,
    String? sortBy,
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      isLoading = true;

      if (state.hasError) {
        state = state.copyWith(error: null);
      }

      final newsResponse = await _repository.fetchEverythingNews(
        query: query,
        language: language,
        sortBy: sortBy,
        pageSize: pageSize,
        page: page,
      );

      data = newsResponse;
    } catch (error) {
      if (error is ErrorResponse) {
        this.error = error;
      } else {
        this.error = ErrorResponse(
          error: 'Error',
          description: error.toString(),
        );
      }
    } finally {
      isLoading = false;
    }
  }
}
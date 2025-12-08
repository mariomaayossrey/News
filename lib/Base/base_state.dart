import '../Errors/errors_rseponse.dart';
class BaseViewState<T> {
  bool? isLoading;
  bool isSuccess;
  ErrorResponse? error;
  T? data;

  BaseViewState(
      {this.isLoading, this.isSuccess = false, this.error, this.data});

  get hasData => this.isSuccess && this.data != null;

  get hasError => error != null && error!.error!.isNotEmpty;

  BaseViewState<T> copyWith(
      {bool? isLoading, bool isSuccess = false, ErrorResponse? error, T? data}) {
    return BaseViewState<T>(
      data: data?? this.data,
      isLoading: isLoading,
      isSuccess: isSuccess,
      error: error,
    );
  }
}
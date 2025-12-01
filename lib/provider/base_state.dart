class AppError {
  final String error;
  final String txID;

  const AppError({required this.error, this.txID = ''});

  @override
  String toString() => error;
}

class BaseViewState<T> {
  final bool isLoading;
  final bool isSuccess;
  final AppError? error;
  final T? data;

  const BaseViewState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.data,
  });

  bool get hasData => data != null;

  bool get hasError => error != null;

  BaseViewState<T> copyWith({
    bool? isLoading,
    bool? isSuccess,
    AppError? error,
    T? data,
  }) {
    return BaseViewState<T>(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }

  factory BaseViewState.initial() {
    return const BaseViewState();
  }

  factory BaseViewState.loading() {
    return const BaseViewState(isLoading: true);
  }

  factory BaseViewState.success(T data) {
    return BaseViewState(isSuccess: true, data: data);
  }

  factory BaseViewState.error(AppError error) {
    return BaseViewState(error: error);
  }
}
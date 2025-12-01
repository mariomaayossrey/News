import 'package:flutter_riverpod/legacy.dart';
import 'base_state.dart';

abstract class BaseViewModel<T> extends StateNotifier<BaseViewState<T>> {
  BaseViewModel() : super(BaseViewState.initial());

  void setLoading() {
    state = BaseViewState.loading();
  }

  void setData(T data) {
    state = BaseViewState.success(data);
  }

  void setError(AppError error) {
    state = BaseViewState.error(error);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = BaseViewState.initial();
  }
}
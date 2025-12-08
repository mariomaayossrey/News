import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Errors/errors_rseponse.dart';
import 'base_state.dart';

class BaseViewModel<T> extends StateNotifier<BaseViewState<T>> {
  BaseViewModel(BaseViewState<T> viewState) : super(viewState);

  set data(T data) => state = state.copyWith(data: data, isSuccess: true);

  set isLoading(bool isLoading) => state = state.copyWith(isLoading: isLoading);

  set error(ErrorResponse error) => state = state.copyWith(error: error);
}

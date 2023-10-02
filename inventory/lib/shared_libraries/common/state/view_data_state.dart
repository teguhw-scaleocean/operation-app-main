import '../error/failure_response.dart';

enum ViewState { initital, loading, error, hasData, noData }

extension ViewStateExtension on ViewState {
  bool get isInitial => this == ViewState.initital;

  bool get isLoading => this == ViewState.loading;

  bool get isError => this == ViewState.error;

  bool get isHasData => this == ViewState.hasData;

  bool get isNoData => this == ViewState.noData;
}

class ViewData<T> {
  ViewState status;
  T? data;
  String message = "";
  FailureResponse? failure;

  ViewData._({
    required this.status,
    this.data,
    this.message = '',
    this.failure,
  });

  factory ViewData.initial() {
    return ViewData._(status: ViewState.initital);
  }

  factory ViewData.loading({String? message}) {
    return ViewData._(status: ViewState.loading, message: message ?? "");
  }

  factory ViewData.loaded({T? data}) {
    return ViewData._(status: ViewState.hasData, data: data);
  }

  factory ViewData.error({
    required String message,
    required FailureResponse? failure,
  }) {
    return ViewData._(
      status: ViewState.error,
      message: message,
      failure: failure,
    );
  }

  factory ViewData.noData({required String message}) {
    return ViewData._(status: ViewState.noData, message: message);
  }
}

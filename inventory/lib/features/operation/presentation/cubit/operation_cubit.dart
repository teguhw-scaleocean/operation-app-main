import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/env/env.dart';
import '../../../../domains/home/data/model/request/operation_request_dto.dart';
import '../../../../domains/home/domain/usecase/get_operation_backorder_usecase.dart';
import '../../../../domains/home/domain/usecase/get_operation_state_usecase.dart';
import '../../../../domains/home/domain/usecase/get_operation_usecase.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import 'operation_state.dart';

class OperationCubit extends Cubit<OperationState> {
  final GetOperationUsecase getOperationUsecase;
  final GetOperationStateUsecase getOperationStateUsecase;
  final GetOperationBackorderUsecase getOperationBackorderUsecase;
  final SharedPreferences sharedPreferences;

  OperationCubit(
      {required this.getOperationUsecase,
      required this.getOperationStateUsecase,
      required this.getOperationBackorderUsecase,
      required this.sharedPreferences})
      : super(OperationState(
          operationState: ViewData.initial(),
          operationReadyState: ViewData.initial(),
          operationWaitingState: ViewData.initial(),
          operationBackOrderState: ViewData.initial(),
        ));

  getOperationList({required int pickingTypeId}) async {
    emit(OperationState(
      operationState: ViewData.loading(),
      operationReadyState: ViewData.noData(message: 'No Data'),
      operationWaitingState: ViewData.noData(message: 'No Data'),
      operationBackOrderState: ViewData.noData(message: 'No Data'),
    ));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    OperationRequestDto params =
        OperationRequestDto(token: token, id: pickingTypeId);

    var result = await getOperationUsecase.call(params);

    return result.fold(
        (failure) => emit(OperationState(
              operationState: ViewData.error(
                  message: failure.errorMessage, failure: failure),
              operationReadyState: ViewData.noData(message: 'No Data'),
              operationWaitingState: ViewData.noData(message: 'No Data'),
              operationBackOrderState: ViewData.noData(message: 'No Data'),
            )),
        (data) => emit(
              OperationState(
                operationState: ViewData.loaded(data: data),
                operationReadyState: ViewData.noData(message: 'No Data'),
                operationWaitingState: ViewData.noData(message: 'No Data'),
                operationBackOrderState: ViewData.noData(message: 'No Data'),
              ),
            ));
  }

  getOperationReadyList({required int pickingTypeId}) async {
    emit(OperationState(
      operationReadyState: ViewData.loading(),
      operationState: ViewData.noData(message: 'No Data'),
      operationWaitingState: ViewData.noData(message: 'No Data'),
      operationBackOrderState: ViewData.noData(message: 'No Data'),
    ));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    OperationRequestStatusDto params = OperationRequestStatusDto(
        token: token, id: pickingTypeId, state: "assigned");

    var result = await getOperationStateUsecase.call(params);

    return result.fold(
        (failure) => emit(OperationState(
              operationReadyState: ViewData.error(
                  message: failure.errorMessage, failure: failure),
              operationState: ViewData.noData(message: 'No Data'),
              operationWaitingState: ViewData.noData(message: 'No Data'),
              operationBackOrderState: ViewData.noData(message: 'No Data'),
            )),
        (data) => emit(
              OperationState(
                operationReadyState: ViewData.loaded(data: data),
                operationState: ViewData.noData(message: 'No Data'),
                operationWaitingState: ViewData.noData(message: 'No Data'),
                operationBackOrderState: ViewData.noData(message: 'No Data'),
              ),
            ));
  }

  getOperationWaitingList({required int pickingTypeId}) async {
    emit(OperationState(
      operationWaitingState: ViewData.loading(),
      operationState: ViewData.noData(message: 'No Data'),
      operationReadyState: ViewData.noData(message: 'No Data'),
      operationBackOrderState: ViewData.noData(message: 'No Data'),
    ));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    OperationRequestStatusDto params = OperationRequestStatusDto(
        token: token, id: pickingTypeId, state: "confirmed");

    var result = await getOperationStateUsecase.call(params);

    return result.fold(
        (failure) => emit(OperationState(
              operationWaitingState: ViewData.error(
                  message: failure.errorMessage, failure: failure),
              operationState: ViewData.noData(message: 'No Data'),
              operationReadyState: ViewData.noData(message: 'No Data'),
              operationBackOrderState: ViewData.noData(message: 'No Data'),
            )),
        (data) => emit(
              OperationState(
                operationWaitingState: ViewData.loaded(data: data),
                operationState: ViewData.noData(message: 'No Data'),
                operationReadyState: ViewData.noData(message: 'No Data'),
                operationBackOrderState: ViewData.noData(message: 'No Data'),
              ),
            ));
  }

  getOperationBackOrderList({required int pickingTypeId}) async {
    emit(OperationState(
      operationBackOrderState: ViewData.loading(),
      operationState: ViewData.noData(message: 'No Data'),
      operationReadyState: ViewData.noData(message: 'No Data'),
      operationWaitingState: ViewData.noData(message: 'No Data'),
    ));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    OperationRequestBackOrderDto params = OperationRequestBackOrderDto(
        token: token, id: pickingTypeId, backorderId: false);

    var result = await getOperationBackorderUsecase.call(params);

    return result.fold(
        (failure) => emit(OperationState(
              operationBackOrderState: ViewData.error(
                  message: failure.errorMessage, failure: failure),
              operationState: ViewData.noData(message: 'No Data'),
              operationReadyState: ViewData.noData(message: 'No Data'),
              operationWaitingState: ViewData.noData(message: 'No Data'),
            )),
        (data) => emit(
              OperationState(
                operationBackOrderState: ViewData.loaded(data: data),
                operationState: ViewData.noData(message: 'No Data'),
                operationReadyState: ViewData.noData(message: 'No Data'),
                operationWaitingState: ViewData.noData(message: 'No Data'),
              ),
            ));
  }
}

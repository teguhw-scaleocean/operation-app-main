import 'package:equatable/equatable.dart';

import '../../../../domains/home/data/model/response/operation_response_dto.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';

class OperationState extends Equatable {
  final ViewData<OperationResponseDto> operationState;
  final ViewData<OperationResponseDto> operationReadyState;
  final ViewData<OperationResponseDto> operationWaitingState;
  final ViewData<OperationResponseDto> operationBackOrderState;

  const OperationState({
    required this.operationState,
    required this.operationReadyState,
    required this.operationWaitingState,
    required this.operationBackOrderState,
  });

  OperationState copyWith({
    ViewData<OperationResponseDto>? operationState,
    ViewData<OperationResponseDto>? operationReadyState,
    ViewData<OperationResponseDto>? operationWaitingState,
    ViewData<OperationResponseDto>? operationBackOrderState,
  }) {
    return OperationState(
      operationState: operationState ?? this.operationState,
      operationReadyState: operationReadyState ?? this.operationReadyState,
      operationWaitingState:
          operationWaitingState ?? this.operationWaitingState,
      operationBackOrderState:
          operationBackOrderState ?? this.operationBackOrderState,
    );
  }

  @override
  List<Object?> get props => [
        operationState,
        operationReadyState,
        operationWaitingState,
        operationBackOrderState
      ];
}

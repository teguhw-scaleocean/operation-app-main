import 'package:equatable/equatable.dart';

import '../../../../../domains/home/data/model/response/operation_response_dto.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';

class DetailState extends Equatable {
  final ViewData<OperationResponseDto> detailState;
  final ViewData<double> countItemState;

  const DetailState({required this.detailState, required this.countItemState});

  DetailState copyWith(
      {ViewData<OperationResponseDto>? detailState,
      ViewData<double>? countItemState}) {
    return DetailState(
        detailState: detailState ?? this.detailState,
        countItemState: countItemState ?? this.countItemState);
  }

  @override
  List<Object?> get props => [detailState, countItemState];
}

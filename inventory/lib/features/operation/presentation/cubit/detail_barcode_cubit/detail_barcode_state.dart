import 'package:equatable/equatable.dart';

import '../../../../../domains/home/data/model/response/operation_response_dto.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';

class DetailBarcodeState extends Equatable {
  final ViewData<OperationResponseDto> productState;
  final ViewData<dynamic> confirmState;

  const DetailBarcodeState(
      {required this.productState, required this.confirmState});

  DetailBarcodeState copyWith(
      {ViewData<OperationResponseDto>? productState,
      ViewData<dynamic>? confirmState}) {
    return DetailBarcodeState(
        productState: productState ?? this.productState,
        confirmState: confirmState ?? this.confirmState);
  }

  @override
  List<Object?> get props => [productState, confirmState];
}

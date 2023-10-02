import 'package:equatable/equatable.dart';

import '../../../../../domains/home/data/model/response/stock_opname_response_dto.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';

class StockCountSessionState extends Equatable {
  final ViewData<dynamic> stockCountSessionState;

  const StockCountSessionState({required this.stockCountSessionState});

  StockCountSessionState copyWith({
    ViewData<StockOpnameResponseDto>? stockOpnameState,
  }) {
    return StockCountSessionState(
      stockCountSessionState: stockOpnameState ?? stockCountSessionState,
    );
  }

  @override
  List<Object?> get props => [stockCountSessionState];
}

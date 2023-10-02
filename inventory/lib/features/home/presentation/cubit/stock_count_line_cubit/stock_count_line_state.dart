import 'package:equatable/equatable.dart';

import '../../../../../shared_libraries/common/state/view_data_state.dart';

class StockCountLineState extends Equatable {
  final ViewData<dynamic> countState;

  const StockCountLineState({required this.countState});

  StockCountLineState copyWith({
    ViewData<dynamic>? countState,
  }) {
    return StockCountLineState(
      countState: countState ?? this.countState,
    );
  }

  @override
  List<Object?> get props => [countState];
}

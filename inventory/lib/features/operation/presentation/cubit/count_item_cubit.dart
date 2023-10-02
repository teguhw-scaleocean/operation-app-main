import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared_libraries/common/state/view_data_state.dart';

part 'count_item_state.dart';

class CountItemCubit extends Cubit<double> {
  double initData;

  CountItemCubit({this.initData = 0.0}) : super(initData);

  void incrementData() => emit(state + 1);

  void decrementData() => emit(state - 1);

  void insertData({required double quantity}) => emit(quantity);

  @override
  void onChange(Change<double> change) {
    super.onChange(change);
    log(change.toString());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    log(error.toString());
  }
}

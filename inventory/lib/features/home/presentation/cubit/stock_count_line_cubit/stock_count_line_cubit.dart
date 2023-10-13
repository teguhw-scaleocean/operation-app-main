import 'package:bloc/bloc.dart';
import 'package:inventory/shared_libraries/common/error/failure_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/env/env.dart';
import '../../../../../domains/home/data/model/request/warehouse_request_dto.dart';
import '../../../../../domains/home/domain/usecase/get_stock_count_session_usecase.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';
import 'stock_count_line_state.dart';

class StockCountLineCubit extends Cubit<StockCountLineState> {
  final GetStockCountSessionUsecase getStockCountSessionUsecase;
  final SharedPreferences sharedPreferences;

  StockCountLineCubit(
      {required this.getStockCountSessionUsecase,
      required this.sharedPreferences})
      : super(StockCountLineState(countState: ViewData.initial()));

  updateStockSessionLines(
      {required int sessionId,
      required List<Map<String, dynamic>> sessionLinesRequestDto}) async {
    emit(StockCountLineState(countState: ViewData.loading()));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    WarehouseRequestDto params = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
          token: token,
          model: "scaleocean.inventory.count.session",
          method: "update_session_lines",
          args: [
            [sessionId],
            sessionLinesRequestDto
          ],
          context: Context(),
          service: "object",
        ));

    final result = await getStockCountSessionUsecase.call(params);
    return result.fold(
      (failure) => emit(StockCountLineState(
          countState:
              ViewData.error(message: failure.errorMessage, failure: failure))),
      (data) => emit(
        StockCountLineState(
          countState: ViewData.loaded(data: data),
        ),
      ),
    );
  }

  Future<bool> getDoneButtonSession({required int sessionId}) async {
    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    WarehouseRequestDto params = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
          token: token,
          model: "scaleocean.inventory.count.session",
          method: "validate_session",
          args: [
            [sessionId],
          ],
          context: Context(),
        ));

    final result = await getStockCountSessionUsecase.call(params);
    return result.fold((failure) {
      FailureResponse(errorMessage: failure.errorMessage);

      return false;
    }, (data) => true);
  }
}

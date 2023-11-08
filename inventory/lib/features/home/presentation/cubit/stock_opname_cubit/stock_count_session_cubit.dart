import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:inventory/shared_libraries/common/error/failure_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/env/env.dart';
import '../../../../../domains/home/data/model/request/warehouse_request_dto.dart';
import '../../../../../domains/home/domain/usecase/get_stock_count_session_usecase.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';
import 'stock_count_session_state.dart';

class StockCountSessionCubit extends Cubit<StockCountSessionState> {
  final GetStockCountSessionUsecase getStockCountSessionUsecase;
  final SharedPreferences sharedPreferences;

  StockCountSessionCubit(
      {required this.sharedPreferences,
      required this.getStockCountSessionUsecase})
      : super(
            StockCountSessionState(stockCountSessionState: ViewData.initial()));

  // bool isNotification = false;

  getStockCountSession(
      {List<int>? userId,
      int? warehouseId,
      int? sessionId,
      required bool isFindOne}) async {
    emit(StockCountSessionState(stockCountSessionState: ViewData.loading()));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    WarehouseRequestDto params = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
          token: token,
          model: "scaleocean.inventory.count.session",
          method: "get_inventory_count_session",
          args: (isFindOne)
              ? [
                  [],
                  [
                    ["id", "=", sessionId]
                  ]
                ]
              : [
                  [],
                  [
                    ["warehouse_id", "=", warehouseId],
                    ["user_ids", "=", userId]
                  ]
                ],
          context: Context(),
          // service: "object",
        ));

    var result = await getStockCountSessionUsecase.call(params);
    return result.fold(
        (failure) => emit(StockCountSessionState(
            stockCountSessionState: ViewData.error(
                message: failure.errorMessage, failure: failure))),
        (data) => emit(StockCountSessionState(
            stockCountSessionState: ViewData.loaded(data: data))));
  }

  Future<String> startButtonSession({required int stockSessionId}) async {
    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    WarehouseRequestDto params = WarehouseRequestDto(
      jsonrpc: "2.0",
      params: Params(
        token: token,
        model: "scaleocean.inventory.count.session",
        method: "start",
        args: [stockSessionId],
        context: Context(),
      ),
    );

    var result = await getStockCountSessionUsecase.call(params);
    return result.fold((failure) {
      return failure.errorMessage;
    }, (data) {
      if (!data.toString().contains('error') &&
          data.toString().contains('result')) {
        return data["result"].toString();
      } else {
        return data["error"]["data"]["message"].toString();
      }
    });
    // await Future.delayed(
    //     const Duration(milliseconds: 400), () => result = true);
    // log("result from cubit $result");
    // return result;
  }
}

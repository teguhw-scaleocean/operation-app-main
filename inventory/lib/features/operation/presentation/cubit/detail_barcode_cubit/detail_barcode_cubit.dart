import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/domains/home/data/model/request/warehouse_request_dto.dart';
import 'package:inventory/domains/home/domain/usecase/update_detail_usecase.dart';
import 'package:inventory/features/operation/presentation/cubit/detail_cubit/detail_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/env/env.dart';
import '../../../../../domains/home/data/model/request/operation_request_dto.dart';
import '../../../../../domains/home/domain/usecase/get_product_scan_usecase.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';
import '../../ui/operation_detail_screen.dart';
import 'detail_barcode_state.dart';

class DetailBarcodeCubit extends Cubit<DetailBarcodeState> {
  final GetProductScanUsecase productScanUsecase;
  final UpdateDetailUsecase updateDetailUsecase;
  final SharedPreferences sharedPreferences;

  DetailBarcodeCubit(
      {required this.productScanUsecase,
      required this.updateDetailUsecase,
      required this.sharedPreferences})
      : super(DetailBarcodeState(
            productState: ViewData.initial(),
            confirmState: ViewData.initial()));

  List<ItemProduct> dataItems = [];
  List<dynamic> dataProducts = [];
  List<ItemProduct> listProducts = [];

  getBarcode(BuildContext context, {required List<int> idProduct}) async {
    emit(DetailBarcodeState(
        productState: ViewData.loading(),
        confirmState: ViewData.noData(message: '')));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    DetailBarcodeRequestDto params =
        DetailBarcodeRequestDto(token: token, listProductId: idProduct);

    final result = await productScanUsecase.call(params);
    return result.fold(
        (failure) => emit(
              DetailBarcodeState(
                productState: ViewData.error(
                    message: failure.errorMessage, failure: failure),
                confirmState: ViewData.noData(message: ''),
              ),
            ), (data) {
      emit(
        DetailBarcodeState(
          productState: ViewData.loaded(data: data),
          confirmState: ViewData.noData(message: 'No Data'),
        ),
      );

      dataProducts = data.result;
      dataItems = BlocProvider.of<DetailCubit>(context)
          .listItemCount; // Data list count converted

      initData();
    });
  }

  updateProductDoneQty(
      {required int idStockPicking,
      required List<dynamic> listUpdateQuantity}) async {
    emit(DetailBarcodeState(
      productState: ViewData.initial(),
      confirmState: ViewData.loading(),
    ));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    WarehouseRequestDto params = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
          token: token,
          model: "stock.picking",
          method: "update_stock_move",
          args: [
            [
              idStockPicking,
            ],
           listUpdateQuantity
          ],
          context: Context(),
          service: "object",
        ));

    final result = await updateDetailUsecase.call(params);
    return result.fold(
      (failure) => emit(DetailBarcodeState(
          productState: ViewData.initial(),
          confirmState:
              ViewData.error(message: failure.errorMessage, failure: failure))),
      (data) => emit(
        DetailBarcodeState(
          productState: ViewData.initial(),
          confirmState: ViewData.loaded(data: data),
        ),
      ),
    );
  }

  initData() {
    if (dataProducts.isNotEmpty) {
      for (var e in dataItems) {
        for (var item in dataProducts) {
          log("dataProducts: ${dataProducts.map((e) => e.toString()).toList().toString()}");
          if (e.name == item["display_name"] && e.barcode != false) {
            e.id = item['id'];
            e.barcode = item['barcode'];
            log("item['barcode']: ${item['barcode']}");
          }
        }
      }

      log("dataItems ${dataItems.map((e) => e.toMap().toString()).toList().toString()}");
    }
  }
}

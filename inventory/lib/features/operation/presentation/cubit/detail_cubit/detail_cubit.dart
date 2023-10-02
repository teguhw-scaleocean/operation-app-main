import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/env/env.dart';
import '../../../../../domains/home/data/model/request/operation_request_dto.dart';
import '../../../../../domains/home/domain/usecase/get_detail_usecase.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';
import '../../ui/operation_detail_screen.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final GetDetailUsecase getDetailUsecase;
  final SharedPreferences sharedPreferences;

  DetailCubit({required this.getDetailUsecase, required this.sharedPreferences})
      : super(DetailState(
          detailState: ViewData.initial(),
          countItemState: ViewData.initial(),
        ));

  List<dynamic> dataDetail = [];
  List<ItemProduct> listItemCount = [];
  List<int> listProductIds = [];

  getDetailOperation({required List<dynamic> moveIdsWithoutPackage}) async {
    emit(DetailState(
        detailState: ViewData.loading(),
        countItemState: ViewData.noData(message: 'No Data')));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    DetailRequestDto params = DetailRequestDto(
        token: token, moveIdsWithoutPackage: moveIdsWithoutPackage);

    var result = await getDetailUsecase.call(params);

    return result.fold(
        (failure) => emit(DetailState(
            detailState:
                ViewData.error(message: failure.errorMessage, failure: failure),
            countItemState: ViewData.noData(message: 'No Data'))), (data) {
      emit(DetailState(
          detailState: ViewData.loaded(data: data),
          countItemState: ViewData.noData(message: 'No Data')));

      dataDetail = data.result;
      initData();
      getDataProductId(); // For getting list of product id then use it as params
    });
  }

  initData() {
    if (dataDetail.isNotEmpty) {
      for (var item in dataDetail) {
        var dataValue = ItemProduct(
          id: item['id'],
          idMoveWithoutPackage: item['id'],
          name: (item['product_id'] == false) ? '' : item['product_id'][1],
          isScanned: false,
          value: 0.0,
          barcode: '',
        );
        listItemCount.add(dataValue);
      }

      log("listItemCount ${listItemCount.map((e) => e.toMap()).toList().toString()}");
    }
  }

  getDataProductId() {
    if (dataDetail.isNotEmpty) {
      for (var item in dataDetail) {
        if (item['product_id'] != false) {
          int idProduct = item['product_id'][0];
          listProductIds.add(idProduct);
        }
      }
      log("listProductIds: ==== ${listProductIds.map((e) => e).toList().toString()}");
    }
  }
}

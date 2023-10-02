import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/env/env.dart';
import '../../../../domains/home/data/model/request/operation_request_dto.dart';
import '../../../../domains/home/data/model/request/user_request_dto.dart';
import '../../../../domains/home/data/model/response/overview_response_dto.dart';
import '../../../../domains/home/data/model/response/user_response_dto.dart';
import '../../../../domains/home/data/model/response/warehouse_response_dto.dart';
import '../../../../domains/home/domain/usecase/get_overview_usecase.dart';
import '../../../../domains/home/domain/usecase/get_user_usecase.dart';
import '../../../../domains/home/domain/usecase/get_warehouse_usecase.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../shared_libraries/utils/key_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetWarehouseUsecase getWarehouseUsecase;
  final GetOverviewUsecase getOverviewUsecase;
  final GetUserUsecase getUserUsecase;
  final SharedPreferences sharedPreferences;

  HomeCubit(
      {required this.getWarehouseUsecase,
      required this.getOverviewUsecase,
      required this.getUserUsecase,
      required this.sharedPreferences})
      : super(HomeState(
          warehouseState: ViewData.initial(),
          overviewState: ViewData.initial(),
          userState: ViewData.initial(),
          // operationState: ViewData.initial(),
        ));

  getListWarehouse() async {
    emit(
      HomeState(
        warehouseState: ViewData.loading(),
        overviewState: ViewData.noData(message: 'No Data'),
        userState: ViewData.noData(message: 'No Data'),
      ),
    );

    String params =
        "5fcc52f44fb5634d1047f176762bbf922084dc010ae77d9f590dbfbfc03ebb5c";

    var result = await getWarehouseUsecase.call(params);
    return result.fold(
        (failure) => emit(HomeState(
            warehouseState:
                ViewData.error(message: failure.errorMessage, failure: failure),
            overviewState: ViewData.noData(message: 'No Data'),
            userState: ViewData.noData(message: 'No Data'))), (data) {
      emit(
        HomeState(
            warehouseState: ViewData.loaded(data: data),
            overviewState: ViewData.noData(message: 'No Data'),
            userState: ViewData.noData(message: 'No Data')),
      );
    });
    // }
  }

  getListOverview({required int id}) async {
    emit(HomeState(
        overviewState: ViewData.loading(),
        warehouseState: ViewData.noData(message: 'No Data'),
        userState: ViewData.noData(message: 'No Data')));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';

    OperationRequestDto operationRequestDto =
        OperationRequestDto(token: token, id: id);

    var result = await getOverviewUsecase.call(operationRequestDto);
    return result.fold(
        (failure) => emit(HomeState(
            overviewState:
                ViewData.error(message: failure.errorMessage, failure: failure),
            warehouseState: ViewData.noData(message: 'No Data'),
            userState: ViewData.noData(message: 'No Data'))), (data) {
      emit(
        HomeState(
            overviewState: ViewData.loaded(data: data),
            warehouseState: ViewData.noData(message: 'No Data'),
            userState: ViewData.noData(message: 'No Data')),
      );
    });
  }

  getUser() async {
    emit(HomeState(
        warehouseState: ViewData.noData(message: 'No Data'),
        overviewState: ViewData.noData(message: 'No Data'),
        userState: ViewData.loading()));

    String token =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? '';
    String emailAddress = sharedPreferences.getString(KeyHelper.username) ?? '';

    UserRequestDto params =
        UserRequestDto(token: token, emailAddress: emailAddress);

    var result = await getUserUsecase.call(params);
    return result.fold(
      (failure) => emit(HomeState(
          warehouseState: ViewData.noData(message: 'Empty Data'),
          overviewState: ViewData.noData(message: 'Empty Data'),
          userState:
              ViewData.error(message: failure.errorMessage, failure: failure))),
      (data) => HomeState(
          userState: ViewData.loaded(data: data),
          warehouseState: ViewData.noData(message: 'No Data'),
          overviewState: ViewData.noData(message: 'No Data')),
    );
  }
}

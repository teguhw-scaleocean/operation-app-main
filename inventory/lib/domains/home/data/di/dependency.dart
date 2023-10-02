import 'package:inventory/domains/home/domain/usecase/get_product_scan_usecase.dart';
import 'package:inventory/domains/home/domain/usecase/get_stock_count_session_usecase.dart';
import 'package:inventory/domains/home/domain/usecase/update_detail_usecase.dart';

import '../../../../injections/injections.dart';
import '../../domain/repository/home_repository.dart';
import '../../domain/usecase/get_detail_usecase.dart';
import '../../domain/usecase/get_operation_backorder_usecase.dart';
import '../../domain/usecase/get_operation_state_usecase.dart';
import '../../domain/usecase/get_operation_usecase.dart';
import '../../domain/usecase/get_overview_usecase.dart';
import '../../domain/usecase/get_stock_opname_usecase.dart';
import '../../domain/usecase/get_user_usecase.dart';
import '../../domain/usecase/get_warehouse_usecase.dart';
import '../datasource/remote/home_remote_datasource.dart';
import '../repository/home_repostiroy_impl.dart';

class HomeDependency {
  HomeDependency() {
    _registerHomeRemoteDatasource();
    _registerHomeRepository();
    _registerHomeUsecase();
  }

  void _registerHomeRemoteDatasource() =>
      sl.registerLazySingleton<HomeRemoteDatasource>(
        () => HomeRemoteDatasourceImpl(
          dio: sl(),
        ),
      );

  void _registerHomeRepository() => sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
          homeRemoteDatasource: sl(),
        ),
      );

  void _registerHomeUsecase() {
    sl.registerLazySingleton<GetWarehouseUsecase>(
      () => GetWarehouseUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetOverviewUsecase>(
      () => GetOverviewUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetOperationUsecase>(
      () => GetOperationUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetOperationStateUsecase>(
      () => GetOperationStateUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetOperationBackorderUsecase>(
      () => GetOperationBackorderUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetDetailUsecase>(
      () => GetDetailUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetUserUsecase>(
      () => GetUserUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetStockOpnameUsecase>(
      () => GetStockOpnameUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetProductScanUsecase>(
      () => GetProductScanUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<UpdateDetailUsecase>(
      () => UpdateDetailUsecase(
        homeRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetStockCountSessionUsecase>(
      () => GetStockCountSessionUsecase(
        homeRepository: sl(),
      ),
    );
  }
}

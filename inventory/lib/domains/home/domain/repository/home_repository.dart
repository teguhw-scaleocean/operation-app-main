import 'package:dartz/dartz.dart';
import 'package:inventory/domains/home/data/model/request/warehouse_request_dto.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../data/model/request/operation_request_dto.dart';
import '../../data/model/request/user_request_dto.dart';
import '../../data/model/response/operation_response_dto.dart';
import '../../data/model/response/overview_response_dto.dart';
import '../../data/model/response/stock_opname_response_dto.dart';
import '../../data/model/response/user_response_dto.dart';
import '../../data/model/response/warehouse_response_dto.dart';

abstract class HomeRepository {
  const HomeRepository();

  Future<Either<FailureResponse, WarehouseResponseDto>> getWarehouse(
      {required WarehouseRequestDto warehouseRequestDto});

  Future<Either<FailureResponse, OverviewResponseDto>> getOverview(
      {required OperationRequestDto operationRequestDto});

  Future<Either<FailureResponse, OperationResponseDto>> getOperation(
      {required OperationRequestDto operationRequestDto});

  Future<Either<FailureResponse, OperationResponseDto>> getOperationByState(
      {required OperationRequestStatusDto operationRequestStatusDto});

  Future<Either<FailureResponse, OperationResponseDto>> getOperationBackOrder(
      {required OperationRequestBackOrderDto operationRequestBackOrderDto});

  Future<Either<FailureResponse, OperationResponseDto>> getDetail(
      {required DetailRequestDto detailRequestDto});

  Future<Either<FailureResponse, UserResponseDto>> getUser(
      {required UserRequestDto userRequestDto});

  Future<Either<FailureResponse, StockOpnameResponseDto>> getStockOpname(
      {required String token});

  Future<Either<FailureResponse, OperationResponseDto>> getProductScan(
      {required DetailBarcodeRequestDto detailBarcodeRequestDto});

  Future<Either<FailureResponse, dynamic>> updateProductQty(
      {required WarehouseRequestDto paramsDto});

  Future<Either<FailureResponse, dynamic>> stockCountSession(
      {required WarehouseRequestDto stockCountSessionDto});
}

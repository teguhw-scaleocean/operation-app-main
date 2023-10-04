import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/remote/home_remote_datasource.dart';
import '../model/request/operation_request_dto.dart';
import '../model/request/user_request_dto.dart';
import '../model/request/warehouse_request_dto.dart';
import '../model/response/operation_response_dto.dart';
import '../model/response/overview_response_dto.dart';
import '../model/response/stock_opname_response_dto.dart';
import '../model/response/user_response_dto.dart';
import '../model/response/warehouse_response_dto.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource homeRemoteDatasource;

  HomeRepositoryImpl({required this.homeRemoteDatasource});

  @override
  Future<Either<FailureResponse, WarehouseResponseDto>> getWarehouse(
      {required WarehouseRequestDto warehouseRequestDto}) async {
    try {
      final response = await homeRemoteDatasource.getWarehouse(
          warehouseRequestDto: warehouseRequestDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, OverviewResponseDto>> getOverview(
      {required OperationRequestDto operationRequestDto}) async {
    try {
      final response = await homeRemoteDatasource.getOverview(
          operationRequestDto: operationRequestDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, OperationResponseDto>> getOperation(
      {required OperationRequestDto operationRequestDto}) async {
    try {
      final response = await homeRemoteDatasource.getOperation(
          operationRequestDto: operationRequestDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, OperationResponseDto>> getOperationByState(
      {required OperationRequestStatusDto operationRequestStatusDto}) async {
    try {
      final response = await homeRemoteDatasource.getOperationByState(
          operationRequestStatusDto: operationRequestStatusDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, OperationResponseDto>> getOperationBackOrder(
      {required OperationRequestBackOrderDto
          operationRequestBackOrderDto}) async {
    try {
      final response = await homeRemoteDatasource.getOperationBackOrder(
          operationRequestBackOrderDto: operationRequestBackOrderDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, OperationResponseDto>> getDetail(
      {required DetailRequestDto detailRequestDto}) async {
    try {
      final response = await homeRemoteDatasource.getDetail(
          detailRequestDto: detailRequestDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, UserResponseDto>> getUser(
      {required UserRequestDto userRequestDto}) async {
    try {
      final response =
          await homeRemoteDatasource.getUser(userRequestDto: userRequestDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, StockOpnameResponseDto>> getStockOpname(
      {required String token}) async {
    try {
      final response = await homeRemoteDatasource.getStockOpname(token: token);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, OperationResponseDto>> getProductScan(
      {required DetailBarcodeRequestDto detailBarcodeRequestDto}) async {
    try {
      final response = await homeRemoteDatasource.getProductScan(
          detailBarcodeRequestDto: detailBarcodeRequestDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, dynamic>> updateProductQty(
      {required WarehouseRequestDto paramsDto}) async {
    try {
      final response =
          await homeRemoteDatasource.updateProductQty(paramsDto: paramsDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, dynamic>> stockCountSession(
      {required WarehouseRequestDto stockCountSessionDto}) async {
    try {
      final response = await homeRemoteDatasource.stockCountSession(
          stockCountSessionDto: stockCountSessionDto);

      return Right(response);
    } catch (e) {
      return Left(FailureResponse(errorMessage: e.toString()));
    }
  }
}

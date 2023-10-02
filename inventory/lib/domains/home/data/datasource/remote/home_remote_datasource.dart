import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../../core/network/env/env.dart';
import '../../model/request/operation_request_dto.dart';
import '../../model/request/user_request_dto.dart';
import '../../model/request/warehouse_request_dto.dart';
import '../../model/response/operation_response_dto.dart';
import '../../model/response/overview_response_dto.dart';
import '../../model/response/stock_opname_response_dto.dart';
import '../../model/response/user_response_dto.dart';
import '../../model/response/warehouse_response_dto.dart';

abstract class HomeRemoteDatasource {
  Future<WarehouseResponseDto> getWarehouse({required String token});

  Future<OverviewResponseDto> getOverview(
      {required OperationRequestDto operationRequestDto});

  Future<OperationResponseDto> getOperation(
      {required OperationRequestDto operationRequestDto});

  Future<OperationResponseDto> getOperationByState(
      {required OperationRequestStatusDto operationRequestStatusDto});

  Future<OperationResponseDto> getOperationBackOrder(
      {required OperationRequestBackOrderDto operationRequestBackOrderDto});

  Future<OperationResponseDto> getDetail(
      {required DetailRequestDto detailRequestDto});

  Future<UserResponseDto> getUser({required UserRequestDto userRequestDto});

  Future<StockOpnameResponseDto> getStockOpname({required String token});

  Future<dynamic> getProductScan(
      {required DetailBarcodeRequestDto detailBarcodeRequestDto});

  Future<dynamic> updateProductQty({required WarehouseRequestDto paramsDto});

  Future<dynamic> stockCountSession(
      {required WarehouseRequestDto stockCountSessionDto});
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final Dio dio;

  HomeRemoteDatasourceImpl({required this.dio});

  @override
  Future<WarehouseResponseDto> getWarehouse({required String token}) async {
    WarehouseRequestDto warehouseDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
            token: token,
            model: "stock.warehouse",
            method: "search_read",
            args: [],
            context: Context()));

    try {
      final response = await dio.post(
        AppConstants.appApi.warehouse,
        // options: Options(

        //   responseType: ResponseType.json,
        //   // followRedirects: true,
        //   // contentType: 'application/json',
        // ),
        data: warehouseDto.toJson(),
      );

      return WarehouseResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<OverviewResponseDto> getOverview(
      {required OperationRequestDto operationRequestDto}) async {
    WarehouseRequestDto paramsDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
            token: operationRequestDto.token,
            model: "stock.picking.type",
            method: "search_read",
            args: [
              [
                ["warehouse_id", "=", operationRequestDto.id]
              ]
            ],
            context: Context()));

    try {
      final response = await dio.post(AppConstants.appApi.warehouse,
          data: paramsDto.toJson());

      return OverviewResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<OperationResponseDto> getOperation(
      {required OperationRequestDto operationRequestDto}) async {
    WarehouseRequestDto paramsDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
            token: operationRequestDto.token,
            model: "stock.picking",
            method: "search_read",
            args: [
              [
                ["picking_type_id", "=", operationRequestDto.id],
                ["state", "!=", "done"],
                ["state", "!=", "draft"],
                ["state", "!=", "cancel"],
              ],
              [
                "id",
                "name",
                "partner_id",
                "state",
                "location_dest_id",
                "scheduled_date",
                "origin",
                "backorder_id",
                "move_ids_without_package"
              ]
            ],
            context: Context()));

    try {
      final response = await dio.post(AppConstants.appApi.warehouse,
          data: paramsDto.toJson());

      return OperationResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<OperationResponseDto> getOperationByState(
      {required OperationRequestStatusDto operationRequestStatusDto}) async {
    WarehouseRequestDto paramsDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
            token: operationRequestStatusDto.token,
            model: "stock.picking",
            method: "search_read",
            args: [
              [
                ["picking_type_id", "=", operationRequestStatusDto.id],
                ["state", "=", operationRequestStatusDto.state],
                ["state", "!=", "done"],
                ["state", "!=", "draft"],
                ["state", "!=", "cancel"],
              ],
              [
                "name",
                "partner_id",
                "state",
                "location_dest_id",
                "scheduled_date",
                "origin",
                "backorder_id",
                "move_ids_without_package"
              ]
            ],
            context: Context()));

    try {
      final response = await dio.post(AppConstants.appApi.warehouse,
          data: paramsDto.toJson());

      return OperationResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<OperationResponseDto> getOperationBackOrder(
      {required OperationRequestBackOrderDto
          operationRequestBackOrderDto}) async {
    WarehouseRequestDto paramsDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
            token: operationRequestBackOrderDto.token,
            model: "stock.picking",
            method: "search_read",
            args: [
              [
                ["picking_type_id", "=", operationRequestBackOrderDto.id],
                ["backorder_id", "!=", false],
                ["state", "!=", "done"],
                ["state", "!=", "draft"],
                ["state", "!=", "cancel"],
              ],
              [
                "name",
                "partner_id",
                "state",
                "location_dest_id",
                "scheduled_date",
                "origin",
                "backorder_id",
                "move_ids_without_package"
              ]
            ],
            context: Context()));

    try {
      final response = await dio.post(AppConstants.appApi.warehouse,
          data: paramsDto.toJson());

      return OperationResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<OperationResponseDto> getDetail(
      {required DetailRequestDto detailRequestDto}) async {
    WarehouseRequestDto paramsDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
            token: detailRequestDto.token,
            model: "stock.move",
            method: "search_read",
            args: [
              [
                ["id", "=", detailRequestDto.moveIdsWithoutPackage],
              ]
            ],
            context: Context()));

    try {
      final response = await dio.post(AppConstants.appApi.warehouse,
          data: paramsDto.toJson());

      return OperationResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<UserResponseDto> getUser(
      {required UserRequestDto userRequestDto}) async {
    WarehouseRequestDto paramsDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
            token: userRequestDto.token,
            model: "res.users",
            method: "search_read",
            args: [
              [
                ["email", "=", userRequestDto.emailAddress]
              ],
              [
                "id",
                "name",
                "email",
                "display_name",
                "contact_address_complete",
                "phone_sanitized"
              ]
            ],
            context: Context()));

    try {
      final response = await dio.post(AppConstants.appApi.warehouse,
          data: paramsDto.toJson());

      return UserResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<StockOpnameResponseDto> getStockOpname({required String token}) async {
    WarehouseRequestDto stockOpnameDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
            token: token,
            model: "stock.count.session",
            method: "search_read",
            args: [],
            context: Context()));

    try {
      final response = await dio.post(
        AppConstants.appApi.warehouse,
        data: stockOpnameDto.toJson(),
      );

      return StockOpnameResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future getProductScan(
      {required DetailBarcodeRequestDto detailBarcodeRequestDto}) async {
    WarehouseRequestDto paramsDto = WarehouseRequestDto(
        jsonrpc: "2.0",
        params: Params(
          token: detailBarcodeRequestDto.token,
          model: "product.product",
          method: "search_read",
          args: [
            [
              ["id", "=", detailBarcodeRequestDto.listProductId]
            ],
            [
              "id",
              "name",
              "display_name",
              "barcode",
              "code",
              "qty_available",
              "free_qty",
              "virtual_available",
              "incoming_qty",
              "outgoing_qty"
            ]
          ],
          context: Context(),
        ));

    try {
      final response = await dio.post(
        AppConstants.appApi.warehouse,
        data: paramsDto.toJson(),
      );

      return OperationResponseDto.fromJson(response.data);
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future updateProductQty({required WarehouseRequestDto paramsDto}) async {
    try {
      final response = await dio.post(
        AppConstants.appApi.warehouse,
        data: paramsDto.toJson(),
      );

      return response.data;
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future stockCountSession(
      {required WarehouseRequestDto stockCountSessionDto}) async {
    try {
      final response = await dio.post(
        AppConstants.appApi.warehouse,
        data: stockCountSessionDto.toJson(),
      );

      return response.data;
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}

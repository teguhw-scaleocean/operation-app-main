import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/domains/home/data/model/request/warehouse_request_dto.dart';
import 'package:inventory/domains/home/data/model/response/warehouse_response_dto.dart';
import 'package:inventory/domains/home/domain/repository/home_repository.dart';
import 'package:inventory/domains/home/domain/usecase/get_warehouse_usecase.dart';
import 'package:inventory/shared_libraries/common/error/failure_response.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helper/model/warehouse_response_dto.dart';

void main() => testGetWarehouseUseCase();

class MockHomeRepository extends Mock implements HomeRepository {}

void testGetWarehouseUseCase() {
  late final HomeRepository mockHomeRepository;
  late final GetWarehouseUsecase getWarehouseUsecase;

  setUpAll(() {
    mockHomeRepository = MockHomeRepository();
    getWarehouseUsecase =
        GetWarehouseUsecase(homeRepository: mockHomeRepository);
  });

  group('Get Warehouse Usecase', () {
    test('''Success \t
    GIVEN Right<WarehouseResponseDto> from HomeRepository
    WHEN call method execute
    THEN return Right<WarehouseResponseDto>
    ''', () async {
      String token =
          "5fcc52f44fb5634d1047f176762bbf922084dc010ae77d9f590dbfbfc03ebb5c";
      WarehouseRequestDto warehouseRequestDto = WarehouseRequestDto(
          jsonrpc: "2.0",
          params: Params(
              token: token,
              model: "stock.warehouse",
              method: "search_read",
              args: [
                [
                  ["company_id", "=", 1]
                ]
              ],
              context: Context()));

      /// GIVEN
      when(() => mockHomeRepository.getWarehouse(
              warehouseRequestDto: warehouseRequestDto))
          .thenAnswer((_) async => Right(warehouseResponseDtoDummy));

      /// WHEN
      final result = await getWarehouseUsecase.call(warehouseRequestDto);

      /// THEN
      expect(result, isA<Right>());
      expect(
          result.getOrElse(() =>
              const WarehouseResponseDto(jsonrpc: '', result: <Result>[])),
          isA<WarehouseResponseDto>());
      expect(
          result
              .getOrElse(() =>
                  const WarehouseResponseDto(jsonrpc: '', result: <Result>[]))
              .result
              .first
              .id,
          warehouseResponseDtoDummy.result.first.id);
    });

    test('''Failed \t
    GIVEN Left<Failure> from HomeRepository
    WHEN call method execute
    THEN return Left<Failure>
    ''', () async {
      String token =
          "5fcc52f44fb5634d1047f176762bbf922084dc010ae77d9f590dbfbfc03ebb5c";
      WarehouseRequestDto warehouseRequestDto = WarehouseRequestDto(
          jsonrpc: "2.0",
          params: Params(
              token: token,
              model: "stock.warehouse",
              method: "search_read",
              args: [
                [
                  ["company_id", "=", 1]
                ]
              ],
              context: Context()));

      /// GIVEN
      when(() => mockHomeRepository.getWarehouse(
              warehouseRequestDto: warehouseRequestDto))
          .thenAnswer(
              (_) async => const Left(FailureResponse(errorMessage: '')));

      /// WHEN
      final result = await getWarehouseUsecase.call(warehouseRequestDto);

      /// THEN
      expect(result, isA<Left>());
    });
  });
}

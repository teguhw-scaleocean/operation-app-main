import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/domains/home/data/datasource/remote/home_remote_datasource.dart';
import 'package:inventory/domains/home/data/model/response/warehouse_response_dto.dart';
import 'package:inventory/domains/home/data/repository/home_repostiroy_impl.dart';
import 'package:inventory/domains/home/domain/repository/home_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helper/model/warehouse_response_dto.dart';

void main() => testProductRepositoryTest();

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDatasource {}

void testProductRepositoryTest() {
  late final HomeRemoteDatasource mockHomeRemoteDataSource;
  late final HomeRepository homeRepository;
  String token = '';

  setUpAll(() {
    mockHomeRemoteDataSource = MockHomeRemoteDataSource();
    homeRepository =
        HomeRepositoryImpl(homeRemoteDatasource: mockHomeRemoteDataSource);
  });

  group('Home Repository Impl', () {
    test('''SUCCESS \t
    GIVEN Right<WarehouseResponseDto> from HomeRemoteDataSource
    WHEN getWarehouse method executed
    THEN return Right<WarehouseResponseDto>
    ''', () async {
      token =
          "5fcc52f44fb5634d1047f176762bbf922084dc010ae77d9f590dbfbfc03ebb5c";

      when(() => mockHomeRemoteDataSource.getWarehouse(token: token))
          .thenAnswer((_) async => Future.value(warehouseResponseDtoDummy));

      // WHEN
      final result = await homeRepository.getWarehouse(token: token);

      // THEN
      expect(result, isA<Right>());
      expect(
          result.getOrElse(
              () => WarehouseResponseDto(jsonrpc: '', result: <Result>[])),
          isA<WarehouseResponseDto>());
      expect(
          result
              .getOrElse(
                  () => WarehouseResponseDto(jsonrpc: '', result: <Result>[]))
              .result
              .first
              .id,
          warehouseResponseDtoDummy.result.first.id);
    });

    test('''Fail \t
  GIVEN Left<FailureResponse> from HomeRemoteDataSource
  WHEN getWarehouse method executed
  THEN return Left<FailureResponse>
''', () async {
      token =
          "5fcc52f44fb5634d1047f176762bbf922084dc010ae77d9f590dbfbfc03ebb5c";

      when(() => mockHomeRemoteDataSource.getWarehouse(token: token))
          .thenThrow(DioError(requestOptions: RequestOptions(path: '')));

      // WHEN
      final result = await homeRepository.getWarehouse(token: token);

      // THEN
      expect(result, isA<Left>());
    });
  });
}

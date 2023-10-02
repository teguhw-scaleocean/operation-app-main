import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/domains/home/data/datasource/remote/home_remote_datasource.dart';
import 'package:inventory/shared_libraries/common/error/failure_response.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helper/json_reader.dart';


void main() => testHomeRemoteDataSourceTest();

class DioAdapterMock extends Mock implements HttpClientAdapter {}

class RequestOptionMock extends Mock implements RequestOptions {}

void testHomeRemoteDataSourceTest() {
  final Dio dio = Dio();
  late DioAdapterMock dioAdapterMock;
  late final HomeRemoteDatasource homeRemoteDatasource;

  setUpAll(() {
    dioAdapterMock = DioAdapterMock();
    dio.httpClientAdapter = dioAdapterMock;
    homeRemoteDatasource = HomeRemoteDatasourceImpl(dio: dio);
    registerFallbackValue(RequestOptionMock());
  });

  test(''' Success \t
  GIVEN fetch data from api with result data
  WHEN getWarehouse method executed
  THEN return WarehouseResponseDto
''', () async {
    final responseJson = TestHelper.readJson('helper/json/warehouse.json');
    final httpResponse =
        ResponseBody.fromString(responseJson, HttpStatus.ok, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });

    when(() => dioAdapterMock.fetch(any(), any(), any()))
        .thenAnswer((invocation) async => httpResponse);

    String token =
        "5fcc52f44fb5634d1047f176762bbf922084dc010ae77d9f590dbfbfc03ebb5c";
    final result = await homeRemoteDatasource.getWarehouse(token: token);

    expect(result.result.length, 1);
  });

  test(''' Error \t
  GIVEN fetch data from api with error data
  WHEN getWarehouse method executed
  THEN throwsException
''', () async {
    String token = '';

    when(() => dioAdapterMock.fetch(any(), any(), any())).thenThrow(
        const FailureResponse(errorMessage: 'Internal Server Error'));

    token = "5fcc52f44fb5634d1047f176762bbf922084dc010ae77d9f590dbfbfc03ebb5c";
    // final result = await homeRemoteDatasource.getWarehouse(token: token);

    expect(
        // WHEN
        () => homeRemoteDatasource.getWarehouse(token: token),

        // THEN
        throwsException);
  });
}

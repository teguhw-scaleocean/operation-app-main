import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/domains/home/data/model/request/warehouse_request_dto.dart';
import 'package:inventory/domains/home/domain/usecase/get_overview_usecase.dart';
import 'package:inventory/domains/home/domain/usecase/get_user_usecase.dart';
import 'package:inventory/domains/home/domain/usecase/get_warehouse_usecase.dart';
import 'package:inventory/features/home/presentation/cubit/home_cubit.dart';
import 'package:inventory/shared_libraries/common/error/failure_response.dart';
import 'package:inventory/shared_libraries/common/state/view_data_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/model/warehouse_response_dto.dart';

class MockGetWarehouseUseCase extends Mock implements GetWarehouseUsecase {}

class MockGetUserUseCase extends Mock implements GetUserUsecase {}

class MockGetOverviewUseCase extends Mock implements GetOverviewUsecase {}

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() => testWarehouseCubit();

void testWarehouseCubit() {
  late final GetWarehouseUsecase mockGetWarehouseUseCase;
  late final GetOverviewUsecase mockOverviewUseCase;
  late final GetUserUsecase mockGetUserUseCase;
  late final SharedPreferences mockSharedPreferences;

  setUpAll(() {
    mockGetWarehouseUseCase = MockGetWarehouseUseCase();
    mockOverviewUseCase = MockGetOverviewUseCase();
    mockGetUserUseCase = MockGetUserUseCase();
    mockSharedPreferences = MockSharedPreference();
  });

  group('Warehouse Cubit', () {
    String token = '';
    blocTest<HomeCubit, HomeState>(
      'emits [] when nothing is added.',
      build: () => HomeCubit(
        getWarehouseUsecase: mockGetWarehouseUseCase,
        getOverviewUsecase: mockOverviewUseCase,
        getUserUsecase: mockGetUserUseCase,
        sharedPreferences: mockSharedPreferences,
      ),
      expect: () => [],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [loading and loaded] when getWarehouse is call',
      build: () {
        token =
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

        when(
          () => mockGetWarehouseUseCase.call(warehouseRequestDto),
        ).thenAnswer((_) async => Right(warehouseResponseDtoDummy));

        return HomeCubit(
          getWarehouseUsecase: mockGetWarehouseUseCase,
          getOverviewUsecase: mockOverviewUseCase,
          getUserUsecase: mockGetUserUseCase,
          sharedPreferences: mockSharedPreferences,
        );
      },
      act: (HomeCubit cubit) => cubit.getListWarehouse(companyId: 1),
      expect: () => [
        HomeState(
          warehouseState: ViewData.loading(),
          overviewState: ViewData.noData(message: 'No Data'),
          userState: ViewData.noData(message: 'No Data'),
        ),
        HomeState(
            warehouseState: ViewData.loaded(data: warehouseResponseDtoDummy),
            overviewState: ViewData.noData(message: 'No Data'),
            userState: ViewData.noData(message: 'No Data'))
      ],
      // verify: (cubit) => mockGetWarehouseUseCase.call(token)
    );

    blocTest<HomeCubit, HomeState>(
        'emits [loading and error] when getWarehouse is call',
        build: () {
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

          when(() => mockGetWarehouseUseCase.call(warehouseRequestDto))
              .thenAnswer(
                  (_) async => const Left(FailureResponse(errorMessage: '')));
          return HomeCubit(
              getWarehouseUsecase: mockGetWarehouseUseCase,
              getOverviewUsecase: mockOverviewUseCase,
              getUserUsecase: mockGetUserUseCase,
              sharedPreferences: mockSharedPreferences);
        },
        act: (cubit) => cubit.getListWarehouse(companyId: 1),
        expect: () => [
              HomeState(
                  warehouseState: ViewData.loading(message: 'Loading....'),
                  overviewState: ViewData.noData(message: 'No Data'),
                  userState: ViewData.noData(message: 'No Data')),
              HomeState(
                  warehouseState: ViewData.error(
                      message: '',
                      failure: const FailureResponse(
                          errorMessage: 'Error Warehouse')),
                  overviewState: ViewData.noData(message: 'No Data'),
                  userState: ViewData.noData(message: 'No Data'))
            ]);
  });
}

import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../../data/model/request/warehouse_request_dto.dart';
import '../../data/model/response/warehouse_response_dto.dart';
import '../repository/home_repository.dart';

class GetWarehouseUsecase
    extends UseCase<WarehouseResponseDto, WarehouseRequestDto> {
  final HomeRepository homeRepository;

  GetWarehouseUsecase({required this.homeRepository});

  @override
  Future<Either<FailureResponse, WarehouseResponseDto>> call(
          WarehouseRequestDto params) async =>
      await homeRepository.getWarehouse(warehouseRequestDto: params);
}

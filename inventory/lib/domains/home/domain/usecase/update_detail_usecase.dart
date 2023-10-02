import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../../data/model/request/warehouse_request_dto.dart';
import '../repository/home_repository.dart';

class UpdateDetailUsecase extends UseCase<dynamic, WarehouseRequestDto> {
  final HomeRepository homeRepository;

  UpdateDetailUsecase({required this.homeRepository});

  @override
  Future<Either<FailureResponse, dynamic>> call(
          WarehouseRequestDto params) async =>
      await homeRepository.updateProductQty(paramsDto: params);
}

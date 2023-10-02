import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../../data/model/request/warehouse_request_dto.dart';
import '../repository/home_repository.dart';

class GetStockCountSessionUsecase
    extends UseCase<dynamic, WarehouseRequestDto> {
  final HomeRepository homeRepository;

  GetStockCountSessionUsecase({required this.homeRepository});

  @override
  Future<Either<FailureResponse, dynamic>> call(WarehouseRequestDto params) async =>
      await homeRepository.stockCountSession(stockCountSessionDto: params);
}

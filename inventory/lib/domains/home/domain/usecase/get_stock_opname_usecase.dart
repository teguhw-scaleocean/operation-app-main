
import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../../data/model/response/stock_opname_response_dto.dart';
import '../repository/home_repository.dart';

class GetStockOpnameUsecase extends UseCase<StockOpnameResponseDto, String> {
  final HomeRepository homeRepository;

  GetStockOpnameUsecase({required this.homeRepository});

  @override
  Future<Either<FailureResponse, StockOpnameResponseDto>> call(
          String params) async => await homeRepository.getStockOpname(token: params);
}

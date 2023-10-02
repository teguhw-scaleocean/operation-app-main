import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../../data/model/request/operation_request_dto.dart';
import '../../data/model/response/overview_response_dto.dart';
import '../repository/home_repository.dart';

class GetOverviewUsecase
    extends UseCase<OverviewResponseDto, OperationRequestDto> {
  final HomeRepository homeRepository;

  GetOverviewUsecase({required this.homeRepository});

  @override
  Future<Either<FailureResponse, OverviewResponseDto>> call(
          OperationRequestDto params) async =>
      await homeRepository.getOverview(operationRequestDto: params);
}

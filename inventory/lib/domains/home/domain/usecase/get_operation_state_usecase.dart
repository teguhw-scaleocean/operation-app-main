import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../../data/model/request/operation_request_dto.dart';
import '../../data/model/response/operation_response_dto.dart';
import '../repository/home_repository.dart';

class GetOperationStateUsecase
    extends UseCase<OperationResponseDto, OperationRequestStatusDto> {
  final HomeRepository homeRepository;

  GetOperationStateUsecase({required this.homeRepository});

  @override
  Future<Either<FailureResponse, OperationResponseDto>> call(
          OperationRequestStatusDto params) async =>
      await homeRepository.getOperationByState(
          operationRequestStatusDto: params);
}

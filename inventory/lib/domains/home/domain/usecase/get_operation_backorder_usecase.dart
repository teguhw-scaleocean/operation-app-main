import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../../data/model/request/operation_request_dto.dart';
import '../../data/model/response/operation_response_dto.dart';
import '../repository/home_repository.dart';

class GetOperationBackorderUsecase
    extends UseCase<OperationResponseDto, OperationRequestBackOrderDto> {
  final HomeRepository homeRepository;

  GetOperationBackorderUsecase({required this.homeRepository});

  @override
  Future<Either<FailureResponse, OperationResponseDto>> call(
          OperationRequestBackOrderDto params) async =>
      await homeRepository.getOperationBackOrder(operationRequestBackOrderDto: params);
}

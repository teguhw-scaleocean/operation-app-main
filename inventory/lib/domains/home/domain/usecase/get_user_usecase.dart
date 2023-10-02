import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../../data/model/request/user_request_dto.dart';
import '../../data/model/response/user_response_dto.dart';
import '../repository/home_repository.dart';

class GetUserUsecase extends UseCase<UserResponseDto, UserRequestDto> {
  final HomeRepository homeRepository;

  GetUserUsecase({required this.homeRepository});

  @override
  Future<Either<FailureResponse, UserResponseDto>> call(
          UserRequestDto params) async =>
      await homeRepository.getUser(userRequestDto: params);
}

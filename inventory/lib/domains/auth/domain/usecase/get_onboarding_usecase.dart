import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../repository/auth_repository.dart';

class GetOnBoardingUseCase extends UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  GetOnBoardingUseCase({required this.authRepository});

  @override
  Future<Either<FailureResponse, bool>> call(NoParams params) async =>
      await authRepository.getOnBoardingStatus();
}

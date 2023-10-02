import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../repository/auth_repository.dart';

class GetTokenUsecase extends UseCase<String, NoParams> {
  final AuthRepository authRepository;

  GetTokenUsecase({required this.authRepository});

  @override
  Future<Either<FailureResponse, String>> call(NoParams params) async =>
      await authRepository.getCachedToken();
}

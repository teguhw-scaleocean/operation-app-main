import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../repository/auth_repository.dart';

class CachedTokenUsecase extends UseCase<bool, String> {
  final AuthRepository authRepository;

  CachedTokenUsecase({required this.authRepository});

  @override
  Future<Either<FailureResponse, bool>> call(String params) async =>
      authRepository.cachedToken(token: params);
}

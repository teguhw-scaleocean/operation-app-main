import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../entity/request/auth_request_entity.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<FailureResponse, bool>> cacheOnBoardingStatus();

  Future<Either<FailureResponse, bool>> getOnBoardingStatus();

  Future<Either<FailureResponse, bool>> cachedToken({required String token});

  Future<Either<FailureResponse, String>> getCachedToken();

  Future<Either<FailureResponse, dynamic>> signIn(
      {required AuthRequestEntity authRequestEntity});
}

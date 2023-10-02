import 'package:dartz/dartz.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';
import '../entity/request/auth_request_entity.dart';
import '../repository/auth_repository.dart';

class SignInUseCase extends UseCase<dynamic, AuthRequestEntity> {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  @override
  Future<Either<FailureResponse, dynamic>> call(AuthRequestEntity params) async => await authRepository.signIn(authRequestEntity: params);
}

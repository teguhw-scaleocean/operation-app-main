import '../../../../injections/injections.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/cached_onboarding_usecase.dart';
import '../../domain/usecase/cached_token_usecase.dart';
import '../../domain/usecase/get_onboarding_usecase.dart';
import '../../domain/usecase/get_token_usecase.dart';
import '../../domain/usecase/sign_in_usecase.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../datasource/remote/auth_remote_datasource.dart';
import '../mapper/auth_mapper.dart';
import '../repository/auth_repository_impl.dart';

class AuthDependency {
  AuthDependency() {
    _registerAuthRemote();
    _registerAuthLocal();
    _registerAuthMapper();
    _registerAuthRepository();
    _registerUseCase();
  }

  void _registerAuthRemote() => sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
          dio: sl(),
          sharedPreferences: sl(),
        ),
      );

  void _registerAuthLocal() => sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
          sharedPreferences: sl(),
        ),
      );

  void _registerAuthMapper() => sl.registerLazySingleton<AuthMapper>(
        () => AuthMapper(),
      );

  void _registerAuthRepository() => sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          authMapper: sl(),
          authRemoteDataSource: sl(),
          authLocalDataSource: sl(),
        ),
      );

  void _registerUseCase() {
    sl.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(
        authRepository: sl(),
      ),
    );
    sl.registerLazySingleton<CachedOnboardingUsecase>(
      () => CachedOnboardingUsecase(
        authRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetOnBoardingUseCase>(
      () => GetOnBoardingUseCase(
        authRepository: sl(),
      ),
    );
    sl.registerLazySingleton<CachedTokenUsecase>(
      () => CachedTokenUsecase(
        authRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetTokenUsecase>(
      () => GetTokenUsecase(
        authRepository: sl(),
      ),
    );
  }
}

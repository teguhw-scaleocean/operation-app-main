import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../domain/entity/request/auth_request_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../datasource/remote/auth_remote_datasource.dart';
import '../mapper/auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final AuthMapper authMapper;

  AuthRepositoryImpl(
      {required this.authMapper,
      required this.authRemoteDataSource,
      required this.authLocalDataSource});

  @override
  Future<Either<FailureResponse, dynamic>> signIn(
      {required AuthRequestEntity authRequestEntity}) async {
    try {
      final response = await authRemoteDataSource.signIn(
          authRequestBodyDto: authMapper
              .mapAuthRequestEntityToAuthRequestDto(authRequestEntity));

      return Right(response);
    } on DioError catch (e) {
      return Left(
        FailureResponse(
          errorMessage: e.response.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<FailureResponse, bool>> cacheOnBoardingStatus() async {
    try {
      await authLocalDataSource.cacheOnBoarding();
      return const Right(true);
    } on Exception catch (error) {
      return Left(FailureResponse(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, bool>> getOnBoardingStatus() async {
    try {
      final response = await authLocalDataSource.getOnBoardingStatus();
      return Right(response);
    } on Exception catch (error) {
      return Left(FailureResponse(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, bool>> cachedToken(
      {required String token}) async {
    try {
      await authLocalDataSource.cacheToken(token: token);
      return const Right(true);
    } on Exception catch (error) {
      return Left(FailureResponse(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, String>> getCachedToken() async {
    try {
      final response = await authLocalDataSource.getToken();
      return Right(response);
    } on Exception catch (error) {
      return Left(FailureResponse(errorMessage: error.toString()));
    }
  }
}

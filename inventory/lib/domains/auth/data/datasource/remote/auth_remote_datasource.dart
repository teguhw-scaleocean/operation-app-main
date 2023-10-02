import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/env/env.dart';
import '../../../../../shared_libraries/utils/pref_helper.dart';
import '../../model/request/auth_request_body_dto.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<dynamic> signIn({required AuthRequestBodyDto authRequestBodyDto});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl(
      {required this.dio, required this.sharedPreferences});

  /// This [signIn] perform an fetch json call authentication
  @override
  Future<dynamic> signIn(
      {required AuthRequestBodyDto authRequestBodyDto}) async {
    try {
      Response response = await dio.post(AppConstants.appApi.signIn,
          data: authRequestBodyDto.toJson());

      if (response.data['result'] != null) {
        /// If result its not null,
        /// then it will store the data. Locally from the response token.
        await PreferenceHelper.saveUserCredential(sharedPreferences,
            authRequestBodyDto.params.login, response.data["result"]["token"]);
      }
      return response.data;
    } on DioError catch (error) {
      log(error.toString());
      return error.response?.data;
    }
  }
}

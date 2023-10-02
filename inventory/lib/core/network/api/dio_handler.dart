import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../env/env.dart';
import 'api_interceptors.dart';

class DioHandler {
  late String apiBaseUrl;
  late SharedPreferences sharedPreferences;

  DioHandler({
    required this.apiBaseUrl,
    required this.sharedPreferences,
  });

  Dio get dio => _getDio();

  Dio _getDio() {
    BaseOptions options = BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: 50000,
      receiveTimeout: 30000,
    );
    options.headers = _defaultHeader();
    final dio = Dio(options);
    dio.interceptors.add(ApiInterceptors());

    return dio;
  }

  Map<String, dynamic> _defaultHeader() {
    String authorizationToken =
        sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ??
            "notfound";
    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';
    // headers['api-key'] = AppConstants.cachedKey.apiKey;
    return headers;
  }
}

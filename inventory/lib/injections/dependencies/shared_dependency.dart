import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api/dio_handler.dart';
import '../../core/network/flavor/app_flavor.dart';
import '../injections.dart';

class SharedLibDependency {
  const SharedLibDependency();

  Future<void> registerCore() async {
    //// Shared Preference  Register
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);

    //// Dio Register
    sl.registerLazySingleton<Dio>(() => sl<DioHandler>().dio);
    sl.registerLazySingleton<DioHandler>(
      () => DioHandler(
        apiBaseUrl: Config.baseUrl,
        sharedPreferences: sl(),
      ),
    );
  }
}

import '../../core/navigation/navigation_helper.dart';
import '../../core/navigation/routes/auth_router/auth_router.dart';
import '../injections.dart';

class CommonDependency {
  CommonDependency() {
    _navigation();
    _routers();
  }

  void _navigation() =>
      sl.registerLazySingleton<NavigationHelper>(() => NavigationHelperImpl());

  void _routers() {
    sl.registerLazySingleton<AuthRouter>(
      () => AuthRouterImpl(
        navigationHelper: sl(),
      ),
    );

    //Add Other Router
  }
}

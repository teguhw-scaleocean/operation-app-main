
import '../../navigation_helper.dart';
import '../../routes.dart';

abstract class AuthRouter {
  void navigateToSignIn();

  Future<dynamic>? navigateToAllSignIn();

  void goBack({String? arguments});

  void navigateToHome();
}

class AuthRouterImpl implements AuthRouter {
  final NavigationHelper navigationHelper;

  AuthRouterImpl({required this.navigationHelper});

  @override
  void navigateToSignIn() =>
      navigationHelper.pushReplacementNamed(AppRoutes.signIn);

  @override
  void goBack({String? arguments}) => navigationHelper.pop(arguments);

  @override
  Future<dynamic>? navigateToAllSignIn() =>
      navigationHelper.pushNamedAndRemoveUntil(AppRoutes.signIn);

  @override
  void navigateToHome() => navigationHelper.pushReplacementNamed(AppRoutes.home);
}

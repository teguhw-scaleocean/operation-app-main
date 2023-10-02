class AppConstants {
  const AppConstants();

  static BaseEnvironment baseEnvironment = const BaseEnvironment();

  static Api appApi = const Api();

  static CachedKey cachedKey = const CachedKey();

  static ErrorMessage errorMessage = const ErrorMessage();
}

class BaseEnvironment {
  const BaseEnvironment();

  String get baseUrlProd => "https://inventory.demo.scaleocean.app";

  String get baseUrlDev => "https://inventory.dev.scaleocean.app";

  String get baseUrl => "";
}

class Api {
  const Api();

  String get signIn => '/json-call/user_authenticate';

  String get warehouse => '/json-call';
}

class CachedKey {
  const CachedKey();

  String get onBoardingKey => 'onBoardingKey';

  // String get apiKey => 'a398b1455c7248931b66dae30a8463e825828ed3';

  String get tokenKey => 'tokenKey';

  String get fcmToken => 'fcmToken';
}

class ErrorMessage {
  const ErrorMessage();

  String get usernameEmpty => "username must not empty";

  String get passwordEmpty => "password must not empty";

  String get confirmPasswordEmpty => "confirm password must not empty";

  String get confirmPasswordMustSame =>
      "password and confirm password must same";

  String get formNotEmpty => "username and password must not empty";

  String get failedGetOnBoarding => 'failed get onboarding status';

  String get failedGetToken => 'failed get onboarding status';

  String get fullNameEmpty => "full name must not empty";

  String get addressEmpty => "address must not empty";

  String get userProfileNotEmpty => "full name and address must not empty";
}

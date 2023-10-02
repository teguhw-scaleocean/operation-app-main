import 'dart:developer';

import 'package:inventory/shared_libraries/common/constants/resource_constants.dart';

import '../env/env.dart';

enum Flavor {
  development,
  production,
}

class Config {
  static Config? _instance;

  Config._internal() {
    _instance = this;
  }

  factory Config() => _instance ?? Config._internal();

  static Flavor? appFlavor;

  static bool get isDebug {
    if (appFlavor == Flavor.production) {
      return false;
    } else {
      return true;
    }
  }

  static String get baseUrl {
    if (appFlavor == Flavor.production) {
      log('ENV: PRODUCTION');
      return AppConstants.baseEnvironment.baseUrlProd;
    } else {
      log('ENV: DEVELOPMENT');
      return AppConstants.baseEnvironment.baseUrlDev;
    }
  }

  static String get db {
    if (appFlavor == Flavor.production) {
      return const ResourceConstants().baseDemoDb;
    } else {
      return const ResourceConstants().baseDevDb;
    }
  }
}

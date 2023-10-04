import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/env/env.dart';
import 'key_helper.dart';

class PreferenceHelper {
  static Future<void> saveUserCredential(
      SharedPreferences preferences, String username, String token) async {
    await preferences.setString(KeyHelper.username, username);
    await preferences.setString(KeyHelper.token, token);
    log("$username, $token");
  }

  static Future<void> saveUserResModel(
      SharedPreferences preferences, int companyId) async {
    await preferences.setInt(KeyHelper.companyId, companyId);
    log("saveUserResModel companyId: $companyId");
  }

  static Future<void> clearUserCredential(SharedPreferences preferences) async {
    await preferences.remove(KeyHelper.username);
    await preferences.remove(KeyHelper.token);
    await preferences.remove(KeyHelper.companyId);
    await preferences.remove(AppConstants.cachedKey.tokenKey);
    log('Success Remove');
  }
}

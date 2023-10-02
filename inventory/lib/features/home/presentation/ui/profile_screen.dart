import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../injections/injections.dart';
import '../../../../shared_libraries/utils/pref_helper.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final SharedPreferences sharedPreferences = sl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
            onTap: () async {
              await PreferenceHelper.clearUserCredential(sharedPreferences)
                  .then((value) => Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.signIn, (route) => false));
            },
            child: const Text('Profile Screen')),
      ),
    );
  }
}

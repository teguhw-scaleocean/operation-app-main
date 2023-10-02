// import 'dart:developer';

// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';

// class LocalAuthHelper {
//   static final _auth = LocalAuthentication();

//   static Future<bool> hasBiometrics() async {
//     try {
//       return await _auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       log(e.toString());
//       return false;
//     }
//   }

//   static Future<bool> scanFingerprint() async {
//     final isAvailable = await hasBiometrics();
//     if (!isAvailable) {
//       log(isAvailable.toString());
//       return false;
//     }
//     log(isAvailable.toString());

//     try {
//       return await _auth.authenticate(
//         localizedReason: 'Scan Fingerprint to Authenticate',
        
//       // );
//       options: const AuthenticationOptions(
//         stickyAuth: true,
//         useErrorDialogs: true,
//       ));
//     } on PlatformException catch (e) {
//       log(e.toString());
//       return false;
//     }
//   }
// }

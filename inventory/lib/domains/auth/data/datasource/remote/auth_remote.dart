
// class AuthNew {
//   Future<void> signIn(
//     String dbname,
//     String username,
//     String password,
//     bool persistSession, {
//     int retry = 0,
//   }) async {
//     emit(Authenticating());
//     final response = await authRepository.authenticate(
//       dbname: dbname,
//       username: username,
//       password: password,
//       persistSession: persistSession,
//     );

//     response.fold(
//       (Exception exception) {
//         if (retry < retryCount) {
//           return signIn(
//             dbname,
//             username,
//             password,
//             persistSession,
//             retry: retry + 1,
//           );
//         } else {
//           if (exception is SocketException) {
//             errorOnloginAttempt += 1;
//           }
//           final msg = _getLoginErrorMsg(exception);
//           emit(AuthenticationFailure(message: msg));
//           emit(NotAuthenticated());
//         }
//       },
//       (dynamic res) async {
//         if (res is OdooSession) {
//           errorOnloginAttempt = 0;
//           session = res;
//           await _saveSessionOffline();
//           await _saveInformationAccount(
//               dbname, username, password, persistSession);
//           emit(Authenticated(session: res));
// // partner_id
//         } else {
//           session = res.oldSession;
//           await _saveSessionOffline();
//           await _saveInformationAccount(
//               dbname, username, password, persistSession);
//           emit(Authenticated(
//             offlineSessionUid: (res as Credential).username,
//             offlineMode: true,
//             session: res.oldSession,
//           ));
//         }
//       },
//     );
//   }
// }

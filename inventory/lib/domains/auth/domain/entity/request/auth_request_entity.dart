class AuthRequestEntity {
  final String jsonrpc;
  final ParamsEntity params;

  AuthRequestEntity({
    required this.jsonrpc,
    required this.params,
  });
}

class ParamsEntity {
  final String login;
  final String password;
  final String db;

  ParamsEntity({
    required this.login,
    required this.password,
    required this.db,
  });
}

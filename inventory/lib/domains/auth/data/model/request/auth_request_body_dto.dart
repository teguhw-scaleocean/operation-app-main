class AuthRequestBodyDto {
  String jsonrpc;
  Params params;

  AuthRequestBodyDto({
    required this.jsonrpc,
    required this.params,
  });

  factory AuthRequestBodyDto.fromJson(Map<String, dynamic> json) =>
      AuthRequestBodyDto(
        jsonrpc: json["jsonrpc"],
        params: Params.fromJson(json["params"]),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "params": params.toJson(),
      };
}

class Params {
  String login;
  String password;
  String db;

  Params({
    required this.login,
    required this.password,
    required this.db,
  });

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        login: json["login"],
        password: json["password"],
        db: json["db"],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
        "password": password,
        "db": db,
      };
}

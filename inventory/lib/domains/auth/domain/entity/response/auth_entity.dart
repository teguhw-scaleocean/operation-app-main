class AuthEntity {
  String jsonrpc;
  dynamic id;
  ResultEntity result;

  AuthEntity({
    required this.jsonrpc,
    required this.id,
    required this.result,
  });
}

class ResultEntity {
  String token;
  int uid;
  bool globalToken;

  ResultEntity({
    required this.token,
    required this.uid,
    required this.globalToken,
  });
}

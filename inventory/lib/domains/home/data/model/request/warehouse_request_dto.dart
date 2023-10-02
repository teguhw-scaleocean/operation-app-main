class WarehouseRequestDto {
  String jsonrpc;
  Params params;

  WarehouseRequestDto({
    required this.jsonrpc,
    required this.params,
  });

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "params": params.toJson(),
      };
}

class Params {
  String token;
  String model;
  String method;
  List<dynamic> args;
  Context context;
  String? service;

  Params({
    required this.token,
    required this.model,
    required this.method,
    required this.args,
    required this.context,
    this.service,
  });

  Map<String, dynamic> toJson() => {
        "token": token,
        "model": model,
        "method": method,
        "args": List<dynamic>.from(args.map((x) => x)),
        "context": context.toJson(),
      };
}

class Context {
  Context();

  factory Context.fromJson(Map<String, dynamic> json) => Context();

  Map<String, dynamic> toJson() => {};
}

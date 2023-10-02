class AuthResponseDto {
    String jsonrpc;
    dynamic id;
    Result result;

    AuthResponseDto({
        required this.jsonrpc,
        this.id,
        required this.result,
    });

    factory AuthResponseDto.fromJson(Map<String, dynamic> json) => AuthResponseDto(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class Result {
    String token;
    int uid;
    bool globalToken;

    Result({
        required this.token,
        required this.uid,
        required this.globalToken,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        token: json["token"],
        uid: json["uid"],
        globalToken: json["global_token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "uid": uid,
        "global_token": globalToken,
    };
}

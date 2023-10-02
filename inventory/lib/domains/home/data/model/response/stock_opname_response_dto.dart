class StockOpnameResponseDto {
  String jsonrpc;
  dynamic id;
  List<dynamic> result;

  StockOpnameResponseDto({
    required this.jsonrpc,
    this.id,
    required this.result,
  });

  factory StockOpnameResponseDto.fromJson(Map<String, dynamic> json) =>
      StockOpnameResponseDto(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: List<dynamic>.from(
          (json['result'] as List<dynamic>),
        ),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

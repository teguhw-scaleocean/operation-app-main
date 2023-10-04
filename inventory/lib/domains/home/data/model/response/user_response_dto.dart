class UserResponseDto {
  String jsonrpc;
  dynamic id;
  List<ResultUser> result;

  UserResponseDto({
    required this.jsonrpc,
    this.id,
    required this.result,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) =>
      UserResponseDto(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: List<ResultUser>.from(
            json["result"].map((x) => ResultUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class ResultUser {
  int? id;
  String? name;
  String? email;
  String? displayName;
  String? contactAddressComplete;
  String? phoneSanitized;
  List<dynamic>? companyId;

  ResultUser(
      {this.id,
      this.name,
      this.email,
      this.displayName,
      this.contactAddressComplete,
      this.phoneSanitized,
      this.companyId});

  factory ResultUser.fromJson(Map<String, dynamic> json) => ResultUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        displayName: json["display_name"],
        contactAddressComplete: json["contact_address_complete"],
        phoneSanitized: json["phone_sanitized"],
        companyId: json["company_id"] == null
            ? []
            : List<dynamic>.from(json["company_id"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "display_name": displayName,
        "contact_address_complete": contactAddressComplete,
        "phone_sanitized": phoneSanitized,
        "company_id": companyId == null
            ? []
            : List<dynamic>.from(companyId!.map((x) => x)),
      };
}

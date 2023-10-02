// ignore_for_file: public_member_api_docs, sort_constructors_first
class UpdateSessionLinesRequestDto {
  int id;
  double quantity;
  bool isScan;

  UpdateSessionLinesRequestDto({
    required this.id,
    required this.quantity,
    required this.isScan,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'is_scan': isScan,
    };
  }

  factory UpdateSessionLinesRequestDto.fromJson(Map<String, dynamic> json) {
    return UpdateSessionLinesRequestDto(
      id: json['id'] as int,
      quantity: json['quantity'] as double,
      isScan: json['is_scan'] as bool,
    );
  }
}

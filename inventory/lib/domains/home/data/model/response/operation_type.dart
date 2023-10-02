// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OperationType {
  int pickingId;
  List<dynamic> moveIdsWithoutPackage;
  String location;
  String name;
  dynamic sku;
  String status;
  String date;
  bool isLate;
  bool isBackOrder;
  List<dynamic> backOrder;

  OperationType({
    required this.pickingId,
    required this.moveIdsWithoutPackage,
    required this.location,
    required this.name,
    required this.sku,
    required this.status,
    required this.date,
    required this.isLate,
    required this.isBackOrder,
    required this.backOrder,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pickingId': pickingId,
      'moveIdsWithoutPackage': moveIdsWithoutPackage,
      'location': location,
      'name': name,
      'sku': sku,
      'status': status,
      'date': date,
      'isLate': isLate,
      'isBackOrder': isBackOrder,
      'backOrder': backOrder,
    };
  }

  String toJson() => json.encode(toMap());
}

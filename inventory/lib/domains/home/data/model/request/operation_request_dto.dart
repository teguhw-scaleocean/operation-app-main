

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OperationRequestDto {
  String token;
  int id;

  OperationRequestDto({
    required this.token,
    required this.id,
  });
}

class OperationRequestStatusDto {
  int id;
  String token;
  String state;

  OperationRequestStatusDto({
    required this.id,
    required this.token,
    required this.state,
  });
}

class OperationRequestBackOrderDto {
  int id;
  String token;
  bool backorderId;

  OperationRequestBackOrderDto({
    required this.id,
    required this.token,
    required this.backorderId,
  });
}

class DetailRequestDto {
  // int id;
  String token;
  List<dynamic> moveIdsWithoutPackage;

  DetailRequestDto({
    // this.id,
    required this.token,
    required this.moveIdsWithoutPackage,
  });
}

class DetailBarcodeRequestDto {
  String token;
  List<int> listProductId;

  DetailBarcodeRequestDto({
    required this.token,
    required this.listProductId,
  });
}

class DetailWriteRequestDto {
  int idMove;
  double quantityValue;

  DetailWriteRequestDto({
    required this.idMove,
    required this.quantityValue,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': idMove,
      'qty_done': quantityValue,
    };
  }
}

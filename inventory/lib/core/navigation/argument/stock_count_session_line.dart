// ignore_for_file: public_member_api_docs, sort_constructors_first
class StockCountSessionLine {
  dynamic sessionId;

  StockCountSessionLine({
    required this.sessionId,
  });
}

class StockSessionLines {
  dynamic id;
  dynamic name;
  dynamic dateCreate;
  dynamic stockCountId;
  dynamic stockCountName;
  dynamic locationId;
  dynamic locationName;
  dynamic warehouseId;
  dynamic warehouseName;
  bool? useScanner;
  dynamic totalProductCount;
  dynamic totalScanCount;
  dynamic totalUnscanCount;
  dynamic type;
  dynamic state;
  List<UserId>? userIds;
  List<LineId>? lineIds;

  StockSessionLines({
    this.id,
    this.name,
    this.dateCreate,
    this.stockCountId,
    this.stockCountName,
    this.locationId,
    this.locationName,
    this.warehouseId,
    this.warehouseName,
    this.useScanner,
    this.totalProductCount,
    this.totalScanCount,
    this.totalUnscanCount,
    this.type,
    this.state,
    this.userIds,
    this.lineIds,
  });

  factory StockSessionLines.fromJson(Map<dynamic, dynamic> json) =>
      StockSessionLines(
        id: json["id"],
        name: json["name"],
        dateCreate: json["date_create"],
        stockCountId: json["stock_count_id"],
        stockCountName: json["stock_count_name"],
        locationId: json["location_id"],
        locationName: json["location_name"],
        warehouseId: json["warehouse_id"],
        warehouseName: json["warehouse_name"],
        useScanner: json["use_scanner"],
        totalProductCount: json["total_product_count"],
        totalScanCount: json["total_scan_count"],
        totalUnscanCount: json["total_unscan_count"],
        type: json["type"],
        state: json["state"],
        userIds: json["user_ids"] == null
            ? []
            : List<UserId>.from(
                json["user_ids"]!.map((x) => UserId.fromJson(x))),
        lineIds: json["session_line_ids"] == null
            ? []
            : List<LineId>.from(
                json["session_line_ids"]!.map((x) => LineId.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date_create": dateCreate,
        "stock_count_id": stockCountId,
        "stock_count_name": stockCountName,
        "location_id": locationId,
        "location_name": locationName,
        "warehouse_id": warehouseId,
        "warehouse_name": warehouseName,
        "use_scanner": useScanner,
        "total_product_count": totalProductCount,
        "total_scan_count": totalScanCount,
        "total_unscan_count": totalUnscanCount,
        "type": type,
        "state": state,
        "user_ids": userIds == null
            ? []
            : List<dynamic>.from(userIds!.map((x) => x.toJson())),
        "session_line_ids": lineIds == null
            ? []
            : List<dynamic>.from(lineIds!.map((x) => x.toJson())),
      };
}

class LineId {
  dynamic id;
  dynamic sessionId;
  dynamic locationId;
  dynamic locationName;
  dynamic productId;
  dynamic sku;
  dynamic productName;
  dynamic quantity;
  bool? isScan;

  LineId({
    this.id,
    this.sessionId,
    this.locationId,
    this.locationName,
    this.productId,
    this.sku,
    this.productName,
    this.quantity,
    this.isScan,
  });

  factory LineId.fromJson(Map<dynamic, dynamic> json) => LineId(
        id: json["id"],
        sessionId: json["session_id"],
        locationId: json["location_id"],
        locationName: json["location_name"],
        productId: json["product_id"],
        sku: json["sku"],
        productName: json["product_name"],
        quantity: json["quantity"],
        isScan: json["is_scan"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "session_id": sessionId,
        "location_id": locationId,
        "location_name": locationName,
        "product_id": productId,
        "sku": sku,
        "product_name": productName,
        "quantity": quantity,
        "is_scan": isScan,
      };
}

class UserId {
  dynamic id;
  dynamic name;

  UserId({
    this.id,
    this.name,
  });

  factory UserId.fromJson(Map<dynamic, dynamic> json) => UserId(
        id: json["id"],
        name: json["name"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

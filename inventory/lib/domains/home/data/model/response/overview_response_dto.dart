class OverviewResponseDto {
  String jsonrpc;
  dynamic id;
  List<ResultOverview> result;

  OverviewResponseDto({
    required this.jsonrpc,
    this.id,
    required this.result,
  });

  factory OverviewResponseDto.fromJson(Map<String, dynamic> json) =>
      OverviewResponseDto(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result:
            List<ResultOverview>.from(json["result"].map((x) => ResultOverview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class ResultOverview {
  int id;
  dynamic name;
  int color;
  int sequence;
  List<dynamic> sequenceId;
  dynamic sequenceCode;
  dynamic defaultLocationSrcId;
  dynamic defaultLocationDestId;
  dynamic code;
  dynamic returnPickingTypeId;
  dynamic showEntirePacks;
  List<dynamic> warehouseId;
  dynamic active;
  dynamic useCreateLots;
  dynamic useExistingLots;
  dynamic printLabel;
  dynamic showOperations;
  dynamic showReserved;
  dynamic reservationMethod;
  int reservationDaysBefore;
  int reservationDaysBeforePriority;
  int countPickingDraft;
  int countPickingReady;
  int countPicking;
  int countPickingWaiting;
  int countPickingLate;
  int countPickingBackorders;
  dynamic barcode;
  List<dynamic> companyId;
  DateTime lastUpdate;
  dynamic displayName;
  List<dynamic> createUid;
  DateTime createDate;
  List<dynamic> writeUid;
  DateTime writeDate;
  int countPickingBatch;
  int countPickingWave;

  ResultOverview({
    required this.id,
    required this.name,
    required this.color,
    required this.sequence,
    required this.sequenceId,
    required this.sequenceCode,
    required this.defaultLocationSrcId,
    required this.defaultLocationDestId,
    required this.code,
    required this.returnPickingTypeId,
    required this.showEntirePacks,
    required this.warehouseId,
    required this.active,
    required this.useCreateLots,
    required this.useExistingLots,
    required this.printLabel,
    required this.showOperations,
    required this.showReserved,
    required this.reservationMethod,
    required this.reservationDaysBefore,
    required this.reservationDaysBeforePriority,
    required this.countPickingDraft,
    required this.countPickingReady,
    required this.countPicking,
    required this.countPickingWaiting,
    required this.countPickingLate,
    required this.countPickingBackorders,
    required this.barcode,
    required this.companyId,
    required this.lastUpdate,
    required this.displayName,
    required this.createUid,
    required this.createDate,
    required this.writeUid,
    required this.writeDate,
    required this.countPickingBatch,
    required this.countPickingWave,
  });

  factory ResultOverview.fromJson(Map<String, dynamic> json) => ResultOverview(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        sequence: json["sequence"],
        sequenceId: List<dynamic>.from(json["sequence_id"].map((x) => x)),
        sequenceCode: json["sequence_code"],
        defaultLocationSrcId: json["default_location_src_id"],
        defaultLocationDestId: json["default_location_dest_id"],
        code: json["code"],
        returnPickingTypeId: json["return_picking_type_id"],
        showEntirePacks: json["show_entire_packs"],
        warehouseId: List<dynamic>.from(json["warehouse_id"].map((x) => x)),
        active: json["active"],
        useCreateLots: json["use_create_lots"],
        useExistingLots: json["use_existing_lots"],
        printLabel: json["print_label"],
        showOperations: json["show_operations"],
        showReserved: json["show_reserved"],
        reservationMethod: json["reservation_method"],
        reservationDaysBefore: json["reservation_days_before"],
        reservationDaysBeforePriority: json["reservation_days_before_priority"],
        countPickingDraft: json["count_picking_draft"],
        countPickingReady: json["count_picking_ready"],
        countPicking: json["count_picking"],
        countPickingWaiting: json["count_picking_waiting"],
        countPickingLate: json["count_picking_late"],
        countPickingBackorders: json["count_picking_backorders"],
        barcode: json["barcode"],
        companyId: List<dynamic>.from(json["company_id"].map((x) => x)),
        lastUpdate: DateTime.parse(json["__last_update"]),
        displayName: json["display_name"],
        createUid: List<dynamic>.from(json["create_uid"].map((x) => x)),
        createDate: DateTime.parse(json["create_date"]),
        writeUid: List<dynamic>.from(json["write_uid"].map((x) => x)),
        writeDate: DateTime.parse(json["write_date"]),
        countPickingBatch: json["count_picking_batch"],
        countPickingWave: json["count_picking_wave"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "sequence": sequence,
        "sequence_id": List<dynamic>.from(sequenceId.map((x) => x)),
        "sequence_code": sequenceCode,
        "default_location_src_id": defaultLocationSrcId,
        "default_location_dest_id": defaultLocationDestId,
        "code": code,
        "return_picking_type_id": returnPickingTypeId,
        "show_entire_packs": showEntirePacks,
        "warehouse_id": List<dynamic>.from(warehouseId.map((x) => x)),
        "active": active,
        "use_create_lots": useCreateLots,
        "use_existing_lots": useExistingLots,
        "print_label": printLabel,
        "show_operations": showOperations,
        "show_reserved": showReserved,
        "reservation_method": reservationMethod,
        "reservation_days_before": reservationDaysBefore,
        "reservation_days_before_priority": reservationDaysBeforePriority,
        "count_picking_draft": countPickingDraft,
        "count_picking_ready": countPickingReady,
        "count_picking": countPicking,
        "count_picking_waiting": countPickingWaiting,
        "count_picking_late": countPickingLate,
        "count_picking_backorders": countPickingBackorders,
        "barcode": barcode,
        "company_id": List<dynamic>.from(companyId.map((x) => x)),
        "__last_update": lastUpdate.toIso8601String(),
        "display_name": displayName,
        "create_uid": List<dynamic>.from(createUid.map((x) => x)),
        "create_date": createDate.toIso8601String(),
        "write_uid": List<dynamic>.from(writeUid.map((x) => x)),
        "write_date": writeDate.toIso8601String(),
        "count_picking_batch": countPickingBatch,
        "count_picking_wave": countPickingWave,
      };
}

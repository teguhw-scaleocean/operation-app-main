

import 'package:equatable/equatable.dart';

class WarehouseResponseDto extends Equatable {
  final String jsonrpc;
  final dynamic id;
  final List<Result> result;

  const WarehouseResponseDto({
    required this.jsonrpc,
    this.id,
    required this.result,
  });

  factory WarehouseResponseDto.fromJson(Map<String, dynamic> json) =>
      WarehouseResponseDto(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarehouseResponseDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          jsonrpc == other.jsonrpc &&
          result == other.result;


  @override
  List<Object?> get props => [jsonrpc, id, result];

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode ^ jsonrpc.hashCode ^ result.hashCode;


  // @override
  // // TODO: implement hashCode
  // int get hashCode => super.hashCode;

}

class Result {
  int id;
  String name;
  bool active;
  List<dynamic> companyId;
  List<dynamic> partnerId;
  List<dynamic> viewLocationId;
  List<dynamic> lotStockId;
  String code;
  List<int> routeIds;
  String receptionSteps;
  String deliverySteps;
  List<dynamic> whInputStockLocId;
  List<dynamic> whQcStockLocId;
  List<dynamic> whOutputStockLocId;
  List<dynamic> whPackStockLocId;
  List<dynamic> mtoPullId;
  List<dynamic> pickTypeId;
  List<dynamic> packTypeId;
  List<dynamic> outTypeId;
  List<dynamic> inTypeId;
  List<dynamic> intTypeId;
  List<dynamic> returnTypeId;
  List<dynamic> crossdockRouteId;
  List<dynamic> receptionRouteId;
  List<dynamic> deliveryRouteId;
  List<dynamic> resupplyWhIds;
  List<dynamic> resupplyRouteIds;
  int sequence;
  DateTime lastUpdate;
  String displayName;
  List<dynamic> createUid;
  DateTime createDate;
  List<dynamic> writeUid;
  DateTime writeDate;

  Result({
    required this.id,
    required this.name,
    required this.active,
    required this.companyId,
    required this.partnerId,
    required this.viewLocationId,
    required this.lotStockId,
    required this.code,
    required this.routeIds,
    required this.receptionSteps,
    required this.deliverySteps,
    required this.whInputStockLocId,
    required this.whQcStockLocId,
    required this.whOutputStockLocId,
    required this.whPackStockLocId,
    required this.mtoPullId,
    required this.pickTypeId,
    required this.packTypeId,
    required this.outTypeId,
    required this.inTypeId,
    required this.intTypeId,
    required this.returnTypeId,
    required this.crossdockRouteId,
    required this.receptionRouteId,
    required this.deliveryRouteId,
    required this.resupplyWhIds,
    required this.resupplyRouteIds,
    required this.sequence,
    required this.lastUpdate,
    required this.displayName,
    required this.createUid,
    required this.createDate,
    required this.writeUid,
    required this.writeDate,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        active: json["active"],
        companyId: List<dynamic>.from(json["company_id"].map((x) => x)),
        partnerId: List<dynamic>.from(json["partner_id"].map((x) => x)),
        viewLocationId:
            List<dynamic>.from(json["view_location_id"].map((x) => x)),
        lotStockId: List<dynamic>.from(json["lot_stock_id"].map((x) => x)),
        code: json["code"],
        routeIds: List<int>.from(json["route_ids"].map((x) => x)),
        receptionSteps: json["reception_steps"],
        deliverySteps: json["delivery_steps"],
        whInputStockLocId:
            List<dynamic>.from(json["wh_input_stock_loc_id"].map((x) => x)),
        whQcStockLocId:
            List<dynamic>.from(json["wh_qc_stock_loc_id"].map((x) => x)),
        whOutputStockLocId:
            List<dynamic>.from(json["wh_output_stock_loc_id"].map((x) => x)),
        whPackStockLocId:
            List<dynamic>.from(json["wh_pack_stock_loc_id"].map((x) => x)),
        mtoPullId: List<dynamic>.from(json["mto_pull_id"].map((x) => x)),
        pickTypeId: List<dynamic>.from(json["pick_type_id"].map((x) => x)),
        packTypeId: List<dynamic>.from(json["pack_type_id"].map((x) => x)),
        outTypeId: List<dynamic>.from(json["out_type_id"].map((x) => x)),
        inTypeId: List<dynamic>.from(json["in_type_id"].map((x) => x)),
        intTypeId: List<dynamic>.from(json["int_type_id"].map((x) => x)),
        returnTypeId: List<dynamic>.from(json["return_type_id"].map((x) => x)),
        crossdockRouteId:
            List<dynamic>.from(json["crossdock_route_id"].map((x) => x)),
        receptionRouteId:
            List<dynamic>.from(json["reception_route_id"].map((x) => x)),
        deliveryRouteId:
            List<dynamic>.from(json["delivery_route_id"].map((x) => x)),
        resupplyWhIds:
            List<dynamic>.from(json["resupply_wh_ids"].map((x) => x)),
        resupplyRouteIds:
            List<dynamic>.from(json["resupply_route_ids"].map((x) => x)),
        sequence: json["sequence"],
        lastUpdate: DateTime.parse(json["__last_update"]),
        displayName: json["display_name"],
        createUid: List<dynamic>.from(json["create_uid"].map((x) => x)),
        createDate: DateTime.parse(json["create_date"]),
        writeUid: List<dynamic>.from(json["write_uid"].map((x) => x)),
        writeDate: DateTime.parse(json["write_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "active": active,
        "company_id": List<dynamic>.from(companyId.map((x) => x)),
        "partner_id": List<dynamic>.from(partnerId.map((x) => x)),
        "view_location_id": List<dynamic>.from(viewLocationId.map((x) => x)),
        "lot_stock_id": List<dynamic>.from(lotStockId.map((x) => x)),
        "code": code,
        "route_ids": List<dynamic>.from(routeIds.map((x) => x)),
        "reception_steps": receptionSteps,
        "delivery_steps": deliverySteps,
        "wh_input_stock_loc_id":
            List<dynamic>.from(whInputStockLocId.map((x) => x)),
        "wh_qc_stock_loc_id": List<dynamic>.from(whQcStockLocId.map((x) => x)),
        "wh_output_stock_loc_id":
            List<dynamic>.from(whOutputStockLocId.map((x) => x)),
        "wh_pack_stock_loc_id":
            List<dynamic>.from(whPackStockLocId.map((x) => x)),
        "mto_pull_id": List<dynamic>.from(mtoPullId.map((x) => x)),
        "pick_type_id": List<dynamic>.from(pickTypeId.map((x) => x)),
        "pack_type_id": List<dynamic>.from(packTypeId.map((x) => x)),
        "out_type_id": List<dynamic>.from(outTypeId.map((x) => x)),
        "in_type_id": List<dynamic>.from(inTypeId.map((x) => x)),
        "int_type_id": List<dynamic>.from(intTypeId.map((x) => x)),
        "return_type_id": List<dynamic>.from(returnTypeId.map((x) => x)),
        "crossdock_route_id":
            List<dynamic>.from(crossdockRouteId.map((x) => x)),
        "reception_route_id":
            List<dynamic>.from(receptionRouteId.map((x) => x)),
        "delivery_route_id": List<dynamic>.from(deliveryRouteId.map((x) => x)),
        "resupply_wh_ids": List<dynamic>.from(resupplyWhIds.map((x) => x)),
        "resupply_route_ids":
            List<dynamic>.from(resupplyRouteIds.map((x) => x)),
        "sequence": sequence,
        "__last_update": lastUpdate.toIso8601String(),
        "display_name": displayName,
        "create_uid": List<dynamic>.from(createUid.map((x) => x)),
        "create_date": createDate.toIso8601String(),
        "write_uid": List<dynamic>.from(writeUid.map((x) => x)),
        "write_date": writeDate.toIso8601String(),
      };
}

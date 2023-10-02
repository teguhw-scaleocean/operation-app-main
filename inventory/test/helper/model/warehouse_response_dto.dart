import 'dart:convert';

import 'package:inventory/domains/home/data/model/response/warehouse_response_dto.dart';

import '../json_reader.dart';

final resultWarehouseDummyJson =
    json.decode(TestHelper.readJson('helper/json/warehouse.json'));

final WarehouseResponseDto warehouseResponseDtoDummy =
    WarehouseResponseDto.fromJson(resultWarehouseDummyJson);

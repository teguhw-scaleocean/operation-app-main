// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory/core/navigation/argument/stock_count_session_line.dart';
import 'package:inventory/core/navigation/argument/stock_session_detail_argument.dart';
import 'package:inventory/shared_libraries/component/custom_field.dart';
import 'package:inventory/shared_libraries/component/loading_overlay.dart';
import 'package:inventory/shared_libraries/component/primary_button.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../domains/home/data/model/request/update_session_lines_request_dto.dart';
import '../../../../shared_libraries/common/constants/resource_constants.dart';
import '../../../../shared_libraries/common/theme/theme.dart';
import '../../../../shared_libraries/component/general_dialog.dart';
import '../cubit/stock_count_line_cubit/stock_count_line_cubit.dart';

class StockCountSessionDetailScreen extends StatefulWidget {
  final StockSessionDetailArgument stockSessionDetailArgument;

  const StockCountSessionDetailScreen(
      {Key? key, required this.stockSessionDetailArgument})
      : super(key: key);

  @override
  State<StockCountSessionDetailScreen> createState() =>
      _StockCountSessionDetailScreenState();
}

class _StockCountSessionDetailScreenState
    extends State<StockCountSessionDetailScreen> {
  final LoadingOverlay _loadingOverlay = LoadingOverlay();
  TextEditingController controller = TextEditingController();
  late ScrollController scrollController;
  List<dynamic> listCount = [];
  List<ItemProduct>? listCountItems = [];
  List<ItemProduct>? listCountItemsPrevious = [];
  String quantity = '';
  bool isSubmitted = false;
  var isShowFab;
  String _scanBarcode = 'Unknown';
  late ItemProduct selectedItem;
  late StockSessionLines stockSessionLines;

  @override
  void initState() {
    super.initState();

    log(widget.stockSessionDetailArgument.isStartedButton.toString());
    stockSessionLines = StockSessionLines.fromJson(
        widget.stockSessionDetailArgument.stockSessionLines);
    log(widget.stockSessionDetailArgument.stockSessionLines.toString());
    listCountItems = stockSessionLines.lineIds?.map((e) {
      return ItemProduct(
          id: e.id,
          name: e.productName,
          value: (e.quantity == false) ? 0.0 : e.quantity,
          location: e.locationName,
          sku: e.sku,
          isScan: e.isScan!,
          serialNumber: '');
    }).toList();
    log(listCountItems!.map((e) => e.toJson()).toList().toString());

    listCountItemsPrevious = stockSessionLines.lineIds?.map((e) {
      return ItemProduct(
          id: e.id,
          name: e.productName,
          value: (e.quantity == false) ? 0.0 : e.quantity,
          location: e.locationName,
          sku: e.sku,
          isScan: e.isScan!,
          serialNumber: '');
    }).toList();

    scrollController = ScrollController();
    isShowFab = true;

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isShowFab == true) {
          setState(() {
            isShowFab = false;
          });
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isShowFab == false) {
          setState(() {
            isShowFab = true;
          });
        }
      }
    });
  }

  Future<bool> updateStockSessionLines(BuildContext context, int sessionId,
      List<Map<String, dynamic>> sessionLinesValue) async {
    context.read<StockCountLineCubit>().updateStockSessionLines(
        sessionId: sessionId, sessionLinesRequestDto: sessionLinesValue);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.stockSessionDetailArgument.isStartedButton) {
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(75.0),
            child: AppBar(
              backgroundColor: ColorName.whiteColor,
              leading: (widget.stockSessionDetailArgument.isStartedButton)
                  ? const SizedBox()
                  : InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: ColorName.blackColor,
                      ),
                    ),
              title: Text(
                'Inventory Session',
                style: BaseText.blackText16
                    .copyWith(fontWeight: BaseText.semiBold),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              elevation: 1,
              actions: [
                IconButton(
                    onPressed: () => scanBarcodeNormal(context),
                    icon: Image.asset(const AssetConstans().scanBarcode,
                        height: 24, width: 24))
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: ColorName.whiteColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCustomFieldDetail(
                            title: 'Session', value: stockSessionLines.name),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ColorName.doneColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              stockSessionLines.state.toString().toUpperCase(),
                              style: BaseText.whiteText12
                                  .copyWith(fontWeight: BaseText.medium),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    buildCustomFieldDetail(
                        title: 'Location',
                        value: stockSessionLines.locationName),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildFieldIconDetail(
                          title: 'Tanggal',
                          value: DateFormat("EEEE, d MMMM yyyy", "id_ID")
                              .format(DateTime.parse(stockSessionLines
                                  .dateCreate
                                  .substring(0, 10))),
                        ),
                        buildFieldIconDetail(
                          title: ' Jam',
                          value: stockSessionLines.dateCreate
                              .toString()
                              .substring(10, 16),
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          color: ColorName.borderNewColor,
                        )),
                    Text('Product',
                        style: BaseText.mainTextStyle16
                            .copyWith(fontWeight: BaseText.semiBold)),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        child: ListView.builder(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: listCountItems?.length,
                            itemBuilder: (context, index) {
                              // final item = listCount[index];
                              final itemProduct = listCountItems?[index];
                              // String productName =
                              //     listCount[index]['product_id'][1];

                              if (index == listCountItems!.length - 1) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  child:
                                      buildCountSection(context, itemProduct!),
                                );
                              } else {
                                return buildCountSection(context, itemProduct!);
                              }
                              // return Container();
                            }),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Visibility(
            visible: isShowFab,
            child: (isSubmitted)
                ? LoadingButton(
                    height: 36,
                    width: MediaQuery.of(context).size.width / 1.1,
                    title: 'Konfirmasi')
                : InkWell(
                    onTap: () {
                      List<Map<String, dynamic>> listToConfirm = [];

                      for (var e in listCountItemsPrevious!) {
                        for (var element in listCountItems!) {
                          final UpdateSessionLinesRequestDto
                              objectQuantityValue =
                              UpdateSessionLinesRequestDto(
                            id: element.id,
                            quantity: element.value,
                            isScan: element.isScan,
                          );

                          if (element.id == e.id && element.value != e.value) {
                            listToConfirm.add(objectQuantityValue.toJson());
                          }
                        }
                      }

                      log("listToConfirmA: ${listToConfirm.map((e) => e).toList().toString()}");

                      if (isSubmitted) {
                        return;
                      } else {
                        confirmToSubmitDialog(context, () {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (listToConfirm.isNotEmpty &&
                                listCountItems != listCountItemsPrevious) {
                              updateStockSessionLines(context,
                                      stockSessionLines.id, listToConfirm)
                                  .then((value) {
                                if (value) {
                                  setState(() {
                                    isSubmitted = true;
                                  });
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    var successSnackBar = SnackBar(
                                        content: Text('Success..',
                                            style: BaseText.whiteText14));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(successSnackBar);
                                  }).then((value) async {
                                    Navigator.maybePop(context);
                                    await Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.home,
                                        (route) => false,
                                        arguments: false);
                                  });
                                }
                              });
                            } else {
                              Navigator.maybePop(context);
                              var noDataSnackBar = SnackBar(
                                  content: Text('No quantity updated',
                                      style: BaseText.whiteText14));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(noDataSnackBar);
                            }
                          });
                        });
                      }
                    },
                    child: PrimaryButton(
                        height: 36,
                        width: MediaQuery.of(context).size.width / 1.1,
                        title: 'Konfirmasi'),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildCountSection(BuildContext context, ItemProduct item) {
    // TODO: Check Serial Number atau SKU ==> Barcode
    // TODO: Required field Serial Number dan field SKU di json

    quantity = item.value.toString();
    controller = TextEditingController(
      text: quantity,
    );

    log("quantity $quantity");
    return StatefulBuilder(builder: (context, countState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name.toString(),
            style: BaseText.blackText16.copyWith(fontWeight: BaseText.semiBold),
          ),
          Text(
            item.location,
            // '?????',
            style:
                BaseText.greyText14.copyWith(color: ColorName.borderNewColor),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // RichText(
              //     text: TextSpan(
              //         text: item.value.toString(),
              //         style: BaseText.blackText16
              //             .copyWith(fontWeight: BaseText.semiBold),
              //         children: [
              //       TextSpan(
              //         text: ' Qty',
              //         style: BaseText.greyText14.copyWith(
              //             color: ColorName.borderNewColor,
              //             fontWeight: BaseText.light),
              //       )
              //     ])),
              Row(
                children: [
                  (isSubmitted)
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            if (item.value > 0) {
                              countState(() {
                                item.value--;
                                quantity = item.value.toString();
                                controller = TextEditingController(
                                  text: quantity,
                                );
                              });
                              log(item.value.toString());
                            }
                          },
                          child: buildCountButton(
                              const Icon(
                                Icons.remove,
                                size: 16,
                              ),
                              isSubmitted),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: 20,
                      width: 68,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: TextField(
                          readOnly: isSubmitted,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          controller: controller,
                          style: BaseText.blackText16
                              .copyWith(fontWeight: BaseText.semiBold),
                          decoration: const InputDecoration(),
                          onSubmitted: (val) {
                            double itemField = double.parse(val);
                            item.value = itemField;
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]'),
                            ),
                            FilteringTextInputFormatter.deny(
                              RegExp(
                                  r'^0+'), //users can't type 0 at 1st position
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  (isSubmitted)
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            countState(() {
                              item.value++;
                              quantity = item.value.toString();
                              controller = TextEditingController(
                                text: quantity,
                              );
                            });
                            log(item.value.toString());
                          },
                          child: buildCountButton(
                              const Icon(
                                Icons.add,
                                size: 16,
                              ),
                              isSubmitted),
                        )
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              color: ColorName.borderNewColor,
            ),
          ),
        ],
      );
    });
  }

  Future<void> scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      log(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    selectedItem = listCountItems!.firstWhere(
        (element) => element.serialNumber
            .toString()
            .toLowerCase()
            .contains(_scanBarcode.toLowerCase()),
        orElse: () => ItemProduct(
            id: 001,
            name: '',
            value: 0.01,
            isScan: false,
            location: '',
            sku: 0,
            serialNumber: null));

    log("selectedItem ${selectedItem.toMap().toString()}");
    // } else
    if (selectedItem.sku == _scanBarcode ||
        selectedItem.serialNumber == _scanBarcode) {
      setState(() {
        selectedItem.value++;
        quantity = selectedItem.value.toString();
        controller = TextEditingController(
          text: quantity,
        );

        log(selectedItem.value.toString());
      });
      var successScanSnackBar = SnackBar(
          content: Text(const ResourceConstants().successScanText,
              style: BaseText.whiteText14));
      ScaffoldMessenger.of(context).showSnackBar(successScanSnackBar);
    } else {
      var errorSnackBar = SnackBar(
          content: Text(const ResourceConstants().errorScanText,
              style: BaseText.whiteText14));
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }
}

void _buildDisableCountQuantity(BuildContext context) {
  var errorSnackBar = SnackBar(
      content: Text(const ResourceConstants().disableCountQuantity,
          style: BaseText.whiteText14));
  ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
}

class ItemProduct {
  int id;
  String name;
  double value;
  bool isScan;
  String location;
  dynamic sku;
  dynamic serialNumber;

  ItemProduct({
    required this.id,
    required this.name,
    required this.value,
    required this.isScan,
    required this.location,
    required this.sku,
    required this.serialNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'value': value,
      'isScan': isScan,
      'location': location,
      'sku': sku,
      'serialNumber': serialNumber,
    };
  }

  factory ItemProduct.fromMap(Map<String, dynamic> map) {
    return ItemProduct(
      id: map['id'] as int,
      name: map['name'] as String,
      value: map['value'] as double,
      isScan: map['isScan'] as bool,
      location: map['location'] as String,
      sku: map['sku'] as dynamic,
      serialNumber: map['serialNumber'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemProduct.fromJson(String source) =>
      ItemProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}

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
import 'package:inventory/features/operation/presentation/cubit/detail_barcode_cubit/detail_barcode_cubit.dart';
import 'package:inventory/shared_libraries/component/general_dialog.dart';
import 'package:smooth_highlight/smooth_highlight.dart';

import '../../../../core/navigation/argument/operation_detail_argument.dart';
import '../../../../domains/home/data/model/request/operation_request_dto.dart';
import '../../../../shared_libraries/common/constants/resource_constants.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../shared_libraries/common/theme/theme.dart';
import '../../../../shared_libraries/component/custom_field.dart';
import '../../../../shared_libraries/component/loading_overlay.dart';
import '../../../../shared_libraries/component/primary_button.dart';
import '../../../../shared_libraries/component/title_appbar.dart';
import '../cubit/detail_barcode_cubit/detail_barcode_state.dart';
import '../cubit/detail_cubit/detail_cubit.dart';
import '../cubit/detail_cubit/detail_state.dart';

class OperationDetailScreen extends StatefulWidget {
  final OperationDetailArgument argument;

  const OperationDetailScreen({
    Key? key,
    required this.argument,
  }) : super(key: key);

  @override
  State<OperationDetailScreen> createState() => _OperationDetailScreenState();
}

class _OperationDetailScreenState extends State<OperationDetailScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController scanController = TextEditingController();
  late ScrollController scrollController;
  String _scanBarcode = 'Unknown';
  bool isSubmitted = false;
  bool isScroll = false;
  var isShowFab;
  late ItemProduct item;
  late ItemProduct selectedItem;
  late ItemProduct lastSelectedItem;
  var countItemState;
  String quantity = '';
  int productId = 0;
  int targetIndex = 1111;
  double productQty = 0.0;
  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  List<dynamic> dataDetail = [];
  // List<dynamic> listBarcode = [];
  List<ItemProduct> listProductQty = [];

  List<ItemProduct> listProductQtyBarcode = [];
  List<int> listIdProducts = [];
  List<ItemProduct> listSelectedItem = [];
  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
    log("this.pickTypeId: ${widget.argument.pickTypeId.toString()}");

    Future.delayed(const Duration(milliseconds: 550), getOperationDetail);

    isShowFab = true;
    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isShowFab == true) {
          setState(() {
            isShowFab = false;
          });
        }
      }

      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isShowFab == false) {
          setState(() {
            isShowFab = true;
          });
        }
      }
    });

    // log("key: ${key?.currentContext.toString()}");
  }

  getOperationDetail() {
    context.read<DetailCubit>().getDetailOperation(
        moveIdsWithoutPackage: widget.argument.moveIdsWithoutPackage);
  }

  getBarcode({required List<int> productIds}) {
    context
        .read<DetailBarcodeCubit>()
        .getBarcode(context, idProduct: productIds);
  }

  Future<bool> updateProductQty(
      {required int idStockPicking, required List<dynamic> list}) async {
    context.read<DetailBarcodeCubit>().updateProductDoneQty(
        idStockPicking: idStockPicking, listUpdateQuantity: list);

    log("eDto: ${list.map((e) => e.toString()).toList().toString()}");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<DetailBarcodeCubit, DetailBarcodeState>(
        listener: (context, state) {
          final statusProductBarcode = state.productState.status;
          final statusConfirm = state.confirmState.status;

          if (statusProductBarcode.isError) {
            var errorSnackBar = SnackBar(
                content: Text('${state.productState.failure?.errorMessage}',
                    style: BaseText.whiteText14));
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          } else if (statusConfirm.isError) {
            var errorConfirmSnackBar = SnackBar(
                content: Text('${state.confirmState.failure?.errorMessage}',
                    style: BaseText.whiteText14));
            ScaffoldMessenger.of(context).showSnackBar(errorConfirmSnackBar);
          } else if (statusProductBarcode.isLoading) {
            log('Product barcode loading...');
          } else if (statusProductBarcode.isNoData) {
            var errorSnackBar = SnackBar(
                content: Text('No Data Product Barcode',
                    style: BaseText.whiteText14));
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          } else if (statusProductBarcode.isHasData) {
            listProductQtyBarcode =
                context.read<DetailBarcodeCubit>().dataItems;

            log("listProductQtyBarcode: ${listProductQtyBarcode.map((e) => e.toJson()).toList().toString()}");
            // listBarcode = state.productState.data?.result ?? [];

            // log("barcode data ${listBarcode.map((e) => e["barcode"]).toList().toString()}");
          } else if (statusConfirm.isHasData) {
            var successConfirmSnackBar = SnackBar(
                content: Text(const ResourceConstants().successUpdateStock,
                    style: BaseText.whiteText14));
            ScaffoldMessenger.of(context).showSnackBar(successConfirmSnackBar);
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: ColorName.whiteColor,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: ColorName.blackColor,
                          size: 16,
                        )),
                    pinned: false,
                    floating: true,
                    snap: false,
                    expandedHeight: 58,
                    stretch: false,
                    automaticallyImplyLeading: true,
                    elevation: 0.5,
                    backgroundColor: ColorName.whiteColor,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: buildTitleAppBar(
                          context, "${widget.argument.titleAppBar} Detail"),
                    ),
                    centerTitle: true,
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: false,
                    snap: false,
                    expandedHeight: 75,
                    forceElevated: true,
                    backgroundColor: ColorName.whiteColor,
                    elevation: 0.5,
                    centerTitle: true,
                    title: buildScanPerItem(context, productQty),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 28),
                          child: BlocConsumer<DetailCubit, DetailState>(
                            listener: (context, state) {
                              final status = state.detailState.status;

                              if (status.isError) {
                                var errorSnackBar = SnackBar(
                                    content: Text(
                                        '${state.detailState.failure?.errorMessage}',
                                        style: BaseText.whiteText14));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(errorSnackBar);
                              } else if (status.isLoading) {
                                _loadingOverlay.show(context);
                              } else if (status.isHasData) {
                                _loadingOverlay.hide();
                                dataDetail =
                                    state.detailState.data?.result ?? [];
                                log(dataDetail.toString());
                                listProductQty =
                                    context.read<DetailCubit>().listItemCount;
                                listIdProducts =
                                    context.read<DetailCubit>().listProductIds;

                                Timer(const Duration(milliseconds: 800), () {
                                  if (listIdProducts.isNotEmpty) {
                                    getBarcode(productIds: listIdProducts);
                                  }
                                });
                              }
                            },
                            buildWhen: (previous, current) =>
                                previous != current,
                            builder: (context, state) {
                              final status = state.detailState.status;

                              if (status.isHasData) {
                                var pickNumber =
                                    (dataDetail.first['picking_id'] == false)
                                        ? ''
                                        : dataDetail.first['picking_id'];
                                var vendor =
                                    (dataDetail.first['partner_id'] == false)
                                        ? ''
                                        : dataDetail.first['partner_id'][1];
                                var destinationLocation =
                                    (dataDetail.first['location_dest_id'] ==
                                            false)
                                        ? ''
                                        : dataDetail.first['location_dest_id'];
                                String tanggal = dataDetail.first['date'];
                                var sourceLocation =
                                    (dataDetail.first['location_id'] == false)
                                        ? ''
                                        : dataDetail.first['location_id'];
                                productId =
                                    (dataDetail.first["product_id"] == false)
                                        ? 0
                                        : dataDetail.first["product_id"][0];

                                return Container(
                                  color: ColorName.whiteColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          buildCustomFieldDetail(
                                              title:
                                                  'Nomor ${widget.argument.titleAppBar}',
                                              value: pickNumber[1].toString()),
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: (widget
                                                            .argument.status ==
                                                        "Waiting")
                                                    ? ColorName.waitingColor
                                                    : (widget.argument.status ==
                                                            "Terlambat")
                                                        ? ColorName.lateColor
                                                        : (widget.argument
                                                                    .status ==
                                                                "Ready")
                                                            ? ColorName
                                                                .readyColor
                                                            : (widget.argument
                                                                        .status ==
                                                                    "Back Order")
                                                                ? ColorName
                                                                    .backOrderColor
                                                                : (widget.argument
                                                                            .status ==
                                                                        "done")
                                                                    ? ColorName
                                                                        .doneColor
                                                                    : ColorName
                                                                        .lightNewGreyColor,
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  child: Text(
                                                      "${widget.argument.status[0].toUpperCase()}${widget.argument.status.substring(1)}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: BaseText
                                                          .whiteText14
                                                          .copyWith(
                                                              fontWeight:
                                                                  BaseText
                                                                      .medium)),
                                                ),
                                              )),
                                        ],
                                      ),
                                      (vendor.toString().isEmpty)
                                          ? const SizedBox()
                                          : buildCustomFieldDetail(
                                              title: 'Vendor', value: vendor),
                                      // buildCustomFieldDetail(
                                      //     title: 'Customer', value: 'Pilastro'),
                                      buildCustomFieldDetail(
                                          title: 'Destination Location',
                                          value: destinationLocation.last),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          buildFieldIconDetail(
                                            title: 'Tanggal',
                                            value: DateFormat(
                                                    "EEEE, d MMMM yyyy",
                                                    "id_ID")
                                                .format(DateTime.parse(
                                                    tanggal.substring(0, 10))),
                                          ),
                                          buildFieldIconDetail(
                                            title: ' Jam',
                                            value: tanggal.substring(10, 16),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Divider(
                                          thickness: 2,
                                          color: ColorName.borderColor,
                                        ),
                                      ),
                                      buildLabelLocation(
                                          location: sourceLocation.last),
                                      const SizedBox(height: 12),
                                      NotificationListener<
                                              UserScrollNotification>(
                                          onNotification: (notification) {
                                            final ScrollDirection direction =
                                                notification.direction;

                                            setState(() {
                                              if (direction ==
                                                  ScrollDirection.reverse) {
                                                isShowFab = true;
                                                log(isShowFab.toString());
                                              } else if (direction ==
                                                  ScrollDirection.forward) {
                                                isShowFab = false;
                                                log(isShowFab.toString());
                                              }
                                            });
                                            return true;
                                          },
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: dataDetail.length,
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Divider(
                                                    thickness: 2,
                                                    color:
                                                        ColorName.borderColor,
                                                  ),
                                                );
                                              },
                                              itemBuilder: (context, index) {
                                                item = listProductQty[index];
                                                String productName = (dataDetail[
                                                                index]
                                                            ['product_id'][1] ==
                                                        false)
                                                    ? ''
                                                    : dataDetail[index]
                                                        ['product_id'][1];
                                                productQty = dataDetail[index]
                                                    ['product_qty'];
                                                // double itemCount = listProductQty[index];

                                                return buildCountSection(
                                                    context,
                                                    productName,
                                                    productQty,
                                                    item,
                                                    key,
                                                    index
                                                    // itemCount,
                                                    );
                                              })),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
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
                      onTap: () async {
                        List<Map<String, dynamic>> listProductQtyPrevious = [];
                        List<Map<String, dynamic>> listToConfirm = [];
                        for (var e in listProductQty) {
                          Map<String, dynamic> product = {
                            "id": e.idMoveWithoutPackage,
                            "qty_done": 0.0,
                          };
                          listProductQtyPrevious.add(product);
                        }

                        log("listProductQtyPrevious: ${listProductQtyPrevious.map((e) => e.toString()).toList().toString()}");

                        for (var e in listProductQtyPrevious) {
                          for (var element in listProductQty) {
                            final objectQuantityValue = DetailWriteRequestDto(
                              idMove: element.idMoveWithoutPackage,
                              quantityValue: element.value,
                            ).toMap();

                            if (element.idMoveWithoutPackage == e["id"] &&
                                element.value != e["qty_done"]) {
                              listToConfirm.add(objectQuantityValue);
                            }
                          }
                        }

                        log("listProduct: ${listProductQty.map((e) => e.toJson()).toList().toString()}");
                        log("listProductPrev: ${listProductQtyPrevious.map((e) => e['qty_done']).toList().toString()}");
                        log("listToConfirmA: ${listToConfirm.map((e) => e.toString()).toList().toString()}");

                        if (isSubmitted) {
                          return;
                        } else {
                          confirmToSubmitDialog(context, () {
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              if (listToConfirm.isNotEmpty) {
                                updateProductQty(
                                        idStockPicking:
                                            widget.argument.pickTypeId,
                                        list: listToConfirm)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      isSubmitted = true;
                                    });
                                    var successSnackBar = SnackBar(
                                        content: Text('Success..',
                                            style: BaseText.whiteText14));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(successSnackBar);
                                  }
                                });
                                Navigator.maybePop(context);
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
            )),
      ),
    );
  }

  Widget buildCountSection(BuildContext context, String? productName,
      double? productQty, ItemProduct item, key, int index) {
    quantity = item.value.toString();
    controller = TextEditingController(
      text: quantity,
    );
    return StatefulBuilder(builder: (context, countState) {
      countItemState = countState;
      return SmoothHighlight(
        enabled: index == targetIndex,
        color: ColorName.scannedColor,
        child: ListTile(
          key: index == targetIndex ? key : GlobalKey(),
          contentPadding: EdgeInsets.zero,
          title: Text(
            "${productName.toString()}\n",
            style: BaseText.blackText16.copyWith(fontWeight: BaseText.semiBold),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      text: productQty.toString(),
                      style: BaseText.blackText16
                          .copyWith(fontWeight: BaseText.semiBold),
                      children: [
                    TextSpan(
                      text: ' Qty',
                      style: BaseText.greyText14.copyWith(
                          color: ColorName.borderNewColor,
                          fontWeight: BaseText.light),
                    )
                  ])),
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
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        // child: Text(item.toString()),
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
        ),
      );
    });
  }

  Row buildScanPerItem(BuildContext context, double productQty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 48,
          width: MediaQuery.of(context).size.width - 90,
          child: TextField(
            // controller: scanController,
            style: BaseText.greyText16.copyWith(fontWeight: BaseText.semiBold),
            cursorColor: ColorName.mainColor,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: ColorName.mainColor,
                  ),
                ),
                focusColor: ColorName.mainColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: ColorName.lightNewGreyColor,
                  ),
                ),
                hintText: 'Masukkan barcode',
                hintStyle: BaseText.greyText14,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      color: ColorName.mainColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: ColorName.whiteColor,
                  ),
                )),
            onSubmitted: (value) {
              selectedItem = listProductQtyBarcode.firstWhere(
                  (element) => element.barcode
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase()),
                  orElse: () => ItemProduct(
                      id: 001,
                      idMoveWithoutPackage: 00000,
                      name: '',
                      isScanned: false,
                      value: 0.01,
                      barcode: "0"));

              targetIndex = listProductQty.indexWhere(
                (element) => element.barcode.toString().toLowerCase().contains(
                      value.toLowerCase(),
                    ),
              );

              log("selectedItem ${selectedItem.toMap().toString()}");
              log("targetIndex: $targetIndex");

              if (productQty == 0.0) {
                var failedSnackBar = SnackBar(
                    content: Text('Failed to scan, item not available',
                        style: BaseText.whiteText14));
                ScaffoldMessenger.of(context).showSnackBar(failedSnackBar);
              } else {
                if (value == selectedItem.barcode) {
                  // setState(() {
                  selectedItem.value++;
                  quantity = selectedItem.value.toString();
                  controller = TextEditingController(
                    text: quantity,
                  );
                  selectedItem.isScanned = true;
                  // });
                  // listProductQty.sort((a, b) => b.value.compareTo(a.value));
                  callSuccessScanMessage(context);
                  Timer(const Duration(seconds: 1), () {
                    Scrollable.ensureVisible(key.currentContext!,
                            // duration: const Duration(milliseconds: 80),
                            curve: Curves.fastOutSlowIn)
                        .then((value) => targetIndex = 11111);
                  });
                } else {
                  callErrorScanMessage(context);
                }
              }
            },
          ),
        ),
        InkWell(
            onTap: () => scanBarcodeNormal(context, item),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ColorName.mainColor, width: 1),
                  borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(const AssetConstans().scanBarcode,
                    height: 24, width: 24),
              ),
            ))
      ],
    );
  }

  void _buildDisableCountQuantity(BuildContext context) {
    var errorSnackBar = SnackBar(
        content: Text(const ResourceConstants().disableCountQuantity,
            style: BaseText.whiteText14));
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  Future<void> scanBarcodeNormal(
      BuildContext context, ItemProduct itemProduct) async {
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

    selectedItem = listProductQtyBarcode.firstWhere(
        (element) => element.barcode
            .toString()
            .toLowerCase()
            .contains(_scanBarcode.toLowerCase()),
        orElse: () => ItemProduct(
            id: 001,
            idMoveWithoutPackage: 00000,
            name: '',
            isScanned: false,
            value: 0.01,
            barcode: "0"));

    targetIndex = listProductQty.indexWhere(
      (element) => element.barcode.toString().toLowerCase().contains(
            _scanBarcode.toLowerCase(),
          ),
    );

    if (productQty == 0.0) {
      var failedSnackBar = SnackBar(
          content: Text('Failed to scan, item not available',
              style: BaseText.whiteText14));
      ScaffoldMessenger.of(context).showSnackBar(failedSnackBar);
    } else {
      log("selectedItem ${selectedItem.toMap().toString()}");
      if (selectedItem.barcode == _scanBarcode) {
        setState(() {
          // _scanBarcode = barcodeScanRes;
          selectedItem.value++;
          quantity = selectedItem.value.toString();
          controller = TextEditingController(
            text: quantity,
          );
          log(selectedItem.value.toString());
        });

        callSuccessScanMessage(context);
        Timer(const Duration(milliseconds: 20), () {
          Scrollable.ensureVisible(key.currentContext!,
                  duration: const Duration(milliseconds: 80),
                  curve: Curves.fastOutSlowIn)
              .then((value) => targetIndex = 1111);
        });
      } else {
        callErrorScanMessage(context);
      }
    }
  }

  void callErrorScanMessage(BuildContext context) {
    var errorSnackBar = SnackBar(
        content: Text(const ResourceConstants().errorScanText,
            style: BaseText.whiteText14));
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void callSuccessScanMessage(BuildContext context) {
    var successScanSnackBar = SnackBar(
        content: Text(const ResourceConstants().successScanText,
            style: BaseText.whiteText14));
    ScaffoldMessenger.of(context).showSnackBar(successScanSnackBar);
  }
}

class ItemProduct {
  int id;
  int idMoveWithoutPackage;
  String name;
  bool isScanned;
  double value;
  dynamic barcode;

  ItemProduct({
    required this.id,
    required this.idMoveWithoutPackage,
    required this.name,
    required this.isScanned,
    required this.value,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idMoveWithoutPackage': idMoveWithoutPackage,
      'name': name,
      'isScanned': isScanned,
      'value': value,
      'barcode': barcode,
    };
  }

  factory ItemProduct.fromMap(Map<String, dynamic> map) {
    return ItemProduct(
      id: map['id'] as int,
      idMoveWithoutPackage: map['idMoveWithoutPackage'] as int,
      name: map['name'] as String,
      isScanned: map['is_scanned'] as bool,
      value: map['value'] as double,
      barcode: map['barcode'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemProduct.fromJson(String source) =>
      ItemProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory/shared_libraries/common/state/view_data_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/navigation/argument/operation_argument.dart';
import '../../../../core/navigation/argument/operation_detail_argument.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../domains/home/data/model/response/operation_type.dart';
import '../../../../injections/injections.dart';
import '../../../../shared_libraries/common/constants/resource_constants.dart';
import '../../../../shared_libraries/common/theme/theme.dart';
import '../../../../shared_libraries/component/empty_state_operation.dart';
import '../../../../shared_libraries/component/general_dialog.dart';
import '../../../../shared_libraries/component/primary_button.dart';
import '../../../../shared_libraries/component/search_field.dart';
import '../../../../shared_libraries/component/title_appbar.dart';
import '../cubit/operation_cubit.dart';
import '../cubit/operation_state.dart';

class OperationScreen extends StatefulWidget {
  final OperationArgument argument;

  const OperationScreen({Key? key, required this.argument}) : super(key: key);

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen>
    with TickerProviderStateMixin {
  final GlobalKey keySearch = GlobalKey();
  final searchController = TextEditingController();
  String query = '';

  var groupFilter;

  //Pilih Urutan
  String selectedValue = '';
  var selectedPop;

  var selectedStartDate;
  var selectedEndDate; // End
  late Size mediaQuery;

  late TabController _tabController;
  final scrollController = ScrollController();
  SharedPreferences preferences = sl();
  // final LoadingOverlay _loadingOverlay = LoadingOverlay();
  bool isShowCalendar = false;
  late Timer _timerOperation;
  late Timer _timerOperationReady;
  late Timer _timerOperationWaiting;
  late Timer _timerOperationBackOrder;

  List<OperationType> listOperation = [];
  List<OperationType> listResult = [];
  List<OperationType> listResultTemp = [];

  List<dynamic> listResponseReady = [];
  List<OperationType> listResultReady = [];
  List<OperationType> listOperationReady = [];
  List<OperationType> listResultReadyTemp = [];

  List<OperationType> listResultWaiting = [];
  List<OperationType> listOperationWaiting = [];
  List<OperationType> listResultWaitingTemp = [];

  List<OperationType> listResultBackOrder = [];
  List<OperationType> listOperationBackOrder = [];
  List<OperationType> listResultBackOrderTemp = [];

  List<OperationType> listResultLate = [];
  List<OperationType> listOperationLate = [];
  List<OperationType> listResultLateTemp = [];

  void _onSearch(String value) {
    setState(() {
      listResult = listOperation
          .where((element) =>
              element.location.toLowerCase().contains(value.toLowerCase()))
          .toList();

      log(listResult.map((e) => e.location).toList().toString());
    });
  }

  void _onSearchReady(String value) {
    setState(() {
      listResultReady = listOperationReady
          .where((element) =>
              element.location.toLowerCase().contains(value.toLowerCase()))
          .toList();

      listResultReady =
          listResultReady.where((element) => element.isLate != true).toList();

      log(listResultReady.map((e) => e.location).toList().toString());
    });
  }

  void _onSearchWaiting(String value) {
    setState(() {
      listResultWaiting = listOperationWaiting
          .where((element) =>
              element.location.toLowerCase().contains(value.toLowerCase()))
          .toList();

      log(listResultWaiting.map((e) => e.location).toList().toString());
    });
  }

  void _onSearchLate(String value) {
    setState(() {
      listResultLate = listResultLateTemp
          .where((element) =>
              element.location.toLowerCase().contains(value.toLowerCase()))
          .toList();

      log(listResultLate.map((e) => e.location).toList().toString());
    });
  }

  void _onSearchBackOrder(String value) {
    setState(() {
      listResultBackOrder = listOperationBackOrder
          .where((element) =>
              element.location.toLowerCase().contains(value.toLowerCase()))
          .toList();

      log(listResultBackOrder.map((e) => e.location).toList().toString());
    });
  }

  // Unused Temporary
  void _onClear() {
    // listResult.clear();
    // log(listResult.map((e) => e.location).toList().toString());
    // listResult.addAll(listOperation);
    // log(listResult.map((e) => e.location).toList().toString());
    // searchController.clear();
  }

  @override
  void initState() {
    super.initState();
    getOperation(pickingTypeId: widget.argument.pickingTypeId);
    getOperationReady(pickingTypeId: widget.argument.pickingTypeId);
    getOperationWaiting(pickingTypeId: widget.argument.pickingTypeId);
    getOperationBackOrder(pickingTypeId: widget.argument.pickingTypeId);

    _tabController = TabController(length: 5, vsync: this);

    _tabController.animateTo(0);
  }

  @override
  void dispose() {
    _timerOperation.cancel();
    _timerOperationReady.cancel();
    _timerOperationWaiting.cancel();
    _timerOperationBackOrder.cancel();

    super.dispose();
  }

  Future<void> getOperation({required int pickingTypeId}) async {
    _timerOperation = Timer(
        const Duration(milliseconds: 500),
        () => context
            .read<OperationCubit>()
            .getOperationList(pickingTypeId: pickingTypeId));
  }

  Future<void> getOperationReady({required int pickingTypeId}) async {
    _timerOperationReady = Timer(
        const Duration(seconds: 1),
        () => context
            .read<OperationCubit>()
            .getOperationReadyList(pickingTypeId: pickingTypeId));
  }

  Future<void> getOperationWaiting({required int pickingTypeId}) async {
    _timerOperationWaiting = Timer(
        const Duration(seconds: 2),
        () => context
            .read<OperationCubit>()
            .getOperationWaitingList(pickingTypeId: pickingTypeId));
  }

  Future<void> getOperationBackOrder({required int pickingTypeId}) async {
    _timerOperationBackOrder = Timer(
        const Duration(seconds: 3),
        () => context
            .read<OperationCubit>()
            .getOperationBackOrderList(pickingTypeId: pickingTypeId));
  }

  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime.now(),
    DateTime.now(),
  ];

  final config = CalendarDatePicker2Config(
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: Colors.teal[800],
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: RefreshIndicator(
            color: ColorName.mainColor,
            onRefresh: () {
              if (_tabController.index == 0) {
                return getOperation(
                    pickingTypeId: widget.argument.pickingTypeId);
              } else if (_tabController.index == 1) {
                return getOperationReady(
                    pickingTypeId: widget.argument.pickingTypeId);
              } else if (_tabController.index == 2) {
                return getOperationWaiting(
                    pickingTypeId: widget.argument.pickingTypeId);
              } else if (_tabController.index == 3) {
                return getOperation(
                    pickingTypeId: widget.argument.pickingTypeId);
              } else {
                return getOperationBackOrder(
                    pickingTypeId: widget.argument.pickingTypeId);
              }
            },
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(155),
                child: AppBar(
                  leading: Padding(
                      padding: const EdgeInsets.only(top: 16, left: 20),
                      child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: ColorName.blackColor,
                            size: 16,
                          ))),
                  centerTitle: true,
                  title: Column(
                    children: [
                      buildTitleAppBar(context, widget.argument.titleAppbar),
                    ],
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(40),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child:
                              buildSearchFilter(context, _tabController.index),
                        ),
                        TabBar(
                            // FIX: Tab indicator mentok tanpa padding
                            // inventory-v1.0.12-1
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            isScrollable: true,
                            indicatorColor: ColorName.mainColor,
                            // indicatorPadding: const EdgeInsets.only(bottom: 10),
                            labelPadding: const EdgeInsets.only(
                                bottom: 12, right: 10, left: 10),
                            labelColor: ColorName.mainColor,
                            unselectedLabelColor: ColorName.greyColor,
                            labelStyle: BaseText.mainTextStyle14
                                .copyWith(fontWeight: BaseText.semiBold),
                            //Pada tab, yang tidak di klik tidak di bold
                            unselectedLabelStyle: BaseText.greyText14.copyWith(
                                fontWeight: BaseText.regular,
                                color: Colors.grey[850]),
                            controller: _tabController,
                            onTap: (int i) {
                              setState(() {});
                            },
                            tabs: [
                              Text('Semua (${listResult.length})'),
                              Text('Ready (${listResultReady.length})'),
                              Text('Menunggu (${listResultWaiting.length})'),
                              Text('Terlambat (${listResultLate.length})'),
                              Text('Backorder (${listResultBackOrder.length})')
                            ]),
                      ],
                    ),
                  ),
                  backgroundColor: ColorName.whiteColor,
                ),
              ),
              body: BlocListener<OperationCubit, OperationState>(
                  // bloc: context.read<OperationCubit>(),
                  listener: (context, state) {
                final status = state.operationState.status;
                final statusReady = state.operationReadyState.status;
                final statusWaiting = state.operationWaitingState.status;
                final statusBackOrder = state.operationBackOrderState.status;

                if (status.isError) {
                  // final errorStatus =
                  //     state.operationState.failure?.errorMessage;
                  // if (errorStatus
                  //     .toString()
                  //     .toLowerCase()
                  //     .contains('500')) {
                  errorDialog(context, "Opss Gagal",
                          "Gagal memuat, silahkan coba lagi")
                      .then((value) =>
                          Future.delayed(const Duration(seconds: 4), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }));
                  // }
                } else if (status.isHasData) {
                  // _loadingOverlay.hide();
                  setState(() {});
                  final listResponse = state.operationState.data?.result;

                  int difference = 0;
                  if (listResponse != null) {
                    listResult.clear();
                    listOperation = listResponse.map((item) {
                      final scheduleDate = item['scheduled_date'];
                      final scheduleDateTime = DateTime.parse(scheduleDate);
                      difference =
                          daysBetween(scheduleDateTime, DateTime.now());

                      bool isLate = (difference > 0) ? true : false;
                      bool isBackOrder =
                          (item['backorder_id'] != false) ? true : false;
                      String statusConverted = "";

                      if (!isBackOrder &&
                          !isLate &&
                          item['state'] == "assigned") {
                        // Ready
                        statusConverted = "Ready";
                      } else if (!isBackOrder && item['state'] == "confirmed") {
                        // Waiting
                        statusConverted = "Waiting";
                      } else if (!isBackOrder && isLate) {
                        // Terlambat
                        statusConverted = "Terlambat";
                      } else if (isBackOrder) {
                        // Back Order
                        statusConverted = "Back Order";
                      }

                      return OperationType(
                          pickingId: item['id'],
                          moveIdsWithoutPackage:
                              item['move_ids_without_package'],
                          name: (item['partner_id'] == false)
                              ? ""
                              : item['partner_id'][1],
                          location: item['name'],
                          status: statusConverted,
                          sku: item['origin'],
                          date: item['scheduled_date'].toString(),
                          isLate: isLate,
                          isBackOrder: isBackOrder,
                          backOrder: (item['backorder_id'] == false)
                              ? <dynamic>[]
                              : item['backorder_id']);
                    }).toList();

                    // Sort list of all listOperation, also listOperationLate by id
                    listOperation
                        .sort((a, b) => b.pickingId.compareTo(a.pickingId));

                    listOperationLate = listOperation
                        .where((element) => element.isLate == true)
                        .toList();

                    // log("listOperation ${listOperation.map((e) => e.toMap()).toList().toString()}");
                    log("listOperationLate== ${listOperationLate.map((e) => e.status).toList()}");
                    listResultLate.addAll(listOperationLate);
                    listResultLateTemp.addAll(listOperationLate);
                    // log("listResultLateTemp ${listResultLateTemp.map((e) => e.location).toList()}");

                    // listResultLate = listResultLate
                    //     .where((element) =>
                    //         element.isLate == true &&
                    //         element.status == "assigned")
                    //     .toList();

                    // listResultLateTemp = listResultLateTemp
                    //     .where((element) =>
                    //         element.isLate == true &&
                    //         element.status == "assigned")
                    //     .toList();

                    listResult.addAll(listOperation);
                    listResultTemp.addAll(listOperation);
                  }
                } else if (statusReady.isHasData) {
                  // _loadingOverlay.hide();
                  setState(() {});

                  final listResponseReady =
                      state.operationReadyState.data?.result;

                  int difference = 0;
                  if (listResponseReady != null) {
                    listResultReady.clear();
                    listOperationReady = listResponseReady.map((item) {
                      final scheduleDate = item['scheduled_date'];
                      final scheduleDateTime = DateTime.parse(scheduleDate);
                      difference =
                          daysBetween(scheduleDateTime, DateTime.now());

                      bool isLate = (difference > 0) ? true : false;
                      bool isBackOrder =
                          (item['backorder_id'] != false) ? true : false;
                      String statusConverted = "";

                      if (item['state'] == "assigned") {
                        // Ready
                        statusConverted = "Ready";
                      }

                      return OperationType(
                          pickingId: item['id'],
                          moveIdsWithoutPackage:
                              item['move_ids_without_package'],
                          name: (item['partner_id'] == false)
                              ? ""
                              : item['partner_id'][1],
                          location: item['name'],
                          status: statusConverted,
                          sku: item['origin'],
                          date: item['scheduled_date'].toString(),
                          isLate: isLate,
                          isBackOrder: isBackOrder,
                          backOrder: (item['backorder_id'] == false)
                              ? <dynamic>[]
                              : item['backorder_id']);
                    }).toList();

                    // Sort by id
                    listOperationReady
                        .sort((a, b) => b.pickingId.compareTo(a.pickingId));

                    // log("listOperationReady ${listOperationReady.map((e) => e.name).toList()}");
                    listResultReady.addAll(listOperationReady);
                    listResultReadyTemp.addAll(listOperationReady);
                    listResultReadyTemp = listResultReadyTemp
                        .where((element) => element.isLate != true)
                        .toList();
                    // log("listResultReadyTemp ${listResultReadyTemp.map((e) => e.name).toList()}");

                    // listResultReady = listResultReady
                    //     .where((element) => element.isLate != true)
                    //     .toList();
                  }
                } else if (statusWaiting.isHasData) {
                  // _loadingOverlay.hide();
                  setState(() {});

                  final listResponseWait =
                      state.operationWaitingState.data?.result;

                  int difference = 0;
                  if (listResponseWait != null) {
                    listResultWaiting.clear();
                    listOperationWaiting = listResponseWait.map((item) {
                      final scheduleDate = item['scheduled_date'];
                      final scheduleDateTime = DateTime.parse(scheduleDate);
                      difference =
                          daysBetween(scheduleDateTime, DateTime.now());

                      bool isLate = (difference > 0) ? true : false;
                      bool isBackOrder =
                          (item['backorder_id'] != false) ? true : false;
                      String statusConverted = "";

                      if (item['state'] == "confirmed") {
                        // Waiting
                        statusConverted = "Waiting";
                      }

                      return OperationType(
                          pickingId: item['id'],
                          moveIdsWithoutPackage:
                              item['move_ids_without_package'],
                          name: (item['partner_id'] == false)
                              ? ""
                              : item['partner_id'][1],
                          location: item['name'],
                          status: statusConverted,
                          sku: item['origin'],
                          date: item['scheduled_date'].toString(),
                          isLate: isLate,
                          isBackOrder: isBackOrder,
                          backOrder: (item['backorder_id'] == false)
                              ? <dynamic>[]
                              : item['backorder_id']);
                    }).toList();

                    // Sort by id
                    listOperationWaiting
                        .sort((a, b) => b.pickingId.compareTo(a.pickingId));

                    listResultWaiting.addAll(listOperationWaiting);
                    listResultWaitingTemp.addAll(listOperationWaiting);
                  }
                } else if (statusBackOrder.isHasData) {
                  // _loadingOverlay.hide();
                  setState(() {});

                  final listResponseBackOrder =
                      state.operationBackOrderState.data?.result;

                  int difference = 0;
                  if (listResponseBackOrder != null) {
                    listResultBackOrder.clear();
                    listOperationBackOrder = listResponseBackOrder.map((item) {
                      final scheduleDate = item['scheduled_date'];
                      final scheduleDateTime = DateTime.parse(scheduleDate);
                      difference =
                          daysBetween(scheduleDateTime, DateTime.now());

                      bool isLate = (difference > 0) ? true : false;
                      bool isBackOrder =
                          (item['backorder_id'] != false) ? true : false;
                      String statusConverted = "";

                      if (isBackOrder) {
                        // Back Order
                        statusConverted = "Back Order";
                      }

                      return OperationType(
                          pickingId: item['id'],
                          moveIdsWithoutPackage:
                              item['move_ids_without_package'],
                          name: (item['partner_id'] == false)
                              ? ""
                              : item['partner_id'][1],
                          location: item['name'],
                          status: statusConverted,
                          sku: item['origin'],
                          date: item['scheduled_date'].toString(),
                          isLate: isLate,
                          isBackOrder: isBackOrder,
                          backOrder: (item['backorder_id'] == false)
                              ? <dynamic>[]
                              : item['backorder_id']);
                    }).toList();
                    // Sort by id
                    listOperationBackOrder
                        .sort((a, b) => b.pickingId.compareTo(a.pickingId));

                    listResultBackOrder.addAll(listOperationBackOrder);
                    listResultBackOrderTemp.addAll(listOperationBackOrder);
                  }
                }
              }, child: Builder(builder: (context) {
                final status =
                    context.read<OperationCubit>().state.operationState.status;

                final statusReady = context
                    .read<OperationCubit>()
                    .state
                    .operationReadyState
                    .status;
                final statusWaiting = context
                    .read<OperationCubit>()
                    .state
                    .operationWaitingState
                    .status;
                final statusBackOrder = context
                    .read<OperationCubit>()
                    .state
                    .operationBackOrderState
                    .status;

                return TabBarView(controller: _tabController, children: [
                  (status.isLoading)
                      ? const SizedBox()
                      : (listResult.isEmpty)
                          ? buildEmptyResultOperation(context)
                          : Container(
                              // inventory-v1.0.12-1
                              // FIX: warna background ganti: E6EAEF
                              color: ColorName.disableColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: SizedBox(
                                  child: Scrollbar(
                                radius: const Radius.circular(45),
                                controller: scrollController,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: listResult.length,
                                    itemBuilder: (context, index) {
                                      // bool isBackOrder =
                                      //     (listOperation[index].location == "Surabaya")
                                      //         ? true
                                      //         : false;

                                      var item = listResult[index];

                                      return buildOperationItem(item: item);
                                    }),
                              )),
                            ),
                  // const Center(child: Text('Semua Content')),
                  (statusReady.isLoading)
                      ? const SizedBox()
                      : (listResultReady.isEmpty)
                          ? buildEmptyResultOperation(context)
                          : Container(
                              // inventory-v1.0.12-1
                              // FIX: warna background ganti: E6EAEF
                              color: ColorName.disableColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: SizedBox(
                                  child: Scrollbar(
                                radius: const Radius.circular(45),
                                controller: scrollController,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: listResultReady.length,
                                    itemBuilder: (context, index) {
                                      var item = listResultReady[index];

                                      return buildOperationItem(item: item);
                                    }),
                              )),
                            ),

                  (statusWaiting.isLoading)
                      ? const SizedBox()
                      : (listResultWaiting.isEmpty)
                          ? buildEmptyResultOperation(context)
                          : Container(
                              // inventory-v1.0.12-1
                              // FIX: warna background ganti: E6EAEF
                              color: ColorName.disableColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: SizedBox(
                                  child: Scrollbar(
                                radius: const Radius.circular(45),
                                controller: scrollController,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    itemCount: listResultWaiting.length,
                                    itemBuilder: (context, index) {
                                      var item = listResultWaiting[index];

                                      return buildOperationItem(item: item);
                                    }),
                              )),
                            ),

                  (listResultLate.isEmpty)
                      ? buildEmptyResultOperation(context)
                      : Container(
                          // inventory-v1.0.12-1
                          // FIX: warna background ganti: E6EAEF
                          color: ColorName.disableColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SizedBox(
                              child: Scrollbar(
                            radius: const Radius.circular(45),
                            controller: scrollController,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                itemCount: listResultLate.length,
                                itemBuilder: (context, index) {
                                  var item = listResultLate[index];

                                  return buildOperationItem(item: item);
                                }),
                          )),
                        ),

                  (statusBackOrder.isLoading)
                      ? const SizedBox()
                      : (listResultBackOrder.isEmpty)
                          ? buildEmptyResultOperation(context)
                          : Container(
                              // inventory-v1.0.12-1
                              // FIX: warna background ganti: E6EAEF
                              color: ColorName.disableColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: SizedBox(
                                  child: Scrollbar(
                                radius: const Radius.circular(45),
                                controller: scrollController,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    itemCount: listResultBackOrder.length,
                                    itemBuilder: (context, index) {
                                      var item = listResultBackOrder[index];

                                      return buildOperationItem(item: item);
                                    }),
                              )),
                            ),
                ]);
              })),
            )),
      ),
    );
  }

  Widget buildSearchFilter(BuildContext context, int tabIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            context,
            queryKey: searchController.text,
            keySearch: keySearch,
            controller: searchController,
            onSearch: (tabIndex == 0)
                ? _onSearch
                : (tabIndex == 1)
                    ? _onSearchReady
                    : (tabIndex == 2)
                        ? _onSearchWaiting
                        : (tabIndex == 3)
                            ? _onSearchLate
                            : _onSearchBackOrder,
            clearData: _onClear,
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => showModalBottomSheet(
                isDismissible: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(20.w),
                //       topRight: Radius.circular(20.w)),
                // ),
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, filterState) {
                    return DraggableScrollableSheet(
                        initialChildSize: 0.6,
                        // minChildSize: 0.15,
                        // maxChildSize: 1.0,
                        builder: (_, scrollControllerSheet) {
                          return Container(
                            // height: ScreenUtil().screenHeight,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: ColorName.whiteColor,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ListView(
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                controller: scrollControllerSheet,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  Container(
                                    height: 6,
                                    width: double.minPositive,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: mediaQuery.width / 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: ColorName.lightNewGreyColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Filter',
                                        style: BaseText.mainTextStyle14
                                            .copyWith(
                                                fontWeight: BaseText.semiBold),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            Navigator.of(context).maybePop(),
                                        icon: const Icon(Icons.close,
                                            color: ColorName.mainColor,
                                            size: 16),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                      height:
                                          12), // Jarak antara title filter dan pilih tanggal terlalu jauh.
                                  Row(
                                    children: [
                                      Text(
                                        'Pilih Tanggal',
                                        style: BaseText.blackText16.copyWith(
                                            fontWeight: BaseText.semiBold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            filterState(() {
                                              isShowCalendar = true;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Tanggal Mulai',
                                                  style: BaseText.blackText12),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        mediaQuery.width / 2.5,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: ColorName
                                                            .lightGreyColor),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.date_range,
                                                            color: ColorName
                                                                .blackColor),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                            (selectedStartDate ==
                                                                    DateTime
                                                                        .now())
                                                                ? ''
                                                                : (selectedStartDate ==
                                                                        null)
                                                                    ? DateTime
                                                                            .now()
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10)
                                                                    : selectedStartDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                            style: BaseText
                                                                .blackText14
                                                                .copyWith(
                                                                    fontWeight:
                                                                        BaseText
                                                                            .medium))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 8, right: 8, top: 24),
                                        child: Icon(Icons.arrow_forward,
                                            color: ColorName.mainColor),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          filterState(() {
                                            isShowCalendar = true;
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Tanggal Berakhir',
                                                style: BaseText.blackText12),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Container(
                                                  width: mediaQuery.width / 2.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: ColorName
                                                          .lightGreyColor),
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.date_range,
                                                          color: ColorName
                                                              .blackColor),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                          (selectedEndDate ==
                                                                  DateTime
                                                                      .now())
                                                              ? ''
                                                              : (selectedEndDate ==
                                                                      null)
                                                                  ? ''
                                                                  : selectedEndDate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                          style: BaseText
                                                              .blackText14
                                                              .copyWith(
                                                                  fontWeight:
                                                                      BaseText
                                                                          .medium))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Visibility(
                                      visible: isShowCalendar,
                                      child:
                                          _buildDefaultRangeDatePickerWithValue(
                                              filterState)),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Text(
                                        'Pilih Urutan',
                                        style: BaseText.blackText16.copyWith(
                                            fontWeight: BaseText.semiBold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // warna radio button, atau button apapun yang diklick bewarna biru scale ocean #2B5279
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: DateFilter.terbaru,
                                            groupValue: groupFilter,
                                            activeColor: ColorName.mainColor,
                                            onChanged: (value) {
                                              filterState(() {
                                                groupFilter = value;
                                                log(groupFilter.toString());
                                              });
                                            },
                                          ),
                                          Text(
                                            'Berdasarkan terbaru',
                                            style: BaseText.blackText12,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: DateFilter.terlama,
                                            groupValue: groupFilter,
                                            activeColor: ColorName.mainColor,
                                            onChanged: (value) {
                                              filterState(() {
                                                groupFilter = value;
                                                log(groupFilter.toString());
                                              });
                                            },
                                          ),
                                          Text('Berdasarkan terlama',
                                              style: BaseText.blackText12),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (tabIndex == 0) {
                                            setState(() {
                                              listResult.clear();
                                              listResult.addAll(listResultTemp);
                                              log("listResult after: ${listResult.map((e) => e).toList()}");
                                            });
                                          } else if (tabIndex == 1) {
                                            setState(() {
                                              listResultReady.clear();
                                              listResultReady
                                                  .addAll(listResultReadyTemp);
                                              log("listResultReady after: ${listResultReady.map((e) => e).toList()}");
                                            });
                                          } else if (tabIndex == 2) {
                                            setState(() {
                                              listResultWaiting.clear();
                                              listResultWaiting.addAll(
                                                  listResultWaitingTemp);
                                              log("listResultWaiting after: ${listResultWaiting.map((e) => e).toList()}");
                                            });
                                          } else if (tabIndex == 3) {
                                            setState(() {
                                              listResultLate.clear();
                                              listResultLate
                                                  .addAll(listResultLateTemp);
                                              log("listResultLate after: ${listResultLate.map((e) => e).toList()}");
                                            });
                                          } else if (tabIndex == 4) {
                                            setState(() {
                                              listResultBackOrder.clear();
                                              listResultBackOrder.addAll(
                                                  listResultBackOrderTemp);
                                              log("listResultBackOrder after: ${listResultBackOrder.map((e) => e).toList()}");
                                            });
                                          }
                                        },
                                        child: SecondaryButton(
                                            height: 36,
                                            width: mediaQuery.width / 2.3,
                                            title: 'Reset'),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // selectedStartDate =
                                          //     DateTime.utc(2023, 07, 05);
                                          log("start value $selectedStartDate");
                                          // selectedEndDate =
                                          //     DateTime.utc(2023, 07, 06);
                                          log("end value $selectedEndDate");
                                          if (tabIndex == 0) {
                                            filterOperation(
                                                list: listResult,
                                                selectedStartDate:
                                                    selectedStartDate,
                                                selectedEndDate:
                                                    selectedEndDate);
                                          } else if (tabIndex == 1) {
                                            filterOperation(
                                                list: listResultReady,
                                                selectedStartDate:
                                                    selectedStartDate,
                                                selectedEndDate:
                                                    selectedEndDate);
                                          } else if (tabIndex == 2) {
                                            filterOperation(
                                                list: listResultWaiting,
                                                selectedStartDate:
                                                    selectedStartDate,
                                                selectedEndDate:
                                                    selectedEndDate);
                                          } else if (tabIndex == 3) {
                                            filterOperation(
                                                list: listResultLate,
                                                selectedStartDate:
                                                    selectedStartDate,
                                                selectedEndDate:
                                                    selectedEndDate);
                                          } else {
                                            filterOperation(
                                                list: listResultBackOrder,
                                                selectedStartDate:
                                                    selectedStartDate,
                                                selectedEndDate:
                                                    selectedEndDate);
                                          }
                                          // filterState(() {});
                                          // filterState(() {});
                                          // setState(() {});
                                          groupFilter = null;
                                          Navigator.of(context).maybePop();
                                        },
                                        child: PrimaryButton(
                                            height: 36,
                                            width: mediaQuery.width / 2.3,
                                            title: 'Simpan'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 35),
                                ],
                              ),
                            ),
                          );
                        });
                  });
                }),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SvgPicture.asset(
                const AssetConstans().filter,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultRangeDatePickerWithValue(filterState) {
    DateTime? startDate;
    Object? endDate;

    _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
    ) {
      values =
          values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
      var valueText = (values.isNotEmpty ? values[0] : null)
          .toString()
          .replaceAll('00:00:00.000', '');

      if (datePickerType == CalendarDatePicker2Type.multi) {
        valueText = values.isNotEmpty
            ? values
                .map((v) => v.toString().replaceAll('00:00:00.000', ''))
                .join(', ')
            : 'null';
      } else {
        if (values.isNotEmpty) {
          startDate = values[0];
          endDate = values.length > 1 ? values[1] : 'null';
          valueText = '$startDate to $endDate';
          // final startDateParsed = DateFormat("dd-MM-yyyy").format(startDate!);
          selectedStartDate = startDate;
          // selectedEndDate = (endDate != null) ? endDate : null;
          // selectedStartDate = startDate;
          selectedEndDate =
              (endDate.toString().length <= 4) ? startDate : endDate;
          isShowCalendar = false;
          filterState(() {});
          log(selectedStartDate.toString());
          log(selectedEndDate.toString());
        } else {
          // return 'null';
          selectedEndDate = selectedStartDate;
          log('else CalendarDatePicker2Type.range $selectedEndDate');
        }
      }

      // return valueText;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const SizedBox(height: 10),
        // const Text('Range Date Picker (With default value)'),
        CalendarDatePicker2(
            config: config,
            value: _rangeDatePickerValueWithDefaultValue,
            onValueChanged: (dates) {
              filterState(() {
                _rangeDatePickerValueWithDefaultValue = dates;
                _getValueText(
                    config.calendarType, _rangeDatePickerValueWithDefaultValue);
              });
            }),
        const SizedBox(height: 10),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     const Text('Selection(s):  '),
        //     const SizedBox(width: 10),
        //     Text(
        //       _getValueText(
        //         config.calendarType,
        //         _rangeDatePickerValueWithDefaultValue,
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 25),
      ],
    );
  }

  // Column buildDateStartEnd({required String label, required dynamic value}) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label, style: BaseText.blackText12),
  //       SizedBox(height: 8.h),
  //       Row(
  //         children: [
  //           Container(
  //             width: ScreenUtil().screenWidth / 2.5,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10.w),
  //                 color: ColorName.lightGreyColor),
  //             padding: EdgeInsets.all(12.w),
  //             child: Row(
  //               children: [
  //                 const Icon(Icons.date_range, color: ColorName.blackColor),
  //                 SizedBox(width: 10.w),
  //                 Text((value == DateTime) ? DateTime.now().toString().substring(0, 10) : value.toString(),
  //                     style: BaseText.blackText14
  //                         .copyWith(fontWeight: BaseText.medium))
  //               ],
  //             ),
  //           ),
  //         ],
  //       )
  //     ],
  //   );
  // }

  Widget buildOperationItem({required OperationType item}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.operationDetail,
          arguments: OperationDetailArgument(
              item.pickingId,
              item.moveIdsWithoutPackage,
              widget.argument.titleAppbar,
              item.status)),
      child: Flexible(
        // FIX: Padding bawah jika tidak ada nomor sku
        // inventory-v1.0.12-1
        // height: (item.sku == false || item.backOrder.isEmpty) ? 99 : 120,
        // width: double.infinity,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: ColorName.borderColor)),
          color: ColorName.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: item.location,
                              style: BaseText.blackText16
                                  .copyWith(fontWeight: BaseText.semiBold),
                              children: [
                                TextSpan(
                                  text: ' ',
                                  style: BaseText.blackText16
                                      .copyWith(fontWeight: BaseText.semiBold),
                                )
                              ]),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: (item.status == "Waiting")
                                ? ColorName.waitingColor
                                : (item.status == "Terlambat")
                                    ? ColorName.lateColor
                                    : (item.status == "Ready")
                                        ? ColorName.readyColor
                                        : (item.status == "Back Order")
                                            ? ColorName.backOrderColor
                                            : (item.status == "done")
                                                ? ColorName.doneColor
                                                : ColorName.lightNewGreyColor,
                          ),
                          child: Text(
                              "${item.status[0].toUpperCase()}${item.status.substring(1)}",
                              style: BaseText.whiteText12
                                  .copyWith(fontWeight: BaseText.medium)),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name, style: BaseText.greyText14),
                        Text(item.date.substring(0, 10))
                      ],
                    ),
                    (item.backOrder.isEmpty)
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: 8),
                    (item.backOrder.isEmpty)
                        ? const SizedBox()
                        : Text(item.backOrder.last.toString(),
                            style: BaseText.greyText14),
                    (item.backOrder.isEmpty)
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: 8),
                    (item.sku == false)
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: 9),
                    (item.sku == false)
                        ? const SizedBox(height: 0)
                        : Text(item.sku.toString(), style: BaseText.greyText14)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  List<OperationType> itemsBetweenDates({
    required List<OperationType> items,
    required DateTime start,
    required DateTime end,
  }) {
    var output = <OperationType>[];
    for (var i = 0; i < items.length; i += 1) {
      // var date = items[i].date;
      var date = DateTime.parse(items[i].date);
      if (date.compareTo(start) >= 0 && date.compareTo(end) <= 0) {
        output.add(items[i]);
      }
    }
    log("output list: ${output.map((e) => e.date).toList().toString()}");
    items.clear();
    items.addAll(output);
    log("items list: ${items.map((e) => e.date).toList().toString()}");

    if (groupFilter == DateFilter.terbaru) {
      setState(() {
        items.sort(
            (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
      });
    } else {
      setState(() {
        items.sort(
            (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
      });
    }
    return items;
  }

  filterOperation({
    required List<OperationType> list,
    required DateTime? selectedStartDate,
    required DateTime? selectedEndDate,
  }) {
    late DateTime startDateFilter;

    if (selectedStartDate != null) {
      // Date Converted
      var newDay = selectedStartDate.day - 1;
      var year = selectedStartDate.year;
      var month = selectedStartDate.month;
      startDateFilter = DateTime.utc(year, month, newDay);
      // startDateFilter = selectedStartDate;
    }

    if (groupFilter.toString().isNotEmpty &&
        selectedStartDate != null &&
        selectedEndDate != null) {
      itemsBetweenDates(
          items: list, start: startDateFilter, end: selectedEndDate);
    } else {
      if (groupFilter == DateFilter.terbaru) {
        setState(() {
          list.sort((a, b) =>
              DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
        });
      } else {
        setState(() {
          list.sort((a, b) =>
              DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
        });
      }
    }

    // setState(() {});
  }
}

enum DateFilter { terbaru, terlama }

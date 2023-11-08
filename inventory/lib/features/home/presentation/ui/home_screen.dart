// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:inventory/core/navigation/argument/stock_count_session.dart';
import 'package:inventory/core/navigation/argument/stock_session_detail_argument.dart';
import 'package:inventory/features/home/presentation/cubit/stock_opname_cubit/stock_count_session_state.dart';
import 'package:inventory/shared_libraries/common/state/view_data_state.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_remaining/time_remaining.dart';
import 'package:yaml/yaml.dart';

import '../../../../core/navigation/argument/operation_argument.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../domains/home/data/model/response/overview_response_dto.dart';
import '../../../../domains/home/data/model/response/user_response_dto.dart';
import '../../../../domains/home/data/model/response/warehouse_response_dto.dart';
import '../../../../injections/injections.dart';
import '../../../../shared_libraries/common/constants/resource_constants.dart';
import '../../../../shared_libraries/common/theme/theme.dart';
import '../../../../shared_libraries/component/custom_field.dart';
import '../../../../shared_libraries/component/general_dialog.dart';
import '../../../../shared_libraries/component/loading_overlay.dart';
import '../../../../shared_libraries/component/loading_widget.dart';
import '../../../../shared_libraries/utils/key_helper.dart';
import '../../../../shared_libraries/utils/pref_helper.dart';
import '../cubit/home_cubit.dart';
import '../cubit/stock_opname_cubit/stock_count_session_cubit.dart';
import '../cubit/user_cubit/user_cubit.dart';
import '../cubit/user_cubit/user_state.dart';

class HomeScreen extends StatefulWidget {
  final bool? isSigned;

  const HomeScreen({Key? key, this.isSigned = false}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final SharedPreferences sharedPreferences = sl();
  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  Timer? countDownTimer;
  Duration duration = const Duration(days: 5);
  bool isSheetOpen = false;
  bool hasNotification = false;
  late Function sheetSetState;
  late Function sheetState;
  late Timer _timer;
  late Timer _timerToGetUser;
  ResultUser user = ResultUser();
  var endTime;
  var dateOutput;
  var timeUnformatted;
  var companyId;
  var userId;
  bool isFinishedTime = false;
  bool isToday = false;

  @override
  void initState() {
    super.initState();

    int companyId = sharedPreferences.getInt(KeyHelper.companyId) ?? 00;
    userId = sharedPreferences.getInt(KeyHelper.idUser) ?? 00;

    _timer = Timer(const Duration(milliseconds: 50),
        () => getWarehouse(companyId: companyId));
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  Future<void> getWarehouse({required int companyId}) async {
    context.read<HomeCubit>().getListWarehouse(companyId: companyId);
  }

  Future<void> getOverview({required int warehouseId}) async {
    context.read<HomeCubit>().getListOverview(id: warehouseId);
  }

  Future<void> getUser() async {
    final email = sharedPreferences.getString(KeyHelper.username) ?? '';
    context.read<UserCubit>().getUser(emailAddress: email);
  }

  Future<void> getStockCountSession(
      {required int userIds, required int warehouseId}) async {
    isFinishedTime = false;
    isToday = false;

    context.read<StockCountSessionCubit>().getStockCountSession(
        userId: [userIds], warehouseId: warehouseId, isFindOne: false);
  }

  /// GIVE start_button navigate to StockSessionDetailScreen with prevent to back
  /// WHEN is Submitted
  /// THEN back to HOME
  Future<String> startButtonSession({required int stockSessionId}) async {
    String result = "";
    log(stockSessionId.toString());
    await context
        .read<StockCountSessionCubit>()
        .startButtonSession(stockSessionId: stockSessionId)
        .then((value) => result = value);
    return result;
  }

  List<ResultUser> listUSers = [];
  List<Result>? listWarehouseName = [];
  List<ResultOverview>? listOverviews = [];
  List<ItemOverview> newList = [];
  List<StyleItemOverview> listTemporary = [
    StyleItemOverview(
        name: "delivery orders",
        iconPath: 'assets/icon/home/0.png',
        color: ColorName.homeBlueColor,
        bgPath: 'assets/icon/home/0bg.png'),
    StyleItemOverview(
        name: "receipts",
        iconPath: 'assets/icon/home/1.png',
        color: ColorName.homeGreenColor,
        bgPath: 'assets/icon/home/1bg.png'),
    StyleItemOverview(
        name: "returns",
        iconPath: 'assets/icon/home/2.png',
        color: ColorName.homeOrangeColor,
        bgPath: 'assets/icon/home/2bg.svg'),
    StyleItemOverview(
        name: "internal transfer",
        iconPath: 'assets/icon/home/3.svg',
        color: ColorName.purpleColor,
        bgPath: 'assets/icon/home/3bg.svg'),
  ];
  List<dynamic>? listOperations = [];
  // By Status
  // Ready = assigned
  List<dynamic>? listOperationsReady = [];
  // Waiting = confirm
  List<dynamic>? listOperationsWaiting = [];
  // Done = done
  List<dynamic>? listOperationsDone = [];

  List<dynamic>? listReceipt = [];
  List<dynamic> listStockOpname = [];

  var groupValue;
  int warehouseId = 0;
  int warehouseInitId = 0;
  String warehouseName = '';
  int pickingTypeId = 0;
  var itemStockScheduled;
  var stockOpname;
  late Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _onHomeRefresh,
        color: ColorName.mainColor,
        child: SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            body:
                BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
              final statusWarehouse = state.warehouseState.status;
              final statusOverview = state.overviewState.status;

              if (statusWarehouse.isError) {
                final errorWarehouse =
                    state.warehouseState.failure?.errorMessage;
                if (errorWarehouse.toString().toLowerCase().contains('500')) {
                  buildGeneralDialog(context, 'Failed to load warehouse data');
                }
              } else if (statusOverview.isError) {
                buildGeneralDialog(context, 'Failed to load overview data');
              } else if (statusWarehouse.isHasData) {
                listWarehouseName = state.warehouseState.data?.result;
                warehouseInitId = listWarehouseName!.first.id;
                groupValue = listWarehouseName!.first;

                if (listWarehouseName!.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 250),
                      () => getOverview(warehouseId: warehouseInitId));
                  Future.delayed(
                      const Duration(milliseconds: 650), () => getUser());
                  Future.delayed(
                      const Duration(seconds: 1),
                      () async => await getStockCountSession(
                          userIds: userId ?? user.id,
                          warehouseId: warehouseInitId));
                  setState(() {});
                }
              } else if (statusOverview.isHasData) {
                listOverviews = state.overviewState.data?.result;

                if (listOverviews!.isNotEmpty) {
                  newList.clear();
                  for (var item in listOverviews!) {
                    for (var itemStyle in listTemporary) {
                      if (itemStyle.name
                          .toString()
                          .toLowerCase()
                          .contains(item.name.toString().toLowerCase())) {
                        newList.add(ItemOverview(
                          pickingTypeId: item.id,
                          warehouseName: item.warehouseId[1],
                          title: item.name,
                          titleTotal: item.countPicking,
                          icon: itemStyle.iconPath,
                          iconBg: itemStyle.bgPath,
                          color: itemStyle.color,
                        ));
                      }
                    }
                  }
                }
              }
            }, builder: (context, state) {
              final statusWarehouse = state.warehouseState.status;
              final statusOverview = state.overviewState.status;

              if (statusWarehouse.isLoading || statusWarehouse.isHasData) {
                return const SizedBox();
              } else if (statusOverview.isLoading) {
                return buildLoadingWidget();
              } else if (statusOverview.isNoData) {
                return _buildEmptyState();
              } else if (statusOverview.isHasData) {
                if (newList.isNotEmpty) {
                  return Container(
                    height: mediaQuery.height,
                    color: ColorName.disableColor,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Stack(
                          children: [
                            SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),

                              // height: mediaQuery.height,
                              child: Column(
                                children: [
                                  BlocConsumer<UserCubit, UserState>(
                                    listener: (context, state) {
                                      final statusUser = state.userState.status;

                                      if (statusUser.isError) {
                                        var errorSnackBar = SnackBar(
                                            content: Text('Error User',
                                                style: BaseText.whiteText14));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(errorSnackBar);
                                      } else if (statusUser.isHasData) {
                                        listUSers =
                                            state.userState.data!.result;
                                        user = listUSers.first;
                                        companyId = user.companyId?.first;
                                        log('user companyId: ${companyId.toString()}');
                                      }
                                    },
                                    builder: (context, state) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: mediaQuery.height / 3.8,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/home/bg.png'),
                                                    fit: BoxFit.cover)),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 32,
                                                      horizontal: 16),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      FutureBuilder(
                                                          future: service
                                                              .rootBundle
                                                              .loadString(
                                                                  "pubspec.yaml"),
                                                          builder: (context,
                                                              snapshot) {
                                                            String
                                                                latestVersion =
                                                                "";

                                                            if (snapshot
                                                                .hasData) {
                                                              var yaml = loadYaml(
                                                                  snapshot.data
                                                                      .toString());
                                                              latestVersion =
                                                                  yaml[
                                                                      'version'];
                                                            }
                                                            return Text(
                                                                'Inventory App v$latestVersion',
                                                                style: BaseText
                                                                    .whiteText10
                                                                    .copyWith(
                                                                        fontStyle:
                                                                            FontStyle.italic));
                                                          }),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                          (user.name == null)
                                                              ? ''
                                                              : 'Halo, Selamat Datang',
                                                          style: BaseText
                                                              .whiteText14
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                      // FIX: jarak 2px antara halo dan nama
                                                      // inventory-v1.0.12-1
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        (user.name == null)
                                                            ? ''
                                                            : "${user.name}!",
                                                        style: BaseText
                                                            .whiteText16
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  BlocListener<StockCountSessionCubit,
                                      StockCountSessionState>(
                                    listener: (context, state) {
                                      final status =
                                          state.stockCountSessionState.status;

                                      if (status.isError) {
                                        final errorStockSession = state
                                            .stockCountSessionState
                                            .failure
                                            ?.errorMessage;

                                        if (errorStockSession
                                            .toString()
                                            .toLowerCase()
                                            .contains('500')) {
                                          buildGeneralDialog(context,
                                              'Failed to load session data');
                                        }
                                      } else if (status.isHasData) {
                                        // _loadingOverlay.hide();

                                        // setState(() {});

                                        listStockOpname = state
                                                .stockCountSessionState
                                                .data["result"] ??
                                            [];
                                        // listStockOpname.removeWhere((element) =>
                                        //     element['date_create'] == false);
                                        // listStockOpname.sort((a, b) =>
                                        //     b['date_create']
                                        //         .compareTo(a['date_create']));
                                        log("listStockOpname: ${listStockOpname.map((e) => e['date_create']).toList().toString()}");

                                        stockOpname = listStockOpname.lastWhere(
                                            (element) => element["state"]
                                                .toString()
                                                .toLowerCase()
                                                .contains("draft"),
                                            orElse: () => null);
                                        log("stockOpname: ${stockOpname.toString()}");
                                        if (stockOpname != null) {
                                          var successSnackBar = SnackBar(
                                              backgroundColor:
                                                  ColorName.doneColor,
                                              content: Text(
                                                  'Successfully! get session stock opanme',
                                                  style: BaseText.whiteText14));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(successSnackBar);

                                          hasNotification = true;
                                          log("hasNotification: $hasNotification");

                                          timeUnformatted =
                                              stockOpname['date_create']
                                                  .toString()
                                                  .substring(10);
                                          log("timeUnformatted: ${timeUnformatted.toString()}");

                                          final date =
                                              stockOpname['date_create'];

                                          DateTime scheduleDate =
                                              DateTime.parse(date);
                                          log("scheduleDate: ${scheduleDate.toString()}");

                                          final dateTimeNow = DateTime.now();
                                          final resultDifferenceDay =
                                              scheduleDate
                                                  .difference(dateTimeNow)
                                                  .inDays;

                                          log("resultDifferenceDay: ${resultDifferenceDay.toString()}");
                                          dateOutput =
                                              Duration(days: resultDifferenceDay
                                                      // hours: hour,
                                                      // minutes: minute,
                                                      // seconds: second,
                                                      )
                                                  .inHours;
                                          log("dateOutput: ${dateOutput.toString()}");
                                          // log("endTime: ${endTime.toString()}");

                                          if (dateOutput
                                              .toString()
                                              .startsWith("-")) {
                                            setState(() {
                                              endTime = Duration(
                                                hours: dateOutput,
                                                minutes: 00,
                                                seconds: 00,
                                              ).inDays;
                                            });
                                            isFinishedTime = true;
                                            log("isFinishedTime: $isFinishedTime");
                                            // });
                                          } else if (dateOutput
                                              .toString()
                                              .startsWith("0")) {
                                            setState(() {
                                              endTime = Duration(
                                                hours: dateOutput,
                                                minutes: 00,
                                                seconds: 00,
                                              );
                                            });

                                            isToday = true;
                                            log("isToday: $isToday");
                                          } else {
                                            setState(() {
                                              endTime = Duration(
                                                hours: dateOutput,
                                                minutes: 00,
                                                seconds: 00,
                                              );
                                            });
                                          }
                                          log("endTime: ${endTime.toString()}");
                                        } else {
                                          stockOpname = null;
                                        }

                                        // }
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      color: ColorName.greyColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            (ResponsiveWrapper.of(context).isMobile)
                                ? SingleChildScrollView(
                                    child: Padding(
                                    // FIX: jarak nama dan dashboard terlalu jauh
                                    // inventory-v1.0.12-1
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 115),
                                    child: Wrap(
                                      children: newList.map<Widget>((e) {
                                        // if (e.title.toLowerCase().contains("receipts")) {
                                        return _buildItemOverview(
                                            e, sharedPreferences);
                                        // }
                                      }).toList(),
                                    ),
                                  ))
                                : SingleChildScrollView(
                                    child: Padding(
                                      // FIX: jarak nama dan dashboard terlalu jauh
                                      // inventory-v1.0.12-1
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 115),
                                      child: Center(
                                        child: Wrap(
                                          children: newList.map<Widget>((e) {
                                            // if (e.title.toLowerCase().contains("receipts")) {
                                            return _buildItemOverview(
                                                e, sharedPreferences);
                                            // }
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                            Positioned(
                              top: 50,
                              right: 20,
                              child: InkWell(
                                onTap: () {
                                  confirmToSignOutDialog(context, () async {
                                    await PreferenceHelper.clearUserCredential(
                                            sharedPreferences)
                                        .then((value) =>
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                AppRoutes.signIn,
                                                (route) => false));
                                  });
                                },
                                child: const Icon(
                                  Icons.logout_rounded,
                                  color: ColorName.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            }),
            bottomNavigationBar: Container(
              width: mediaQuery.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: ColorName.disableColor,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      // isSheetOpen = true;
                      // startTimer();
                      _buildStockOpname(context, stockOpname);
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorName.mainColor),
                          child: const Icon(
                            Icons.notifications_none_outlined,
                            color: ColorName.whiteColor,
                          ),
                        ),
                        Visibility(
                          visible: hasNotification,
                          child: Positioned(
                            right: 9,
                            top: 9,
                            child: CircleAvatar(
                              backgroundColor: ColorName.redColor,
                              radius: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text("1", style: BaseText.whiteText8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      if (listWarehouseName!.isEmpty) {
                        return;
                      } else {
                        _buildSelectWarehouse(context);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: mediaQuery.width - 100,
                      // padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorName.whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                  (listWarehouseName!.isEmpty)
                                      ? 'Pilih warehouse'
                                      : groupValue.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: BaseText.greyText14),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.arrow_forward_ios, size: 14))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onHomeRefresh() async {
    warehouseId = (warehouseId == 0) ? warehouseInitId : warehouseId;
    Future.delayed(
        const Duration(milliseconds: 50),
        () => getOverview(warehouseId: warehouseId).then((value) async {
              await Future.delayed(const Duration(milliseconds: 400),
                  () async => await getUser());
              // Future.delayed(const Duration(milliseconds: 600), () => getWarehouse());
              await Future.delayed(
                  const Duration(seconds: 1),
                  () async => await getStockCountSession(
                      userIds: user.id!, warehouseId: warehouseId));
            }));
  }

  Future<dynamic> _buildSelectWarehouse(BuildContext context) {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, sheetStateNew) {
            sheetState = sheetStateNew;

            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ListView(
                shrinkWrap: true,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih warehouse',
                        style: BaseText.mainTextStyle14
                            .copyWith(fontWeight: BaseText.semiBold),
                      ),
                      // const Spacer(flex: 2),
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close,
                            color: ColorName.mainColor, size: 16),
                      ),
                    ],
                  ),
                  CupertinoScrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: SizedBox(
                      // padding: EdgeInsets.onl(horizontal: 16.w),
                      width: double.infinity,
                      child: ListView.builder(
                          controller: scrollController,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: listWarehouseName?.length,
                          itemBuilder: (context, index) {
                            var e = listWarehouseName![index];

                            return RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: ColorName.mainColor,
                              value: e,
                              groupValue: groupValue,
                              onChanged: (value) {
                                sheetState(() {
                                  groupValue = value;
                                  // warehouseName = e.name;
                                  warehouseId = groupValue.id;
                                  warehouseName = groupValue.name;

                                  log(warehouseId.toString());
                                  log(warehouseName);
                                });
                                setState(() {});
                              },
                              title: Text(e.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: BaseText.blackText14),
                            );
                          }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  InkWell(
                      onTap: () {
                        if (groupValue != null) {
                          Future.delayed(const Duration(milliseconds: 250),
                              () => getOverview(warehouseId: warehouseId));
                          Future.delayed(const Duration(milliseconds: 650),
                              () => getUser());

                          Future.delayed(
                              const Duration(seconds: 2),
                              () => getStockCountSession(
                                  userIds: user.id ?? 0,
                                  warehouseId: warehouseId));
                        } else {
                          Navigator.pop(context);
                          var successSnackBar = SnackBar(
                              content: Text(
                                  const ResourceConstants()
                                      .selectWarehouseFirst,
                                  style: BaseText.whiteText14));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(successSnackBar);
                        }
                        Navigator.of(context).maybePop();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 8),
                        // height: 40.h,
                        child: Material(
                          color: ColorName.mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: SizedBox(
                            height: 43,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                  child: Text(
                                'Simpan',
                                style: BaseText.whiteText14
                                    .copyWith(fontWeight: BaseText.semiBold),
                              )),
                            ),
                          ),
                        ),
                      )),
                  // const SizedBox(height: 16)

                  const SizedBox(height: 24),
                ],
              ),
            );
          });
        });
  }

  void _buildStockOpname(BuildContext contex, dynamic upcomingToStock) {
    bool isEmpty = false;

    if (stockOpname == null) {
      setState(() {
        isEmpty = true;
        log("isEmpty: $isEmpty");
      });
    }

    Future<void> futureBottomSheet = showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, stockState) {
            // sheetSetState = stockState;

            return SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              child: Container(
                // height: mediaQuery.height / 1,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: ColorName.whiteColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Empty Stock Opname
                    Visibility(
                      visible: isEmpty,
                      child: SizedBox(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pemberitahuan Stock Opname',
                                    style: BaseText.mainTextStyle14.copyWith(
                                        fontWeight: BaseText.semiBold),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).maybePop(),
                                    icon: const Icon(Icons.close,
                                        color: ColorName.mainColor, size: 16),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      const AssetConstans().emptyHome,
                                      height: 145),
                                  const SizedBox(height: 24),
                                  Text(const ResourceConstants().emptyHomeTitle,
                                      style: BaseText.blackText20.copyWith(
                                          fontWeight: BaseText.semiBold)),
                                  const SizedBox(height: 16),
                                  Text(
                                      const ResourceConstants()
                                          .emptyHomeContentStockOp,
                                      style: BaseText.blackText12,
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 32),
                                  _buildViewAllSession(context),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Not Empty
                    Visibility(
                      visible: !isEmpty,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pemberitahuan Stock Opname',
                                    style: BaseText.mainTextStyle16.copyWith(
                                        fontWeight: BaseText.semiBold),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).maybePop(),
                                    icon: const Icon(Icons.close,
                                        color: ColorName.mainColor, size: 16),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              buildCustomFieldDetail(
                                  title: 'Warehouse',
                                  // value: "itemStockScheduled['product_id'][1]",
                                  value: (stockOpname == null ||
                                          stockOpname['warehouse_name'] ==
                                              false)
                                      ? ''
                                      : stockOpname['warehouse_name']),
                              buildCustomFieldDetail(
                                  title: 'Location Stock',
                                  // value: "itemStockScheduled['location_id'][1]",
                                  value: (stockOpname == null ||
                                          stockOpname['location_name'] == false)
                                      ? ''
                                      : stockOpname['location_name']),
                              //  buildCustomField(title: 'Address', value: stockOpname[''])   ,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildFieldIconDetail(
                                      title: 'Tanggal',
                                      // value: "itemStockScheduled['date']"
                                      value: (stockOpname == null ||
                                              stockOpname['date_create'] ==
                                                  false)
                                          ? ''
                                          : DateFormat(
                                                  "EEEE, d MMMM yyyy", "id_ID")
                                              .format(DateTime.parse(
                                                  stockOpname['date_create']
                                                      .substring(0, 10)))),
                                  buildFieldIconDetail(
                                      title: ' Jam',
                                      value: (stockOpname == null ||
                                              stockOpname['date_create'] ==
                                                  false)
                                          ? '-'
                                          : stockOpname['date_create']
                                              .toString()
                                              .substring(10, 16)),
                                ],
                              ),
                              const SizedBox(height: 32),
                              // Schedule Date - Current Date
                              InkWell(
                                onTap: () async {
                                  final stockSessionId = stockOpname["id"];
                                  if (isToday) {
                                    Future.delayed(
                                            const Duration(milliseconds: 50),
                                            () => startButtonSession(
                                                stockSessionId: stockSessionId))
                                        .then((value) {
                                      log("value start: $value");

                                      if (value
                                          .toLowerCase()
                                          .contains("true")) {
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          var successSnackBar = SnackBar(
                                              content: Text('Session Started..',
                                                  style: BaseText.whiteText14));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(successSnackBar);
                                        }).then(
                                            (value) async =>
                                                await Navigator.pushNamed(
                                                    context,
                                                    AppRoutes
                                                        .stockScheduleDetail,
                                                    arguments:
                                                        StockSessionDetailArgument(
                                                            stockSessionLines:
                                                                stockOpname,
                                                            isStartedButton:
                                                                true)));
                                      } else {
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          var notStartedSnackBar = SnackBar(
                                              backgroundColor:
                                                  ColorName.redColor,
                                              content: Text(value,
                                                  style: BaseText.whiteText14));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(notStartedSnackBar);
                                        }).then(
                                            (value) async =>
                                                await Navigator.pushNamed(
                                                    context,
                                                    AppRoutes
                                                        .stockScheduleDetail,
                                                    arguments:
                                                        StockSessionDetailArgument(
                                                            stockSessionLines:
                                                                stockOpname,
                                                            isStartedButton:
                                                                true)));
                                      }
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                    var unableToStartSnackBar = SnackBar(
                                        backgroundColor: ColorName.redColor,
                                        content: Text('Cannot Start Session..',
                                            style: BaseText.whiteText14));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(unableToStartSnackBar);
                                  }
                                },
                                child: Material(
                                  color: (isFinishedTime || isToday)
                                      ? ColorName.mainColor
                                      : ColorName.lightNewGreyColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: Center(
                                        // child: Text(
                                        // timeUnformatted.toString(),
                                        // (stockOpname == null ||
                                        //         stockOpname['date_create'] ==
                                        //             false)
                                        //     ? '-'
                                        //     : stockOpname['date_create'],
                                        // style: BaseText.whiteText14.copyWith(
                                        //     fontWeight: BaseText.semiBold),
                                        // endTime.toString()
                                        // ),
                                        child: (isFinishedTime)
                                            ? Text(
                                                "${endTime.toString().substring(1)} day ago",
                                                style: BaseText.whiteText14
                                                    .copyWith(
                                                        fontWeight:
                                                            BaseText.semiBold),
                                              )
                                            : (isToday)
                                                ? Text(
                                                    "Start",
                                                    style: BaseText.whiteText14
                                                        .copyWith(
                                                            fontWeight: BaseText
                                                                .semiBold),
                                                  )
                                                : (isEmpty)
                                                    ? const Text('')
                                                    : TimeRemaining(
                                                        duration: endTime,
                                                        style: BaseText
                                                            .whiteText14
                                                            .copyWith(
                                                                fontWeight:
                                                                    BaseText
                                                                        .semiBold),
                                                      )
                                        // : TimerCountdown(
                                        //     format: CountDownTimerFormat
                                        //         .hoursMinutesSeconds,
                                        //     timeTextStyle: BaseText
                                        //         .whiteText14
                                        //         .copyWith(
                                        //             fontWeight: BaseText
                                        //                 .semiBold),
                                        //     enableDescriptions: false,
                                        //     endTime: DateTime(
                                        //         2023, 08, 01, 09),
                                        //     onEnd: () {
                                        //       // isFinishedTime = true;

                                        //       // log(isFinishedTime
                                        //       //     .toString());

                                        //       // _buildGeneralDialog(
                                        //       //     context, 'Stock Reminder');
                                        //     },
                                        //   ),
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildViewAllSession(context),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
    futureBottomSheet.then((value) {
      // if (isFinishedTime) {
      //   _buildGeneralDialog(context, 'Stock Reminder');
      // }
      // setState(() {
      //   isFinishedTime = false;
      //   isToday = false;
      // });
    });
  }

  InkWell _buildViewAllSession(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.stockSchedule,
            arguments: StockCountSessionArgument(
                userIds: user.id ?? 0,
                warehouseId: (warehouseId == 0) ? warehouseInitId : warehouseId,
                isStartedButton: false));
      },
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Text('Lihat semua jadwal',
                    style: BaseText.mainTextStyle14)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 110),
              child: Divider(
                color: ColorName.mainColor,
                thickness: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemOverview(ItemOverview item, SharedPreferences preferences) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.operation,
            arguments: OperationArgument(
                titleAppbar: item.title, pickingTypeId: item.pickingTypeId));

        log("pickTypeId: ${item.pickingTypeId}");
      },
      child: SizedBox(
        // inventory-v1.0.12-1
        // FIX: margin di dalam dashboard terlalu besar
        height: 133,
        width: mediaQuery.width / 2.2,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: item.color,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: (item.icon.toLowerCase().contains(".svg"))
                              ? SvgPicture.asset(item.icon,
                                  color: ColorName.whiteColor,
                                  height: 18,
                                  width: 18)
                              : Image.asset(item.icon, height: 18, width: 18),
                        )),
                    const SizedBox(height: 16),
                    Text(item.titleTotal.toString(),
                        style: BaseText.blackText20
                            .copyWith(fontWeight: BaseText.black)),
                    const SizedBox(height: 4),
                    // inventory-v1.0.12-1
                    // FIX: size font receipt dll 16px semibold
                    Text(
                      item.title,
                      style: BaseText.greyText16
                          .copyWith(fontWeight: BaseText.semiBold),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                Positioned(
                  top: 9.5,
                  right: 11,
                  child: (item.iconBg.contains(".svg"))
                      ? SvgPicture.asset(
                          item.iconBg,
                          height: 56,
                          width: 56,
                          color: item.color.withOpacity(0.10),
                        )
                      : Image.asset(
                          item.iconBg,
                          // fit: BoxFit.cover,
                          height: 56,
                          width: 56,
                          color: item.color.withOpacity(0.10),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(const AssetConstans().emptyHome),
              const SizedBox(height: 24),
              Text(const ResourceConstants().emptyHomeTitle,
                  style: BaseText.blackText20
                      .copyWith(fontWeight: BaseText.semiBold)),
              const SizedBox(height: 16),
              Text(const ResourceConstants().emptyHomeContent,
                  style: BaseText.blackText12, textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}

class ItemOverview {
  int pickingTypeId;
  String warehouseName;
  int titleTotal;
  String title;
  String icon;
  String iconBg;
  Color color;

  ItemOverview({
    required this.pickingTypeId,
    required this.warehouseName,
    required this.titleTotal,
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.color,
  });
}

class StyleItemOverview {
  String name;
  String iconPath;
  String bgPath;
  Color color;

  StyleItemOverview({
    required this.name,
    required this.iconPath,
    required this.bgPath,
    required this.color,
  });
}

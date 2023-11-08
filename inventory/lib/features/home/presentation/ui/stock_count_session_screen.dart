import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory/core/navigation/argument/stock_count_session_line.dart';
import 'package:inventory/core/navigation/argument/stock_session_detail_argument.dart';

import '../../../../core/navigation/argument/stock_count_session.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../shared_libraries/common/theme/theme.dart';
import '../../../../shared_libraries/component/empty_state_operation.dart';
import '../../../../shared_libraries/component/state_badge_widget.dart';
import '../cubit/stock_opname_cubit/stock_count_session_cubit.dart';
import '../cubit/stock_opname_cubit/stock_count_session_state.dart';

class StockCountSessionScreen extends StatefulWidget {
  final StockCountSessionArgument stockCountSessionArgument;

  const StockCountSessionScreen(
      {Key? key, required this.stockCountSessionArgument})
      : super(key: key);

  @override
  State<StockCountSessionScreen> createState() =>
      _StockCountSessionScreenState();
}

class _StockCountSessionScreenState extends State<StockCountSessionScreen> {
  // List<StockOpnameSchedule> listStockOpnames = [
  List<dynamic> listStockOpname = [];
  var mediaQuery;

  @override
  void initState() {
    super.initState();
    log(widget.stockCountSessionArgument.userIds.toString());
    log(widget.stockCountSessionArgument.warehouseId.toString());

    if (widget.stockCountSessionArgument.userIds != 0 &&
        widget.stockCountSessionArgument.warehouseId != 0) {
      Future.delayed(const Duration(milliseconds: 100), getStockCountSession);
    }
  }

  getStockCountSession() async {
    context.read<StockCountSessionCubit>().getStockCountSession(
      userId: [widget.stockCountSessionArgument.userIds],
      warehouseId: widget.stockCountSessionArgument.warehouseId,
      isFindOne: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorName.lightGreyColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorName.blackColor,
                size: 16,
              ),
            ),
            centerTitle: true,
            title: Text('Sessions',
                style: BaseText.blackText16
                    .copyWith(fontWeight: BaseText.semiBold)),
            backgroundColor: ColorName.whiteColor,
            elevation: 1,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: BlocConsumer<StockCountSessionCubit, StockCountSessionState>(
            listener: (context, state) {
              final status = state.stockCountSessionState.status;

              if (status.isError) {
                var errorSnackBar = SnackBar(
                    content: Text(
                        'Error ${state.stockCountSessionState.failure?.errorMessage}',
                        style: BaseText.whiteText14));
                ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
              } else if (status.isHasData) {
                listStockOpname =
                    state.stockCountSessionState.data['result'] ?? [];
                listStockOpname
                    .removeWhere((element) => element['date_create'] == false);
                listStockOpname.sort(
                    (a, b) => b['date_create'].compareTo(a['date_create']));
                log("listStockOpname: ${listStockOpname.map((e) => jsonEncode(e)).toList().toString()}");
              }
            },
            builder: (context, state) {
              final status = state.stockCountSessionState.status;

              if (status.isHasData) {
                return SizedBox(
                    height: mediaQuery.height,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: listStockOpname.length,
                        itemBuilder: (context, index) {
                          var item = listStockOpname[index];

                          final idSession = item['id'];
                          var date = (item['date_create'] == false)
                              ? ''
                              : item['date_create'];
                          var locationStock = (item['location_name'] == false)
                              ? ''
                              : item['location_name'];
                          var warehouse = (item['warehouse_name'] == false)
                              ? ''
                              : item['warehouse_name'];

                          return _buildItemStockSchedule(
                              item, date, locationStock, warehouse, idSession);
                        }));
              } else if (status.isError) {
                return Text(
                    state.stockCountSessionState.failure?.errorMessage ?? '');
              } else {
                return buildEmptyResultOperation(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemStockSchedule(
      item, dynamic date, dynamic location, dynamic warehouse, int sessionId) {
    Color color;
    if (item['state'].toString().toLowerCase().contains('in progress')) {
      color = ColorName.backOrderColor;
    } else if (item['state'].toString().toLowerCase().contains('submitted')) {
      color = ColorName.readyColor;
    } else if (item['state'].toString().toLowerCase().contains('done')) {
      color = ColorName.doneColor;
    } else {
      color = ColorName.greyColor;
    }
    // StockSessionLines sessionItem = item;
    log("sessionItem===${item.toString()}");
    // String dateFormatted = '';

    getFormatedDate(date) {
      if (date.toString().isEmpty) {
        return '';
      } else {
        var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
        var inputDate = inputFormat.parse(date);
        var outputFormat = DateFormat('dd/MM/yyyy hh:mm');
        return outputFormat.format(inputDate);
      }
    }

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.stockScheduleDetail,
          arguments: StockSessionDetailArgument(
              stockSessionLines: item, isStartedButton: false)),
      child: SizedBox(
        // height: 87,
        // width: double.infinity,
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: getFormatedDate(date),
                          style: BaseText.blackText16
                              .copyWith(fontWeight: BaseText.semiBold),
                          children: const [
                            // TextSpan(
                            //   text: ' 11:00',
                            //   style: BaseText.blackText16
                            //       .copyWith(fontWeight: BaseText.semiBold),
                            // )
                          ]),
                    ),
                    stateBadge(color: color, state: item['state'])
                  ],
                ),
                const SizedBox(height: 8),
                Text(warehouse, style: BaseText.greyText14),
                const SizedBox(height: 4),
                Text(location,
                    style: BaseText.greyText14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StockOpnameSchedule {
  final String date;
  final String warehouse;
  final String location;

  StockOpnameSchedule(this.date, this.warehouse, this.location);
}

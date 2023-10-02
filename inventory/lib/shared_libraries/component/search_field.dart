import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/theme/theme.dart';

class SearchField extends StatefulWidget {
  BuildContext context;

  String queryKey;

  dynamic keySearch;

  TextEditingController controller;

  dynamic clearData;

  dynamic onSearch;

  SearchField(
    this.context, {
    Key? key,
    required this.queryKey,
    required this.keySearch,
    required this.controller,
    required this.onSearch,
    required this.clearData,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      // margin: const EdgeInsets.only(bottom: 10, top: 20),
      // height: 45,
      // width: ResponsiveWrapper.of(context).isTablet
      //           ? MediaQuery.of(context).size.width / 1.12 : ResponsiveWrapper.of(context).isLargerThan(MOBILE) ? MediaQuery.of(context).size.width / 1.12 : MediaQuery.of(context).size.width / 1.25,
      child: Form(
        key: widget.keySearch,
        child: TextFormField(
          keyboardType: TextInputType.text,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: widget.onSearch,

          // getSelectedValue: (item) {
          //   log(item);
          // },
          controller: widget.controller,
          decoration: InputDecoration(
              prefixIcon: const Icon(
                CupertinoIcons.search,
                size: 15,
                color: ColorName.blackColor,
              ),
              prefixIconColor: ColorName.greyColor,
              // suffixIcon: (widget.controller.text.toString() != '' ||
              //         widget.controller.text.isNotEmpty)
              //     ? InkWell(
              //         onTap: () {
              //           setState(() {
              //             widget.controller.clear();

              //             widget.clearData;
              //           });
              //         },
              //         child: const Icon(
              //           CupertinoIcons.clear_circled,
              //           size: 15,
              //           color: ColorName.greyColor,
              //         ))
              //     : null,
              contentPadding: EdgeInsets.zero,
              hintText: "Cari...",
              hintStyle: BaseText.greyTextStyle
                  .copyWith(fontSize: 14, color: ColorName.newGreyColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: ColorName.borderNewColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: ColorName.borderNewColor,
                ),
              ),
              focusColor: ColorName.mainColor,
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: ColorName.mainColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6))),
        ),
      ),
    );
  }
}

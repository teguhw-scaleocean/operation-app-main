import 'package:flutter/material.dart';

import '../common/theme/theme.dart';

Widget buildCustomField({required String title, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(title,
          style: BaseText.greyText12.copyWith(fontWeight: BaseText.semiBold)),
      const SizedBox(height: 4),
      Text(value,
          style: BaseText.blackText14.copyWith(fontWeight: BaseText.medium)),
      const SizedBox(height: 16),
    ],
  );
}

Widget buildCustomFieldDetail({required String title, required String value}) {
  // Text(
  //                                                               DateFormat(
  //                                                                       "EEEE, d MMMM yyyy",
  //                                                                       "id_ID")
  //                                                                   .format(DateTime
  //                                                                       .now()),
  //                                                               style: BaseText
  //                                                                   .whiteText14),
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(title,
          style: BaseText.greyText14.copyWith(
              fontWeight: BaseText.medium, color: ColorName.borderNewColor)),
      const SizedBox(height: 4),
      Text(value,
          style: BaseText.blackText16.copyWith(fontWeight: BaseText.semiBold)),
      const SizedBox(height: 16),
    ],
  );
}

Widget buildFieldIconDetail(
    {required Icon icon, required String title, required String value}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: BaseText.greyText14.copyWith(
              fontWeight: BaseText.medium, color: ColorName.borderNewColor)),
      const SizedBox(height: 4),
      Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Text(value,
              style:
                  BaseText.blackText16.copyWith(fontWeight: BaseText.semiBold)),
          const SizedBox(height: 16),
        ],
      ),
    ],
  );
}

RichText buildLabelLocation({required String location}) {
  return RichText(
    text: TextSpan(
        text: 'Source Location: ',
        style: BaseText.mainTextStyle16,
        children: [
          TextSpan(
              text: location,
              style: BaseText.mainTextStyle16
                  .copyWith(fontWeight: BaseText.semiBold))
        ]),
  );
}

Container buildCountButton(Icon icon, bool isDisable) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(35),
      border: Border.all(
          color: isDisable ? ColorName.newGreyColor : ColorName.mainColor),
      color: ColorName.whiteColor,
    ),
    child: Padding(padding: const EdgeInsets.all(4), child: icon),
  );
}

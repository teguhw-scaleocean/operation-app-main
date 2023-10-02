import 'package:flutter/material.dart';

import '../common/theme/theme.dart';

Widget buildFieldIcon(
    {required Icon icon, required String title, required String value}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: BaseText.greyText12.copyWith(fontWeight: BaseText.semiBold)),
      Row(
        children: [
          icon,
          const SizedBox(height: 4),
          Text(value,
              style:
                  BaseText.blackText14.copyWith(fontWeight: BaseText.medium)),
          const SizedBox(height: 16),
        ],
      ),
    ],
  );
}

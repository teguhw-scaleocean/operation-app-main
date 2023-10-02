import 'package:flutter/material.dart';

import '../common/theme/theme.dart';

Widget buildTitleAppBar(BuildContext context, String title) {
  return Container(
    padding: const EdgeInsets.only(top: 20),
    // height: 35.h,
    child: Text(title,
        textAlign: TextAlign.center,
        style: BaseText.blackText16.copyWith(fontWeight: BaseText.semiBold)),
  );
}

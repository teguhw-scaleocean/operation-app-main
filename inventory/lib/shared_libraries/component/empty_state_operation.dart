import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/constants/resource_constants.dart';
import '../common/theme/theme.dart';

Align buildEmptyResultOperation(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 4.5),
        SvgPicture.asset(const AssetConstans().emptyHome, height: 145),
        const SizedBox(height: 24),
        Text(const ResourceConstants().emptyHomeTitle,
            style:
                BaseText.blackText20.copyWith(fontWeight: BaseText.semiBold)),
        const SizedBox(height: 16),
        Text(const ResourceConstants().emptyOperationContent,
            style: BaseText.blackText12, textAlign: TextAlign.center)
      ],
    ),
  );
}

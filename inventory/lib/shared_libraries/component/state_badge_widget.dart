import 'package:flutter/material.dart';

import '../common/theme/theme.dart';

Container stateBadge({required dynamic color, required String state}) {
  return Container(
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        state.toString(),
        style: BaseText.whiteText12.copyWith(fontWeight: BaseText.medium),
      ),
    ),
  );
}

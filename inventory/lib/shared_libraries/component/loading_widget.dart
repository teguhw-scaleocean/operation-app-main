import 'package:flutter/material.dart';

import '../common/theme/theme.dart';

Widget buildLoadingWidget() {
  return const Center(
      child: CircularProgressIndicator.adaptive(
          backgroundColor: ColorName.mainColor));
}

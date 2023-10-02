import 'package:flutter/material.dart';

import '../common/theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  double height;
  double width;
  String title;

  PrimaryButton({
    Key? key,
    required this.height,
    required this.width,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorName.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
            child: Text(
          title,
          style: BaseText.whiteText14.copyWith(fontWeight: BaseText.semiBold),
        )),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  double height;
  double width;
  String title;

  SecondaryButton({
    Key? key,
    required this.height,
    required this.width,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorName.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(
            color: ColorName.mainColor,
            width: 1,
          )),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
            child: Text(
          title,
          style:
              BaseText.mainTextStyle14.copyWith(fontWeight: BaseText.semiBold),
        )),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  double height;
  double width;
  String title;

  LoadingButton({
    Key? key,
    required this.height,
    required this.width,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorName.disableColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
            child: Text(
          title,
          style: BaseText.whiteText14.copyWith(fontWeight: BaseText.semiBold),
        )),
      ),
    );
  }
}

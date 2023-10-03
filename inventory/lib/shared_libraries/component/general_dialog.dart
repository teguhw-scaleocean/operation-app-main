import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/constants/resource_constants.dart';
import '../common/theme/theme.dart';

Future<dynamic> buildGeneralDialog(BuildContext context, String title) {
  return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
        );
      });
}

Future errorDialog(BuildContext context, String title, String content) async {
  showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: 120,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(title,
                      textAlign: TextAlign.left,
                      style: BaseText.blackText18
                          .copyWith(fontWeight: BaseText.semiBold)),
                  const SizedBox(height: 8),
                  Text(content,
                      textAlign: TextAlign.left, style: BaseText.greyText12),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      });
}

confirmToSubmitDialog(BuildContext context, void Function()? onTap) {
  var mediaQuery = MediaQuery.of(context).size;
  showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return SizedBox(
          child: Dialog(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 170,
              width: 328,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(const ResourceConstants().submitTitle,
                        textAlign: TextAlign.left,
                        style: BaseText.blackText16
                            .copyWith(fontWeight: BaseText.semiBold)),
                    const SizedBox(height: 8),
                    Text(const ResourceConstants().submitContent,
                        textAlign: TextAlign.left, style: BaseText.greyText12),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Material(
                            color: ColorName.whiteColor,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: ColorName.mainColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                            child: SizedBox(
                              height: 50,
                              width: mediaQuery.width / 3,
                              child: Center(
                                  child: Text(
                                'TIDAK',
                                style: BaseText.mainTextStyle14
                                    .copyWith(fontWeight: BaseText.semiBold),
                              )),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onTap,
                          child: Material(
                            color: ColorName.mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: SizedBox(
                              height: 50,
                              width: mediaQuery.width / 3,
                              child: Center(
                                  child: Text(
                                'YA',
                                style: BaseText.whiteText14
                                    .copyWith(fontWeight: BaseText.semiBold),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

confirmToSignOutDialog(BuildContext context, void Function()? onTap) {
  var mediaQuery = MediaQuery.of(context).size;
  showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return ColoredBox(
          color: const Color(0x80000000),
          child: Dialog(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 170,
              width: 328,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text('Sign Out',
                        textAlign: TextAlign.left,
                        style: BaseText.blackText16
                            .copyWith(fontWeight: BaseText.semiBold)),
                    const SizedBox(height: 8),
                    Text(const ResourceConstants().signOutContent,
                        textAlign: TextAlign.left, style: BaseText.greyText12),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Material(
                            color: ColorName.mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: SizedBox(
                              height: 50,
                              width: mediaQuery.width / 3,
                              child: Center(
                                  child: Text(
                                'Tidak',
                                style: BaseText.whiteText14
                                    .copyWith(fontWeight: BaseText.semiBold),
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: onTap,
                          child: Material(
                            color: ColorName.whiteColor,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: ColorName.mainColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                            child: SizedBox(
                              height: 50,
                              width: mediaQuery.width / 3,
                              child: Center(
                                  child: Text(
                                'Ya',
                                style: BaseText.mainTextStyle14
                                    .copyWith(fontWeight: BaseText.semiBold),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

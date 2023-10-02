// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:sizer/sizer.dart';

// import '../../../../core/navigation/routes.dart';
// import '../../../../shared_libraries/common/constants/resource_constants.dart';
// import '../../../../shared_libraries/common/theme/theme.dart';

// class SignInMethod extends StatefulWidget {
//   const SignInMethod({Key? key}) : super(key: key);

//   @override
//   State<SignInMethod> createState() => _SignInMethodState();
// }

// class _SignInMethodState extends State<SignInMethod> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 2), () => showSignInMethod(context));
//   }

//   showSignInMethod(BuildContext context) {
//     showCupertinoDialog(
//         barrierDismissible: true,
//         context: context,
//         builder: (context) {
//           return SizedBox(
//             child: Dialog(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.w)),
//               child: SizedBox(
//                 height: 270.h,
//                 width: 328.w,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 16.h),
//                     SvgPicture.asset(const AssetConstans().finger),
//                     SizedBox(height: 24.h),
//                     Text(const ResourceConstants().signInMethodTitle,
//                         textAlign: TextAlign.center,
//                         style: BaseText.blackText16
//                             .copyWith(fontWeight: BaseText.semiBold)),
//                     SizedBox(height: 8.h),
//                     Text(const ResourceConstants().signInMethodContent,
//                         textAlign: TextAlign.center,
//                         style: BaseText.greyText12),
//                     SizedBox(height: 40.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         InkWell(
//                           onTap: () => Navigator.pushNamed(context, AppRoutes.signIn),
//                           child: Material(
//                             color: ColorName.whiteColor,
//                             shape: RoundedRectangleBorder(
//                               side: const BorderSide(
//                                 color: ColorName.mainColor,
//                                 width: 1,
//                               ),
//                                 borderRadius: BorderRadius.circular(100)),
//                             child: SizedBox(
//                               height: 50.h,
//                               width: SizerUtil.height / 3,
//                               child: Center(
//                                   child: Text(
//                                 'TIDAK',
//                                 style: BaseText.mainTextStyle14
//                                     .copyWith(fontWeight: BaseText.semiBold),
//                               )),
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () => Navigator.of(context).maybePop(),
//                           child: Material(
//                             color: ColorName.mainColor,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(100)),
//                             child: SizedBox(
//                               height: 50.h,
//                               width: ScreenUtil().screenWidth / 3,
//                               child: Center(
//                                   child: Text(
//                                 'YA',
//                                 style: BaseText.whiteText14
//                                     .copyWith(fontWeight: BaseText.semiBold),
//                               )),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16.h),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(onPressed: () => showSignInMethod(context), icon: const Icon(Icons.ac_unit_rounded))
//         ],
//       ),
//     );
//   }
// }

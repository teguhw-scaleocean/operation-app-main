import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/network/env/env.dart';
import '../../../../shared_libraries/common/constants/resource_constants.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../shared_libraries/common/theme/theme.dart';
import '../splash_cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 1),
  //       () => Navigator.of(context).pushNamed(AppRoutes.onboarding));
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.mainColor,
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
            body: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) async {
            final status = state.splashState.status;
            if (status.isHasData) {
              if (state.splashState.data ==
                  AppConstants.cachedKey.onBoardingKey) {
                Navigator.pushNamed(context, AppRoutes.signIn);
              }
              if (state.splashState.data == AppConstants.cachedKey.tokenKey) {
                // final isAuthenticated = await LocalAuthHelper.scanFingerprint();

                // if (isAuthenticated) {
                Navigator.pushNamed(context, AppRoutes.home);
                // }
              }
            }
            if (status.isNoData) {
              Navigator.pushNamed(context, AppRoutes.onboarding);
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  ColorName.gradient1Color,
                  ColorName.gradient2Color,
                ])),
            child: Center(
              child: SvgPicture.asset(const AssetConstans().splash),
            ),
          ),
        )),
      ),
    );
  }
}

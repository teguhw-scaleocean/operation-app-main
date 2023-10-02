import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../shared_libraries/common/constants/resource_constants.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../shared_libraries/common/theme/theme.dart';
import '../onboarding_cubit/onboarding_cubit.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            final status = state.onBoardState.status;
            if (status.isHasData) {
              // toSignIn();
              Navigator.pushNamed(context, AppRoutes.signIn);
            }
          },
          child: IntroductionScreen(
            globalBackgroundColor: ColorName.lightBackgroundColor,
            pages: [
              PageViewModel(
                image: SvgPicture.asset(const AssetConstans().onBoard1),
                title: const ResourceConstants().onBoardTitle1,
                body: const ResourceConstants().onBoardDescription1,
                decoration: PageDecoration(
                  imageFlex: 2,
                  titlePadding: const EdgeInsets.only(bottom: 10.0, top: 64.0),
                  contentMargin: const EdgeInsets.symmetric(horizontal: 16.0),
                  titleTextStyle: BaseText.blackText18
                      .copyWith(fontWeight: BaseText.semiBold),
                  bodyTextStyle: BaseText.greyText12,
                ),
              ),
              PageViewModel(
                image: SvgPicture.asset(const AssetConstans().onBoard2),
                title: const ResourceConstants().onBoardTitle2,
                body: const ResourceConstants().onBoardDescription2,
                decoration: PageDecoration(
                  imageFlex: 2,
                  titlePadding: const EdgeInsets.only(bottom: 10.0, top: 64.0),
                  contentMargin: const EdgeInsets.symmetric(horizontal: 16.0),
                  titleTextStyle: BaseText.blackText18
                      .copyWith(fontWeight: BaseText.semiBold),
                  bodyTextStyle: BaseText.greyText12,
                ),
              ),
            ],
            onDone: () =>
                context.read<OnboardingCubit>().saveOnboardingSession(),
            showBackButton: false,
            showNextButton: false,
            showSkipButton: true,
            dotsDecorator: const DotsDecorator(
                size: Size(10.0, 10.0),
                color: ColorName.lightNewGreyColor,
                activeColor: ColorName.mainColor,
                activeSize: Size(24.0, 6.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            skip: const Text(
              "Lewati",
              style: TextStyle(
                color: ColorName.mainColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            done: const Text(
              "Selesai",
              style: TextStyle(
                color: ColorName.mainColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
    );
  }
}

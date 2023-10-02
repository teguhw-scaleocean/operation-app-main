import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/env/env.dart';
import '../../../../domains/auth/domain/usecase/get_onboarding_usecase.dart';
import '../../../../domains/auth/domain/usecase/get_token_usecase.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetOnBoardingUseCase getOnBoardingUseCase;
  final GetTokenUsecase getTokenUsecase;

  SplashCubit(
      {required this.getOnBoardingUseCase, required this.getTokenUsecase})
      : super(SplashState(splashState: ViewData.initial()));

  Future<void> splashInit() async {
    await Future.delayed(const Duration(seconds: 3));
    final result = await getOnBoardingUseCase.call(const NoParams());

    return result.fold(
        (failure) => emit(
              SplashState(
                splashState: ViewData.error(
                    message: failure.errorMessage, failure: failure),
              ),
            ), (data) async {
      if (data) {
        final checkToken = await getTokenUsecase.call(const NoParams());

        checkToken.fold(
            (failure) => emit(
                  SplashState(
                    splashState: ViewData.error(
                        message: failure.errorMessage, failure: failure),
                  ),
                ), (dataToken) async {
          if (dataToken.isEmpty) {
            emit(
              SplashState(
                splashState:
                    ViewData.loaded(data: AppConstants.cachedKey.onBoardingKey),
              ),
            );
          } else {
            emit(
              SplashState(
                splashState:
                    ViewData.loaded(data: AppConstants.cachedKey.tokenKey),
              ),
            );
          }
        });
      } else {
        emit(SplashState(splashState: ViewData.noData(message: "No Data")));
      }
    });
  }
}

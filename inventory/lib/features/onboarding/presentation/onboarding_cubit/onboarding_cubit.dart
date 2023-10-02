import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domains/auth/domain/usecase/cached_onboarding_usecase.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../shared_libraries/common/use_case/use_case.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CachedOnboardingUsecase cachedOnboardingUsecase;

  OnboardingCubit({required this.cachedOnboardingUsecase})
      : super(OnboardingState(onBoardState: ViewData.initial()));

  Future<void> saveOnboardingSession() async {
    log('save onboarding');
    final result = await cachedOnboardingUsecase.call(const NoParams());

    return result.fold(
      (failure) => emit(OnboardingState(
          onBoardState:
              ViewData.error(message: failure.errorMessage, failure: failure))),
      (data) =>
          emit(OnboardingState(onBoardState: ViewData.loaded(data: data))),
    );
  }
}

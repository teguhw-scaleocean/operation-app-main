part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  final ViewData<bool> onBoardState;

  const OnboardingState({required this.onBoardState});

  OnboardingState copyWith({ViewData<bool>? onBoardState}) {
    return OnboardingState(onBoardState: onBoardState ?? this.onBoardState);
  }

  @override
  List<Object?> get props => [onBoardState];
}


part of 'splash_cubit.dart';

class SplashState extends Equatable {
  final ViewData<String> splashState;

  const SplashState({required this.splashState});

  SplashState copyWith({ViewData<String>? splashState}) {
    return SplashState(splashState: splashState ?? this.splashState);
  }

  @override
  List<Object?> get props => [splashState];
}

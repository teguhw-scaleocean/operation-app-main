part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  /// [signInDataState] State for sign in with ViewData type
  /// which can be Initial, isLoading, noData, hasData or isError
  final ViewData signInDataState;

  const SignInState({required this.signInDataState});

  SignInState copyWith({ViewData? signInDataState}) {
    return SignInState(
        signInDataState: signInDataState ?? this.signInDataState);
  }

  @override
  List<Object?> get props => [signInDataState];
}

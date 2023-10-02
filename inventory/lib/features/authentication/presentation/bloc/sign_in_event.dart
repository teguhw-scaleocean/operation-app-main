part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

/// [SignIn] An event for credential authentication
/// This also creates a param
/// to the AuthRequestEntity that will be used in sign in button.
class SignIn extends SignInEvent {
  final AuthRequestEntity authRequest;

  const SignIn({required this.authRequest});

  @override
  List<Object?> get props => [authRequest];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domains/auth/domain/entity/request/auth_request_entity.dart';
import '../../../../domains/auth/domain/usecase/cached_token_usecase.dart';
import '../../../../domains/auth/domain/usecase/sign_in_usecase.dart';
import '../../../../shared_libraries/common/error/failure_response.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase signInUseCase;
  final CachedTokenUsecase cachedTokenUsecase;

  SignInBloc({required this.signInUseCase, required this.cachedTokenUsecase})
      : super(
          /// Define signInState initial
          SignInState(
            signInDataState: ViewData.initial(),
          ),
        ) {
    on<SignIn>((event, emit) async {
      /// Indicates signInState loading message.
      emit(SignInState(signInDataState: ViewData.loading()));

      if (event.authRequest.params.db.isNotEmpty &&
          event.authRequest.params.login.isNotEmpty &&
          event.authRequest.params.password.isNotEmpty) {
        /// Calls signInUsecase to [result] if the email field and password field are not empty.
        final result = await signInUseCase.call(event.authRequest);

        return result.fold(

            /// Indicates signInState failure message.
            (failure) => emit(
                  SignInState(
                    signInDataState: ViewData.error(
                      message: failure.errorMessage,
                      failure:
                          FailureResponse(errorMessage: failure.errorMessage),
                    ),
                  ),
                ), (data) async {
          if (!data.toString().contains('error') &&
              data.toString().contains('result')) {
            /// [cachedTokenUsecase] Stores token data if the response body
            /// contains a result field and not an error field.
            await cachedTokenUsecase.call(data["result"]["token"]);

            /// If successfully sign in then load response [data] with [dynamic] type.
            emit(SignInState(signInDataState: ViewData.loaded(data: data)));
          } else {
            /// Indicates error message
            ///
            /// Then mapping according to the error message response from authentication
            /// whether 404 or access denied.
            emit(SignInState(
                signInDataState: ViewData.error(
                    message: data["error"]["data"]["message"],
                    failure: FailureResponse(
                        errorMessage: data["error"]["data"]["message"]))));
          }
        });
      }
      // else if (event.authRequest.params.db.isEmpty || event.authRequest.params.login.isEmpty ||
      //     event.authRequest.params.password.isEmpty) {
      //   /// Indicates error message
      //   ///
      //   /// If the email field and password field are empty
      //   /// or not filled in by the user.
      //   emit(SignInState(
      //       signInDataState: ViewData.error(
      //           message: 'Please fill in your email or password ',
      //           failure: const FailureResponse(
      //               errorMessage: 'Please fill in your email or password '))));
      // }
    });
  }
}

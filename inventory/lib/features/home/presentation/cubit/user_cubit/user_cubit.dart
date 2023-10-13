import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:inventory/shared_libraries/utils/pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/env/env.dart';
import '../../../../../domains/home/data/model/request/user_request_dto.dart';
import '../../../../../domains/home/domain/usecase/get_user_usecase.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../../shared_libraries/utils/key_helper.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserUsecase getUserUsecase;
  final SharedPreferences sharedPreferences;

  UserCubit({required this.getUserUsecase, required this.sharedPreferences})
      : super(UserState(
          userState: ViewData.initial(),
          // operationState: ViewData.initial(),
        ));

  var companyId;
  var userId;

  getUser({required String emailAddress}) async {
    emit(UserState(userState: ViewData.loading()));

    String token = sharedPreferences.getString(KeyHelper.token) ?? '';
    // String emailAddress = sharedPreferences.getString(KeyHelper.username) ?? '';

    UserRequestDto params =
        UserRequestDto(token: token, emailAddress: emailAddress);

    var result = await getUserUsecase.call(params);
    return result.fold(
        (failure) => emit(UserState(
            userState: ViewData.error(
                message: failure.errorMessage,
                failure: failure))), (data) async {
      final user = data.result.first;
      companyId = user.companyId?.first;
      userId = user.id;

      log("companyId === ${companyId.toString()}");

      await PreferenceHelper.saveUserResModel(
          sharedPreferences, userId, companyId);

      emit(
        UserState(
          userState: ViewData.loaded(data: data),
        ),
      );
    });
  }
}

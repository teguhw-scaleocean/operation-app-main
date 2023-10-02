import 'package:equatable/equatable.dart';

import '../../../../../domains/home/data/model/response/user_response_dto.dart';
import '../../../../../shared_libraries/common/state/view_data_state.dart';

class UserState extends Equatable {
  final ViewData<UserResponseDto> userState;

  const UserState({required this.userState});

  UserState copyWith({ViewData<UserResponseDto>? userState}) {
    return UserState(userState: userState ?? this.userState);
  }

  @override
  List<Object?> get props => [userState];
}

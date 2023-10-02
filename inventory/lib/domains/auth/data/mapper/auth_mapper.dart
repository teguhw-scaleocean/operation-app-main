import '../../domain/entity/request/auth_request_entity.dart';
import '../../domain/entity/response/auth_entity.dart';
import '../model/request/auth_request_body_dto.dart';
import '../model/response/auth_response_dto.dart';

class AuthMapper {
  AuthEntity mapAuthResponseDtoToAuthEntity(AuthResponseDto? authDto) {
    return AuthEntity(
        jsonrpc: authDto?.jsonrpc ?? "",
        id: authDto?.id ?? 0,
        result: mapResultDtoToResultEntity(authDto?.result));
  }

  ResultEntity mapResultDtoToResultEntity(Result? result) {
    return ResultEntity(
        token: result?.token ?? "",
        uid: result?.uid ?? 0,
        globalToken: result?.globalToken ?? false);
  }

  AuthRequestBodyDto mapAuthRequestEntityToAuthRequestDto(
      AuthRequestEntity authRequestEntity) {
    return AuthRequestBodyDto(
        jsonrpc: authRequestEntity.jsonrpc,
        params: mapToParamsDto(authRequestEntity.params));
  }

  Params mapToParamsDto(ParamsEntity params) {
    return Params(
        login: params.login, password: params.password, db: params.db);
  }
}

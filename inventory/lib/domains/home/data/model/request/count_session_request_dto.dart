// ignore_for_file: public_member_api_docs, sort_constructors_first
class CountSessionRequestDto {
  String token;
  int userId;
  int warehouseId;

  CountSessionRequestDto({
    required this.token,
    required this.userId,
    required this.warehouseId,
  });
}

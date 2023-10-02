import '../common/constants/resource_constants.dart';

class ValidateFieldHelper {
  ValidateFieldHelper();

  String? validateField(String? value, bool isEmail, bool isPassword) {
    if (value == null || value.isEmpty) {
      if (isEmail) {
        return const ResourceConstants().emailFieldErrorMessage;
      } else if (isPassword) {
        return const ResourceConstants().passwordFieldErrorMessage;
      } else {
        return const ResourceConstants().serverFieldErrorMessage;
      }
    }
    return null;
  }
}

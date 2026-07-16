class AppValidators {
  AppValidators._();

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'validation_email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_required';
    }
    if (value.length < 8) {
      return 'validation_password';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value != password) {
      return 'validation_confirm_password';
    }
    return null;
  }
}

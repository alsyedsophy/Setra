import '../utils/validators.dart';

extension StringExtensions on String {
  /// True when the string is null, empty, or only whitespace.
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => trim().isNotEmpty;

  bool get isValidEmail => AppValidators.email(this) == null;

  int? toIntOrNull() => int.tryParse(this);
}

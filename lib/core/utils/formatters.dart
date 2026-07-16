import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String currency(double amount, {String? locale, String? symbol}) {
    return NumberFormat.currency(locale: locale, symbol: symbol).format(amount);
  }

  static String date(
    DateTime date, {
    String? locale,
    String pattern = 'yMMMMd',
  }) {
    return DateFormat(pattern, locale).format(date);
  }

  static String compactNumber(num value, {String? locale}) {
    return NumberFormat.compact(locale: locale).format(value);
  }
}

import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String formatWithTime(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }
}

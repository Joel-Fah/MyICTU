import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExt on DateTime {
  String get relative => timeago.format(this);
  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());
}

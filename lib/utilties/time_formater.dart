import 'package:date_time_format/date_time_format.dart';

String formateTime(DateTime date) {
  return DateTimeFormat.format(date, format: r'D, j M, g:i a');
}

String formateStringTime(String date) {
  final dateTime = DateTime.tryParse(date);
  if (dateTime == null) return date;
  return DateTimeFormat.format(dateTime, format: r'D, j M, g:i a');
}

String formateDateWithoutTime(DateTime date) {
  return DateTimeFormat.format(date, format: r'D, j M');
}

String formateDateStringWithoutTime(String date) {
  final dateTime = DateTime.tryParse(date);
  if (dateTime == null) return date;
  return DateTimeFormat.format(dateTime, format: r'D, j M');
}

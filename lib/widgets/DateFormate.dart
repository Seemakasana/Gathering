import 'package:intl/intl.dart';

class customFormat{
  static String formatEventDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }
  static String formatEventTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp).toLocal();
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
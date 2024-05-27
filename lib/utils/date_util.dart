import 'package:intl/intl.dart';

class DateUtil {
  static DateTime parseDateTime(String dateTimeString) {
    final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return format.parse(dateTimeString);
  }
}

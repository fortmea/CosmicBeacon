import 'package:intl/intl.dart';

DateTime parseCustomDate(String dateString) {
  DateFormat inputFormat = DateFormat('yyyy-MMM-dd HH:mm');
  DateTime parsedDate = inputFormat.parse(dateString);

  return parsedDate;
}

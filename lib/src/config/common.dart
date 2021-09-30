import 'package:intl/intl.dart';

String getFormattedDate(int date) {
  DateFormat formattercurrentDate = new DateFormat('dd/MM/yyyy');
  var dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(date);
  var formatedDate = formattercurrentDate.format(dateFromTimeStamp);
  return formatedDate;
}

String formatSlot(int number) {
  var startingTime = number.toString();
  var startingTimeTemp;
  if (startingTime.length == 3) {
    startingTimeTemp =
        '0' + startingTime.substring(0, 1) + ':' + startingTime.substring(1);
  } else {
    startingTimeTemp =
        startingTime.substring(0, 2) + ':' + startingTime.substring(2);
  }
  return startingTimeTemp;
}

String getTimeFromMilisecond(int number) {
  var now = DateTime.fromMillisecondsSinceEpoch(number);
  final DateFormat formatter = DateFormat('kk:mm');
  final String formatted = formatter.format(now);
  return formatted;
}

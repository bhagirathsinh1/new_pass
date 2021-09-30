String getFormatedTime(int time) {
  var startingTime = time.toString();
  String startTimeTemp;
  if (startingTime.length == 3) {
    startTimeTemp =
        '0' + startingTime.substring(0, 1) + ':' + startingTime.substring(1);
  } else {
    startTimeTemp =
        startingTime.substring(0, 2) + ':' + startingTime.substring(2);
  }
  return startTimeTemp;
}

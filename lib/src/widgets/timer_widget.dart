import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/model/booking_model.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/themeData.dart';

class TimerWidget extends StatefulWidget {
  TimerWidget(
      {Key? key,
      required this.creationDate,
      required this.onpress,
      required this.cancelPress,
      required this.data})
      : super(key: key);
  int creationDate;
  Function onpress;
  Function cancelPress;
  BookingModel data;
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String hr1 = "0";
  String hr2 = "0";
  String min1 = "0";
  String min2 = "0";
  String sec1 = "0";
  String sec2 = "0";
  bool isTimeOver = false;
  bool isInitial = false;

  Duration difference = Duration();
  Timer? timer;

  getIsCanceldOrNot(int oldDate) {
    var currentTimeStemp = DateTime.now().millisecondsSinceEpoch;

    DateTime oldDateFormated = new DateTime.fromMillisecondsSinceEpoch(oldDate);

    DateTime currentTimeStempFormated =
        new DateTime.fromMillisecondsSinceEpoch(currentTimeStemp);

    if (currentTimeStempFormated
        .isBefore(oldDateFormated.add(Duration(hours: 0)))) {
      difference = currentTimeStempFormated
          .difference(oldDateFormated.add(Duration(hours: 0)));

      if (difference.isNegative) {
        difference = difference.abs();

        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitMinutes = twoDigits(difference.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(difference.inSeconds.remainder(60));
        String twoDigithr = twoDigits(difference.inHours.remainder(60));

        setState(() {
          hr1 = twoDigithr[0];
          hr2 = twoDigithr[1];
          min1 = twoDigitMinutes[0];
          min2 = twoDigitMinutes[1];
          sec1 = twoDigitSeconds[0];
          sec2 = twoDigitSeconds[1];
        });
      } else {
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitMinutes = twoDigits(difference.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(difference.inSeconds.remainder(60));
        String twoDigithr = twoDigits(difference.inHours.remainder(60));
        setState(() {
          hr1 = twoDigithr[0];
          hr2 = twoDigithr[1];
          min1 = twoDigitMinutes[0];
          min2 = twoDigitMinutes[1];
          sec1 = twoDigitSeconds[0];
          sec2 = twoDigitSeconds[1];
        });
      }
    } else {
      setState(() {
        isTimeOver = true;
      });
      // widget.onpress();
    }
    // timer?.cancel();
  }

  checkDate() {
    var currentTimeStemp = DateTime.now().millisecondsSinceEpoch;

    DateTime oldDateFormated =
        new DateTime.fromMillisecondsSinceEpoch(widget.creationDate);
    print(oldDateFormated);

    DateTime currentTimeStempFormated =
        new DateTime.fromMillisecondsSinceEpoch(currentTimeStemp);
    print(currentTimeStempFormated);

    if (currentTimeStempFormated
        .isBefore(oldDateFormated.add(Duration(hours: 1)))) {
      startTimer();
    } else {
      setState(() {
        isTimeOver = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    checkDate();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      getIsCanceldOrNot(widget.creationDate);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isTimeOver) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
        child: Center(
          child: Text(
            AppStrings.youcannotcancel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ThemeClass.orangeColor,
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Text(
            AppStrings.bdCancelbookingbefore,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ThemeClass.redColor,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hr1 == "0" && hr2 == "0"
                  ? Container()
                  : Column(
                      children: [
                        Container(
                          width: 80,
                          child: Text(
                            AppStrings.bdHours,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: ThemeClass.orangeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Color(0x33FD5E4D),
                              ),
                              height: 50,
                              alignment: Alignment.center,
                              width: 39,
                              child: Text(
                                '$hr1',
                                style: TextStyle(
                                  color: ThemeClass.redColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Color(0x33FD5E4D),
                              ),
                              height: 50,
                              alignment: Alignment.center,
                              width: 39,
                              child: Text(
                                '$hr2',
                                style: TextStyle(
                                  color: ThemeClass.redColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
              hr1 == "0" && hr2 == "0"
                  ? Container()
                  : FadeTransition(
                      opacity: _animationController,
                      child: SizedBox(
                        width: 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 5,
                              height: 5,
                              color: Color(0xffFD5E4D),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 5,
                              height: 5,
                              color: Color(0xffFD5E4D),
                            ),
                          ],
                        ),
                      ),
                    ),
              Column(
                children: [
                  Container(
                    width: 80,
                    child: Text(
                      AppStrings.bdMins,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: ThemeClass.orangeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color(0x33FD5E4D),
                        ),
                        height: 50,
                        alignment: Alignment.center,
                        width: 39,
                        child: Text(
                          '$min1',
                          style: TextStyle(
                            color: ThemeClass.redColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color(0x33FD5E4D),
                        ),
                        height: 50,
                        alignment: Alignment.center,
                        width: 39,
                        child: Text(
                          '$min2',
                          style: TextStyle(
                            color: ThemeClass.redColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              FadeTransition(
                opacity: _animationController,
                child: SizedBox(
                  width: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 5,
                        height: 5,
                        color: Color(0xffFD5E4D),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 5,
                        height: 5,
                        color: Color(0xffFD5E4D),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 80,
                    child: Text(
                      AppStrings.bdSecs,
                      style: TextStyle(
                        color: ThemeClass.orangeColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color(0x33FD5E4D),
                        ),
                        height: 50,
                        alignment: Alignment.center,
                        width: 39,
                        child: Text(
                          "${sec1}",
                          style: TextStyle(
                            color: ThemeClass.redColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color(0x33FD5E4D),
                        ),
                        height: 50,
                        alignment: Alignment.center,
                        width: 39,
                        child: Text(
                          "${sec2}",
                          style: TextStyle(
                            color: ThemeClass.redColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // child: _buildcancelButton(context, data),
            child: ButtonWidget(
                title: AppStrings.bdCancelBooking,
                onpress: () {
                  showAlertDialogGlobal(AppStrings.Confirmation,
                      AppStrings.Areyousuretocanceltrip, context, () {
                    // cancelBookingApi(data, 'cancelled', "cancelTime");

                    widget.cancelPress(widget.data);
                  });
                },
                icon: Icons.arrow_forward),
          ),
        ],
      );
    }
  }
}

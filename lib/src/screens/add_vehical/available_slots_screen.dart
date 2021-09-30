import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/booking_service.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/model/slot_model.dart';
import 'package:pass/src/model/vehical_list_model.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:intl/intl.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailableSlotsScreen extends StatefulWidget {
  const AvailableSlotsScreen({
    Key? key,
    this.vehicle,
  }) : super(key: key);
  final MyVehicalListModel? vehicle;

  @override
  _AvailableSlotsScreenState createState() => _AvailableSlotsScreenState();
}

class _AvailableSlotsScreenState extends State<AvailableSlotsScreen> {
  bool isFirstPage = true;
  bool loading = false;
  DateTime currentDate = new DateTime.now().add(Duration(days: 1));
  DateTime now = new DateTime.now().add(Duration(days: 1));
  DateFormat formatterYear = new DateFormat('yyyy');
  DateFormat formatterMonth = new DateFormat('M');
  DateFormat formattercurrentDate = new DateFormat('MM/dd/yyyy');
  bool isSlotSelected = false;

  bool isError = false;

  String formattedYear = "";
  String formattedmonth = "";

  String _currentDropDownValue = "";

  SlotModel? allSlotList;
  List<String> finalMonthList = List<String>.empty(growable: true);
  // var slot = Slot();
  var slotBookingModel = {};

  void buildNextMonths() {
    var currentDateTime = DateTime.now();
    var currentYear = currentDateTime.year;
    for (var i = currentDateTime.month; i < currentDateTime.month + 12; i++) {
      var expression = i % 12;
      if (expression == 0) expression = 12;
      finalMonthList.add("${monthListItalian[expression - 1]} $currentYear");
      if (expression == 12) currentYear++;
    }
  }

  @override
  void initState() {
    monthListItalian = AppStrings.lan == "it" ? monthListItalian : monthList;
    super.initState();
    buildNextMonths();
    initDate();
    getSlots();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initDate() {
    _currentDropDownValue = finalMonthList.first;
  }

  getSlots() {
    String formattedcurrentDate = formattercurrentDate.format(now);
    print(formattedcurrentDate);
    getVehicleList(formattedcurrentDate);
  }

  Future<void> getVehicleList(String dateTosend) async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences prefs;

      prefs = await SharedPreferences.getInstance();
      String url = "booking/checkslots?startDate=$dateTosend";
      var response = await HttpConfig().httpGetRequest(
        url,
        prefs.getString("customer_accessToken").toString(),
      );
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // print(body);
        SlotModel tempslots = SlotModel.fromJson(body);

        allSlotList = tempslots;
        print(body);
      } else if (response.statusCode == 409) {
        final body = json.decode(response.body);
        print(body["message"]);
        showSnackbarMessageGlobal(body["message"], context);
        setState(() {
          isError = true;
        });
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
        setState(() {
          isError = true;
        });
      }
    } catch (e) {
      showSnackbarMessageGlobal(e.toString(), context);
      print(e);
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }

    // return globleVehicalList;
  }

  List<String> monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> daylist = ['Gi', 'Ve', 'Sa', 'Do', 'Lu'];
  List<String> monthListItalian = [
    'gennaio',
    'febbraio',
    'marzo',
    'aprile',
    'maggio',
    'giugno',
    'luglio',
    'agosto',
    'settembre',
    'ottobre',
    'novembre',
    'dicembre'
  ];

  setWeek(day) {
    if (AppStrings.lan == "it") {
      switch (day.toString().toLowerCase()) {
        case "sun":
          return "do";
        case "mon":
          return "lun";
        case "tue":
          return "mar";
        case "wed":
          return "mer";
        case "thu":
          return "gio";
        case "fri":
          return "ven";
        case "sat":
          return "sab";
      }
    } else {
      return day;
    }
  }

  _selectItem(int index) async {
    setState(() {
      String selectted = allSlotList!.slots![index].isSelectedByYou.toString();

      if (selectted == "true") {
        allSlotList!.slots![index].isSelectedByYou = false;
      } else {
        allSlotList!.slots = allSlotList!.slots!.map((e) {
          e.isSelectedByYou = false;
          return e;
        }).toList();

        allSlotList!.slots![index].isSelectedByYou = true;
      }
    });
    slotBookingModel['slot'] = {
      "startTime": allSlotList!.slots![index].timing!.startTime,
      "endTime": allSlotList!.slots![index].timing!.endTime
    };
    slotBookingModel['date'] = allSlotList!.slots![index].date!;
    slotBookingModel["vehicleId"] = widget.vehicle!.id!;

    // var selectedSlotTemp = allSlotList!.slots![index];
    // selectedSlot.print(
    //     "allSlotList!.slots![index].isSelectedByYou ${allSlotList!.slots![index].toJson()}");
    // setState(() {
    //   for (int i = 0; i < allSlotList!.slots!.length; i++) {
    //     allSlotList!.slots![index].isSelectedByYou = false;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(
              title: AppStrings.asAvailableslots,
            ),
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: _buildSliverList(context, size),
            )
          ],
        ),
      )),
    );
  }

  _buildSliverList(BuildContext context, Size size) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.topLeftRadiousForContainer),
          topRight: Radius.circular(SizeConfig.topRightRadiousForContainer),
        ),
      ),
      child: SingleChildScrollView(
        child: allSlotList != null
            ? allSlotList!.slots!.length > 0
                ? _buildbody(size, context)
                : Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.82,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          AppStrings.somethingwentwrong,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
            : Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.82,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ThemeClass.orangeColor,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Column _buildbody(Size size, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        !isError
            ? loading
                ? SizedBox(
                    height: 70,
                  )
                : _buildSlotNavigationTitle()
            : SizedBox(),
        !isError
            ? loading
                ? SizedBox(
                    height: size.height * 0.6,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ThemeClass.orangeColor,
                      ),
                    ),
                  )
                // : _buildSelectionView(),
                : Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _buildSelectionView2(),
                  )
            : Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Text(
                    AppStrings.somethingwentwrong,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
        !isError
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: ButtonWidget(
                  title: AppStrings.asConfirmbooking,
                  isDisable: !isSlotSelected,
                  onpress: () async {
                    if (isSlotSelected) {
                      Navigator.pushNamed(context, Routes.moreAboutVehicle,
                          // arguments: widget.vehicle,
                          arguments: [
                            slotBookingModel,
                            // widget.vehicle,
                            // widget.pickupAddress,
                            // widget.destinationAddress
                          ]);
                      // getSlots();
                    }
                  },
                ))
            : SizedBox(),
      ],
    );
  }

  // _buildSelectionView() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 20),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: _buildSlotsTIming(),
  //         ),
  //       ),
  //       _buildSelectionArea()
  //     ],
  //   );
  // }

  _buildSelectionView2() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                _buildDropDown(),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Row(
                    children: [
                      for (var i = 0; i < 5; i++) ...[
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                setWeek(allSlotList!.weekList![i].day
                                    .toString()
                                    .substring(0, 3)),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeClass.orangeColor,
                                ),
                              ),
                              Text(
                                allSlotList!.weekList![i].date
                                    .toString()
                                    .split("/")[1],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: ThemeClass.orangeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
              child: SingleChildScrollView(
            child: Container(
              child: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        for (var i = 0; i < allSlotList!.agenda!.length; i++)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 90,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${getFormatedTime(allSlotList!.agenda![i].startTime!)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${getFormatedTime(allSlotList!.agenda![i].endTime!)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Row(
                                    children: [
                                      for (var j = 0; j < 5; j++) ...[
                                        Expanded(
                                          child: allSlotList!
                                                      .slots![i +
                                                          (j *
                                                              allSlotList!
                                                                  .agenda!
                                                                  .length)]
                                                      .slotAvailable
                                                      .toString() ==
                                                  "true"
                                              ? allSlotList!
                                                          .slots![i +
                                                              (j *
                                                                  allSlotList!
                                                                      .agenda!
                                                                      .length)]
                                                          .isSelectedByYou
                                                          .toString() ==
                                                      "true"
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          isSlotSelected =
                                                              false;
                                                          // print(listOfBook[index]['index']);
                                                          // _selectItem(listOfBook[index]['index']);

                                                          print(i +
                                                              (j *
                                                                  allSlotList!
                                                                      .agenda!
                                                                      .length));

                                                          _selectItem(i +
                                                              (j *
                                                                  allSlotList!
                                                                      .agenda!
                                                                      .length));
                                                          // allSlotList!.slots!.removeLast();

                                                          // allSlotList!.slots![index].slotAvailable.
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black54),
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          print(i +
                                                              (j *
                                                                  allSlotList!
                                                                      .agenda!
                                                                      .length));

                                                          isSlotSelected = true;
                                                          _selectItem(i +
                                                              (j *
                                                                  allSlotList!
                                                                      .agenda!
                                                                      .length));
                                                          // allSlotList!.slots!.removeLast();
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black54),
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                              : Center(
                                                  child: Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: ThemeClass
                                                          .orangeColor,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  // Widget _buildSelectionArea() {
  //   var width = MediaQuery.of(context).size.width;
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.only(right: 10),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               for (var i = 0; i < 5; i++) ...[
  //                 Expanded(
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         allSlotList!.weekList![i].day
  //                             .toString()
  //                             .substring(0, 2),
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                           color: ThemeClass.orangeColor,
  //                         ),
  //                       ),
  //                       Text(
  //                         allSlotList!.weekList![i].date
  //                             .toString()
  //                             .split("/")[1],
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 18,
  //                           color: ThemeClass.orangeColor,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ],
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Container(
  //             height: MediaQuery.of(context).size.height * 0.68,
  //             width: MediaQuery.of(context).size.width,
  //             child: GridView.builder(
  //               scrollDirection: Axis.horizontal,
  //               padding: EdgeInsets.only(top: 0, right: 0, left: 12),
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: allSlotList!.agenda!.length,
  //                   crossAxisSpacing:
  //                       MediaQuery.of(context).size.height * 0.030,
  //                   mainAxisSpacing:
  //                       width > 380 ? width * 0.050 : width * 0.032,
  //                   mainAxisExtent: 39),
  //               shrinkWrap: true,
  //               physics: NeverScrollableScrollPhysics(),
  //               itemCount: allSlotList!.slots!.length,
  //               itemBuilder: (BuildContext ctx, index) {
  //                 if (allSlotList!.slots![index].slotAvailable.toString() ==
  //                     "true") {
  //                   if (allSlotList!.slots![index].isSelectedByYou.toString() ==
  //                       "true") {
  //                     return InkWell(
  //                       onTap: () {
  //                         setState(() {
  //                           isSlotSelected = false;
  //                           // print(listOfBook[index]['index']);
  //                           // _selectItem(listOfBook[index]['index']);

  //                           print(allSlotList!.slots![index]);

  //                           _selectItem(index);
  //                           // allSlotList!.slots!.removeLast();

  //                           // allSlotList!.slots![index].slotAvailable.
  //                         });
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.black54),
  //                           shape: BoxShape.circle,
  //                           color: Colors.blue,
  //                         ),
  //                       ),
  //                     );
  //                   } else {
  //                     return InkWell(
  //                       onTap: () {
  //                         setState(() {
  //                           isSlotSelected = true;
  //                           _selectItem(index);
  //                           // allSlotList!.slots!.removeLast();
  //                         });
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.black54),
  //                           shape: BoxShape.circle,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     );
  //                   }
  //                 } else {
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: ThemeClass.orangeColor,
  //                     ),
  //                   );
  //                 }
  //               },
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

//   List<Widget> _buildSlotsTIming() {
//     var height = MediaQuery.of(context).size.height;
// // allSlotList!.agenda!
//     return [
//       _buildDropDown(),
//       // SizedBox(
//       //   height: MediaQuery.of(context).size.height * 0.02,
//       // ),
//       for (var i = 0; i < allSlotList!.agenda!.length; i++)
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 22,
//             ),
//             Text(
//               '${getFormatedTime(allSlotList!.agenda![i].startTime!)}',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Text(
//               '${getFormatedTime(allSlotList!.agenda![i].endTime!)}',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(
//               height: height > 650 ? height * 0.024 : height * 0.013,
//             )
//           ],
//         )
//     ];
//   }

  SizedBox _buildDropDown() {
    return SizedBox(
      width: 90,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          menuMaxHeight: 400,
          isExpanded: true,
          value: _currentDropDownValue,
          selectedItemBuilder: (context) {
            return finalMonthList.map((String value) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    _currentDropDownValue.substring(0, 3),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Text(
                    _currentDropDownValue.split(' ').last,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ]),
              );
            }).toList();
          },
          onChanged: (value) {
            setState(() {
              _currentDropDownValue = value.toString();
            });
            int month = monthListItalian
                .indexOf(_currentDropDownValue.split(' ').first);
            int year = int.parse(_currentDropDownValue.split(' ').last);
            currentDate = DateTime(year, month + 1, 1);

            var dateFormate2 = DateFormat("MM-dd-yyyy").format(currentDate);
            print(dateFormate2);
            getVehicleList(dateFormate2.toString());
          },
          items: finalMonthList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: value,
            );
          }).toList(),
        ),
      ),
    );
  }

  Padding _buildSlotNavigationTitle() {
    debugPrint('currentDate.day ${currentDate.day}');
    debugPrint('DateTime.now ${DateTime.now().day}');
    var showBackButton =
        currentDate.day != DateTime.now().add(Duration(days: 1)).day;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: showBackButton
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () {
                      if (currentDate.day == now.day &&
                          currentDate.month == now.month) {
                        return null;
                      } else {
                        currentDate = currentDate.subtract(Duration(days: 5));
                        var dateFormate2 =
                            DateFormat("MM-dd-yyyy").format(currentDate);
                        getVehicleList(dateFormate2.toString());
                      }
                    },
                  )
                : SizedBox(
                    width: 30,
                  ),
          ),
          Text(
            AppStrings.asChooseyourtimeslot,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Colors.black,
              onPressed: () {
                currentDate = currentDate.add(Duration(days: 5));
                var dateFormate2 = DateFormat("MM-dd-yyyy").format(currentDate);
                getVehicleList(dateFormate2.toString());
              },
            ),
          )
        ],
      ),
    );
  }
}

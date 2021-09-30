import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/common.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/booking_model.dart';
import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/full_screen_image_view.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/src/widgets/timer_widget.dart';
import 'package:pass/src/widgets/widget_for_timeline_chart.dart';

import 'package:pass/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailsScreen extends StatefulWidget {
  BookingDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late String bookingId;
  late Address pickupAddressObject;
  late Address destinationAddressObject;
  bool isTimeOver = false;

  // int inc = 0;
  bool isLoading = false;

  late final myFuture;

  @override
  void initState() {
    // TODO: implement initState
    myFuture = getBookingData();
    super.initState();
  }

  DateFormat formattercurrentDate = new DateFormat('dd/MM/yyyy');
  Future<void> cancelBookingApi(
    BookingModel bookindDetails,
    String status,
    String field,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });

      bookindDetails.bookingStatus = status;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kkmm').format(now);
      int currentTime = int.parse(formattedDate);
      var data = {
        // "rideStartTime": currentTime,
        field: currentTime,
        "bookingStatus": status,
        // "startDate": DateTime.now().millisecondsSinceEpoch
      };
      ;
      var token = await SharedPrefService.getUserToken();
      var response = await HttpConfig().httpPatchRequestWithToken(
          "booking/${bookindDetails.id}", data, token.toString());
      if (response.statusCode == 200) {
        // isTripStarted = true;

      }
    } catch (e) {
      debugPrint("Error $e");
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bookingIdTemp = ModalRoute.of(context)!.settings.arguments as Map;
    bookingId = bookingIdTemp['bookingId'];
    return WillPopScope(
      onWillPop: () async {
        debugPrint("Will pop");
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackgraoundGradient(
          child: Container(
            child: Column(
              children: [
                SimpleAppBarWidget(
                  title: AppStrings.bdBookingDetails,
                  onpress: () {
                    if (bookingIdTemp['foromHomePage']) {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.homeRoute,
                      );
                    } else {
                      Navigator.pop(context, true);
                    }
                  },
                  onPress: true,
                ),
                SizedBox(
                  height: 60,
                ),
                _buildSliverList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Response> getBookingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temppickAddress =
        jsonDecode(prefs.getString('customer_pickupAddress').toString());

    var tempdestiAddress =
        jsonDecode(prefs.getString('customer_destinationAddress').toString());
    pickupAddressObject = Address.fromJson(temppickAddress);
    destinationAddressObject = Address.fromJson(tempdestiAddress);

    prefs.getString("customer_accessToken").toString();
    print(prefs.getString("customer_accessToken").toString());
    return HttpConfig().httpGetRequest(
      'booking/confirmed/$bookingId',
      prefs.getString("customer_accessToken").toString(),
    );
  }

  _buildSliverList(BuildContext context) {
    return Flexible(
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.84,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.topLeftRadiousForContainer),
            topRight: Radius.circular(SizeConfig.topRightRadiousForContainer),
          ),
        ),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getBookingData(),
            builder: (context, AsyncSnapshot<Response> snapshot) {
              if (snapshot.hasData) {
                // var data = BookingModelFromJson(snapshot.data!.body);
                var data =
                    BookingModel.fromJson(jsonDecode(snapshot.data!.body));

                // getIsCanceldOrNot(data.creationDate);
//

                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _vehicleForm(context, data),
                    ),

                    data.bookingStatus == "pending"
                        ? _buildCancelBookingAndButton(context, data)
                        : SizedBox(),
                    // return _buildCancelBookingAndButton(context, bookingDetails);

                    data.bookingStatus != "pending"
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 30),
                            child: _builBottomButton(data),
                          )
                        : SizedBox(),
                  ],
                );
              } else if (snapshot.hasError) {
                return Container(
                  child: Center(child: Text('${snapshot.error}')),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _builBottomButton(BookingModel bookingDetails) {
    if (bookingDetails.bookingStatus == "pending") {
      // return _buildCancelBookingAndButton(context, bookingDetails);
      return Center(
        child: Text(
          AppStrings.Tripispending,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeClass.orangeColor,
          ),
        ),
      );
    } else if (bookingDetails.bookingStatus == "started") {
      return Center(
        child: Text(
          AppStrings.Triphasalreadybeenstarted,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeClass.orangeColor,
          ),
        ),
      );
    } else if (bookingDetails.bookingStatus == "pickedup") {
      return Center(
        child: Text(
          AppStrings.Triphasalreadybeenpickeduped,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeClass.orangeColor,
          ),
        ),
      );
    } else if (bookingDetails.bookingStatus == "completed") {
      return Center(
        child: Text(
          AppStrings.Triphasalreadybeencompleted,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeClass.orangeColor,
          ),
        ),
      );
    } else if (bookingDetails.bookingStatus == "cancelled") {
      return Center(
        child: Text(
          AppStrings.Triphasalreadybeencancelled,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeClass.orangeColor,
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 20,
      );
    }
  }

  Column _buildCancelBookingAndButton(BuildContext context, BookingModel data) {
    return Column(
      children: [
        // _buildTimer(),
        TimerWidget(
          creationDate: data.date,
          onpress: onTimeOver,
          data: data,
          cancelPress: (data) {
            cancelBookingApi(data, 'cancelled', "cancelTime");
          },
        ),
      ],
    );
  }

  onTimeOver() {
    setState(() {
      isTimeOver = true;
    });
  }

  // Column _buildTimer() {
  //   return Column(
  //     children: [
  //       Text(
  //         AppStrings.bdCancelbookingbefore,
  //         style: TextStyle(
  //           fontSize: 20,
  //           fontWeight: FontWeight.w600,
  //           color: ThemeClass.redColor,
  //         ),
  //       ),
  //       SizedBox(height: 10),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Column(
  //             children: [
  //               Container(
  //                 width: 80,
  //                 child: Text(
  //                   AppStrings.bdHours,
  //                   textAlign: TextAlign.start,
  //                   style: TextStyle(
  //                     color: ThemeClass.orangeColor,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 alignment: Alignment.centerLeft,
  //               ),
  //               SizedBox(height: 5),
  //               Row(
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(10),
  //                       ),
  //                       color: Color(0x33FD5E4D),
  //                     ),
  //                     height: 50,
  //                     alignment: Alignment.center,
  //                     width: 39,
  //                     child: Text(
  //                       '0',
  //                       style: TextStyle(
  //                         color: ThemeClass.redColor,
  //                         fontSize: 30,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 10),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(10),
  //                       ),
  //                       color: Color(0x33FD5E4D),
  //                     ),
  //                     height: 50,
  //                     alignment: Alignment.center,
  //                     width: 39,
  //                     child: Text(
  //                       '0',
  //                       style: TextStyle(
  //                         color: ThemeClass.redColor,
  //                         fontSize: 30,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //           SizedBox(
  //             width: 20,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                   height: 15,
  //                 ),
  //                 Container(
  //                   width: 5,
  //                   height: 5,
  //                   color: Color(0xffFD5E4D),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Container(
  //                   width: 5,
  //                   height: 5,
  //                   color: Color(0xffFD5E4D),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Column(
  //             children: [
  //               Container(
  //                 width: 80,
  //                 child: Text(
  //                   AppStrings.bdMins,
  //                   style: TextStyle(
  //                     color: ThemeClass.orangeColor,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                   textAlign: TextAlign.start,
  //                 ),
  //                 alignment: Alignment.centerLeft,
  //               ),
  //               SizedBox(height: 5),
  //               Row(
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(10),
  //                       ),
  //                       color: Color(0x33FD5E4D),
  //                     ),
  //                     height: 50,
  //                     alignment: Alignment.center,
  //                     width: 39,
  //                     child: Text(
  //                       "${min1}",
  //                       style: TextStyle(
  //                         color: ThemeClass.redColor,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 30,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 10),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(10),
  //                       ),
  //                       color: Color(0x33FD5E4D),
  //                     ),
  //                     height: 50,
  //                     alignment: Alignment.center,
  //                     width: 39,
  //                     child: Text(
  //                       "${min2}",
  //                       style: TextStyle(
  //                         color: ThemeClass.redColor,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 30,
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //       SizedBox(
  //         height: 10,
  //       )
  //     ],
  //   );
  // }

  Column _vehicleForm(BuildContext context, BookingModel data) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(Icons.home, "${AppStrings.PickupAddress}"),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "${data.pickupAddress.addressLine2}\n${data.pickupAddress.landmark}, ${data.pickupAddress.city} - ${data.pickupAddress.pincode} ",
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          AppStrings.AuthorizedPerson,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeClass.greyColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.face,
              color: Colors.black,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              data.pickupAddress.authorName.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            showMobileNumberDiallerPad(
                data.pickupAddress.authorMobileNumber.toString());
          },
          child: Row(
            children: [
              Icon(
                Icons.call,
                color: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "${data.pickupAddress.authorMobileNumber}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Divider(
          color: ThemeClass.greyColor,
        ),
        _buildTitle(Icons.home, AppStrings.Destinationaddress),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "${data.destinationAddress.addressLine2}\n${data.destinationAddress.landmark}, ${data.destinationAddress.city} - ${data.destinationAddress.pincode} ",
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppStrings.AuthorizedPerson,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeClass.greyColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.face,
              color: Colors.black,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              data.destinationAddress.authorName.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            showMobileNumberDiallerPad(
                data.destinationAddress.authorMobileNumber.toString());
          },
          child: Row(
            children: [
              Icon(
                Icons.call,
                color: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "${data.destinationAddress.authorMobileNumber}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(
          color: ThemeClass.greyColor,
        ),
        SizedBox(
          height: 10,
        ),
        _buildVehicalDetailsMain(data),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              AppStrings.bdStatus,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: SizedBox.shrink(),
            ),
            Text(
              // '${capitalize(data.bookingStatus)}',
              statusTitle(data.bookingStatus),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: statusColor(data.bookingStatus),
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.bdDriverdetails,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: ThemeClass.orangeColor,
            onTap: () {
              // Navigator.pushNamed(context, Routes.driverDetailsScreen,
              //     arguments: data.driverId);
            },
            child: _buildDriverDetails(data),
          ),
        ),
        SizedBox(height: 10),
        data.driverId.profilePicture == ""
            ? SizedBox()
            : InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageView(
                        path: "${data.driverId.profilePicture}",
                        isFromNetwork: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(data.driverId.profilePicture),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: ThemeClass.orangeColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20)
                      // shape: BoxShape.circle,
                      ),
                  height: 70,
                  width: 70,
                ),
              ),
        SizedBox(height: 10),
        Divider(),
        _timeLineChar(data),
      ],
    );
  }

  String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  Column _buildDriverDetails(BookingModel data) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Icon(
              Icons.person,
              color: Colors.black,
            ),
            SizedBox(width: 10),
            Text(
              '${data.driverId.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Column _buildVehicalDetailsMain(BookingModel bookingDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(Icons.two_wheeler, "${AppStrings.VehicleDetails}"),
        SizedBox(
          height: 10,
        ),
        _buildVehicaDetails(
          "${AppStrings.VehicleName}",
          " ${bookingDetails.vehicleId.make} - ${bookingDetails.vehicleId.model}",
        ),
        SizedBox(
          height: 10,
        ),
        _buildVehicaDetails(
          "${AppStrings.RegistrationNo}",
          bookingDetails.vehicleId.plateNumber.toString(),
        ),
        SizedBox(
          height: 10,
        ),
        _buildVehicaDetails(
          "${AppStrings.Color}",
          bookingDetails.vehicleId.color.toString(),
        ),
        SizedBox(
          height: 10,
        ),
        bookingDetails.customerImages.length > 0
            ? Text(
                "${AppStrings.VehicleImages}",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ThemeClass.greyColor),
              )
            : SizedBox(),
        bookingDetails.customerImages.length > 0
            ? SizedBox(
                height: 10,
              )
            : SizedBox(),
        bookingDetails.customerImages.length > 0
            ? Wrap(
                children: bookingDetails.customerImages.map((e) {
                  var index = bookingDetails.customerImages.indexOf(e);

                  // return _buildimageName(
                  //     bookingDetails.customerImages[index], context);

                  return _buildVehicleImageGrid(
                      bookingDetails.customerImages[index]);
                }).toList(),
              )
            : SizedBox(),
        bookingDetails.customerImages.length > 0
            ? SizedBox(
                height: 10,
              )
            : SizedBox(),
        Divider(
          color: ThemeClass.greyColor,
        ),
        SizedBox(
          height: 10,
        ),
        _buildTitle(
          Icons.calendar_today,
          "${AppStrings.BookingDetails}",
        ),
        SizedBox(
          height: 10,
        ),
        _buildTripDistance(
          "${AppStrings.Tripdistance}",
          "${bookingDetails.tripKm} ${AppStrings.KMs}",
          Icons.location_on,
        ),
        SizedBox(
          height: 10,
        ),
        _buildTripDistance(
            "${AppStrings.Tripduration}",
            "${bookingDetails.tripTime} ${AppStrings.Minutes}",
            Icons.schedule_sharp),
        SizedBox(
          height: 10,
        ),
        _buildTripDistance(
          "${AppStrings.BookingDate}",
          // "",
          // "${getFormattedDate(bookingDetails.date)}",
          "${formattercurrentDate.format(new DateTime.fromMillisecondsSinceEpoch(bookingDetails.date))}",
          Icons.calendar_today_outlined,
        ),
        SizedBox(
          height: 10,
        ),
        _buildTripDistance(
          "${AppStrings.BookingSlot}",
          "${formatSlot(bookingDetails.slot.startTime)} -  ${formatSlot(bookingDetails.slot.endTime)}",
          Icons.timer,
        ),
      ],
    );
  }

  Row _buildTripDistance(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: ThemeClass.greyColor,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ThemeClass.greyColor),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: Text(
              subtitle,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: ThemeClass.orangeColor),
            ),
          ),
        ),
      ],
    );
  }

  Container _buildVehicaDetails(String title, String subtitle) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ThemeClass.greyColor),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ThemeClass.orangeColor,
                radius: 7,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _timeLineChar(BookingModel bookingDetails) {
    if (bookingDetails.bookingStatus == "pending") {
      // var formatedDate = getFormattedDate(bookingDetails.creationDate);

      List<String> timelineTitle = [
        " ${AppStrings.Tripcreatedon} ${getFormattedDate(bookingDetails.creationDate)} at ${getTimeFromMilisecond(bookingDetails.creationDate)}",
        // "Trip started at ${getFormatedTime(bookingDetails.rideStartTime)}",
        "${AppStrings.Tripstarted}",
        "${AppStrings.Pickupconfirmed}",
        "${AppStrings.Deliver}",
      ];

      return ListView.builder(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: timelineTitle.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: TimelineTile(
              alignment: TimelineAlign.start,
              lineXY: 1,
              isFirst: index == 0,
              isLast: index == timelineTitle.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 20,
                height: 20,
                indicator: IndicatorExample(
                  color: index == 0
                      ? ThemeClass.orangeColor
                      : ThemeClass.greyMediumColor,
                ),
              ),
              afterLineStyle: LineStyle(
                color: index == 0
                    ? ThemeClass.orangeColor
                    : ThemeClass.greyMediumColor,
                thickness: 2,
              ),
              beforeLineStyle: LineStyle(
                color: index == 0
                    ? ThemeClass.orangeColor
                    : ThemeClass.greyMediumColor,
                thickness: 2,
              ),
              endChild: GestureDetector(
                child: RowExample(
                  bookingId: bookingDetails.id,
                  title: timelineTitle[index],
                  index: index,
                ),
                onTap: () {},
              ),
            ),
          );
        },
      );
    } else if (bookingDetails.bookingStatus == "started") {
      List<String> timelineTitle = [
        "${AppStrings.Tripcreatedon} ${getFormattedDate(bookingDetails.creationDate)} at ${getTimeFromMilisecond(bookingDetails.creationDate)}",
        "${AppStrings.Tripstartedon} ${getFormattedDate(bookingDetails.startDate)} at ${getTimeFromMilisecond(bookingDetails.rideStartTime)}",
        "${AppStrings.Pickupconfirmed}",
        "${AppStrings.Deliver}"
      ];

      return ListView.builder(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: timelineTitle.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: TimelineTile(
              alignment: TimelineAlign.start,
              lineXY: 1,
              isFirst: index == 0,
              isLast: index == timelineTitle.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 20,
                height: 20,
                indicator: IndicatorExample(
                  color: index == 1 || index == 0
                      ? ThemeClass.orangeColor
                      : ThemeClass.greyMediumColor,
                ),
              ),
              afterLineStyle: LineStyle(
                color: index == 1 || index == 0
                    ? ThemeClass.orangeColor
                    : ThemeClass.greyMediumColor,
                thickness: 2,
              ),
              beforeLineStyle: LineStyle(
                color: index == 1 || index == 0
                    ? ThemeClass.orangeColor
                    : ThemeClass.greyMediumColor,
                thickness: 2,
              ),
              endChild: GestureDetector(
                child: RowExample(
                  bookingId: bookingDetails.id,
                  title: timelineTitle[index],
                  index: index,
                ),
                onTap: () {},
              ),
            ),
          );
        },
      );
    } else if (bookingDetails.bookingStatus == "pickedup") {
      List<String> timelineTitle = [
        "${AppStrings.Tripcreatedon} ${getFormattedDate(bookingDetails.creationDate)} at ${getTimeFromMilisecond(bookingDetails.creationDate)}",
        "${AppStrings.Tripstartedon} ${getFormattedDate(bookingDetails.startDate)} at ${getTimeFromMilisecond(bookingDetails.rideStartTime)}",
        "${AppStrings.Pickupconfirmedon} ${getFormattedDate(bookingDetails.pickupDate)} at ${getTimeFromMilisecond(bookingDetails.pickupTime)}",
        "${AppStrings.Deliver}r"
      ];

      return ListView.builder(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: timelineTitle.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: TimelineTile(
              alignment: TimelineAlign.start,
              lineXY: 1,
              isFirst: index == 0,
              isLast: index == timelineTitle.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 20,
                height: 20,
                indicator: IndicatorExample(
                  color: index == 0 || index == 1 || index == 2
                      ? ThemeClass.orangeColor
                      : ThemeClass.greyMediumColor,
                ),
              ),
              afterLineStyle: LineStyle(
                color: index == 0 || index == 1 || index == 2
                    ? ThemeClass.orangeColor
                    : ThemeClass.greyMediumColor,
                thickness: 2,
              ),
              beforeLineStyle: LineStyle(
                color: index == 0 || index == 1 || index == 2
                    ? ThemeClass.orangeColor
                    : ThemeClass.greyMediumColor,
                thickness: 2,
              ),
              endChild: GestureDetector(
                child: RowExample(
                  bookingId: bookingDetails.id,
                  index: index,
                  title: timelineTitle[index],
                  showView: index == 2 ? true : false,
                ),
                onTap: () {},
              ),
            ),
          );
        },
      );
    } else if (bookingDetails.bookingStatus == "completed") {
      List<String> timelineTitle = [
        "${AppStrings.Tripcreatedon} ${getFormattedDate(bookingDetails.creationDate)} at ${getTimeFromMilisecond(bookingDetails.creationDate)}",
        "${AppStrings.Tripstartedon} ${getFormattedDate(bookingDetails.startDate)} at ${getTimeFromMilisecond(bookingDetails.rideStartTime)}",
        "${AppStrings.Pickupconfirmedon} ${getFormattedDate(bookingDetails.pickupDate)} at ${getTimeFromMilisecond(bookingDetails.pickupTime)}",
        "${AppStrings.Deliveredon} ${getFormattedDate(bookingDetails.deliveryDate)} at ${getTimeFromMilisecond(bookingDetails.rideEndTime)}",
      ];

      return ListView.builder(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: timelineTitle.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: TimelineTile(
              alignment: TimelineAlign.start,
              lineXY: 1,
              isFirst: index == 0,
              isLast: index == timelineTitle.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 20,
                height: 20,
                indicator: IndicatorExample(
                  color: index == 0 || index == 1 || index == 2 || index == 3
                      ? ThemeClass.orangeColor
                      : ThemeClass.greyMediumColor,
                ),
              ),
              afterLineStyle: LineStyle(
                color: index == 0 || index == 1 || index == 2 || index == 3
                    ? ThemeClass.orangeColor
                    : ThemeClass.greyMediumColor,
                thickness: 2,
              ),
              beforeLineStyle: LineStyle(
                color: index == 0 || index == 1 || index == 2 || index == 3
                    ? ThemeClass.orangeColor
                    : ThemeClass.greyMediumColor,
                thickness: 2,
              ),
              endChild: GestureDetector(
                child: RowExample(
                  bookingId: bookingDetails.id,
                  title: timelineTitle[index],
                  index: index,
                  showView: index == 2 || index == 3 ? true : false,
                ),
                onTap: () {},
              ),
            ),
          );
        },
      );
    } else {
      return SizedBox();
    }
    // SizedBox();
  }

  // Column _buildDriverDetails(BookingModel data) {
  //   return Column(
  //     children: [
  //       SizedBox(height: 10),
  //       Row(
  //         children: [
  //           Icon(
  //             Icons.person,
  //             color: Colors.black,
  //           ),
  //           SizedBox(width: 10),
  //           Text(
  //             '${data.driverId.name}',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Row _buildTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          size: 30,
          color: ThemeClass.greyColor,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ThemeClass.greyColor,
          ),
        ),
      ],
    );
  }

  InkWell _buildVehicleImageGrid(String path) {
    var imageurl = HttpConfig().IMAGE_URL + path;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenImageView(
              path: "${HttpConfig().IMAGE_URL}$path",
              isFromNetwork: true,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(imageurl),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: ThemeClass.orangeColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)
            // shape: BoxShape.circle,
            ),
        height: 70,
        width: 70,
      ),
    );
  }

  showMobileNumberDiallerPad(String number) async {
    var url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

String getFormatedTime(int time) {
  if (time == 0) {
    return "";
  } else {
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
}

statusTitle(status) {
  switch (status.toString().toLowerCase()) {
    case "pending":
      return AppStrings.pending;
    case "started":
      return AppStrings.started;
    case "pickedup":
      return AppStrings.pickedup;
    case "completed":
      return AppStrings.completed;
    case "cancelled":
      return AppStrings.cancelled;
    default:
      return "";
  }
}

statusColor(status) {
  switch (status.toString().toLowerCase()) {
    case "pending":
      return Colors.blue;
    case "started":
      return Colors.amber;
    case "pickedup":
      return Colors.brown;
    case "completed":
      return Colors.green;
    case "cancelled":
      return Colors.red;
  }
}

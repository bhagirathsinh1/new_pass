import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/booking_model.dart';
import 'package:pass/src/model/view_booking_model.dart';
import 'package:pass/src/screens/booking/booking_details_screen.dart';

import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/themeData.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  Future<http.Response> _getBookings() async {
    var pref = await SharedPrefService.getUserToken();
    return HttpConfig().httpGetRequest('customer/app/mybookings', pref!);
  }

  DateFormat formattercurrentDate = new DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
          child: Container(
        child: Column(
          children: [
            SimpleAppBarWidget(title: AppStrings.mbMyBookings),
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      SizeConfig.topLeftRadiousForContainer,
                    ),
                    topRight: Radius.circular(
                      SizeConfig.topRightRadiousForContainer,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: _getBookings(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.statusCode == 200) {
                          List<ViewBookingModel> bookings = [];
                          bookings =
                              viewBookingModelFromJson(snapshot.data.body);
                          if (bookings.length > 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                for (var i = 0; i < bookings.length; i++)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            print(bookings[i].id);
                                            var data =
                                                await Navigator.pushNamed(
                                              context,
                                              Routes.bookingDetailsScreen,
                                              // arguments: [bookings[i].id, false],
                                              arguments: {
                                                'bookingId': bookings[i].id,
                                                'foromHomePage': false,
                                              },
                                            );
                                            if (data != null) {
                                              _getBookings();
                                              setState(() {});
                                            }
                                          },
                                          child: _buildCard(
                                            vehicle: bookings[i].vehicleId,
                                            status: capitalize(
                                                bookings[i].bookingStatus),
                                            booking: bookings[i],
                                            subTitle:
                                                "${formattercurrentDate.format(new DateTime.fromMillisecondsSinceEpoch(bookings[i].date))} - ${getFormatedTime(bookings[i].slot.startTime)}",
                                            time:
                                                "${bookings[i].tripTime} ${AppStrings.mins}",
                                          )),
                                      Divider()
                                    ],
                                  ),
                              ],
                            );
                          } else {
                            return Container(
                              child: Center(
                                child: Text("${AppStrings.NoBookingavailable}"),
                              ),
                            );
                          }
                        } else if (snapshot.data!.statusCode == 204) {
                          return Container(
                            child: Center(
                              child: Text("${AppStrings.NoBookingavailable}"),
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Container(
                          child: Center(
                            child: Text("${AppStrings.errorFetchingDetails}"),
                          ),
                        );
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ThemeClass.orangeColor,
                            ),
                          ),
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ThemeClass.orangeColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  String getFormatedTime(int time) {
    if (time == 0) {
      return "";
    } else {
      var startingTime = time.toString();
      String startTimeTemp;
      if (startingTime.length == 3) {
        startTimeTemp = '0' +
            startingTime.substring(0, 1) +
            ':' +
            startingTime.substring(1);
      } else {
        startTimeTemp =
            startingTime.substring(0, 2) + ':' + startingTime.substring(2);
      }
      return startTimeTemp;
    }
  }

  Future<http.Response> getVehicleDetails(String vehicleId) async {
    var pref = await SharedPrefService.getUserToken();
    // await Future.delayed(Duration(seconds: 3));
    var response = HttpConfig().httpGetRequest('vehicle/$vehicleId', pref!);
    // print(response.);
    return response;
  }

  Container _buildCard(
      {required VehicleId vehicle,
      required String subTitle,
      required String time,
      required String status,
      required ViewBookingModel booking}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              booking.customerId.name.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            AppStrings.Vehicle +
                booking.vehicleId.make +
                " " +
                booking.vehicleId.model,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ThemeClass.greyColor,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            "${AppStrings.Time} $subTitle",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ThemeClass.greyColor,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {},
                icon: Icon(
                  Icons.location_on,
                  size: 25,
                  color: ThemeClass.orangeColor,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  booking.pickupAddress.addressLine2.toString() +
                      ", ${booking.pickupAddress.landmark.toString()}" +
                      ", ${booking.pickupAddress.city.toString()} - ${booking.pickupAddress.pincode.toString()}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ThemeClass.orangeColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                time,
                style: TextStyle(
                    color: Color(0xff6E6E6E),
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    fontSize: 15),
              ),
              Spacer(),
              Text(
                statusTitle(status),
                style: TextStyle(
                    color: statusColor(status),
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 25,
                color: statusColor(status),
              ),
            ],
          ),
        ],
      ),
    );
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
}

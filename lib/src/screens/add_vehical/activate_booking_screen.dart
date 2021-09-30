import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pass/routes.dart';

import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/vehical_list_model.dart';
import 'package:pass/src/screens/add_vehical/already_have_subcription.dart';
import 'package:pass/src/screens/add_vehical/booking_exceed_buy_subscription_screen.dart';
import 'package:pass/src/screens/add_vehical/subscription_success_buy_screen.dart';
import 'package:pass/src/screens/web_view_screen/web_view_screen.dart';
import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pass/src/model/customer_register_model.dart';

import 'booking_exceed_buy_subscription_screen.dart';

class ActivateBookingScreen extends StatefulWidget {
  const ActivateBookingScreen({Key? key, this.selectedSlot}) : super(key: key);

  final dynamic selectedSlot;
  @override
  _ActivateBookingScreenState createState() => _ActivateBookingScreenState();
}

class _ActivateBookingScreenState extends State<ActivateBookingScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: Column(
          children: [
            SimpleAppBarWidget(
              title: AppStrings.hAppTitle,
            ),
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: Container(
                height: size.height * 0.84,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(SizeConfig.topLeftRadiousForContainer),
                    topRight:
                        Radius.circular(SizeConfig.topRightRadiousForContainer),
                  ),
                ),
                padding: EdgeInsets.all(25.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.2),
                    Text(
                      AppStrings.abayourbooking,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    ButtonWidget(
                        title: AppStrings.abClickToActivate,
                        onpress: () {
                          _openWebView();
                          // Navigator.pushNamed(
                          //     context, Routes.availableSlotsScreen);
                        }),
                    SizedBox(height: size.height * 0.1),
                    Text(
                      AppStrings.abRefreshtocheckupdates,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 0, // Space between underline and text
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.refresh),
                        onPressed: () {},
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _openWebView() async {
    var prefs = await SharedPreferences.getInstance();
    var customerId = prefs.getString('customer_id').toString();
    var accesstoken = prefs.getString('customer_accessToken').toString();
    var url = HttpConfig().PAYMENT_GATWAY_URL +
        "plans?customerId=$customerId&accessToken=$accesstoken";

    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewExample(
          url: url,
        ),
      ),
    );

    if (result != null) {
      var pref = await SharedPreferences.getInstance();
      var customerId = pref.getString("customer_id").toString();
      var token = pref.getString("customer_accessToken").toString();
      var url = "customer/$customerId";

      var response = await HttpConfig().httpGetRequest(url, token.toString());

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        var subscription = Subscription.fromJson(body['subscription']);

        // await SharedPrefService.setSubscription(subscription);
        if (subscription.name == "Free Pass") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ActivateBookingScreen(
                // vehicle: widget.vehicle,
                // pickupAddress: widget.pickupAddress,
                // destinationAddress: widget.destinationAddress,
                selectedSlot: widget.selectedSlot,
              ),
            ),
          );
        } else {
          if (subscription.totalRides! <= 0 || subscription.maxKm! <= 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ActivateBookingScreen(
                  // vehicle: widget.vehicle,
                  // pickupAddress: widget.pickupAddress,
                  // destinationAddress: widget.destinationAddress,
                  selectedSlot: widget.selectedSlot,
                ),
              ),
            );
          } else {
            checkDriverAvailableOrNot(context);
          }
        }
      }
    }
  }

  checkDriverAvailableOrNot(BuildContext context) async {
    // setState(() {
    //   isLoading = true;
    // });
    var pref = await SharedPreferences.getInstance();

    // ! check driver available or not api

    var response = await HttpConfig().httpPostRequestWithToken(
      'booking/check-driver-available',
      widget.selectedSlot,
      pref.getString("customer_accessToken").toString(),
    );

    if (response.statusCode == 201) {
      createBooking(context);
    } else if (response.statusCode == 400) {
      showSnackbarMessageGlobal(AppStrings.Invaliddateformate, context);
    } else if (response.statusCode == 404) {
      showSnackbarMessageGlobal(
          AppStrings.noDriverAvailablePleaseselect, context);
    } else if (response.statusCode == 402) {
      showSnackbarMessageGlobal(
          AppStrings.InvalidPickupOrDestinationaddress, context);
    } else if (response.statusCode == 403) {
      showSnackbarMessageGlobal(
          AppStrings.BookingexceedssubscriptionKM, context);
      var data = jsonDecode(response.body);

      String tempAmount = data['amount'].toString();
      String extraKms = data['extraKms'].toString();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookingExceedBuySubscription(
            paymentAmount: tempAmount,
            extraKms: extraKms,
            selectedSlot: widget.selectedSlot,
          ),
        ),
      );
    } else if (response.statusCode == 405) {
      showSnackbarMessageGlobal(AppStrings.Bookingexceeds50km, context);
    } else {
      showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
    }
  }

  void createBooking(BuildContext context) async {
    try {
      var prefs = await SharedPreferences.getInstance();

      var response = await HttpConfig().httpPostRequestWithToken(
        'booking',
        widget.selectedSlot,
        prefs.getString("customer_accessToken").toString(),
      );

      var booking = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackbarMessageGlobal(AppStrings.Bookingsuccessfullydone, context);
        Navigator.pushReplacementNamed(
          context,
          Routes.confirmationScreen,
          arguments: booking['_id'],
        );
      } else if (response.statusCode == 409) {
        showSnackbarMessageGlobal(
            AppStrings.noDriverAvailablePleaseselect, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.Errorinbooking, context);
      }
    } catch (e) {
      print("errror ============ $e");
      // debugPrint("error $e");
    } finally {}
  }
}

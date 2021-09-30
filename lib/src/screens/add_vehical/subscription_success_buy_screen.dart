import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pass/routes.dart';

import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/screens/add_vehical/booking_exceed_buy_subscription_screen.dart';
import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionSuccessBuy extends StatefulWidget {
  const SubscriptionSuccessBuy({Key? key, required this.selectedSlot})
      : super(key: key);

  final dynamic selectedSlot;
  @override
  _SubscriptionSuccessBuyState createState() => _SubscriptionSuccessBuyState();
}

class _SubscriptionSuccessBuyState extends State<SubscriptionSuccessBuy> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgraoundGradient(
        child: Column(
          children: [
            SimpleAppBarWidget(
              title: "Subscribed",
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
                      "Your purchase was successful",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    ButtonWidget(
                        title: "Click to continue",
                        isLoading: isLoading,
                        onpress: () {
                          // _openWebView();
                          // Navigator.pushNamed(
                          //     context, Routes.availableSlotsScreen);
                          checkDriverAvailableOrNot(context);
                        }),
                    SizedBox(height: size.height * 0.1),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  checkDriverAvailableOrNot(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
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
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(AppStrings.Invaliddateformate, context);
    } else if (response.statusCode == 404) {
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(
          AppStrings.noDriverAvailablePleaseselect, context);
    } else if (response.statusCode == 402) {
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(
          AppStrings.InvalidPickupOrDestinationaddress, context);
    } else if (response.statusCode == 403) {
      setState(() {
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
      showSnackbarMessageGlobal(AppStrings.Bookingexceeds50km, context);
    } else {
      setState(() {
        isLoading = false;
      });
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

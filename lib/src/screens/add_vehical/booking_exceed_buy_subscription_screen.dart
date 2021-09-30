import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pass/routes.dart';

import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/customer_register_model.dart';

import 'package:pass/src/screens/web_view_screen/web_view_for_perticular_amonut_payment.dart';

import 'package:pass/src/widgets/appbar_widget.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingExceedBuySubscription extends StatefulWidget {
  const BookingExceedBuySubscription(
      {Key? key,
      required this.selectedSlot,
      required this.paymentAmount,
      required this.extraKms})
      : super(key: key);

  final dynamic selectedSlot;
  final String extraKms;
  final String paymentAmount;
  @override
  _BookingExceedBuySubscriptionState createState() =>
      _BookingExceedBuySubscriptionState();
}

class _BookingExceedBuySubscriptionState
    extends State<BookingExceedBuySubscription> {
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
              title: "Confirmation",
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
                      "Opps! your KM has been exceeds for this booking Please buy pass at ${widget.paymentAmount}€ per KMS.",
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
                          _openWebView();
                          // Navigator.pushNamed(
                          //     context, Routes.availableSlotsScreen);
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

  // checkDriverAvailableOrNot(BuildContext context) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var pref = await SharedPreferences.getInstance();

  //   // ! check driver available or not api

  //   var response = await HttpConfig().httpPostRequestWithToken(
  //     'booking/check-driver-available',
  //     widget.selectedSlot,
  //     pref.getString("customer_accessToken").toString(),
  //   );

  //   if (response.statusCode == 201) {
  //     createBooking(context);
  //   } else if (response.statusCode == 400) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showSnackbarMessageGlobal(AppStrings.Invaliddateformate, context);
  //   } else if (response.statusCode == 404) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showSnackbarMessageGlobal(
  //         AppStrings.noDriverAvailablePleaseselect, context);
  //   } else if (response.statusCode == 402) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showSnackbarMessageGlobal(
  //         AppStrings.InvalidPickupOrDestinationaddress, context);
  //   } else if (response.statusCode == 403) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showSnackbarMessageGlobal(
  //         AppStrings.BookingexceedssubscriptionKM, context);
  //   } else if (response.statusCode == 405) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showSnackbarMessageGlobal(AppStrings.Bookingexceeds50km, context);
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);
  //   }
  // }

  void createBooking(BuildContext context) async {
    try {
      var prefs = await SharedPreferences.getInstance();

      widget.selectedSlot['extra_payment_done'] = 'true';

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

  _openWebView() async {
    var prefs = await SharedPreferences.getInstance();
    var customerId = prefs.getString('customer_id').toString();
    var accesstoken = prefs.getString('customer_accessToken').toString();

    var url = HttpConfig().PAYMENT_GATWAY_URL +
        "custom-price?customerId=$customerId&amount=${widget.paymentAmount}&extraKms=${widget.extraKms}&accessToken=$accesstoken";
    print(url);
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebViewForPerticularAmountPayment(
                url: url,
              )),
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
        var isUnlimited = body['unlimitedRides'];
        if (isUnlimited == true || isUnlimited == "true") {
          createBooking(context);
        } else {
          // await SharedPrefService.setSubscription(subscription);
          if (subscription.name == "Free Pass") {
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => ActivateBookingScreen(
            //       // vehicle: widget.vehicle,
            //       // pickupAddress: widget.pickupAddress,
            //       // destinationAddress: widget.destinationAddress,
            //       selectedSlot: widget.selectedSlot,
            //     ),
            //   ),
            // );
          } else {
            if (subscription.totalRides! <= 0 || subscription.maxKm! <= 0) {
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (context) => ActivateBookingScreen(
              //       // vehicle: widget.vehicle,
              //       // pickupAddress: widget.pickupAddress,
              //       // destinationAddress: widget.destinationAddress,
              //       selectedSlot: widget.selectedSlot,
              //     ),
              //   ),
              // );
            } else {
              createBooking(context);
            }
          }
          print("not");
        }
      }
    }
  }
}

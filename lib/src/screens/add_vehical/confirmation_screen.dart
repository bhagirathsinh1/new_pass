import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/screens/home_screen.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/themeData.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
// create function to subtract two values
  late String bookingId;
  @override
  Widget build(BuildContext context) {
    final bookingIdTemp = ModalRoute.of(context)!.settings.arguments as String;
    bookingId = bookingIdTemp;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          return Future.value(false);
        },
        child: SingleChildScrollView(
          child: Container(
            child: _buildSliverList(context),
          ),
        ),
      ),
    );
  }

  Container _buildSliverList(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.topLeftRadiousForContainer),
          topRight: Radius.circular(SizeConfig.topRightRadiousForContainer),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/clouds.png',
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(top: 80),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.17,
                      ),
                      Text(
                        AppStrings.csWearecoming,
                        style: TextStyle(
                          color: ThemeClass.orangeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppStrings.csYourbookinghasbeenconfirmed,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            // width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height / 3,

            child: Image.asset(
              'assets/images/transportVehicle.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ButtonWidget(
              title: AppStrings.csViewBooking,
              icon: Icons.arrow_forward,
              onpress: () {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.bookingDetailsScreen,
                  arguments: {
                    'bookingId': bookingId,
                    'foromHomePage': true,
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

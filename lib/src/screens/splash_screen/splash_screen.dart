import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? initalRoutes = '';
  late SharedPreferences prefs;
  @override
  void initState() {
    startTime();
    getUserLogged();
    super.initState();
  }

  Future<void> getUserLogged() async {
    try {
      prefs = await SharedPreferences.getInstance();
      var temp = prefs.getString("IsFirstLogin");
      if (temp == null || temp == "") {
        initalRoutes = Routes.onBoardingRoutes;
        prefs.setString("IsFirstLogin", "true");
      } else {
        var temp1 = await SharedPrefService.getUserToken();
        if (temp1 == null || temp1 == "") {
          initalRoutes = Routes.logingRoute;
        } else {
          initalRoutes = Routes.homeRoute;
          // initalRoutes = Routes.availableSlotsScreen;
        }
      }
    } catch (e) {
      initalRoutes = Routes.onBoardingRoutes;
    }
  }

  startTime() async {
    var duration = Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushNamedAndRemoveUntil(
        context, "$initalRoutes", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Image.asset('assets/images/pass_logo.png'),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splaceScreenBackgroundImage.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

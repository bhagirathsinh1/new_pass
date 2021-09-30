import 'package:flutter/material.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/notification_service/notification_service.dart';
import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              child: Image.asset(
                'assets/images/drawerIcon.png',
                // color: Colors.black,
                height: size.height * 0.2,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 40),
              height: size.height * 0.07,
              alignment: Alignment.centerLeft,
              color: ThemeClass.greyMediumColor.withOpacity(0.3),
              child: Text(
                AppStrings.dAccount,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.myBookingsScreen);
              },
              child: Container(
                height: size.height * 0.07,
                width: size.width * 0.7,
                padding: EdgeInsets.only(left: 40),
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmark,
                      color: Colors.black,
                      // color: ThemeClass.orangeColor,
                      size: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppStrings.dMyBookings,
                      style: TextStyle(
                        // color: ThemeClass.orangeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.myVehicallistScreen);
              },
              child: Container(
                width: size.width,
                height: size.height * 0.07,
                margin: EdgeInsets.only(left: 40),
                child: Row(
                  children: [
                    Icon(
                      Icons.two_wheeler,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppStrings.dMyVehicles,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context,
                    Routes
                        .profileScreen); // // Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                //   return ProfileScreen();
                // }));
              },
              child: Container(
                width: size.width,
                height: size.height * 0.07,
                margin: EdgeInsets.only(left: 40),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppStrings.dProfile,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 40),
              width: size.width,
              height: size.height * 0.07,
              alignment: Alignment.centerLeft,
              color: ThemeClass.greyMediumColor.withOpacity(0.3),
              child: Text(
                AppStrings.dOthers,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 15),
            // GestureDetector(
            //   onTap: () {
            //     // Navigator.pushNamed(context, Routes.chatBoxScreen);
            //     // Navigator.of(context).push(
            //     //   MaterialPageRoute(
            //     //     builder: (context) => ChatBoxScreen(),
            //     //   ),
            //     // );
            //   },
            //   child: Container(
            //     width: size.width,
            //     height: size.height * 0.07,
            //     padding: EdgeInsets.only(left: 40),
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       AppStrings.dChatbox,
            //       textAlign: TextAlign.start,
            //       style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.aboutUsScreen);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => ChatBoxScreen(),
                //   ),
                // );
              },
              child: Container(
                width: size.width,
                height: size.height * 0.07,
                padding: EdgeInsets.only(left: 40),
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.dAboutus,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // Container(
            //   width: size.width,
            //   height: size.height * 0.07,
            //   padding: EdgeInsets.only(left: 40),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     AppStrings.dRateourapp,
            //     textAlign: TextAlign.start,
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: _buildButton(context),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.outlineBorderRadius,
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => ThemeClass.orangeColor,
        ),
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.all(15),
        ),
      ),
      onPressed: () {
        logout();
      },
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout),
            Text(
              AppStrings.dSignOut,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  logout() async {
    SharedPrefService.removeUserToken();
    var prefs = await SharedPreferences.getInstance();

    PushNotificationsHandler.unSubscribeNotification(
        prefs.get('customer_id').toString());

    Navigator.restorablePushNamedAndRemoveUntil(
        context, Routes.logingRoute, (route) => false);
  }
}

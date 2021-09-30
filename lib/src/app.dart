import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/notification_service/notification_service.dart';
import 'package:pass/src/service/navigator_service.dart';
import 'package:pass/src/service/vehicle_service.dart';

import 'package:pass/themeData.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  String? initalRoutes = '';

  // iniateNotificaiton(BuildContext context) {
  //   try {
  //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //       navigationService.navigationKey.currentState!.pushNamed(
  //         Routes.bookingDetailsScreen,
  //         arguments: {
  //           'bookingId': message.data["bookingId"],
  //           'foromHomePage': true,
  //         },
  //       );
  //     });
  //     SharedPreferences.getInstance().then((prefs) {
  //       PushNotificationsHandler.initializeNotification(
  //           prefs.get('customer_id').toString(), context);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // iniateNotificaiton(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VehicleService>(
          create: (_) => VehicleService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeClass.themeData,
        // home: ConfirmationScreen(),
        initialRoute: Routes.initialRoutes,
        routes: Routes.globalRoutes,
        navigatorKey: navigationService.navigationKey,
      ),
    );
  }
}

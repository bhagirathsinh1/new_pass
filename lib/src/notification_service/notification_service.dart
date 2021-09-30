import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pass/routes.dart';
import 'package:pass/src/service/navigator_service.dart';

class PushNotificationsHandler {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> initializeNotification(
      String id, BuildContext context) async {
    _fcm.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    // await updateFcmToken((await _fcm.getToken()).toString());

    _fcm.subscribeToTopic(id);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      print("notificaion listen start ----------");
      print("notification ${message.notification}");

      AndroidNotification? android = message.notification?.android;
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_logo');
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings();
      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        await navigationService.navigationKey.currentState!.pushNamed(
          Routes.bookingDetailsScreen,
          arguments: {
            'bookingId': message.data["bookingId"],
            'foromHomePage': true,
          },
        );
      });
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                android.channelId.toString(),
                android.tag.toString(), android.ticker.toString(),
                icon: 'app_logo',
                // icon: android.smallIcon,
                // icon: 'assets/images/customer_app_logo.png',
              ),
            ));
      }
    });
  }

  static unSubscribeNotification(id) {
    _fcm.unsubscribeFromTopic(id);
  }
}

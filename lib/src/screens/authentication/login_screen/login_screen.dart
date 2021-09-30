import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:pass/routes.dart';
import 'package:pass/src/config/dimens.dart';
import 'package:pass/src/config/size_config.dart';
import 'package:pass/src/config/strings.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/Login_model.dart';
import 'package:pass/src/model/customer_register_model.dart';
import 'package:pass/src/notification_service/notification_service.dart';

import 'package:pass/src/shared_preferance/shared_pref_service.dart';
import 'package:pass/src/widgets/background_gradiant.dart';
import 'package:pass/src/widgets/button_widget.dart';
import 'package:pass/src/widgets/snack_bar_widget.dart';
import 'package:pass/src/widgets/text_form_field_widget.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pass/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isObsecure = true;
  bool isObsecureCnfPass = true;
  bool agree = false;
  bool isFirstSubmit = true;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BackgraoundGradient(
        child: CustomScrollView(
          // physics: NeverScrollableScrollPhysics(),
          slivers: <Widget>[
            _buildSliverAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: MediaQuery.of(context).size.height - 210,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            SizeConfig.topLeftRadiousForContainer),
                        topRight: Radius.circular(
                            SizeConfig.topRightRadiousForContainer),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildForm(context),
                          SizedBox(
                            height: 40,
                          ),
                          _buildBottomTitle(context),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: 150,
      collapsedHeight: 0,
      toolbarHeight: 0,

      flexibleSpace: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildTopImage(),
          ),
        ],
      ),

      backgroundColor: Colors.transparent,
      // title: _buildTopImage(),
    );
  }

  Center _buildTopImage() {
    return Center(
      child: Image.asset(
        "assets/images/pass_logo.png",
        height: SizeConfig.blockSizeVertical * Dimens.logoSmallSize,
        width: SizeConfig.blockSizeVertical * Dimens.logoSmallSize,
      ),
    );
  }

  Container _buildForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
              color: Colors.black38,
              blurRadius: 15.0,
              offset: Offset(0.0, 9.75))
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        autovalidateMode: !isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          children: [
            Text(
              AppStrings.lWelcome,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: 10),
            Text(
              AppStrings.lSigninintocontinue,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * Dimens.verticleSpaceWidget,
            ),
            TextFormFieldWdiget(
              controller: _mobileController,
              type: "email",
              hintText: AppStrings.rEmail,
              showNext: TextInputAction.next,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical *
                  Dimens.verticleSpaceClosestWidget,
            ),
            TextFormFieldWdiget(
              type: "password",
              controller: _pwdController,
              showNext: TextInputAction.done,
              hintText: AppStrings.ltextPassword,
              isPassword: isObsecure,
              icon: isObsecure ? Icons.visibility_off : Icons.visibility,
              onpress: () {
                setState(() {
                  isObsecure = !isObsecure;
                });
              },
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * Dimens.verticleSpaceWidget,
            ),
            InkWell(
              splashColor: Colors.red,
              onTap: () {
                // SharedPrefService.getUserToken();
                Navigator.pushNamed(context, Routes.forgetPasswordScreen);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppStrings.lforgetPassword,
                  style: TextStyle(color: ThemeClass.orangeColor),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * Dimens.verticleSpaceWidget,
            ),
            ButtonWidget(
              title: AppStrings.lSignin,
              icon: Icons.arrow_forward,
              onpress: () {
                login();
              },
              isLoading: isLoading,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * Dimens.verticleSpaceWidget,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildBottomTitle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.signupAsScreen);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.lNewUser,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            TextSpan(
              text: AppStrings.lSignup,
              style: TextStyle(
                fontSize: 20,
                color: ThemeClass.orangeColor,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  login() {
    setState(() {
      isFirstSubmit = false;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      loginService();
    } else {}
  }

  loginService() async {
    var loginModel = LoginModel(
      password: _pwdController.text,
      username: _mobileController.text,
    );

    String url = "auth/customer/login";
    try {
      debugPrint("${loginModel.toJson()}");
      var res = await HttpConfig().httpPostRequest(url, loginModel);
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 201 || res.statusCode == 200) {
        print("success");
        var jsonData = json.decode(res.body);
        print(jsonData);

        var pickupaddress =
            Address.fromJson(jsonData["customer"]["pickupAddress"]);
        var destinationaddress =
            Address.fromJson(jsonData["customer"]["destinationAddress"]);

        var subscription =
            Subscription.fromJson(jsonData["customer"]["subscription"]);

        await SharedPrefService.setUserToken(
            accessToken: jsonData["access_token"],
            id: jsonData["customer"]["_id"].toString(),
            email: jsonData["customer"]["email"],
            username: jsonData["customer"]["name"],
            mobile: jsonData["customer"]["mobileNumber"].toString(),
            role: jsonData["customer"]["role"],
            profilePicture: jsonData["customer"]["profilePicture"],
            pickupAddress: pickupaddress,
            destinationAddress: destinationaddress,
            subscription: subscription);
        // await initializeNotification(jsonData["customer"]["_id"].toString());
        await PushNotificationsHandler.initializeNotification(
            jsonData["customer"]["_id"].toString(), context);

        Navigator.pushReplacementNamed(context, Routes.homeRoute);
      } else if (res.statusCode == 402) {
        showSnackbarMessageGlobal(AppStrings.emailnotverified, context);
      } else if (res.statusCode == 400) {
        showSnackbarMessageGlobal(AppStrings.Usernotverifiedbyadmin, context);
      } else if (res.statusCode == 401) {
        showSnackbarMessageGlobal(
            AppStrings.InvalidUsernameOrPassword, context);
      } else {
        showSnackbarMessageGlobal(AppStrings.somethingwentwrong, context);

        print(res.body);
      }
    } catch (e) {
      debugPrint("error $e");
      showSnackbarMessageGlobal(e.toString(), context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> initializeNotification(String id) async {
  //   _fcm.requestPermission(
  //       alert: true,
  //       announcement: true,
  //       badge: true,
  //       carPlay: true,
  //       criticalAlert: true,
  //       provisional: true,
  //       sound: true);
  //   // await updateFcmToken((await _fcm.getToken()).toString());

  //   _fcm.subscribeToTopic(id);
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print("notificaion listen start ----------");
  //     RemoteNotification? notification = message.notification;

  //     AndroidNotification? android = message.notification?.android;
  //     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  //     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>();
  //     await FirebaseMessaging.instance
  //         .setForegroundNotificationPresentationOptions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  //     if (notification != null && android != null) {
  //       flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               android.channelId.toString(),
  //               android.tag.toString(),
  //               android.ticker.toString(),
  //               icon: 'launch_background',
  //             ),
  //           ));
  //     }
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print("Clicked on notification");
  //     Navigator.pushNamed(context, Routes.myBookingsScreen);
  //   });
  // }

  // Future<void> updateFcmToken(String token) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   SharedPreferences prefs;
  //   prefs = await SharedPreferences.getInstance();
  //   var mapData = new Map<String, dynamic>();
  //   mapData['fcmToken'] = token;
  //   String custid = prefs.getString("customer_id").toString();
  //   String url = "customer/$custid";

  //   try {
  //     var response = await HttpConfig().httpPatchRequestWithToken(
  //         url, mapData, prefs.getString("customer_accessToken").toString());
  //   } catch (e) {} finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
}

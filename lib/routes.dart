import 'package:flutter/material.dart';
import 'package:pass/src/screens/about_us/about_us_screen.dart';
import 'package:pass/src/screens/add_vehical/activate_booking_screen.dart';
import 'package:pass/src/screens/add_vehical/add_vehicle_screen.dart';
import 'package:pass/src/screens/add_vehical/available_slots_screen.dart';

import 'package:pass/src/screens/add_vehical/confirmation_screen.dart';
import 'package:pass/src/screens/add_vehical/destination_address_screen.dart';
import 'package:pass/src/screens/add_vehical/pickup_address_screen.dart';
import 'package:pass/src/screens/authentication/register_screen/personal_register.dart';
import 'package:pass/src/screens/authentication/register_screen/professional_register.dart';
import 'package:pass/src/screens/booking/my_bookings.dart';
import 'package:pass/src/screens/add_vehical/more_about_vehicle_screen.dart';
import 'package:pass/src/screens/booking/booking_details_screen.dart';
import 'package:pass/src/screens/chat/chat_detailed_screen.dart';
import 'package:pass/src/screens/chat/chatbox_screen.dart';
import 'package:pass/src/screens/driver/driver_details_screen.dart';

import 'package:pass/src/screens/my_vehical/my_vehical_list.dart';
import 'package:pass/src/screens/authentication/login_screen/login_screen.dart';
import 'package:pass/src/screens/authentication/register_screen/sign_up_as_screen.dart';
import 'package:pass/src/screens/home_screen.dart';
import 'package:pass/src/screens/notification/notification_screen.dart';
import 'package:pass/src/screens/on_boarding_screen/onboarding_screen.dart';

import 'package:pass/src/screens/authentication/forgot_password/forget_password_screen.dart';

import 'package:pass/src/screens/authentication/email_verification/verify_email_screen.dart';
import 'package:pass/src/screens/profile/change_password.dart';
import 'package:pass/src/screens/profile/profile_screen.dart';
import 'package:pass/src/screens/splash_screen/splash_screen.dart';
import 'package:pass/src/screens/term_and_condition/term_and_condition.dart';

class Routes {
  static final String mainRoutes = "/";
  static final String initialRoutes = "/splash";

  static final String onBoardingRoutes = "/onBoarding";
  static final String logingRoute = "/login";
  static final String registerRoute = "/register";

  static final String homeRoute = "/home";
  static final String addVehicleScreen = "/addVehicle";
  static final String confirmBookingScreen = "/confirmBookingScreen";
  static final String activateBookingScreen = "/activateBookingScreen";
  static final String availableSlotsScreen = "/availableSlotsScreen";
  static final String signupAsScreen = "/signupAsScreen";

  static final String myVehicallistScreen = "/myVehicalScreen";
  static final String myBookingsScreen = "/myBookingsScreen";
  static final String varifyEmailScreen = "/varifyEmailScreen";
  static final String forgetPasswordScreen = "/forgetPasswordScreen";
  static final String otpVerificationScreen = "/otpVerificationScreen";
  static final String createNewPasswordScreen = "/createNewPasswordScreen";
  static final String moreAboutVehicle = "/moreAboutVehicle";
  static final String confirmationScreen = "/confirmationScreen";
  static final String bookingDetailsScreen = "/bookingDetailsScreen";
  static final String notificationScreen = "/notificationScreen";
  static final String profileScreen = "/profileScreen";
  static final String driverDetailsScreen = "/driverDetailsScreen";
  static final String chatBoxScreen = "/chatBoxScreen";
  static final String chatDetailedScreen = "/chatDetailedScreen";
  static final String termAndConditionScreen = "/termAndConditionScreen";
  static final String aboutUsScreen = "/aboutUsScreen";
  static final String changePassWordScreen = "/changePassWordScreen";

  static final String pickupAddressScreen = "/pickupAddressScreen";
  static final String destinationAddressScreen = "/destinationAddressScreen";
  static final String personalRegisterScreen = "/personalRegisterScreen";
  static final String professionalRegisterScreen =
      "/professionalRegisterScreen";

  static final String editVehicleScreen = "/editVehicleScreen";

  static Map<String, Widget Function(BuildContext)> globalRoutes = {
    initialRoutes: (context) => SplashScreen(),
    mainRoutes: (context) => SplashScreen(),
    logingRoute: (context) => LoginScreen(),
    onBoardingRoutes: (context) => OnBoarding(),
    homeRoute: (context) => HomeScreen(),
    addVehicleScreen: (context) => AddVehicleScreen(),
    // confirmBookingScreen: (context) => ConfirmBookingAddressScreen(),
    activateBookingScreen: (context) => ActivateBookingScreen(),
    availableSlotsScreen: (context) => AvailableSlotsScreen(),
    signupAsScreen: (context) => SignupAsScreen(),
    myVehicallistScreen: (context) => MyVehicalListScreen(),
    myBookingsScreen: (context) => MyBookingsScreen(),
    varifyEmailScreen: (context) => VarifyEmailScreen(),
    forgetPasswordScreen: (context) => ForgetPasswordScreen(),
    // otpVerificationScreen: (context) => OtpVerificationScreen(),
    // createNewPasswordScreen: (context) => CreateNewPasswordScreen(),
    moreAboutVehicle: (context) => MoreAboutVehicle(),
    confirmationScreen: (context) => ConfirmationScreen(),
    bookingDetailsScreen: (context) => BookingDetailsScreen(),
    notificationScreen: (context) => NotificationScreen(),
    profileScreen: (context) => ProfileScreen(),
    driverDetailsScreen: (context) => DriverDetailsScreen(),
    chatBoxScreen: (context) => ChatBoxScreen(),
    chatDetailedScreen: (context) => ChatDetailedScreen(),
    termAndConditionScreen: (context) => TermAndConditionScreen(),
    aboutUsScreen: (context) => AboutUsScreen(),
    changePassWordScreen: (context) => ChangePassWordScreen(),
    pickupAddressScreen: (context) => PickupAddressScreen(),
    destinationAddressScreen: (context) => DestinationAddressScreen(),
    personalRegisterScreen: (context) => PersonalRegisterScreen(),
    professionalRegisterScreen: (context) => ProfessionalRegisterScreen(),

    // editVehicleScreen: (context) => EditVehicleScreen(),
  };
}

import 'dart:convert';

import 'package:pass/src/model/customer_register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPreferences? prefs;

  static Future<void> setUserToken({
    String? accessToken,
    String? mobile,
    String? id,
    String? role,
    String? email,
    String? username,
    String? profilePicture,
    required Address pickupAddress,
    required Address destinationAddress,
    required Subscription subscription,
  }) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString('customer_mobile', "$mobile");
    prefs!.setString('customer_id', "$id");
    prefs!.setString('customer_accessToken', "$accessToken");
    prefs!.setString('customer_username', "$username");
    prefs!.setString('customer_role', "$role");
    prefs!.setString('customer_email', "$email");
    prefs!.setString('customer_profilePicture', "$profilePicture");
    prefs!.setString('customer_pickupAddress', jsonEncode(pickupAddress));
    prefs!.setString(
        'customer_destinationAddress', jsonEncode(destinationAddress));
    prefs!.setString('customer_subscription', jsonEncode(subscription));
  }

  static Future<void> setSubscription(Subscription subscription) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString('customer_subscription', jsonEncode(subscription));
  }

  static Future<Subscription> getSubscription() async {
    prefs = await SharedPreferences.getInstance();
    String? subscription = prefs!.getString('customer_subscription');
    return Subscription.fromJson(jsonDecode(subscription!));
  }

  static Future<String?> getUserToken() async {
    prefs = await SharedPreferences.getInstance();
    var a = prefs!.getString('customer_accessToken');

    return a;
  }

  static Future<void> removeUserToken() async {
    prefs = await SharedPreferences.getInstance();

    prefs!.remove("customer_accessToken");
    prefs!.remove("customer_mobile");
    prefs!.remove("customer_id");
    prefs!.remove("customer_username");
    prefs!.remove("customer_role");
    prefs!.remove("customer_email");
    prefs!.remove("customer_profilePicture");
    prefs!.remove("customer_pickupAddress");
    prefs!.remove("customer_destinationAddress");
    prefs!.remove("customer_subscription");
  }
}

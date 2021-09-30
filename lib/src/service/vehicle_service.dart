import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pass/src/http/http_config.dart';
import 'package:pass/src/model/vehical_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleService with ChangeNotifier {
  List<MyVehicalListModel> globleVehicalList = [];

  Future<List<MyVehicalListModel>> getVehicleList() async {
    SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    String url = "vehicle";
    try {
      var response = await HttpConfig().httpGetRequest(
          url, prefs.getString("customer_accessToken").toString());

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        globleVehicalList = [];
        body.forEach((element) {
          globleVehicalList.add(MyVehicalListModel.fromJson(element));
        });
      }
    } catch (e) {
      print(e);
    }

    return globleVehicalList;
  }

  Future<List<MyVehicalListModel>> setVehicleList() async {
    SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    String url = "vehicle";
    try {
      var response = await HttpConfig().httpGetRequest(
          url, prefs.getString("customer_accessToken").toString());

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        globleVehicalList = [];
        body.forEach((element) {
          globleVehicalList.add(MyVehicalListModel.fromJson(element));
        });
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
    return globleVehicalList;
  }
}

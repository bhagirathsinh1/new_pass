// To parse this JSON data, do
//
//     final myVehicalListModel = myVehicalListModelFromJson(jsonString);

import 'dart:convert';

List<MyVehicalListModel> myVehicalListModelFromJson(String str) =>
    List<MyVehicalListModel>.from(
        json.decode(str).map((x) => MyVehicalListModel.fromJson(x)));

String myVehicalListModelToJson(List<MyVehicalListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyVehicalListModel {
  MyVehicalListModel({
    this.id,
    this.make,
    this.model,
    this.plateNumber,
    this.customerId,
    this.v,
  });

  String? id;
  String? make;
  String? model;
  String? plateNumber;
  String? customerId;
  int? v;

  factory MyVehicalListModel.fromJson(Map<String, dynamic> json) =>
      MyVehicalListModel(
        id: json["_id"],
        make: json["make"],
        model: json["model"],
        plateNumber: json["plateNumber"],
        customerId: json["customerId"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "make": make,
        "model": model,
        "plateNumber": plateNumber,
        "customerId": customerId,
        "__v": v,
      };
}

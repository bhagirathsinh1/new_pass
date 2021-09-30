// To parse this JSON data, do
//
//     final addVehicalModel = addVehicalModelFromJson(jsonString);

import 'dart:convert';

class AddVehicalModel {
  AddVehicalModel(
      {this.make, this.model, this.plateNumber, this.customerId, this.color});

  String? make;
  String? model;
  String? plateNumber;
  String? customerId;
  String? color;

  factory AddVehicalModel.fromRawJson(String str) =>
      AddVehicalModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddVehicalModel.fromJson(Map<String, dynamic> json) =>
      AddVehicalModel(
        make: json["make"],
        model: json["model"],
        plateNumber: json["plateNumber"],
        customerId: json["customerId"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "make": make,
        "model": model,
        "plateNumber": plateNumber,
        "customerId": customerId,
        "color": color,
      };
}

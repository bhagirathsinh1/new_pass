// To parse this JSON data, do
//
//     final driver = driverFromJson(jsonString);

import 'dart:convert';

DriverModel driverFromJson(String str) =>
    DriverModel.fromJson(json.decode(str));

String driverToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  DriverModel({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.companyName,
    required this.vatNumber,
    required this.drivingLicenseNumber,
    required this.dateOfIssue,
    required this.dateOfExpiry,
    required this.address,
    required this.iban,
    required this.notes,
    required this.uploadedDocuments,
    required this.profilePicture,
    required this.agenda,
    required this.role,
  });

  String name;
  String email;
  int mobileNumber;
  String companyName;
  String vatNumber;
  String drivingLicenseNumber;
  String dateOfIssue;
  String dateOfExpiry;
  String address;
  String iban;
  String notes;
  List<String> uploadedDocuments;
  String profilePicture;
  List<String> agenda;
  String role;

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobileNumber"] ?? 0,
        companyName: json["companyName"],
        vatNumber: json["vatNumber"],
        drivingLicenseNumber: json["drivingLicenseNumber"],
        dateOfIssue: json["dateOfIssue"],
        dateOfExpiry: json["dateOfExpiry"],
        address: json["address"],
        iban: json["iban"],
        notes: json["notes"],
        uploadedDocuments:
            List<String>.from(json["uploadedDocuments"].map((x) => x)),
        profilePicture: json["profilePicture"],
        agenda: List<String>.from(json["agenda"].map((x) => x)),
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobileNumber": mobileNumber,
        "companyName": companyName,
        "vatNumber": vatNumber,
        "drivingLicenseNumber": drivingLicenseNumber,
        "dateOfIssue": dateOfIssue,
        "dateOfExpiry": dateOfExpiry,
        "address": address,
        "iban": iban,
        "notes": notes,
        "uploadedDocuments": uploadedDocuments,
        "profilePicture": profilePicture,
        "agenda": List<dynamic>.from(agenda.map((x) => x)),
        "role": role,
      };
}

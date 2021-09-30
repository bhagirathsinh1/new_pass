// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    this.password,
    this.subscription,
    this.email,
    this.name,
    this.mobileNumber,
    this.profilePicture,
    this.uploadedDocuments,
    this.vehicle,
    this.pickupAddress,
    this.destinationAddress,
    this.role,
    this.openTime,
    this.closeTime,
  });

  String? password;
  Subscription? subscription;
  String? email;
  String? name;
  String? mobileNumber;
  String? profilePicture;
  List<String>? uploadedDocuments;
  List<String>? vehicle;
  Address? pickupAddress;
  Address? destinationAddress;
  String? role;
  String? openTime;
  String? closeTime;

  // String toJson() => json.encode(toMap());

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        password: json["password"] == null ? "" : json["password"],
        subscription: json["subscription"] == null ? "" : json["subscription"],
        email: json["email"] == null ? "" : json["email"],
        name: json["name"] == null ? "" : json["name"],
        mobileNumber: json["mobileNumber"] == null ? "" : json["mobileNumber"],
        profilePicture:
            json["profilePicture"] == null ? "" : json["profilePicture"],
        uploadedDocuments: json["uploadedDocuments"] == null
            ? []
            : List<String>.from(json["uploadedDocuments"].map((x) => x)),
        vehicle: json["vehicle"] == null
            ? []
            : List<String>.from(json["vehicle"].map((x) => x)),
        pickupAddress: json["pickupAddress"] == null
            ? Address()
            : Address.fromJson(json["pickupAddress"]),
        destinationAddress: json["destinationAddress"] == null
            ? Address()
            : Address.fromJson(json["destinationAddress"]),
        role: json["role"] == null ? "" : json["role"],
        openTime: json["openTime"] == null ? "" : json["openTime"],
        closeTime: json["closeTime"] == null ? "" : json["closeTime"],
      );

  Map<String, dynamic> toMap() => {
        "password": password ?? '',
        "subscription": subscription ?? '',
        "email": email ?? '',
        "name": name ?? '',
        "mobileNumber": mobileNumber ?? '',
        "profilePicture": profilePicture ?? '',
        "uploadedDocuments": uploadedDocuments == null
            ? []
            : List<dynamic>.from(uploadedDocuments!.map((x) => x)),
        // "vehicle": List<dynamic>.from(vehicle!.map((x) => x)),
        // "pickupAddress": pickupAddress!.toMap(),
        // "destinationAddress": destinationAddress.toMap(),
        "role": role ?? '',
        "openTime": openTime ?? '',
        "closeTime": closeTime ?? '',
      };

  Map<String, dynamic> toJson() => {
        "password": password ?? '',
        "subscription": subscription ?? '',
        "email": email ?? '',
        "name": name ?? '',
        "mobileNumber": mobileNumber ?? '',
        "profilePicture": profilePicture ?? '',
        "uploadedDocuments": uploadedDocuments == null ? [] : uploadedDocuments,
        "vehicle": vehicle == null ? '' : jsonEncode(vehicle),
        "pickupAddress": pickupAddress == null ? {} : pickupAddress!.toJson(),
        "destinationAddress":
            destinationAddress == null ? {} : destinationAddress!.toJson(),
        "role": role ?? '',
        "openTime": openTime ?? '',
        "closeTime": closeTime ?? '',
      };
}

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address(
      {this.originalAddress,
      this.addressLine2,
      this.landmark,
      this.city,
      this.pincode,
      this.long,
      this.lat,
      this.authorName,
      this.authorMobileNumber,
      this.country});

  String? originalAddress;
  String? addressLine2;
  String? landmark;
  String? city;
  String? pincode;
  String? long;
  String? lat;
  String? authorName;
  String? authorMobileNumber;
  String? country;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        originalAddress:
            json["originalAddress"] == null ? null : json["originalAddress"],
        addressLine2:
            json["addressLine2"] == null ? null : json["addressLine2"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        city: json["city"] == null ? null : json["city"],
        pincode: json["pincode"] == null ? null : json["pincode"].toString(),
        long: json["long"] == null ? null : json["long"].toString(),
        lat: json["lat"] == null ? null : json["lat"],
        authorName: json["authorName"] == null ? null : json["authorName"],
        country: json["country"] == null ? null : json["country"],
        authorMobileNumber: json["authorMobileNumber"] == null
            ? null
            : json["authorMobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "originalAddress": originalAddress == null ? null : originalAddress,
        "addressLine2": addressLine2 == null ? null : addressLine2,
        "landmark": landmark == null ? null : landmark,
        "city": city == null ? null : city,
        "pincode": pincode == null ? null : pincode,
        "long": long == null ? null : long,
        "lat": lat == null ? null : lat,
        "authorName": authorName == null ? null : authorName,
        "country": country == null ? null : country,
        "authorMobileNumber":
            authorMobileNumber == null ? null : authorMobileNumber,
      };
}

class Subscription {
  Subscription({
    this.name,
    this.totalRides,
    this.maxKm,
    this.maxkmExceededRate,
  });

  String? name;

  int? totalRides;
  double? maxKm;
  int? maxkmExceededRate;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        name: json["name"],
        totalRides: json["totalRides"],
        maxKm: double.parse(json["maxKm"].toString()),
        maxkmExceededRate: json["maxkmExceededRate"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "totalRides": totalRides,
        "maxKm": maxKm,
        "maxkmExceededRate": maxkmExceededRate,
      };
}

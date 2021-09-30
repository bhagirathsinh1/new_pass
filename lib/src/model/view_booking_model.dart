// To parse this JSON data, do
//
//     final viewBookingModel = viewBookingModelFromJson(jsonString);

import 'dart:convert';

List<ViewBookingModel> viewBookingModelFromJson(String str) =>
    List<ViewBookingModel>.from(
        json.decode(str).map((x) => ViewBookingModel.fromJson(x)));

String viewBookingModelToJson(List<ViewBookingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ViewBookingModel {
  ViewBookingModel({
    required this.bookingStatus,
    required this.driverVideos,
    required this.driverImages,
    required this.customerImages,
    required this.rideEndTime,
    required this.pickupTime,
    required this.rideStartTime,
    required this.id,
    required this.damagedMotorbike,
    required this.date,
    required this.insuredMotorbike,
    required this.notes,
    required this.registeredMotorbike,
    required this.vehicleId,
    required this.workingMotorbike,
    required this.slot,
    required this.customerId,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.driverId,
    required this.tripKm,
    required this.tripTime,
    required this.v,
  });

  String bookingStatus;
  List<dynamic> driverVideos;
  List<dynamic> driverImages;
  List<dynamic> customerImages;
  int rideEndTime;
  int pickupTime;
  int rideStartTime;
  String id;
  bool damagedMotorbike;
  int date;
  bool insuredMotorbike;
  String notes;
  bool registeredMotorbike;
  VehicleId vehicleId;
  bool workingMotorbike;
  Slot slot;
  CustomerId customerId;
  Address pickupAddress;
  Address destinationAddress;
  DriverId driverId;
  double tripKm;
  int tripTime;
  int v;

  factory ViewBookingModel.fromJson(Map<String, dynamic> json) =>
      ViewBookingModel(
        bookingStatus: json["bookingStatus"],
        driverVideos: json["driverVideos"] != null
            ? List<dynamic>.from(json["driverVideos"].map((x) => x))
            : [],
        driverImages: json["driverImages"] != null
            ? List<dynamic>.from(json["driverImages"].map((x) => x))
            : [],
        customerImages: json["customerImages"] != null
            ? List<dynamic>.from(json["customerImages"].map((x) => x))
            : [],
        rideEndTime: json["rideEndTime"],
        pickupTime: json["pickupTime"],
        rideStartTime: json["rideStartTime"],
        id: json["_id"],
        damagedMotorbike: json["damagedMotorbike"],
        date: json["date"],
        insuredMotorbike: json["insuredMotorbike"],
        notes: json["notes"],
        registeredMotorbike: json["registeredMotorbike"],
        vehicleId: VehicleId.fromJson(json["vehicleId"]),
        workingMotorbike: json["workingMotorbike"],
        slot: Slot.fromJson(json["slot"]),
        customerId: CustomerId.fromJson(json["customerId"]),
        pickupAddress: Address.fromJson(json["pickupAddress"]),
        destinationAddress: Address.fromJson(json["destinationAddress"]),
        driverId: DriverId.fromJson(json["driverId"]),
        tripKm: json["tripKm"].toDouble(),
        tripTime: json["tripTime"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "bookingStatus": bookingStatus,
        "driverVideos": List<dynamic>.from(driverVideos.map((x) => x)),
        "driverImages": List<dynamic>.from(driverImages.map((x) => x)),
        "customerImages": List<dynamic>.from(customerImages.map((x) => x)),
        "rideEndTime": rideEndTime,
        "pickupTime": pickupTime,
        "rideStartTime": rideStartTime,
        "_id": id,
        "damagedMotorbike": damagedMotorbike,
        "date": date,
        "insuredMotorbike": insuredMotorbike,
        "notes": notes,
        "registeredMotorbike": registeredMotorbike,
        "vehicleId": vehicleId.toJson(),
        "workingMotorbike": workingMotorbike,
        "slot": slot.toJson(),
        "customerId": customerId.toJson(),
        "pickupAddress": pickupAddress.toJson(),
        "destinationAddress": destinationAddress.toJson(),
        "driverId": driverId.toJson(),
        "tripKm": tripKm,
        "tripTime": tripTime,
        "__v": v,
      };
}

class CustomerId {
  CustomerId({
    required this.adminVerified,
    required this.emailVerified,
    required this.otp,
    required this.passActive,
    required this.fcmToken,
    required this.passInactive,
    required this.closeTime,
    required this.openTime,
    required this.tripTime,
    required this.pickupToDestinationKm,
    required this.destinationAddress,
    required this.pickupAddress,
    required this.uploadedDocuments,
    required this.vehicleId,
    required this.id,
    required this.password,
    required this.subscription,
    required this.email,
    required this.name,
    required this.mobileNumber,
    required this.profilePicture,
    required this.role,
    required this.v,
  });

  bool adminVerified;
  bool emailVerified;
  int otp;
  int passActive;
  String fcmToken;
  int passInactive;
  int closeTime;
  int openTime;
  int tripTime;
  double pickupToDestinationKm;
  Address destinationAddress;
  Address pickupAddress;
  List<dynamic> uploadedDocuments;
  List<dynamic> vehicleId;
  String id;
  String password;
  Subscription subscription;
  String email;
  String name;
  int mobileNumber;
  String profilePicture;
  String role;
  int v;

  factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(
        adminVerified: json["adminVerified"],
        emailVerified: json["emailVerified"],
        otp: json["otp"],
        passActive: json["passActive"],
        fcmToken: json["fcmToken"],
        passInactive: json["passInactive"],
        closeTime: json["closeTime"],
        openTime: json["openTime"],
        tripTime: json["tripTime"],
        pickupToDestinationKm: json["pickupToDestinationKm"].toDouble(),
        destinationAddress: Address.fromJson(json["destinationAddress"]),
        pickupAddress: Address.fromJson(json["pickupAddress"]),
        uploadedDocuments:
            List<dynamic>.from(json["uploadedDocuments"].map((x) => x)),
        vehicleId: List<dynamic>.from(json["vehicleId"].map((x) => x)),
        id: json["_id"],
        password: json["password"],
        subscription: Subscription.fromJson(json["subscription"]),
        email: json["email"],
        name: json["name"],
        mobileNumber: json["mobileNumber"],
        profilePicture: json["profilePicture"],
        role: json["role"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "adminVerified": adminVerified,
        "emailVerified": emailVerified,
        "otp": otp,
        "passActive": passActive,
        "fcmToken": fcmToken,
        "passInactive": passInactive,
        "closeTime": closeTime,
        "openTime": openTime,
        "tripTime": tripTime,
        "pickupToDestinationKm": pickupToDestinationKm,
        "destinationAddress": destinationAddress.toJson(),
        "pickupAddress": pickupAddress.toJson(),
        "uploadedDocuments":
            List<dynamic>.from(uploadedDocuments.map((x) => x)),
        "vehicleId": List<dynamic>.from(vehicleId.map((x) => x)),
        "_id": id,
        "password": password,
        "subscription": subscription.toJson(),
        "email": email,
        "name": name,
        "mobileNumber": mobileNumber,
        "profilePicture": profilePicture,
        "role": role,
        "__v": v,
      };
}

class Address {
  Address({
    required this.originalAddress,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.pincode,
    required this.long,
    required this.lat,
    required this.authorName,
    required this.authorMobileNumber,
  });

  String originalAddress;

  String addressLine2;
  String landmark;
  String city;
  String pincode;
  String long;
  String lat;

  String authorName;
  String authorMobileNumber;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        originalAddress: json["originalAddress"],
        addressLine2: json["addressLine2"],
        landmark: json["landmark"],
        city: json["city"],
        pincode: json["pincode"],
        long: json["long"],
        lat: json["lat"],
        authorName: json["authorName"],
        authorMobileNumber: json["authorMobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "originalAddress": originalAddress,
        "addressLine2": addressLine2,
        "landmark": landmark,
        "city": city,
        "pincode": pincode,
        "long": long,
        "lat": lat,
        "authorName": authorName,
        "authorMobileNumber": authorMobileNumber,
      };
}

class Subscription {
  Subscription({
    required this.name,
    required this.totalRides,
    required this.maxKm,
    required this.maxkmExceededRate,
  });

  String name;
  int totalRides;
  double maxKm;
  int maxkmExceededRate;

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

class DriverId {
  DriverId({
    required this.emailVerified,
    required this.fcmToken,
    required this.role,
    required this.agenda,
    required this.uploadedDocuments,
    required this.long,
    required this.lat,
    required this.address,
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.password,
    required this.vatNumber,
    required this.notes,
    required this.companyName,
    required this.drivingLicenseNumber,
    required this.dateOfIssue,
    required this.dateOfExpiry,
    required this.iban,
    required this.profilePicture,
    required this.v,
  });

  bool emailVerified;
  String fcmToken;
  String role;
  List<dynamic> agenda;
  List<dynamic> uploadedDocuments;
  int long;
  int lat;
  String address;
  String id;
  String name;
  int mobileNumber;
  String email;
  String password;
  String vatNumber;
  String notes;
  String companyName;
  String drivingLicenseNumber;
  DateTime dateOfIssue;
  DateTime dateOfExpiry;
  String iban;
  String profilePicture;
  int v;

  factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
        emailVerified: json["emailVerified"],
        fcmToken: json["fcmToken"],
        role: json["role"],
        agenda: List<dynamic>.from(json["agenda"].map((x) => x)),
        uploadedDocuments:
            List<dynamic>.from(json["uploadedDocuments"].map((x) => x)),
        long: json["long"],
        lat: json["lat"],
        address: json["address"],
        id: json["_id"],
        name: json["name"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        password: json["password"],
        vatNumber: json["vatNumber"],
        notes: json["notes"],
        companyName: json["companyName"],
        drivingLicenseNumber: json["drivingLicenseNumber"],
        dateOfIssue: DateTime.parse(json["dateOfIssue"]),
        dateOfExpiry: DateTime.parse(json["dateOfExpiry"]),
        iban: json["iban"],
        profilePicture: json["profilePicture"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "emailVerified": emailVerified,
        "fcmToken": fcmToken,
        "role": role,
        "agenda": List<dynamic>.from(agenda.map((x) => x)),
        "uploadedDocuments":
            List<dynamic>.from(uploadedDocuments.map((x) => x)),
        "long": long,
        "lat": lat,
        "address": address,
        "_id": id,
        "name": name,
        "mobileNumber": mobileNumber,
        "email": email,
        "password": password,
        "vatNumber": vatNumber,
        "notes": notes,
        "companyName": companyName,
        "drivingLicenseNumber": drivingLicenseNumber,
        "dateOfIssue": dateOfIssue.toIso8601String(),
        "dateOfExpiry": dateOfExpiry.toIso8601String(),
        "iban": iban,
        "profilePicture": profilePicture,
        "__v": v,
      };
}

class Slot {
  Slot({
    required this.startTime,
    required this.endTime,
  });

  int startTime;
  int endTime;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
      };
}

class VehicleId {
  VehicleId({
    required this.id,
    required this.make,
    required this.model,
    required this.plateNumber,
    required this.customerId,
    required this.v,
  });

  String id;
  String make;
  String model;
  String plateNumber;
  String customerId;
  int v;

  factory VehicleId.fromJson(Map<String, dynamic> json) => VehicleId(
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

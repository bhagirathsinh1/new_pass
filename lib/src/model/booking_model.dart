// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:pass/src/model/customer_model.dart';

import 'package:pass/src/model/driver_model.dart';
import 'package:pass/src/model/slot.dart';

List<BookingModel> bookingModelFromJson(String str) => List<BookingModel>.from(
    json.decode(str).map((x) => BookingModel.fromJson(x)));

String bookingModelToJson(List<BookingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingModel {
  BookingModel({
    required this.id,
    required this.customerId,
    required this.driverId,
    required this.date,
    required this.creationDate,
    required this.startDate,
    required this.pickupDate,
    required this.deliveryDate,
    required this.slot,
    required this.tripKm,
    required this.rideStartTime,
    required this.pickupTime,
    required this.rideEndTime,
    required this.pickupDetails,
    required this.destinationDetails,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.customerImages,
    required this.notes,
    required this.registeredMotorbike,
    required this.insuredMotorbike,
    required this.tripTime,
    required this.workingMotorbike,
    required this.damagedMotorbike,
    required this.cancelTime,
    required this.bookingStatus,
    required this.vehicleId,
  });

  String id;
  CustomerModel customerId;
  DriverModel driverId;
  int date;
  int creationDate;
  int startDate;
  int pickupDate;
  int deliveryDate;
  Slot slot;
  double tripKm;
  int rideStartTime;
  int pickupTime;
  int rideEndTime;
  Details pickupDetails;
  Details destinationDetails;
  Address pickupAddress;
  Address destinationAddress;
  List<String> customerImages;
  String notes;
  bool registeredMotorbike;
  bool insuredMotorbike;
  int tripTime;
  bool workingMotorbike;
  bool damagedMotorbike;
  int cancelTime;
  String bookingStatus;
  VehicleModel vehicleId;

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        customerId: CustomerModel.fromJson(json["customerId"]),
        driverId: DriverModel.fromJson(json["driverId"]),
        date: json["date"],
        creationDate: json["creationDate"],
        startDate: json['startDate'],
        pickupDate: json['pickupDate'],
        deliveryDate: json['deliveryDate'],
        slot: Slot.fromJson(json["slot"]),
        tripKm: double.parse(json["tripKm"].toString()),
        rideStartTime: json["rideStartTime"],
        pickupTime: json["pickupTime"],
        rideEndTime: json["rideEndTime"],
        pickupDetails: Details.fromJson(json["pickupDetails"]),
        destinationDetails: Details.fromJson(json["destinationDetails"]),
        pickupAddress: Address.fromJson(json["pickupAddress"]),
        destinationAddress: Address.fromJson(json["destinationAddress"]),
        customerImages: json["customerImages"] != null
            ? List<String>.from(json["customerImages"].map((x) => x))
            : [],
        notes: json["notes"],
        registeredMotorbike: json["registeredMotorbike"],
        insuredMotorbike: json["insuredMotorbike"],
        tripTime: json["tripTime"],
        workingMotorbike: json["workingMotorbike"],
        damagedMotorbike: json["damagedMotorbike"],
        cancelTime: json["cancelTime"],
        bookingStatus: json["bookingStatus"],
        vehicleId: VehicleModel.fromJson(json['vehicleId']),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId.toJson(),
        "driverId": driverId.toJson(),
        "date": date,
        "creationDate": creationDate,
        "startDate": startDate,
        "pickupDate": pickupDate,
        "deliveryDate": deliveryDate,
        "slot": slot.toJson(),
        "tripKm": tripKm,
        "rideStartTime": rideStartTime,
        "pickupTime": pickupTime,
        "rideEndTime": rideEndTime,
        "pickupDetails": pickupDetails.toJson(),
        "destinationDetails": destinationDetails.toJson(),
        "pickupAddress": pickupAddress.toJson(),
        "destinationAddress": destinationAddress.toJson(),
        "customerImages": List<dynamic>.from(customerImages.map((x) => x)),
        "notes": notes,
        "registeredMotorbike": registeredMotorbike,
        "insuredMotorbike": insuredMotorbike,
        "tripTime": tripTime,
        "workingMotorbike": workingMotorbike,
        "damagedMotorbike": damagedMotorbike,
        "cancelTime": cancelTime,
        "bookingStatus": bookingStatus,
        "vehicleId": vehicleId,
      };
}

class Address {
  Address({
    this.originalAddress,
    this.addressLine2,
    this.landmark,
    this.city,
    this.pincode,
    this.long,
    this.lat,
    this.authorName,
    this.authorMobileNumber,
  });

  String? originalAddress;
  String? addressLine2;
  String? landmark;
  String? city;
  String? pincode;
  String? long;
  String? lat;
  String? authorName;
  String? authorMobileNumber;

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

class Details {
  Details(
      {this.driverImages,
      this.driverVideos,
      this.notes,
      this.signature,
      this.authorName});

  List<String>? driverImages;
  List<String>? driverVideos;
  String? notes;
  String? signature;
  String? authorName;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        driverImages: List<String>.from(json["driverImages"].map((x) => x)),
        driverVideos: List<String>.from(json["driverVideos"].map((x) => x)),
        notes: json["notes"],
        signature: json["signature"],
        authorName: json["authorName"],
      );

  Map<String, dynamic> toJson() => {
        "driverImages": driverImages != null
            ? List<dynamic>.from(driverImages!.map((x) => x))
            : [],
        "driverVideos": driverVideos != null
            ? List<dynamic>.from(driverVideos!.map((x) => x))
            : [],
        "notes": notes,
        "signature": signature,
        "authorName": authorName,
      };
}

class SlotModel {
  SlotModel({
    this.startTime,
    this.endTime,
  });

  int? startTime;
  int? endTime;

  factory SlotModel.fromJson(Map<String, dynamic> json) => SlotModel(
        startTime: json["startTime"] == null ? null : json["startTime"],
        endTime: json["endTime"] == null ? null : json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime == null ? null : startTime,
        "endTime": endTime == null ? null : endTime,
      };
}

VehicleModel vehicleModelFromJson(String str) =>
    VehicleModel.fromJson(json.decode(str));

String vehicleModelToJson(VehicleModel data) => json.encode(data.toJson());

class VehicleModel {
  VehicleModel({
    this.make,
    this.model,
    this.plateNumber,
    this.customerId,
    this.color,
  });

  String? make;
  String? model;
  String? plateNumber;
  String? customerId;
  String? color;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        make: json["make"] == null ? null : json["make"],
        model: json["model"] == null ? null : json["model"],
        plateNumber: json["plateNumber"] == null ? null : json["plateNumber"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        color: json["color"] == null ? null : json["color"],
      );

  Map<String, dynamic> toJson() => {
        "make": make == null ? null : make,
        "model": model == null ? null : model,
        "plateNumber": plateNumber == null ? null : plateNumber,
        "customerId": customerId == null ? null : customerId,
        "color": color == null ? null : color,
      };
}

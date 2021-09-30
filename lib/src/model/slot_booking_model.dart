// To parse this JSON data, do
//
//     final slotBookingModel = slotBookingModelFromJson(jsonString);

import 'dart:convert';

SlotBookingModel slotBookingModelFromJson(String str) =>
    SlotBookingModel.fromJson(json.decode(str));

String slotBookingModelToJson(SlotBookingModel data) =>
    json.encode(data.toJson());

class SlotBookingModel {
  SlotBookingModel({
    required this.date,
    required this.notes,
    required this.registeredMotorbike,
    required this.insuredMotorbike,
    required this.workingMotorbike,
    required this.damagedMotorbike,
    required this.slot,
    required this.vehicleId,
  });

  String date;
  String notes;
  bool registeredMotorbike;
  bool insuredMotorbike;
  bool workingMotorbike;
  bool damagedMotorbike;
  Slot slot;
  String vehicleId;

  factory SlotBookingModel.fromJson(Map<String, dynamic> json) =>
      SlotBookingModel(
        date: json["date"],
        notes: json["notes"],
        registeredMotorbike: json["registeredMotorbike"],
        insuredMotorbike: json["insuredMotorbike"],
        workingMotorbike: json["workingMotorbike"],
        damagedMotorbike: json["damagedMotorbike"],
        slot: Slot.fromJson(json["slot"]),
        vehicleId: json["vehicleId"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "notes": notes,
        "registeredMotorbike": registeredMotorbike,
        "insuredMotorbike": insuredMotorbike,
        "workingMotorbike": workingMotorbike,
        "damagedMotorbike": damagedMotorbike,
        "slot": slot.toJson(),
        "vehicleId": vehicleId,
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

// To parse this JSON data, do
//
//     final slot = slotFromJson(jsonString);

import 'dart:convert';

List<Slot> slotFromJson(String str) =>
    List<Slot>.from(json.decode(str).map((x) => Slot.fromJson(x)));

String slotToJson(List<Slot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

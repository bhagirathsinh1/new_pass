// To parse this JSON data, do
//
//     final slotModel = slotModelFromJson(jsonString);

import 'dart:convert';

SlotModel slotModelFromJson(String str) => SlotModel.fromJson(json.decode(str));

String slotModelToJson(SlotModel data) => json.encode(data.toJson());

class SlotModel {
  SlotModel({
    this.slots,
    this.weekList,
    this.agenda,
  });

  List<Slot>? slots;
  List<WeekList>? weekList;
  List<Agenda>? agenda;

  factory SlotModel.fromJson(Map<String, dynamic> json) => SlotModel(
        slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
        weekList: List<WeekList>.from(
            json["weekList"].map((x) => WeekList.fromJson(x))),
        agenda:
            List<Agenda>.from(json["agenda"].map((x) => Agenda.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "slots": List<dynamic>.from(slots!.map((x) => x.toJson())),
        "weekList": List<dynamic>.from(weekList!.map((x) => x.toJson())),
        "agenda": List<dynamic>.from(agenda!.map((x) => x.toJson())),
      };
}

class Agenda {
  Agenda({
    this.id,
    this.startTime,
    this.endTime,
    this.v,
  });

  String? id;
  int? startTime;
  int? endTime;
  int? v;

  factory Agenda.fromJson(Map<String, dynamic> json) => Agenda(
        id: json["_id"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "startTime": startTime,
        "endTime": endTime,
        "__v": v,
      };
}

class Slot {
  Slot({
    this.date,
    this.timing,
    this.slotAvailable,
    this.isSelectedByYou,
    this.day,
  });

  String? date;
  Timing? timing;
  bool? slotAvailable;
  bool? isSelectedByYou;
  String? day;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        date: json["date"],
        timing: Timing.fromJson(json["timing"]),
        slotAvailable: json["slotAvailable"],
        isSelectedByYou: json["isSelectedByYou"],
        day: json["day"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "timing": timing!.toJson(),
        "slotAvailable": slotAvailable,
        "isSelectedByYou": isSelectedByYou,
        "day": day,
      };
}

class Timing {
  Timing({
    this.startTime,
    this.endTime,
  });

  int? startTime;
  int? endTime;

  factory Timing.fromJson(Map<String, dynamic> json) => Timing(
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
      };
}

class WeekList {
  WeekList({
    this.date,
    this.day,
  });

  String? date;
  String? day;

  factory WeekList.fromJson(Map<String, dynamic> json) => WeekList(
        date: json["date"],
        day: json["day"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "day": day,
      };
}

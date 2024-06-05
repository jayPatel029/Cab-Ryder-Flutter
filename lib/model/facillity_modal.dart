// To parse this JSON data, do
//
//     final facilitylistModal = facilitylistModalFromJson(jsonString);

import 'dart:convert';

FacilitylistModal facilitylistModalFromJson(String str) => FacilitylistModal.fromJson(json.decode(str));

String facilitylistModalToJson(FacilitylistModal data) => json.encode(data.toJson());

class FacilitylistModal {
  List<Facilitylist> facilitylist;
  String responseCode;
  String result;
  String responseMsg;

  FacilitylistModal({
    required this.facilitylist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory FacilitylistModal.fromJson(Map<String, dynamic> json) => FacilitylistModal(
    facilitylist: List<Facilitylist>.from(json["facilitylist"].map((x) => Facilitylist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "facilitylist": List<dynamic>.from(facilitylist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Facilitylist {
  String id;
  String title;
  String img;

  Facilitylist({
    required this.id,
    required this.title,
    required this.img,
  });

  factory Facilitylist.fromJson(Map<String, dynamic> json) => Facilitylist(
    id: json["id"],
    title: json["title"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
  };
}

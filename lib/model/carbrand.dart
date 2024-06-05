// To parse this JSON data, do
//
//     final carBrand = carBrandFromJson(jsonString);

import 'dart:convert';

CarBrand carBrandFromJson(String str) => CarBrand.fromJson(json.decode(str));

String carBrandToJson(CarBrand data) => json.encode(data.toJson());

class CarBrand {
  List<Carbrandlist> carbrandlist;
  String responseCode;
  String result;
  String responseMsg;

  CarBrand({
    required this.carbrandlist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) => CarBrand(
    carbrandlist: List<Carbrandlist>.from(json["carbrandlist"].map((x) => Carbrandlist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "carbrandlist": List<dynamic>.from(carbrandlist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Carbrandlist {
  String id;
  String title;
  String img;

  Carbrandlist({
    required this.id,
    required this.title,
    required this.img,
  });

  factory Carbrandlist.fromJson(Map<String, dynamic> json) => Carbrandlist(
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

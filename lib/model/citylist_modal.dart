// To parse this JSON data, do
//
//     final cityList = cityListFromJson(jsonString);

import 'dart:convert';

CityList cityListFromJson(String str) => CityList.fromJson(json.decode(str));

String cityListToJson(CityList data) => json.encode(data.toJson());

class CityList {
  List<Citylist> citylist;
  String responseCode;
  String result;
  String responseMsg;

  CityList({
    required this.citylist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CityList.fromJson(Map<String, dynamic> json) => CityList(
    citylist: List<Citylist>.from(json["citylist"].map((x) => Citylist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "citylist": List<dynamic>.from(citylist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Citylist {
  String id;
  String title;

  Citylist({
    required this.id,
    required this.title,
  });

  factory Citylist.fromJson(Map<String, dynamic> json) => Citylist(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

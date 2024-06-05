// To parse this JSON data, do
//
//     final carType = carTypeFromJson(jsonString);

import 'dart:convert';

CarType carTypeFromJson(String str) => CarType.fromJson(json.decode(str));

String carTypeToJson(CarType data) => json.encode(data.toJson());

class CarType {
  List<Cartypelist> cartypelist;
  String responseCode;
  String result;
  String responseMsg;

  CarType({
    required this.cartypelist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CarType.fromJson(Map<String, dynamic> json) => CarType(
    cartypelist: List<Cartypelist>.from(json["cartypelist"].map((x) => Cartypelist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "cartypelist": List<dynamic>.from(cartypelist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Cartypelist {
  String id;
  String title;
  String img;

  Cartypelist({
    required this.id,
    required this.title,
    required this.img,
  });

  factory Cartypelist.fromJson(Map<String, dynamic> json) => Cartypelist(
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

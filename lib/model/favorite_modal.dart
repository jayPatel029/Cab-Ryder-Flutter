// To parse this JSON data, do
//
//     final favoriteModal = favoriteModalFromJson(jsonString);

import 'dart:convert';

FavoriteModal favoriteModalFromJson(String str) => FavoriteModal.fromJson(json.decode(str));

String favoriteModalToJson(FavoriteModal data) => json.encode(data.toJson());

class FavoriteModal {
  String responseCode;
  String result;
  String responseMsg;
  List<FeatureCar> featureCar;

  FavoriteModal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.featureCar,
  });

  factory FavoriteModal.fromJson(Map<String, dynamic> json) => FavoriteModal(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    featureCar: List<FeatureCar>.from(json["FeatureCar"].map((x) => FeatureCar.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "FeatureCar": List<dynamic>.from(featureCar.map((x) => x.toJson())),
  };
}

class FeatureCar {
  String id;
  String carTitle;
  String carImg;
  String carRating;
  String carNumber;
  String totalSeat;
  String carGear;
  String priceType;
  String engineHp;
  String fuelType;
  String carDistance;

  FeatureCar({
    required this.id,
    required this.carTitle,
    required this.carImg,
    required this.carRating,
    required this.carNumber,
    required this.totalSeat,
    required this.carGear,
    required this.priceType,
    required this.engineHp,
    required this.fuelType,
    required this.carDistance,
  });

  factory FeatureCar.fromJson(Map<String, dynamic> json) => FeatureCar(
    id: json["id"],
    carTitle: json["car_title"],
    carImg: json["car_img"],
    carRating: json["car_rating"],
    carNumber: json["car_number"],
    totalSeat: json["total_seat"],
    carGear: json["car_gear"],
    priceType: json["price_type"],
    engineHp: json["engine_hp"],
    fuelType: json["fuel_type"],
    carDistance: json["car_distance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "car_title": carTitle,
    "car_img": carImg,
    "car_rating": carRating,
    "car_number": carNumber,
    "total_seat": totalSeat,
    "car_gear": carGear,
    "price_type": priceType,
    "engine_hp": engineHp,
    "fuel_type": fuelType,
    "car_distance": carDistance,
  };
}

// To parse this JSON data, do
//
//     final exploreModal = exploreModalFromJson(jsonString);

import 'dart:convert';

ExploreModal exploreModalFromJson(String str) => ExploreModal.fromJson(json.decode(str));

String exploreModalToJson(ExploreModal data) => json.encode(data.toJson());

class ExploreModal {
  String responseCode;
  String result;
  String responseMsg;
  List<FeatureCar> featureCar;

  ExploreModal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.featureCar,
  });

  factory ExploreModal.fromJson(Map<String, dynamic> json) => ExploreModal(
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
  String pickLat;
  String pickLng;
  String engineHp;
  String fuelType;
  String pickAddress;
  String carDistance;

  FeatureCar({
    required this.id,
    required this.carTitle,
    required this.carImg,
    required this.carRating,
    required this.carNumber,
    required this.totalSeat,
    required this.carGear,
    required this.pickLat,
    required this.pickLng,
    required this.engineHp,
    required this.fuelType,
    required this.pickAddress,
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
    pickLat: json["pick_lat"],
    pickLng: json["pick_lng"],
    engineHp: json["engine_hp"],
    fuelType: json["fuel_type"],
    pickAddress: json["pick_address"],
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
    "pick_lat": pickLat,
    "pick_lng": pickLng,
    "engine_hp": engineHp,
    "fuel_type": fuelType,
    "pick_address": pickAddress,
    "car_distance": carDistance,
  };
}

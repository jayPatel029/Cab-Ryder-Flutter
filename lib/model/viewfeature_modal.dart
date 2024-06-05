// To parse this JSON data, do
//
//     final viewFeatureModal = viewFeatureModalFromJson(jsonString);

import 'dart:convert';

ViewFeatureModal viewFeatureModalFromJson(String str) => ViewFeatureModal.fromJson(json.decode(str));

String viewFeatureModalToJson(ViewFeatureModal data) => json.encode(data.toJson());

class ViewFeatureModal {
  String responseCode;
  String result;
  String responseMsg;
  String isBlock;
  String tax;
  String currency;
  List<FeatureCar> featureCar;

  ViewFeatureModal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.isBlock,
    required this.tax,
    required this.currency,
    required this.featureCar,
  });

  factory ViewFeatureModal.fromJson(Map<String, dynamic> json) => ViewFeatureModal(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    isBlock: json["is_block"],
    tax: json["tax"],
    currency: json["currency"],
    featureCar: List<FeatureCar>.from(json["FeatureCar"].map((x) => FeatureCar.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "is_block": isBlock,
    "tax": tax,
    "currency": currency,
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
  String carRentPrice;
  String priceType;
  String engineHp;
  String fuelType;
  String carTypeTitle;
  String carDistance;

  FeatureCar({
    required this.id,
    required this.carTitle,
    required this.carImg,
    required this.carRating,
    required this.carNumber,
    required this.totalSeat,
    required this.carGear,
    required this.carRentPrice,
    required this.priceType,
    required this.engineHp,
    required this.fuelType,
    required this.carTypeTitle,
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
    carRentPrice: json["car_rent_price"],
    priceType: json["price_type"],
    engineHp: json["engine_hp"],
    fuelType: json["fuel_type"],
    carTypeTitle: json["car_type_title"],
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
    "car_rent_price": carRentPrice,
    "price_type": priceType,
    "engine_hp": engineHp,
    "fuel_type": fuelType,
    "car_type_title": carTypeTitle,
    "car_distance": carDistance,
  };
}

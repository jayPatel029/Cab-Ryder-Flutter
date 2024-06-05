// To parse this JSON data, do
//
//     final myCarListModal = myCarListModalFromJson(jsonString);

import 'dart:convert';

MyCarListModal myCarListModalFromJson(String str) => MyCarListModal.fromJson(json.decode(str));

String myCarListModalToJson(MyCarListModal data) => json.encode(data.toJson());

class MyCarListModal {
  String responseCode;
  String result;
  String responseMsg;
  List<Mycarlist> mycarlist;

  MyCarListModal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.mycarlist,
  });

  factory MyCarListModal.fromJson(Map<String, dynamic> json) => MyCarListModal(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    mycarlist: List<Mycarlist>.from(json["mycarlist"].map((x) => Mycarlist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "mycarlist": List<dynamic>.from(mycarlist.map((x) => x.toJson())),
  };
}

class Mycarlist {
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
  String carStatus;
  String carAc;
  String driverName;
  String driverMobile;
  String carFacility;
  String carType;
  String carBrand;
  String minHrs;
  String carAvailable;
  String carRentPrice;
  String carRentPriceDriver;
  String priceType;
  String carDesc;
  String totalKm;
  int totalGallery;

  Mycarlist({
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
    required this.carStatus,
    required this.carAc,
    required this.driverName,
    required this.driverMobile,
    required this.carFacility,
    required this.carType,
    required this.carBrand,
    required this.minHrs,
    required this.carAvailable,
    required this.carRentPrice,
    required this.carRentPriceDriver,
    required this.priceType,
    required this.carDesc,
    required this.totalKm,
    required this.totalGallery,
  });

  factory Mycarlist.fromJson(Map<String, dynamic> json) => Mycarlist(
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
    carStatus: json["car_status"],
    carAc: json["car_ac"],
    driverName: json["driver_name"],
    driverMobile: json["driver_mobile"],
    carFacility: json["car_facility"],
    carType: json["car_type"],
    carBrand: json["car_brand"],
    minHrs: json["min_hrs"],
    carAvailable: json["car_available"],
    carRentPrice: json["car_rent_price"],
    carRentPriceDriver: json["car_rent_price_driver"],
    priceType: json["price_type"],
    carDesc: json["car_desc"],
    totalKm: json["total_km"],
    totalGallery: json["total_gallery"],
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
    "car_status": carStatus,
    "car_ac": carAc,
    "driver_name": driverName,
    "driver_mobile": driverMobile,
    "car_facility": carFacility,
    "car_type": carType,
    "car_brand": carBrand,
    "min_hrs": minHrs,
    "car_available": carAvailable,
    "car_rent_price": carRentPrice,
    "car_rent_price_driver": carRentPriceDriver,
    "price_type": priceType,
    "car_desc": carDesc,
    "total_km": totalKm,
    "total_gallery": totalGallery,
  };
}

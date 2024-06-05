// To parse this JSON data, do
//
//     final carInfo = carInfoFromJson(jsonString);

import 'dart:convert';

CarInfo carInfoFromJson(String str) => CarInfo.fromJson(json.decode(str));

String carInfoToJson(CarInfo data) => json.encode(data.toJson());

class CarInfo {
  Carinfo carinfo;
  List<String> galleryImages;
  String responseCode;
  String result;
  String responseMsg;

  CarInfo({
    required this.carinfo,
    required this.galleryImages,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CarInfo.fromJson(Map<String, dynamic> json) => CarInfo(
    carinfo: Carinfo.fromJson(json["carinfo"]),
    galleryImages: List<String>.from(json["Gallery_images"].map((x) => x)),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "carinfo": carinfo.toJson(),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Carinfo {
  String id;
  String typeId;
  String cityId;
  String brandId;
  String minHrs;
  String carTitle;
  List<String> carImg;
  String carRating;
  String carNumber;
  String totalSeat;
  String carGear;
  String totalKm;
  String pickLat;
  String pickLng;
  String pickAddress;
  String carDesc;
  String fuelType;
  String priceType;
  String engineHp;
  String carFacility;
  String facilityImg;
  String carTypeTitle;
  String carTypeImg;
  String carBrandTitle;
  String carBrandImg;
  String carRentPrice;
  String carRentPriceDriver;
  String carAc;
  int isFavorite;

  Carinfo({
    required this.id,
    required this.typeId,
    required this.cityId,
    required this.brandId,
    required this.minHrs,
    required this.carTitle,
    required this.carImg,
    required this.carRating,
    required this.carNumber,
    required this.totalSeat,
    required this.carGear,
    required this.totalKm,
    required this.pickLat,
    required this.pickLng,
    required this.pickAddress,
    required this.carDesc,
    required this.fuelType,
    required this.priceType,
    required this.engineHp,
    required this.carFacility,
    required this.facilityImg,
    required this.carTypeTitle,
    required this.carTypeImg,
    required this.carBrandTitle,
    required this.carBrandImg,
    required this.carRentPrice,
    required this.carRentPriceDriver,
    required this.carAc,
    required this.isFavorite,
  });

  factory Carinfo.fromJson(Map<String, dynamic> json) => Carinfo(
    id: json["id"],
    typeId: json["type_id"],
    cityId: json["city_id"],
    brandId: json["brand_id"],
    minHrs: json["min_hrs"],
    carTitle: json["car_title"],
    carImg: List<String>.from(json["car_img"].map((x) => x)),
    carRating: json["car_rating"],
    carNumber: json["car_number"],
    totalSeat: json["total_seat"],
    carGear: json["car_gear"],
    totalKm: json["total_km"],
    pickLat: json["pick_lat"],
    pickLng: json["pick_lng"],
    pickAddress: json["pick_address"],
    carDesc: json["car_desc"],
    fuelType: json["fuel_type"],
    priceType: json["price_type"],
    engineHp: json["engine_hp"],
    carFacility: json["car_facility"],
    facilityImg: json["facility_img"],
    carTypeTitle: json["car_type_title"],
    carTypeImg: json["car_type_img"],
    carBrandTitle: json["car_brand_title"],
    carBrandImg: json["car_brand_img"],
    carRentPrice: json["car_rent_price"],
    carRentPriceDriver: json["car_rent_price_driver"],
    carAc: json["car_ac"],
    isFavorite: json["IS_FAVOURITE"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type_id": typeId,
    "city_id": cityId,
    "brand_id": brandId,
    "min_hrs": minHrs,
    "car_title": carTitle,
    "car_img": List<dynamic>.from(carImg.map((x) => x)),
    "car_rating": carRating,
    "car_number": carNumber,
    "total_seat": totalSeat,
    "car_gear": carGear,
    "total_km": totalKm,
    "pick_lat": pickLat,
    "pick_lng": pickLng,
    "pick_address": pickAddress,
    "car_desc": carDesc,
    "fuel_type": fuelType,
    "price_type": priceType,
    "engine_hp": engineHp,
    "car_facility": carFacility,
    "facility_img": facilityImg,
    "car_type_title": carTypeTitle,
    "car_type_img": carTypeImg,
    "car_brand_title": carBrandTitle,
    "car_brand_img": carBrandImg,
    "car_rent_price": carRentPrice,
    "car_rent_price_driver": carRentPriceDriver,
    "car_ac": carAc,
    'IS_FAVOURITE': isFavorite,
  };
}

// To parse this JSON data, do
//
//     final homeBanner = homeBannerFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

HomeBanner homeBannerFromJson(String str) => HomeBanner.fromJson(json.decode(str));

String homeBannerToJson(HomeBanner data) => json.encode(data.toJson());

class HomeBanner {
  String responseCode;
  String result;
  String responseMsg;
  List<Banner> banner;
  String isBlock;
  String tax;
  String currency;
  List<Carlist> cartypelist;
  List<Carlist> carbrandlist;
  List<FeatureCar> featureCar;
  List<RecommendCar> recommendCar;
  String showAddCar;

  HomeBanner({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.banner,
    required this.isBlock,
    required this.tax,
    required this.currency,
    required this.cartypelist,
    required this.carbrandlist,
    required this.featureCar,
    required this.recommendCar,
    required this.showAddCar,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) => HomeBanner(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    banner: List<Banner>.from(json["banner"].map((x) => Banner.fromJson(x))),
    isBlock: json["is_block"],
    tax: json["tax"],
    currency: json["currency"],
    cartypelist: List<Carlist>.from(json["cartypelist"].map((x) => Carlist.fromJson(x))),
    carbrandlist: List<Carlist>.from(json["carbrandlist"].map((x) => Carlist.fromJson(x))),
    featureCar: List<FeatureCar>.from(json["FeatureCar"].map((x) => FeatureCar.fromJson(x))),
    recommendCar: List<RecommendCar>.from(json["Recommend_car"].map((x) => RecommendCar.fromJson(x))),
    showAddCar: json["show_add_car"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
    "is_block": isBlock,
    "tax": tax,
    "currency": currency,
    "cartypelist": List<dynamic>.from(cartypelist.map((x) => x.toJson())),
    "carbrandlist": List<dynamic>.from(carbrandlist.map((x) => x.toJson())),
    "FeatureCar": List<dynamic>.from(featureCar.map((x) => x.toJson())),
    "Recommend_car": List<dynamic>.from(recommendCar.map((x) => x.toJson())),
    "show_add_car": showAddCar,
  };
}

class Banner {
  String id;
  String img;

  Banner({
    required this.id,
    required this.img,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img": img,
  };
}

class Carlist {
  String id;
  String title;
  String img;

  Carlist({
    required this.id,
    required this.title,
    required this.img,
  });

  factory Carlist.fromJson(Map<String, dynamic> json) => Carlist(
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

class RecommendCar {
  String id;
  String carTitle;
  List<String> carImg;
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

  RecommendCar({
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

  factory RecommendCar.fromJson(Map<String, dynamic> json) => RecommendCar(
    id: json["id"],
    carTitle: json["car_title"],
    carImg: List<String>.from(json["car_img"].map((x) => x)),
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
    "car_img": List<dynamic>.from(carImg.map((x) => x)),
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

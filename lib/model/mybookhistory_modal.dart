// To parse this JSON data, do
//
//     final myBookingHistoryModal = myBookingHistoryModalFromJson(jsonString);

import 'dart:convert';

MyBookingHistoryModal myBookingHistoryModalFromJson(String str) => MyBookingHistoryModal.fromJson(json.decode(str));

String myBookingHistoryModalToJson(MyBookingHistoryModal data) => json.encode(data.toJson());

class MyBookingHistoryModal {
  List<BookHistory> bookHistory;
  String responseCode;
  String result;
  String responseMsg;

  MyBookingHistoryModal({
    required this.bookHistory,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory MyBookingHistoryModal.fromJson(Map<String, dynamic> json) => MyBookingHistoryModal(
    bookHistory: List<BookHistory>.from(json["book_history"].map((x) => BookHistory.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "book_history": List<dynamic>.from(bookHistory.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class BookHistory {
  String bookId;
  String carTitle;
  String carNumber;
  String carImg;
  String totalDayOrHr;
  String cityTitle;
  String carRating;
  String priceType;
  String carPrice;
  String engineHp;
  String fuelType;
  String totalSeat;
  String carGear;
  String oTotal;
  String wallAmt;
  String couAmt;
  DateTime pickupDate;
  String pickupTime;
  DateTime returnDate;
  String returnTime;

  BookHistory({
    required this.bookId,
    required this.carTitle,
    required this.carNumber,
    required this.carImg,
    required this.totalDayOrHr,
    required this.cityTitle,
    required this.carRating,
    required this.priceType,
    required this.carPrice,
    required this.engineHp,
    required this.fuelType,
    required this.totalSeat,
    required this.carGear,
    required this.oTotal,
    required this.wallAmt,
    required this.couAmt,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
  });

  factory BookHistory.fromJson(Map<String, dynamic> json) => BookHistory(
    bookId: json["book_id"],
    carTitle: json["car_title"],
    carNumber: json["car_number"],
    carImg: json["car_img"],
    totalDayOrHr: json["total_day_or_hr"],
    cityTitle: json["city_title"],
    carRating: json["car_rating"],
    priceType: json["price_type"],
    carPrice: json["car_price"],
    engineHp: json["engine_hp"],
    fuelType: json["fuel_type"],
    totalSeat: json["total_seat"],
    carGear: json["car_gear"],
    oTotal: json["o_total"],
    wallAmt: json["wall_amt"],
    couAmt: json["cou_amt"],
    pickupDate: DateTime.parse(json["pickup_date"]),
    pickupTime: json["pickup_time"],
    returnDate: DateTime.parse(json["return_date"]),
    returnTime: json["return_time"],
  );

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "car_title": carTitle,
    "car_number": carNumber,
    "car_img": carImg,
    "total_day_or_hr": totalDayOrHr,
    "city_title": cityTitle,
    "car_rating": carRating,
    "price_type": priceType,
    "car_price": carPrice,
    "engine_hp": engineHp,
    "fuel_type": fuelType,
    "total_seat": totalSeat,
    "car_gear": carGear,
    "o_total": oTotal,
    "wall_amt": wallAmt,
    "cou_amt": couAmt,
    "pickup_date": "${pickupDate.year.toString().padLeft(4, '0')}-${pickupDate.month.toString().padLeft(2, '0')}-${pickupDate.day.toString().padLeft(2, '0')}",
    "pickup_time": pickupTime,
    "return_date": "${returnDate.year.toString().padLeft(4, '0')}-${returnDate.month.toString().padLeft(2, '0')}-${returnDate.day.toString().padLeft(2, '0')}",
    "return_time": returnTime,
  };
}

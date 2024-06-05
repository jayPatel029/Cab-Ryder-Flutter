// To parse this JSON data, do
//
//     final myBookDetailModal = myBookDetailModalFromJson(jsonString);

import 'dart:convert';

MyBookDetailModal myBookDetailModalFromJson(String str) => MyBookDetailModal.fromJson(json.decode(str));

String myBookDetailModalToJson(MyBookDetailModal data) => json.encode(data.toJson());

class MyBookDetailModal {
  List<BookDetail> bookDetails;
  String responseCode;
  String result;
  String responseMsg;

  MyBookDetailModal({
    required this.bookDetails,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory MyBookDetailModal.fromJson(Map<String, dynamic> json) => MyBookDetailModal(
    bookDetails: List<BookDetail>.from(json["book_details"].map((x) => BookDetail.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "book_details": List<dynamic>.from(bookDetails.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class BookDetail {
  String bookId;
  String carTitle;
  String carNumber;
  String carImg;
  String pickLat;
  String pickLng;
  String pickAddress;
  String cityTitle;
  String carRating;
  String priceType;
  String carPrice;
  DateTime pickupDate;
  String pickupTime;
  DateTime returnDate;
  String returnTime;
  String couAmt;
  String customerName;
  String customerContact;
  String customerImg;
  String bookType;
  String wallAmt;
  String totalDayOrHr;
  String taxAmt;
  String taxPer;
  String engineHp;
  String fuelType;
  String totalSeat;
  String carGear;
  dynamic cancleReason;
  String isRate;
  String subtotal;
  String oTotal;
  String pickOtp;
  String dropOtp;
  String paymentMethodName;
  String transactionId;
  String bookStatus;
  List<dynamic> exterPhoto;
  List<dynamic> interPhoto;

  BookDetail({
    required this.bookId,
    required this.carTitle,
    required this.carNumber,
    required this.carImg,
    required this.pickLat,
    required this.pickLng,
    required this.pickAddress,
    required this.cityTitle,
    required this.carRating,
    required this.priceType,
    required this.carPrice,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
    required this.couAmt,
    required this.customerName,
    required this.customerContact,
    required this.customerImg,
    required this.bookType,
    required this.wallAmt,
    required this.totalDayOrHr,
    required this.taxAmt,
    required this.taxPer,
    required this.engineHp,
    required this.fuelType,
    required this.totalSeat,
    required this.carGear,
    required this.cancleReason,
    required this.isRate,
    required this.subtotal,
    required this.oTotal,
    required this.pickOtp,
    required this.dropOtp,
    required this.paymentMethodName,
    required this.transactionId,
    required this.bookStatus,
    required this.exterPhoto,
    required this.interPhoto,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
    bookId: json["book_id"],
    carTitle: json["car_title"],
    carNumber: json["car_number"],
    carImg: json["car_img"],
    pickLat: json["pick_lat"],
    pickLng: json["pick_lng"],
    pickAddress: json["pick_address"],
    cityTitle: json["city_title"],
    carRating: json["car_rating"],
    priceType: json["price_type"],
    carPrice: json["car_price"],
    pickupDate: DateTime.parse(json["pickup_date"]),
    pickupTime: json["pickup_time"],
    returnDate: DateTime.parse(json["return_date"]),
    returnTime: json["return_time"],
    couAmt: json["cou_amt"],
    customerName: json['customer_name'],
    customerContact: json['customer_contact'],
    customerImg: json['customer_img'] ?? '',
    bookType: json["book_type"],
    wallAmt: json["wall_amt"],
    totalDayOrHr: json["total_day_or_hr"],
    taxAmt: json["tax_amt"],
    taxPer: json["tax_per"],
    engineHp: json["engine_hp"],
    fuelType: json["fuel_type"],
    totalSeat: json["total_seat"],
    carGear: json["car_gear"],
    cancleReason: json["cancle_reason"],
    isRate: json["is_rate"],
    subtotal: json["subtotal"],
    oTotal: json["o_total"],
    pickOtp: json["pick_otp"],
    dropOtp: json["drop_otp"],
    paymentMethodName: json["Payment_method_name"],
    transactionId: json["transaction_id"],
    bookStatus: json["book_status"],
    exterPhoto: List<dynamic>.from(json["exter_photo"].map((x) => x)),
    interPhoto: List<dynamic>.from(json["inter_photo"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "car_title": carTitle,
    "car_number": carNumber,
    "car_img": carImg,
    "pick_lat": pickLat,
    "pick_lng": pickLng,
    "pick_address": pickAddress,
    "city_title": cityTitle,
    "car_rating": carRating,
    "price_type": priceType,
    "car_price": carPrice,
    "pickup_date": "${pickupDate.year.toString().padLeft(4, '0')}-${pickupDate.month.toString().padLeft(2, '0')}-${pickupDate.day.toString().padLeft(2, '0')}",
    "pickup_time": pickupTime,
    "return_date": "${returnDate.year.toString().padLeft(4, '0')}-${returnDate.month.toString().padLeft(2, '0')}-${returnDate.day.toString().padLeft(2, '0')}",
    "return_time": returnTime,
    "cou_amt": couAmt,
    "customer_name": customerName,
    "customer_contact": customerContact,
    "customer_img": customerImg,
    "book_type": bookType,
    "wall_amt": wallAmt,
    "total_day_or_hr": totalDayOrHr,
    "tax_amt": taxAmt,
    "tax_per": taxPer,
    "engine_hp": engineHp,
    "fuel_type": fuelType,
    "total_seat": totalSeat,
    "car_gear": carGear,
    "cancle_reason": cancleReason,
    "is_rate": isRate,
    "subtotal": subtotal,
    "o_total": oTotal,
    "pick_otp": pickOtp,
    "drop_otp": dropOtp,
    "Payment_method_name": paymentMethodName,
    "transaction_id": transactionId,
    "book_status": bookStatus,
    "exter_photo": List<dynamic>.from(exterPhoto.map((x) => x)),
    "inter_photo": List<dynamic>.from(interPhoto.map((x) => x)),
  };
}

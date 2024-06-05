// To parse this JSON data, do
//
//     final couponlist = couponlistFromJson(jsonString);

import 'dart:convert';

Couponlist couponlistFromJson(String str) => Couponlist.fromJson(json.decode(str));

String couponlistToJson(Couponlist data) => json.encode(data.toJson());

class Couponlist {
  List<CouponlistElement> couponlist;
  String responseCode;
  String result;
  String responseMsg;

  Couponlist({
    required this.couponlist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory Couponlist.fromJson(Map<String, dynamic> json) => Couponlist(
    couponlist: List<CouponlistElement>.from(json["couponlist"].map((x) => CouponlistElement.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "couponlist": List<dynamic>.from(couponlist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class CouponlistElement {
  String id;
  String couponImg;
  DateTime expireDate;
  String cDesc;
  String couponVal;
  String couponCode;
  String couponTitle;
  String couponSubtitle;
  String minAmt;

  CouponlistElement({
    required this.id,
    required this.couponImg,
    required this.expireDate,
    required this.cDesc,
    required this.couponVal,
    required this.couponCode,
    required this.couponTitle,
    required this.couponSubtitle,
    required this.minAmt,
  });

  factory CouponlistElement.fromJson(Map<String, dynamic> json) => CouponlistElement(
    id: json["id"],
    couponImg: json["coupon_img"],
    expireDate: DateTime.parse(json["expire_date"]),
    cDesc: json["c_desc"],
    couponVal: json["coupon_val"],
    couponCode: json["coupon_code"],
    couponTitle: json["coupon_title"],
    couponSubtitle: json["coupon_subtitle"],
    minAmt: json["min_amt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "coupon_img": couponImg,
    "expire_date": "${expireDate.year.toString().padLeft(4, '0')}-${expireDate.month.toString().padLeft(2, '0')}-${expireDate.day.toString().padLeft(2, '0')}",
    "c_desc": cDesc,
    "coupon_val": couponVal,
    "coupon_code": couponCode,
    "coupon_title": couponTitle,
    "coupon_subtitle": couponSubtitle,
    "min_amt": minAmt,
  };
}

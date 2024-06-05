// To parse this JSON data, do
//
//     final couponCheck = couponCheckFromJson(jsonString);

import 'dart:convert';

CouponCheck couponCheckFromJson(String str) => CouponCheck.fromJson(json.decode(str));

String couponCheckToJson(CouponCheck data) => json.encode(data.toJson());

class CouponCheck {
  String responseCode;
  String result;
  String responseMsg;

  CouponCheck({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CouponCheck.fromJson(Map<String, dynamic> json) => CouponCheck(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

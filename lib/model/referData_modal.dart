// To parse this JSON data, do
//
//     final referData = referDataFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ReferData referDataFromJson(String str) => ReferData.fromJson(json.decode(str));

String referDataToJson(ReferData data) => json.encode(data.toJson());

class ReferData {
  String responseCode;
  String result;
  String responseMsg;
  String code;
  String signupcredit;
  String refercredit;

  ReferData({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.code,
    required this.signupcredit,
    required this.refercredit,
  });

  factory ReferData.fromJson(Map<String, dynamic> json) => ReferData(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    code: json["code"],
    signupcredit: json["signupcredit"],
    refercredit: json["refercredit"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "code": code,
    "signupcredit": signupcredit,
    "refercredit": refercredit,
  };
}

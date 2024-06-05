// To parse this JSON data, do
//
//     final reviewModal = reviewModalFromJson(jsonString);

import 'dart:convert';

ReviewModal reviewModalFromJson(String str) => ReviewModal.fromJson(json.decode(str));

String reviewModalToJson(ReviewModal data) => json.encode(data.toJson());

class ReviewModal {
  String responseCode;
  String result;
  String responseMsg;
  List<Reviewdatum> reviewdata;

  ReviewModal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.reviewdata,
  });

  factory ReviewModal.fromJson(Map<String, dynamic> json) => ReviewModal(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    reviewdata: List<Reviewdatum>.from(json["reviewdata"].map((x) => Reviewdatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "reviewdata": List<dynamic>.from(reviewdata.map((x) => x.toJson())),
  };
}

class Reviewdatum {
  String userImg;
  String userTitle;
  String userRate;
  DateTime reviewDate;
  String userDesc;

  Reviewdatum({
    required this.userImg,
    required this.userTitle,
    required this.userRate,
    required this.reviewDate,
    required this.userDesc,
  });

  factory Reviewdatum.fromJson(Map<String, dynamic> json) => Reviewdatum(
    userImg: json["user_img"],
    userTitle: json["user_title"],
    userRate: json["user_rate"],
    reviewDate: DateTime.parse(json["review_date"]),
    userDesc: json["user_desc"],
  );

  Map<String, dynamic> toJson() => {
    "user_img": userImg,
    "user_title": userTitle,
    "user_rate": userRate,
    "review_date": "${reviewDate.year.toString().padLeft(4, '0')}-${reviewDate.month.toString().padLeft(2, '0')}-${reviewDate.day.toString().padLeft(2, '0')}",
    "user_desc": userDesc,
  };
}

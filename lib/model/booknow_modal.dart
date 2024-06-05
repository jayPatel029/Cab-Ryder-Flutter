// To parse this JSON data, do
//
//     final bookNowModal = bookNowModalFromJson(jsonString);

import 'dart:convert';

BookNowModal bookNowModalFromJson(String str) => BookNowModal.fromJson(json.decode(str));

String bookNowModalToJson(BookNowModal data) => json.encode(data.toJson());

class BookNowModal {
  String responseCode;
  String result;
  String responseMsg;

  BookNowModal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory BookNowModal.fromJson(Map<String, dynamic> json) => BookNowModal(
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

// To parse this JSON data, do
//
//     final walletUpModal = walletUpModalFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

WalletUpModal walletUpModalFromJson(String str) => WalletUpModal.fromJson(json.decode(str));

String walletUpModalToJson(WalletUpModal data) => json.encode(data.toJson());

class WalletUpModal {
  String wallet;
  String responseCode;
  String result;
  String responseMsg;

  WalletUpModal({
    required this.wallet,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory WalletUpModal.fromJson(Map<String, dynamic> json) => WalletUpModal(
    wallet: json["wallet"],
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "wallet": wallet,
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

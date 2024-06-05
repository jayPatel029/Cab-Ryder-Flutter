// To parse this JSON data, do
//
//     final walletReport = walletReportFromJson(jsonString);

import 'dart:convert';

WalletReport walletReportFromJson(String str) => WalletReport.fromJson(json.decode(str));

String walletReportToJson(WalletReport data) => json.encode(data.toJson());

class WalletReport {
  List<Walletitem> walletitem;
  String wallet;
  String responseCode;
  String result;
  String responseMsg;

  WalletReport({
    required this.walletitem,
    required this.wallet,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory WalletReport.fromJson(Map<String, dynamic> json) => WalletReport(
    walletitem: List<Walletitem>.from(json["Walletitem"].map((x) => Walletitem.fromJson(x))),
    wallet: json["wallet"],
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "Walletitem": List<dynamic>.from(walletitem.map((x) => x.toJson())),
    "wallet": wallet,
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Walletitem {
  String message;
  String status;
  String amt;

  Walletitem({
    required this.message,
    required this.status,
    required this.amt,
  });

  factory Walletitem.fromJson(Map<String, dynamic> json) => Walletitem(
    message: json["message"],
    status: json["status"],
    amt: json["amt"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "amt": amt,
  };
}

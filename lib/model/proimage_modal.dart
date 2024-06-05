// To parse this JSON data, do
//
//     final proImageModal = proImageModalFromJson(jsonString);

import 'dart:convert';

ProImageModal proImageModalFromJson(String str) => ProImageModal.fromJson(json.decode(str));

String proImageModalToJson(ProImageModal data) => json.encode(data.toJson());

class ProImageModal {
  UserLogin userLogin;
  String responseCode;
  String result;
  String responseMsg;

  ProImageModal({
    required this.userLogin,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory ProImageModal.fromJson(Map<String, dynamic> json) => ProImageModal(
    userLogin: UserLogin.fromJson(json["UserLogin"]),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "UserLogin": userLogin.toJson(),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class UserLogin {
  String id;
  String name;
  String mobile;
  String password;
  DateTime rdate;
  String status;
  String ccode;
  String code;
  dynamic refercode;
  String wallet;
  String email;
  String profilePic;

  UserLogin({
    required this.id,
    required this.name,
    required this.mobile,
    required this.password,
    required this.rdate,
    required this.status,
    required this.ccode,
    required this.code,
    required this.refercode,
    required this.wallet,
    required this.email,
    required this.profilePic,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
    password: json["password"],
    rdate: DateTime.parse(json["rdate"]),
    status: json["status"],
    ccode: json["ccode"],
    code: json["code"],
    refercode: json["refercode"],
    wallet: json["wallet"],
    email: json["email"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "password": password,
    "rdate": rdate.toIso8601String(),
    "status": status,
    "ccode": ccode,
    "code": code,
    "refercode": refercode,
    "wallet": wallet,
    "email": email,
    "profile_pic": profilePic,
  };
}

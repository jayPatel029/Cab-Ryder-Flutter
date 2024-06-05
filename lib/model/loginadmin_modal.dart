// To parse this JSON data, do
//
//     final adminData = adminDataFromJson(jsonString);

import 'dart:convert';

AdminData adminDataFromJson(String str) => AdminData.fromJson(json.decode(str));

String adminDataToJson(AdminData data) => json.encode(data.toJson());

class AdminData {
  AdminLogin adminLogin;
  String responseCode;
  String result;
  String responseMsg;
  String type;

  AdminData({
    required this.adminLogin,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.type,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) => AdminData(
    adminLogin: AdminLogin.fromJson(json["AdminLogin"]),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "AdminLogin": adminLogin.toJson(),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "type": type,
  };
}

class AdminLogin {
  String id;
  String username;
  String password;
  String mobile;

  AdminLogin({
    required this.id,
    required this.username,
    required this.password,
    required this.mobile,
  });

  factory AdminLogin.fromJson(Map<String, dynamic> json) => AdminLogin(
    id: json["id"],
    username: json["username"],
    password: json["password"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
    "mobile": mobile,
  };
}

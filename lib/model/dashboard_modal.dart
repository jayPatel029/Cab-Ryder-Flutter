// To parse this JSON data, do
//
//     final dashboardModal = dashboardModalFromJson(jsonString);

import 'dart:convert';

DashboardModal dashboardModalFromJson(String str) => DashboardModal.fromJson(json.decode(str));

String dashboardModalToJson(DashboardModal data) => json.encode(data.toJson());

class DashboardModal {
  String responseCode;
  String result;
  String responseMsg;
  List<ReportDatum> reportData;
  String currency;

  DashboardModal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.reportData,
    required this.currency,
  });

  factory DashboardModal.fromJson(Map<String, dynamic> json) => DashboardModal(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    reportData: List<ReportDatum>.from(json["report_data"].map((x) => ReportDatum.fromJson(x))),
    currency: json["Currency"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "report_data": List<dynamic>.from(reportData.map((x) => x.toJson())),
    "Currency": currency,
  };
}

class ReportDatum {
  String title;
  dynamic reportData;
  String url;

  ReportDatum({
    required this.title,
    required this.reportData,
    required this.url,
  });

  factory ReportDatum.fromJson(Map<String, dynamic> json) => ReportDatum(
    title: json["title"],
    reportData: json["report_data"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "report_data": reportData,
    "url": url,
  };
}

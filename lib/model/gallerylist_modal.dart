// To parse this JSON data, do
//
//     final galleryListmodal = galleryListmodalFromJson(jsonString);

import 'dart:convert';

GalleryListmodal galleryListmodalFromJson(String str) => GalleryListmodal.fromJson(json.decode(str));

String galleryListmodalToJson(GalleryListmodal data) => json.encode(data.toJson());

class GalleryListmodal {
  String responseCode;
  String result;
  String responseMsg;
  List<Gallerylist> gallerylist;

  GalleryListmodal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.gallerylist,
  });

  factory GalleryListmodal.fromJson(Map<String, dynamic> json) => GalleryListmodal(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    gallerylist: List<Gallerylist>.from(json["gallerylist"].map((x) => Gallerylist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "gallerylist": List<dynamic>.from(gallerylist.map((x) => x.toJson())),
  };
}

class Gallerylist {
  String id;
  String img;
  String carTitle;

  Gallerylist({
    required this.id,
    required this.img,
    required this.carTitle,
  });

  factory Gallerylist.fromJson(Map<String, dynamic> json) => Gallerylist(
    id: json["id"],
    img: json["img"],
    carTitle: json["car_title"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img": img,
    "car_title": carTitle,
  };
}

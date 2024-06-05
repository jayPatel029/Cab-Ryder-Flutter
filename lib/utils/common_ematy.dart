import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'App_content.dart';
import 'Colors.dart';
import 'fontfameli_model.dart';

Widget ematy({required String title, Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Appcontent.ematyState, height: 96),
        const SizedBox(height: 20),
        RichText(
          textAlign: TextAlign.center,
            text: TextSpan(
          children: [
            TextSpan(text: 'No'.tr, style:   TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold,color: color)),
            TextSpan(text: ' $title ', style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold,color: color)),
            TextSpan(text: 'Found!'.tr, style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold,color: color)),
          ]
        )),
        const SizedBox(height: 10),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                children: [
                  TextSpan(text: 'It can be used to express that something is not someone'.tr, style:  TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff,color:  greyScale),),
                  TextSpan(text: ' $title', style:  TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff,color: greyScale)),
                ]
            )),
      ],
    ),
  );
}

Widget review({required String title, Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        Image.asset(Appcontent.review, height: 96),
        const SizedBox(height: 10),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                children: [
                  TextSpan(text: 'No'.tr, style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, color: color)),
                  TextSpan(text: ' $title ', style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, color: color)),
                  TextSpan(text: 'Found!'.tr, style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, color: color)),
                ]
            )),        const SizedBox(height: 10),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                children: [
                  TextSpan(text: 'It can be used to express that something is not someone'.tr, style:  TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff,color: greyScale),),
                  TextSpan(text: ' $title', style:  TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff, color: greyScale)),
                ]
            )),
      ],
    ),
  );
}

Widget ematyCar({required String title, Color? colors}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Appcontent.ematyCar, height: 96),
        const SizedBox(height: 10),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                children: [
                  TextSpan(text: 'No'.tr, style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, color: colors)),
                  TextSpan(text: ' $title ', style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, color: colors)),
                  TextSpan(text: 'Found!'.tr, style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, color: colors)),
                ]
            )),        const SizedBox(height: 10),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                children: [
                  TextSpan(text: 'It can be used to express that something is not someone'.tr, style:  TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff,color: greyScale),),
                  TextSpan(text: ' $title', style:  TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff,color: greyScale)),
                ]
            )),
      ],
    ),
  );
}
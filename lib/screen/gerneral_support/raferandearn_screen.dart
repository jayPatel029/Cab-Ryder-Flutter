
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_interpolation_to_compose_strings, avoid_print, unnecessary_new, file_names, depend_on_referenced_packages, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:carlink/model/referData_modal.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/common.dart';
import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';


class ReferFriendScreen extends StatefulWidget {
  const ReferFriendScreen({super.key});

  @override
  State<ReferFriendScreen> createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  @override
  void initState() {
    super.initState();
    getPackage();
    getlocledata();
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }


  var userData;
  var currencies;
  getlocledata() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(_prefs.getString('UserLogin')!);
      currencies = jsonDecode(_prefs.getString('bannerData')!);

      ReferandEarn(userData['id']);
    });
  }





  ReferData? referData;
  bool isloading = true;


  //Refer and earn api


  Future ReferandEarn(String uid) async {

    Map body = {
      'uid' : uid,
    };

    print("+++--++123456789+++--++ $body");

    try{
      var response = await http.post(Uri.parse('${Config.baseUrl}${Config.raferData}'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          referData = referDataFromJson(response.body);
        });
        setState(() {
          isloading = false;
        });
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }

  late ColorNotifire notifier;

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getbgcolor,
      appBar: AppBar(
        backgroundColor: onbordingBlue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('Refer a Friend'.tr,style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: FontFamily.europaBold)),
      ),
      body: isloading ?  loader() : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 30),
            Lottie.asset(Appcontent.refer,height: 270,width: 270),
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 190,
              child: RichText(text: TextSpan(
                  children: [
                    TextSpan(text: 'Earn'.tr,style: TextStyle(fontSize: 20, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaBold)),
                    TextSpan(text: ' ${currencies['currency']}${referData?.signupcredit} ', style: TextStyle(fontSize: 20, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaBold)),
                    TextSpan(text: 'for Each'.tr, style: TextStyle(fontSize: 20, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaBold)),
                    TextSpan(text: ' '),
                    TextSpan(text: 'Friend you refer'.tr, style: TextStyle(fontSize: 20, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaBold)),
                  ]
              ),textAlign: TextAlign.center),
            ),
            SizedBox(height: 30),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(Appcontent.referCar, height: 30, width: 30),
                      SizedBox(width: 15,),
                      Text("Share the referral link with your friends".tr, textAlign: TextAlign.start, style: TextStyle(fontSize: 16, color: notifier.getwhiteblackcolor, fontFamily: FontFamily.europaWoff),),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(Appcontent.referCar, height: 30, width: 30,),
                      SizedBox(width: 15,),
                      Expanded(
                        child: RichText(text: TextSpan(
                            children: [
                              TextSpan(text: 'Friend get'.tr,style: TextStyle(fontSize: 16, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaWoff)),
                              TextSpan(text: ' ${currencies['currency']}${referData?.signupcredit} ', style: TextStyle(fontSize: 16, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaBold)),
                              TextSpan(text: 'on their first complete transaction'.tr, style: TextStyle(fontSize: 16, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaWoff)),
                            ]
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(Appcontent.referCar, height: 30, width: 30),
                      SizedBox(width: 15,),
                      RichText(text: TextSpan(
                          children: [
                            TextSpan(text: 'You get'.tr,style: TextStyle(fontSize: 16, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaWoff)),
                            TextSpan(text: ' ${currencies['currency']}${referData?.refercredit} ',style: TextStyle(fontSize: 16, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaBold)),
                            TextSpan(text: 'on your wallet'.tr,style: TextStyle(fontSize: 16, color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaWoff)),
                          ]
                      )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            SizedBox(height: 50,),
            Container(
              height: 50,
              width: Get.size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 15, left: 35, right: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(referData!.code, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Clipboard.setData(
                          new ClipboardData(text: referData!.code),
                        );
                      },
                    child: Icon(Icons.copy),
                      // child: Image(image: AssetImage('assets/copyicon.png'),height: 25,width: 25,),
                  ),
                  SizedBox(width: 30),
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xFFe1e9f5),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 35,right: 35,bottom: 10),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await FlutterShare.share(
                        title: '$appName',
                        text: 'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code ${currencies['currency']}${referData?.signupcredit}  & Enjoy your next trip !!!',
                        linkUrl: Platform.isAndroid
                            ? 'https://play.google.com/store/apps/details?id=$packageName'
                            : Platform.isIOS
                            ? 'https://play.google.com/store/apps/details?id=$packageName'
                            : "",
                        chooserTitle: '$appName');
                  },
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(onbordingBlue),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
                  child:  Text('Refer a Friend'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> share() async {
    print("!!!!!!!!!!" + appName.toString());
    print("!!!!!!!!!!" + packageName.toString());
    await FlutterShare.share(
        title: '$appName',
        text:
        'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code ${currencies['currency']}${referData?.signupcredit} & Enjoy your shopping !!!',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: '$appName');
  }
}

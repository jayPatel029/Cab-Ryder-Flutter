import 'dart:async';
import 'package:carlink/screen/bottombar/carinfo_screeen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/Dark_lightmode.dart';
import '../../utils/fontfameli_model.dart';
import '../bottombar/bottombar_screen.dart';
import 'onbording_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ColorNotifire notifire;
  bool isLogin  = false;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  void initState() {
    getdarkmodepreviousstate();
    super.initState();
    getLocationPermition();
    getDataFromLocal().then((value) async {

      SharedPreferences pref = await SharedPreferences.getInstance();

      String user =  pref.getString("Usertype") ?? "";
      if(user == "ADMIN"){

        Timer(const Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const CarInfoScreen()), (route) => false);
        });

      }else{
        if (isLogin) {
          Timer(const Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomBarScreen()), (route) => false);
          });
        } else {
          Timer(const Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OnbordingScreen()), (route) => false);
          });
        }
      }


    });
  }

  getLocationPermition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {}
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        backgroundColor: notifire.getbgcolor,
        body: Container(
          height: Get.size.height,
          width: Get.size.width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Appcontent.appLogo,height: 165,),
              const SizedBox(height: 15),
              Text('carlink',style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 39, color: notifire.getwhiteblackcolor)),
            ],
          ),
        ));
  }

  Future getDataFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool("isLogin") ?? false;
    });
  }
}

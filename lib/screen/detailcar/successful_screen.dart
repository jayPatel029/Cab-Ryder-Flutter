// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:carlink/screen/bottombar/bottombar_screen.dart';
import 'package:carlink/screen/mypurchases/mypurchases_screen.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessfulScreen extends StatefulWidget {
  const SuccessfulScreen({super.key});

  @override
  State<SuccessfulScreen> createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {
  late ColorNotifire notifire;

  @override
  void initState() {
    bookId();
    super.initState();
  }

  var Id;
  bookId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Id = prefs.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      bottomNavigationBar: Container(
        height: 100,
        width: Get.width,
        decoration: BoxDecoration(
          color: notifire.getbgcolor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  backgroundColor: onbordingBlue,
                  fixedSize: Size(Get.width, 56),
                ),
                  onPressed: () {
                     Get.to(const MyPurchasesScreen());
                  },
                  child:  Text('View My Booking'.tr, style: const TextStyle(fontSize: 15, color: Colors.white, fontFamily: FontFamily.europaBold)),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: notifire.getbgcolor,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.offAll(const BottomBarScreen());
          },
          child: Icon(Icons.arrow_back, color: notifire.getwhiteblackcolor),
        ),
        title: Text("Payment".tr, style: TextStyle(fontSize: 15, color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: onbordingBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 70),
            ),
            Text("Payment Successful!".tr, style: TextStyle(fontSize: 20, color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
            SizedBox(height: Get.height / 50),
            Text("You Car Successfully Booked.\nYou can check your booking on the menu Profile.".tr, style: TextStyle(color: notifire.getgreycolor, fontFamily: FontFamily.europaWoff), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

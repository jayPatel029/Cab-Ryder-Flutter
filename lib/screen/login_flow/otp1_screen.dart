// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, avoid_unnecessary_containers, sort_child_properties_last
import 'dart:async';
import 'package:carlink/screen/login_flow/newpassword_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Custom_widget.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp1Screen extends StatefulWidget {
  final String country;
  final String mNumber;
  final String vId;
  const Otp1Screen({super.key, required this.country, required this.mNumber, required this.vId});

  @override
  State<Otp1Screen> createState() => _Otp1ScreenState();
}

class _Otp1ScreenState extends State<Otp1Screen> {
  OtpFieldController pinPutController = OtpFieldController();
  String code = "";

  late ColorNotifire notifire;
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  int second = 60;
  bool enableResend = false;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (second != 0) {
        setState(() {
          second--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
    getdarkmodepreviousstate();
    super.initState();
  }
  void _resendCode() {
    setState((){
      second = 60;
      resend(code);
      enableResend = false;
    });
  }

  @override
  dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      bottomNavigationBar: SizedBox(
        height: 135,
        width: Get.size.width,
        child: Column(
          children: [
            GestButton(
              height: 50,
              Width: Get.size.width,
              buttoncolor: onbordingBlue,
              buttontext: "Continue".tr,
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
              style: TextStyle(
                fontFamily: FontFamily.europaBold,
                color: WhiteColor,
                fontSize: 15,
              ),
              onclick: () {
                verifyOtp(code);
              },
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: enableResend ? _resendCode : null,
              child: Container(
                height: 50,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: onbordingBlue),
                ),
                child: TextButton(
                  onPressed: enableResend ? _resendCode : null,
                  child: enableResend ? Text('Resend Code'.tr, style: TextStyle(color: onbordingBlue, fontSize: 15)) : Text('$second seconds', style: TextStyle(color: onbordingBlue, fontSize: 15)),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(6),
                  child: Image.asset(Appcontent.close, color: notifire.getwhiteblackcolor,),
                ),
              ),
              SizedBox(height: Get.size.height * 0.04,),
              Container(
                height: 100,
                width: Get.size.width,
                alignment: Alignment.center,
                child: Image.asset(Appcontent.ematy),
              ),
              SizedBox(height: 10,),
              Container(
                width: Get.size.width,
                alignment: Alignment.center,
                child: Text("Almost there!".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 24)),
              ),
              SizedBox(height: 10),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'You need to enter 6-digit code that we have sent to your mobile number'.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: greyScale, fontSize: 14)),
                      TextSpan(text: ' ${widget.country} ${widget.mNumber}', style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15)),
                    ],
                  )),
              SizedBox(height: Get.size.height * 0.035),
              OTPTextField(
                controller: pinPutController,
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 50,
                style: TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                otpFieldStyle: OtpFieldStyle(
                  focusBorderColor: onbordingBlue,
                  enabledBorderColor: Color(0xffEEF2F6),
                  disabledBorderColor: Color(0xffEEF2F6),
                ),
                onChanged: (value) {
                  setState(() {
                    code = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  verifyOtp(String otp) async {
    try{
      FirebaseAuth auth1 = FirebaseAuth.instance;
      var credential = await auth1.signInWithCredential(PhoneAuthProvider.credential(verificationId: widget.vId, smsCode: otp));
      if(credential.user != null){
        Get.to(NewPasswordScreen(conutry: widget.country, mobile: widget.mNumber));
      } else{
        Fluttertoast.showToast(msg: 'Enter Your OTP');
      }
    } catch(e){
      Fluttertoast.showToast(msg: 'Wrong OTP');
    }
  }

  resend(String otp) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.country + widget.mNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try{
          FirebaseAuth auth1 = FirebaseAuth.instance;
          var credential = await auth1.signInWithCredential(PhoneAuthProvider.credential(verificationId: widget.vId, smsCode: otp));
          if(credential.user != null){
          } else {
            Fluttertoast.showToast(msg: 'Wrong OTP');
          }
        } catch(e){
          Fluttertoast.showToast(msg: 'Wrong OTP');
        }
      },
      verificationFailed: (FirebaseAuthException e) {},
      timeout: Duration(seconds: second),
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}

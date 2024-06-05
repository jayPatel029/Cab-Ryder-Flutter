// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, empty_catches
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/screen/login_flow/login_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Custom_widget.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/config.dart';

class NewPasswordScreen extends StatefulWidget {
  final String conutry;
  final String mobile;
  const NewPasswordScreen({super.key, required this.conutry, required this.mobile});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool showPassword = true;
  bool newShowPassword = true;

  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    getdarkmodepreviousstate();
    super.initState();
  }

  Future forgotPassword(password) async {
    Map body = {
      'mobile' : widget.mobile,
      'ccode' : widget.conutry,
      'password' : password,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.forgotPassword), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        return data;
      } else {
      }
    } catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      bottomNavigationBar: GestButton(
        height: 50,
        Width: Get.size.width,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        buttontext: "Create New Password".tr,
        style: TextStyle(
          fontFamily: FontFamily.europaBold,
          color: WhiteColor,
          fontSize: 15,
        ),
        buttoncolor: onbordingBlue,
        onclick: () {
            if (password.text.isNotEmpty && newPassword.text.isNotEmpty) {
              if (_formKey.currentState?.validate() ?? false) {
                if(password.text == newPassword.text) {
                  forgotPassword(newPassword.text).then((value) {
                    if((value["ResponseCode"] == "200")){
                      showModalBottomSheet(
                        backgroundColor: notifire.getbgcolor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 437,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 15,),
                                Image.asset(Appcontent.passwordch, height: 96, width: 96),
                                Text('Password changed!'.tr, style: TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, fontWeight: FontWeight.w700, color: notifire.getwhiteblackcolor)),
                                Column(
                                  children: [
                                    Text('Awesome. You’re successfully'.tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff, fontWeight: FontWeight.w500, color: greyScale),),
                                    Text('updated your password.'.tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff, fontWeight: FontWeight.w500, color: greyScale),),
                                  ],
                                ),
                                GestButton(
                                  height: 50,
                                  Width: Get.size.width,
                                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  buttontext: 'Return to Sign In'.tr,
                                  style: TextStyle(fontFamily: FontFamily.europaBold, fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
                                  onclick: () {
                                    Get.to(LoginScreen());
                                  },
                                  buttoncolor: onbordingBlue,
                                ),
                              ],
                            ),
                          );
                        },);
                      Fluttertoast.showToast(msg: value['ResponseMsg']);
                    } else {
                      Fluttertoast.showToast(msg: value['ResponseMsg']);
                    }
                  });
                } else {
                  Fluttertoast.showToast(msg: 'Password Not Matched!');
                }
              } else {
                Fluttertoast.showToast(msg: 'Please some your text');
              }
            }
        },
      ),
      body: SafeArea(
        child: SizedBox(
          height: Get.size.height,
          width: Get.size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
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
                        child: Image.asset(
                         Appcontent.back,
                          color: notifire.getwhiteblackcolor,
                        ),
                      ),
                    ),
                    SizedBox(height: Get.size.height * 0.025),
                    Text("Create your\nnew password".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 25)),
                    SizedBox(height: 15),
                    Text("Your new password must be different\nfrom previous password.".tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: greyScale, fontSize: 15)),
                    SizedBox(height: 30),

                    textFormFild(
                      notifire,
                      controller: password,
                      obscureText: showPassword,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        child: !showPassword
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/eye.png", height: 25, width: 25, color: greyColor),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/eye-off.png", height: 25, width: 25, color: greyColor),
                              ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset("assets/lock.png", height: 25, width: 25, color: greyColor),
                      ),
                      labelText: "Password".tr,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    textFormFild(
                      notifire,
                      controller: newPassword,
                      obscureText: newShowPassword,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            newShowPassword = !newShowPassword;
                          });
                        },
                        child: !newShowPassword
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/eye.png", height: 25, width: 25, color: greyColor),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/eye-off.png", height: 25, width: 25, color: greyColor),
                              ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset("assets/lock.png", height: 25, width: 25, color: greyColor),
                      ),
                      labelText: "Password".tr,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    passwordRow(
                      title: "Must not contain your name or email".tr,
                      textColor: Color(0xFF22C55E),
                    ),
                    SizedBox(height: 7),
                    passwordRow(
                      title: "At least 8 characters".tr,
                      textColor: greyScale,
                      color: greyScale,
                    ),
                    SizedBox(height: 7),
                    passwordRow(
                      title: "Contains a symbol or a number".tr,
                      textColor: greyScale,
                      color: greyScale,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  passwordRow({
    String? title,
    Color? color,
    Color? textColor,
  }) {
    return Row(
      children: [
        Container(
          height: 25,
          width: 25,
          alignment: Alignment.center,
          child: Image.asset("assets/circle-check.png", color: color),
        ),
        SizedBox(width: 10),
        Text(title ?? "", style: TextStyle(color: textColor, fontFamily: FontFamily.europaWoff)),
      ],
    );
  }
}
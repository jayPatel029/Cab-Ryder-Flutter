// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, empty_catches
import 'dart:convert';
import 'dart:io';
import 'package:carlink/model/proimage_modal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/App_content.dart';
import '../../utils/Colors.dart';
import '../../utils/Custom_widget.dart';
import '../../utils/Dark_lightmode.dart';
import '../../utils/fontfameli_model.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late ColorNotifire notifire;
  bool passwordVisible = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
String networkImage = "";
  var decode;
  var UId;

  @override
  void initState() {
    getlocaldata();
    super.initState();
  }

  getlocaldata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var decode1 = jsonDecode(preferences.getString('UserLogin')!);
    setState(() {
      UId = decode1['id'];
      nameController.text = decode1['name'];
      emailController.text = decode1['email'];
      passwordController.text = decode1['password'];
      networkImage = decode1["profile_pic"];
    });
  }
  Future eprofile(uid, name, email, password) async {
    Map body = {
      "uid" : uid,
      "name" : name,
      "email" : email,
      "password" : password,
    };
    try {
      var response = await http.post(Uri.parse(Config.baseUrl + Config.editProfile),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch (e) {}
  }

  ProImageModal? proImageModal;
  bool Loading =true;
  Future proImage(uid, image) async {
    Map body = {
      "uid" : uid,
      "img": image,
    };
    try {
      var response = await http.post(Uri.parse(Config.baseUrl + Config.proImage),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        setState(()  {
          proImageModal =proImageModalFromJson(response.body);
          Loading=false;
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('UserLogin', jsonEncode(proImageModal!.userLogin));
        preferences.setString('profilePic', networkImage);
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch (e) {}
  }
  XFile? selectImage;
  ImagePicker picker = ImagePicker();
  String? base64String;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(Appcontent.back,color: Colors.white),
          ),
        ),
        backgroundColor: onbordingBlue,
        centerTitle: true,
        elevation: 0,
        title: Text("Edit account".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: WhiteColor, fontSize: 16),
        ),
      ),
      bottomNavigationBar: GestButton(
        height: 50,
        Width: Get.size.width,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        buttoncolor: onbordingBlue,
        buttontext: "Save & Change".tr,
        style: TextStyle(color: WhiteColor, fontFamily: FontFamily.europaBold, fontSize: 15),
        onclick: () {
          if(nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
            eprofile(UId, nameController.text, emailController.text, passwordController.text).then((value) {
              if(value["ResponseCode"] == "200"){
                Get.back();
                Fluttertoast.showToast(msg: value['ResponseMsg']);
              } else {
                Fluttertoast.showToast(msg: value['ResponseMsg']);
              }
            });
          } else {
            Fluttertoast.showToast(msg: 'Please some your text!!'.tr);
          }
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                width: Get.width,
                color: onbordingBlue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          backgroundColor: notifire.getbgcolor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text("From where do you want to take the photo?".tr, style:  TextStyle(fontFamily: FontFamily.europaBold, fontSize: 20, color: notifire.getwhiteblackcolor),),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(fixedSize: const Size(100, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),side: BorderSide(color: greyScale)),
                                              onPressed: () async {
                                                final picked=await picker.pickImage(source: ImageSource.gallery);
                                                if(picked!= null){
                                                  setState(() {
                                                    selectImage = picked;
                                                  });

                                                  List<int> imageByte =File(selectImage!.path).readAsBytesSync();
                                                  base64String =base64Encode(imageByte);
                                                  proImage(UId, base64String).then((value) {
                                                    if(value["ResponseCode"]=="200"){
                                                      getlocaldata();
                                                      Get.back();
                                                      Fluttertoast.showToast(msg: value["ResponseMsg"]);
                                                    } else{
                                                      Fluttertoast.showToast(msg: value["ResponseMsg"]);
                                                    }
                                                  });
                                                } else{
                                                }
                                              },
                                              child:  Text("Gallery".tr, style:  TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor),),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(fixedSize: const Size(100, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), side: BorderSide(color: greyScale)),
                                              onPressed: () async {
                                                final picked=await picker.pickImage(source: ImageSource.camera);
                                                if(picked!= null){
                                                  setState(() {
                                                    selectImage = picked;
                                                  });

                                                  List<int> imageByte =File(selectImage!.path).readAsBytesSync();
                                                  base64String =base64Encode(imageByte);
                                                  proImage(UId, base64String).then((value) {
                                                    if(value["ResponseCode"]=="200"){
                                                      getlocaldata();
                                                      Get.back();
                                                      Fluttertoast.showToast(msg: value["ResponseMsg"]);
                                                    } else{
                                                      Fluttertoast.showToast(msg: value["ResponseMsg"]);
                                                    }
                                                  });
                                                } else{
                                                }
                                              },
                                              child:  Text("Camera".tr, style:  TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor),),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: networkImage == "" ?  const CircleAvatar(
                              maxRadius: 50,
                              backgroundImage: AssetImage(Appcontent.profile),
                            ) :Container(
                                decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image:  NetworkImage('${Config.imgUrl}$networkImage'), fit: BoxFit.cover),
                                )),
                          ),

                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(Appcontent.edit),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              edit(title: 'Full name'.tr),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: notifire.getblackwhitecolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: nameController,
                  style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 16),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: notifire.getbgcolor)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: notifire.getbgcolor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: notifire.getbgcolor),
                    ),
                    hintText: 'Full name'.tr,
                    hintStyle: TextStyle(fontFamily: FontFamily.europaWoff, fontWeight: FontWeight.w500, fontSize: 16, color: greyScale1),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(Appcontent.user, height: 24, width: 24,color: greyScale1),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name'.tr;
                    }
                    return null;
                  },
                ),
              ),
              edit(title: 'Email address'.tr),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: notifire.getblackwhitecolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 16,),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: notifire.getbgcolor)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: notifire.getbgcolor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: notifire.getbgcolor),
                    ),
                    hintText: 'Email address'.tr,
                    hintStyle: TextStyle(fontFamily: FontFamily.europaWoff, fontWeight: FontWeight.w500, fontSize: 16, color: greyScale1),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(Appcontent.mail, height: 24, width: 24,color: greyScale1),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email'.tr;
                    }
                    return null;
                  },
                ),
              ),
              edit(title: 'Password'.tr),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: notifire.getblackwhitecolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 16),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: notifire.getbgcolor)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: notifire.getbgcolor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: notifire.getbgcolor),
                    ),
                    hintText: 'Password'.tr,
                    hintStyle: TextStyle(fontFamily: FontFamily.europaWoff, fontWeight: FontWeight.w500, fontSize: 16, color: greyScale1),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(Appcontent.lock, height: 24, width: 24,color: greyScale1),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passwordVisible =! passwordVisible;
                        });
                      },
                      child: passwordVisible
                          ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset("assets/eye-off.png", height: 25, width: 25, color: greyColor),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset("assets/eye.png", height: 25, width: 25, color: greyColor),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password'.tr;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget edit({required String title}){
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Text(title, style:  TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 14, fontWeight: FontWeight.w700),),
    );
  }
}

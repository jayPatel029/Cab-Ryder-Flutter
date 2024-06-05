// ignore_for_file: avoid_print, empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/modal.dart';
import 'package:carlink/model/policy_modal.dart';
import 'package:carlink/screen/gerneral_support/language_screen.dart';
import 'package:carlink/screen/gerneral_support/raferandearn_screen.dart';
import 'package:carlink/screen/gerneral_support/wallet_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/screen/login_flow/login_screen.dart';
import 'package:carlink/screen/mypurchases/mypurchases_screen.dart';
import 'package:carlink/screen/bottombar/editprofile_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/favorite_controller.dart';
import '../../utils/common.dart';
import '../gerneral_support/faq_screen.dart';
import '../gerneral_support/pagelist_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isdark = false;
  late ColorNotifire notifire;
  FavoriteController favoriteController = Get.find();
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
    save();
    policy();
    getdarkmodepreviousstate();
    super.initState();
  }

  var name;

  resetNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setBool('bottomsheet', false);
    name = '';
    // await prefs.clear();
  }

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = jsonDecode(prefs.getString('UserLogin')!);
    print(name);
  }

  // Page List Api
  late PolicyPage pPage;
  bool loading = true;
  Future policy() async {
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.policy), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          pPage = policyPageFromJson(response.body);
          loading = false;
        });
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch(e){}
  }
  // Account Delete Api
  Future delete(uid) async {
    Map body = {
      "uid": uid,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.accountDelete), body: jsonEncode(body),headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch(e){}
  }
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        backgroundColor: onbordingBlue,
        centerTitle: true,
        elevation: 0,
        title: Text("Profile".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: WhiteColor, fontSize: 16)),
      ),
      body: loading ? loader() : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.size.height * 0.3,
              width: Get.size.width,
              color: onbordingBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  name['profile_pic'] != null ?  CircleAvatar(
                    maxRadius: 50,
                    backgroundImage: NetworkImage('${Config.imgUrl}${name['profile_pic']}'),
                  ) : const CircleAvatar(
                     maxRadius: 50,
                    backgroundImage: AssetImage(Appcontent.profile),
              ),
                  const SizedBox(height: 15),
                  Text(name['name'], style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 18, color: WhiteColor)),
                  const SizedBox(height: 5),
                  Text(name['email'], style: const TextStyle(fontFamily: FontFamily.europaWoff, fontSize: 15, color: Colors.white)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const MyPurchasesScreen());
              },
              child: Container(
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: notifire.getborderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: onbordingBlue,
                      ),
                      child: Center(
                        child: Image.asset(Appcontent.streeing, height: 24, width: 24),
                      ),
                    ),
                    Text('My Booking'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 18, color: notifire.getwhiteblackcolor)),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios, color: notifire.getwhiteblackcolor, size: 24,),
                    const SizedBox(width: 10,),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Text("General".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              itemCount: model().imgList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if(index == 0) {
                      Get.to(const EditScreen())?.then((value) {
                        save();
                        setState(() {});
                      });
                    } else if(index == 2) {
                      Get.to(const FaqScreen());
                    } else if(index == 3) {
                      Get.to(const My_Wallet());
                    } else if(index == 4){
                      Get.to(const LanguageScreen());
                    } else if(index == 5) {
                      Get.to(const ReferFriendScreen());
                    }
                  },
                  child: Container(
                    height: 40,
                    width: Get.size.width,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    color: notifire.getbgcolor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: notifire.getgreycolor),
                          ),
                          child: Image.asset(model().imgList[index], color: notifire.getwhiteblackcolor),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(model().profileList[index], maxLines: 1, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15, overflow: TextOverflow.ellipsis)),
                        ),
                        index == 1 ? Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: onbordingBlue,
                            value: notifire.isDark,
                            onChanged: (value) async {
                              setState(() {
                                isdark = value;
                              });
                              final prefs = await SharedPreferences.getInstance();
                              setState(() {
                                notifire.setIsDark = value;
                                prefs.setBool("setIsDark", value);
                              });
                            },
                          ),
                        )  : Image.asset(Appcontent.right, height: 25, width: 25),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
              child: Text("Support".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: pPage.pagelist.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if(index == 0){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PageListScreen(title: pPage.pagelist[index].title, description: pPage.pagelist[index].description)));
                    } else if(index == 1){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PageListScreen(title: pPage.pagelist[index].title, description: pPage.pagelist[index].description)));
                    } else if(index == 2){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PageListScreen(title: pPage.pagelist[index].title, description: pPage.pagelist[index].description)));
                    }else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PageListScreen(title: pPage.pagelist[index].title, description: pPage.pagelist[index].description)));
                    }
                  },
                  child: Container(
                    height: 40,
                    width: Get.size.width,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    color: notifire.getbgcolor,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: notifire.getgreycolor),
                              ),
                              child: Center(child: Image.asset(Appcontent.noteText, height: 24, width: 24, color: notifire.getwhiteblackcolor)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(pPage.pagelist[index].title, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 14, color: notifire.getwhiteblackcolor, fontWeight: FontWeight.w700)),
                        ),
                        const Spacer(),
                        Image.asset(Appcontent.right, height: 25, width: 25),
                      ],
                    ),
                  ),
                );
              },),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: notifire.getbgcolor,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(13))),
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                Text('Account Delete'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 18, color: onbordingBlue, fontWeight: FontWeight.w700)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Divider(
                                    thickness: 1,
                                    color: notifire.getgreycolor,
                                  ),
                                ),
                                Text('Are you sure you want to delete account?'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 18, color: notifire.getwhiteblackcolor, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            height: 50,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: notifire.getgreycolor),
                                            ),
                                            child: Center(child: Text('Cancel'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 14, color: notifire.getgreycolor))),
                                          ),
                                        ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: onbordingBlue,
                                          fixedSize: Size(Get.width, 50),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                                        ),
                                          onPressed: () {
                                            delete(name['id']).then((value) {
                                              if(value['ResponseCode'] == "200"){
                                                Get.offAll(const LoginScreen());
                                                Fluttertoast.showToast(msg: value['ResponseMsg']);
                                              } else {
                                                Fluttertoast.showToast(msg: value['ResponseMsg']);
                                              }
                                            });
                                          },
                                          child: Text('Yes, Remove'.tr, style: const TextStyle(fontFamily: FontFamily.europaBold, fontSize: 14, color: Colors.white))),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        );
                      },);
                },
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red),
                          ),
                          child: Center(child: Image.asset(Appcontent.trash, height: 24, width: 24, color: Colors.red)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text('Account Delete'.tr, style: const TextStyle(fontFamily: FontFamily.europaBold, fontSize: 14, color: Colors.red, fontWeight: FontWeight.w700)),
                    ),
                    const Spacer(),
                    Image.asset(Appcontent.right, height: 25, width: 25, color: Colors.red),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(Get.width, 50),
                  side: BorderSide(color: onbordingBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                  onPressed: () {
                    resetNew();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                  },
                  child: Text('Log Out'.tr, style: TextStyle(fontSize: 15, color: onbordingBlue, fontFamily: FontFamily.europaBold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

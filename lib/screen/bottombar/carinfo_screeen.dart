// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/dashboard_modal.dart';
import 'package:carlink/screen/addcar_screens/Listcar_screen.dart';
import 'package:carlink/screen/addcar_screens/addcar_screen.dart';
import 'package:carlink/screen/addcar_screens/mybooking_screen.dart';
import 'package:carlink/screen/login_flow/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/common.dart';
import '../addcar_screens/withdraw_screen.dart';
import 'notification_screen.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
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
    save();
    getdarkmodepreviousstate();
    super.initState();
  }

  List img=[
    Appcontent.add,
    Appcontent.carGallery,
    Appcontent.payout,
    Appcontent.carList,
  ];
  List title=[
    'Add Car'.tr,
    'My Booking'.tr,
    'Payout'.tr,
    'List Car'.tr,
  ];

  DashboardModal? dashboardModal;
  bool isLoading = true;
  Future dashboard(uId) async {
    Map body = {
      "uid" : uId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.dashboard), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          dashboardModal = dashboardModalFromJson(response.body);
          isLoading =false;
        });
        var data = jsonDecode(response.body.toString());

        return data;
      } else {
        var data = jsonDecode(response.body.toString());
        return data;
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }

  var name;
  var admin;

  var data;
  var data1;

  String uid = '';
  save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user =  preferences.getString("Usertype")!;
    user == "ADMIN" ? data1 = preferences.getString('AdminLogin')! : data = preferences.getString('UserLogin')!;
    user == "ADMIN" ?  admin = data1.toString().isNotEmpty ? jsonDecode(data1) : "": name = data.toString().isNotEmpty? jsonDecode(data) : "";

    uid = user == "ADMIN" ? "0" :name['id'];
    setState(() {});
    dashboard(uid);
  }


  logOutAdmin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('AdminLogin', '');
    preferences.setString('Usertype', '');
    preferences.setString('UserLogin', '');
    uid = '';
    await preferences.clear();
  }

  Future<void> _refresh()async {
    Future.delayed(const Duration(seconds: 1),() {
      setState(() {
        dashboard(uid);
      });
    },);
  }
  @override
  Widget build(BuildContext context) {
    notifire =Provider.of<ColorNotifire>(context,listen: true);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scaffold(
        backgroundColor: blue,
        floatingActionButton: FloatingActionButton(
          backgroundColor: blue,
          onPressed: () {
            uid == "0"? logOutAdmin() : null;
            uid == "0"? Get.offAll(LoginScreen()) : Get.back();
          },
          child:uid == "0"? Icon(Icons.logout) : Icon(Icons.arrow_back),
        ),
        body: SafeArea(
          child: Column(
            children: [
              uid == "0"? ListTile(
                leading:  Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: greyScale,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('A', style: TextStyle(fontSize: 18,color: Colors.white,fontFamily: FontFamily.europaBold))),
                ),
                title: Text(admin['username'], style: TextStyle(fontSize: 18,color: Colors.white,fontFamily: FontFamily.europaBold)),
                subtitle: Text(admin['mobile'], style: TextStyle(fontSize: 12,color: greyScale,fontFamily: FontFamily.europaWoff)),
                trailing: InkWell(
                  onTap: () {
                    Get.to(NotificationScreen(uid: uid == "0" ? "0" : name['id']));
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff3F71F0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset(Appcontent.notification,color: Colors.white),
                    ),
                  ),
                ),
              ) : ListTile(
                leading:  isLoading ? SizedBox() : name['profile_pic'] == null ? CircleAvatar(
                  maxRadius: 20,
                  backgroundImage: AssetImage(Appcontent.profile),
                ) : CircleAvatar(
                  maxRadius: 20,
                  backgroundImage: NetworkImage('${Config.imgUrl}${name['profile_pic']}'),
                ),
                title: isLoading ? SizedBox() : Text(name['name'], style: TextStyle(fontSize: 18,color: Colors.white,fontFamily: FontFamily.europaBold)),
                subtitle: isLoading ? SizedBox() : Text(name['email'], style: TextStyle(fontSize: 12,color: greyScale,fontFamily: FontFamily.europaWoff)),
                trailing: InkWell(
                  onTap: () {
                    Get.to(NotificationScreen(uid: uid == "0" ? "0" : name['id'],));
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff3F71F0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset(Appcontent.notification,color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(top: 13, bottom: 15),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: img.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if(index == 0){
                            button = true;
                            nameController.clear();
                            cNumberController.clear();
                            driverController.clear();
                            mobileController.clear();
                            ratingController.clear();
                            seatController.clear();
                            withoutRent.clear();
                            withRent.clear();
                            engineController.clear();
                            locationController.clear();
                            latController.clear();
                            lngController.clear();
                            totalKmController.clear();
                            descController.clear();
                            addressController.clear();
                            multiSelect1.clear();
                            multiSelect.clear();
                            minimumController.clear();
                            netImg.clear();
                            image.clear();
                            dropId = "";
                            ccode = '';
                            carStatus = null;
                            ac = null;
                            gear = null;
                            carType = null;
                            carBrand = null;
                            carPrice = null;
                            carFuel = null;
                            Get.to(AddCarScreen(uid: uid == "0" ? "0" : name['id']));
                          } else if(index == 1){
                            setState(() {
                              currentIndex = 0;
                            });
                            Get.to(MyBookScreen(uid: uid == "0" ? "0" : name['id'], dollarSign: dashboardModal?.currency));
                          } else if(index == 2){
                            Get.to(payout_screen(earning: double.parse(dashboardModal!.reportData[3].reportData.toString()), minimum: dashboardModal!.reportData[5].reportData));
                          } else if(index == 3){
                            Get.to(ListCarScreen(uid: uid == "0" ? "0" : name['id']));
                          }
                        },
                        child: uid == "0" ? index == 2 ? SizedBox() : Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff3F71F0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(img[index],color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(title[index], style: const TextStyle(fontSize: 12,color: Colors.white,fontFamily: FontFamily.europaBold)),
                          ],
                        ) : Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff3F71F0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(img[index],color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(title[index], style: const TextStyle(fontSize: 12,color: Colors.white,fontFamily: FontFamily.europaBold)),
                          ],
                        ),
                      );
                    }),
              ),
              Expanded(
                child: Container(
                  height: Get.height,
                  decoration: BoxDecoration(
                    color: notifire.getbgcolor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: isLoading ? loader() :  Column(
                    children: [
                      GridView.builder(
                        itemCount: dashboardModal?.reportData.length,
                        padding:  EdgeInsets.only(top: 10, left: 5, right: 5),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 130),
                        itemBuilder: (context, index) {
                          return uid == "0" ? index == 3 ? SizedBox() : index == 4 ? SizedBox() : index == 5 ? SizedBox() : InkWell(
                            onTap: () {
                              if(index == 0){
                                Get.to(ListCarScreen(uid: uid));
                              } else if(index == 1){
                                setState(() {
                                  currentIndex = 0;
                                });
                                Get.to(MyBookScreen(uid: uid, dollarSign: dashboardModal?.currency));
                              } else if(index == 2){
                                setState(() {
                                  currentIndex = 1;
                                });
                                Get.to(MyBookScreen(uid: uid, dollarSign: dashboardModal?.currency));
                              } else if(index == 4){
                                Get.to(payout_screen(earning: dashboardModal!.reportData[3].reportData, minimum: dashboardModal!.reportData[5].reportData));
                              }
                            },
                            child: Container(
                              // height: 250,
                              width: Get.size.width,
                              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: notifire.getbgcolor,
                              ),
                              child: Container(
                                height: 120,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: notifire.getCarColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 55,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        color: notifire.getBottom,
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      child: ListTile(
                                        title: Text(dashboardModal!.reportData[index].title, style: TextStyle(color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
                                        trailing: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Image.network('${Config.imgUrl}${dashboardModal!.reportData[index].url}')),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 13, top: 13),
                                      child: Text('${index == 0 ? '' : index == 1 ? '': index == 2 ? ''   : dashboardModal?.currency}${index == 3 ?double.parse(dashboardModal!.reportData[index].reportData.toString()).toStringAsFixed(2) : dashboardModal!.reportData[index].reportData}', style: TextStyle(color: notifire.getwhiteblackcolor, fontSize: 25, fontFamily: FontFamily.europaBold)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ) : InkWell(
                            onTap: () {
                              if(index == 0){
                                Get.to(ListCarScreen());
                              } else if(index == 1){
                                setState(() {
                                  currentIndex = 0;
                                });
                                Get.to(MyBookScreen());
                              } else if(index == 2){
                                setState(() {
                                  currentIndex = 1;
                                });
                                Get.to(MyBookScreen());
                              } else if(index == 4){
                                Get.to(payout_screen(earning: double.parse(dashboardModal!.reportData[3].reportData.toString()), minimum: dashboardModal!.reportData[5].reportData));
                              }
                            },
                            child: Container(
                              // height: 250,
                              width: Get.size.width,
                              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: notifire.getbgcolor,
                              ),
                              child: Container(
                                height: 120,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: notifire.getCarColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 55,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        color: notifire.getBottom,
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      child: ListTile(
                                        title: Text(dashboardModal!.reportData[index].title, style: TextStyle(color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
                                        trailing: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Image.network('${Config.imgUrl}${dashboardModal!.reportData[index].url}')),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 13, top: 13),
                                      child: Text('${index == 0 ? '' : index == 1 ? '': index == 2 ? '' : dashboardModal?.currency}${index == 3 ?double.parse(dashboardModal!.reportData[index].reportData.toString()).toStringAsFixed(2) : dashboardModal!.reportData[index].reportData}', style: TextStyle(color: notifire.getwhiteblackcolor, fontSize: 25, fontFamily: FontFamily.europaBold)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget carTool({required String image, required String title}){
    return Row(
      children: [
        Image.asset(image, height: 20, width: 20),
        SizedBox(width: 4),
        Text(title, style: TextStyle(fontFamily: FontFamily.europaWoff, color: Colors.black, fontSize: 13)),
      ],
    );
  }
}

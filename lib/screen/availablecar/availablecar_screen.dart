// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/viewfeature_modal.dart';
import 'package:carlink/screen/detailcar/cardetails_screen.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/controller/favorite_controller.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class AvailablecarScreen extends StatefulWidget {
  final String title;
  const AvailablecarScreen({super.key, required this.title});

  @override
  State<AvailablecarScreen> createState() => _AvailablecarScreenState();
}

class _AvailablecarScreenState extends State<AvailablecarScreen> {
  FavoriteController favoriteController = Get.find();
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
    getvalidate();
    getdarkmodepreviousstate();
    super.initState();
    favoriteController.changShimmer();
  }

  ViewFeatureModal? viewFeatureModal;
  bool isLoading = true;
  Future viewFeature(uid, lats, longs, city) async {
    Map body = {
      "uid": uid,
      "lats": lats,
      "longs": longs,
      "cityid": city,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.viewFeature), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          viewFeatureModal = viewFeatureModalFromJson(response.body);
          isLoading = false;
          favoriteController.isLoading;
        });
      } else {}
    }catch(e){}
  }

  var id;
  Future getvalidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = jsonDecode(sharedPreferences.getString('UserLogin')!);
    var lats = jsonDecode(sharedPreferences.getString('lats')!);
    var long = jsonDecode(sharedPreferences.getString('longs')!);
    var dId = sharedPreferences.getString('lId');
    viewFeature(id['id'], lats, long, dId);
  }


  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        backgroundColor: notifire.getbgcolor,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            child: Image.asset(Appcontent.back, color: notifire.getwhiteblackcolor,),
          ),
        ),
        title: Text(widget.title, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor,),),
       ),
      body: GetBuilder<FavoriteController>(builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: viewFeatureModal?.featureCar.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return isLoading ?   awailableCarShimmer() : InkWell(
                      onTap: () {
                        Get.to(CarDetailsScreen(id: viewFeatureModal!.featureCar[index].id, currency: viewFeatureModal!.currency));
                      },
                      child: Container(
                        height: 160,
                        width: Get.size.width,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Container(
                                  height: 90,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(image: NetworkImage(Config.imgUrl+viewFeatureModal!.featureCar[index].carImg),fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(viewFeatureModal!.featureCar[index].carTitle, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor,),),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(viewFeatureModal!.featureCar[index].carTypeTitle, style: TextStyle(fontFamily:FontFamily.europaBold, fontSize: 15, color: greyScale1,),),
                                          Spacer(),
                                          Image.asset(Appcontent.star1, height: 16),
                                          SizedBox(width: 5),
                                          Text(viewFeatureModal!.featureCar[index].carRating, style: TextStyle(fontFamily: FontFamily.europaWoff, color: greyScale1, fontSize: 13,),),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(viewFeatureModal!.featureCar[index].carNumber, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor,),),
                                          Text("${viewFeatureModal?.currency}${viewFeatureModal?.featureCar[index].carRentPrice}/${viewFeatureModal?.featureCar[index].priceType == '1'? 'hr'.tr : 'days'.tr}", style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15,),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Divider(color: greyScale,),
                            SizedBox(height: 4,),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    carTool(image: 'assets/engine.png', title: '${viewFeatureModal!.featureCar[index].engineHp} ${'hp'.tr}'),
                                    carTool(image: 'assets/manual-gearbox.png', title: viewFeatureModal!.featureCar[index].carGear == '1' ? 'Automatic'.tr : 'Manual'.tr),
                                    carTool(image: 'assets/petrol.png',title: viewFeatureModal?.featureCar[index].fuelType == '0' ? 'Petrol'.tr : viewFeatureModal?.featureCar[index].fuelType == '1' ? 'Diesel'.tr : viewFeatureModal?.featureCar[index].fuelType == '2' ? 'Electric'.tr : viewFeatureModal?.featureCar[index].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr),
                                    carTool(image: 'assets/seat.png', title: '${viewFeatureModal?.featureCar[index].totalSeat} ${'Seats'.tr}'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: notifire.getborderColor),
                          color: notifire.getblackwhitecolor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  awailableCarShimmer() {
    return Container(
      height: 160,
      width: Get.size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 90,
                  width: 140,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: notifire.getblackwhitecolor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 25,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: notifire.getblackwhitecolor,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: notifire.getblackwhitecolor,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 25,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: notifire.getblackwhitecolor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Container(
                    height: 25,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: notifire.getblackwhitecolor,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    height: 25,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: notifire.getblackwhitecolor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Container(
                    height: 25,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: notifire.getblackwhitecolor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        baseColor: notifire.isDark ? Colors.black45 : Colors.grey.shade100,
        highlightColor: notifire.isDark ? Color(0xFF475569) : Color(0xFFeaeff4),
        enabled: true,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: notifire.getborderColor),
        color: notifire.getblackwhitecolor,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget carTool({required String image,  required String title}){
    return Row(
      children: [
        SizedBox(width: 4),
        Image.asset(image, height: 20, width: 20,color: notifire.getwhiteblackcolor),
        SizedBox(width: 4),
        Text(title, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
        SizedBox(width: 10),
      ],
    );
  }

}

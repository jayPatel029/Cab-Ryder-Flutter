// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_typing_uninitialized_variables, non_constant_identifier_names, empty_catches, avoid_print
import 'dart:convert';
import 'package:carlink/model/favorite_modal.dart';
import 'package:carlink/utils/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/controller/favorite_controller.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Custom_widget.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/App_content.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteController favoriteController = Get.find();

  FavoriteModal? favo;
  bool loaders = true;
  Future favCar(uid, cityId) async {
    Map body = {
      "uid": uid,
      "lats": lat,
      "longs": long,
      "cityid": cityId,
    };
    print('Favorite $body');
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.uFavCar), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          favo = favoriteModalFromJson(response.body);
          loaders = false;
        });
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    }catch(e) {}
  }
  Future favorite(uid, carId) async {
    Map body = {
      "uid": uid,
      "car_id": carId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.uFav), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    }catch(e) {}
  }
  bool isLike = false;
  var userId;
  var carId;
  var cId;
  Future getValidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = jsonDecode(sharedPreferences.getString('UserLogin')!);
    cId = jsonDecode(sharedPreferences.getString('lId')!);
    favCar(userId['id'], cId);
  }

  var lat;
  var long;
  latMap() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lat = preferences.getString('lats');
    long = preferences.getString('longs');
  }

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
    latMap();
    getValidate();
    getdarkmodepreviousstate();
    super.initState();
    favoriteController.changShimmer();
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
        title: Text("Favorites".tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor)),
      ),
      body: GetBuilder<FavoriteController>(builder: (favoriteController) {
        return loaders ? loader() : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${favo?.featureCar.length} ${'cars'.tr}".tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor,),),
              Expanded(
                child: favo!.featureCar.isNotEmpty ? ListView.builder(
                  itemCount: favo?.featureCar.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return favoriteController.isLoading
                        ? GestureDetector(
                           onTap: () {
                             Get.bottomSheet(
                               isDismissible: false,
                               backgroundColor: notifire.getbgcolor,
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                               SingleChildScrollView(
                                 child: Padding(
                                   padding: const EdgeInsets.all(10),
                                   child: Column(
                                     crossAxisAlignment:  CrossAxisAlignment.start,
                                     children: [
                                       Center(child: Text('Remove From Favorites?'.tr,style: TextStyle(color: notifire.getwhiteblackcolor,fontFamily: FontFamily.europaBold, fontSize: 18))),
                                       Padding(
                                         padding: const EdgeInsets.symmetric(vertical: 10),
                                         child: Divider(
                                           height: 10,
                                           thickness: 1,
                                           color: Colors.grey,
                                         ),
                                       ),
                                       Row(
                                         children: [
                                           Container(
                                             height: 80,
                                             width: 100,
                                             decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(10),
                                                 image: DecorationImage(image: NetworkImage('${Config.imgUrl}${favo?.featureCar[index].carImg.toString().split("\$;").elementAt(0)}'), fit: BoxFit.cover)
                                             ),
                                           ),
                                           SizedBox(width: 10,),
                                           Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(favo!.featureCar[index].carTitle, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor)),
                                               SizedBox(height: 8),
                                               Text(favo!.featureCar[index].carNumber, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor)),
                                               SizedBox(
                                                 height: 30,
                                                 child: Row(
                                                   children: [
                                                     Image.asset(Appcontent.star1, height: 16),
                                                     SizedBox(width: 5),
                                                     Text(favo!.featureCar[index].carRating, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor)),
                                                   ],
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ],
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 15),
                                         child: Row(
                                           children: [
                                             Expanded(
                                               child: OutlinedButton(
                                                 style: OutlinedButton.styleFrom(
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                   fixedSize: Size(Get.width, 50),
                                                   side: BorderSide(color:  onbordingBlue)
                                                 ),
                                                   onPressed: () {
                                                   Get.back();
                                                   },
                                                   child: Text('Cancel'.tr,style: TextStyle(color: onbordingBlue,fontFamily: FontFamily.europaBold),),
                                               ),
                                             ),
                                             SizedBox(width: 10),
                                             Expanded(
                                               child: ElevatedButton(
                                                 style: ElevatedButton.styleFrom(
                                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                     fixedSize: Size(Get.width, 50),
                                                     backgroundColor: onbordingBlue
                                                 ),
                                                   onPressed: () {
                                                     favorite(userId['id'], favo?.featureCar[index].id).then((value) {
                                                       if(value['ResponseCode'] == '200') {
                                                         favCar(userId['id'], cId);
                                                         setState(() {
                                                           isLike = !isLike;
                                                         });
                                                         Get.back();
                                                         Fluttertoast.showToast(msg: value['ResponseMsg']);
                                                       } else {
                                                         Fluttertoast.showToast(msg: value['ResponseMsg']);
                                                       }
                                                     });
                                                   },
                                                   child: Text('Yes, Remove'.tr,style: TextStyle(color: Colors.white,fontFamily: FontFamily.europaBold),),
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             );
                           },
                          child: Container(
                            height: 250,
                            width: Get.size.width,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: 204,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(image: NetworkImage('${Config.imgUrl}${favo?.featureCar[index].carImg.toString().split("\$;").elementAt(0)}'), fit: BoxFit.cover)
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.7, 0.8, 1.5],
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.9),
                                              Colors.black.withOpacity(0.9),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Image.asset(Appcontent.favorite,color: Colors.red,height: 28,),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          height: 30,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: blurRating(rating: favo!.featureCar[index].carRating, color: Colors.white, context: context),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        right: 20,
                                        bottom: 10,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(favo!.featureCar[index].carTitle, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                            Text(favo!.featureCar[index].carNumber, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        carTool(image: Appcontent.engine,  number: favo!.featureCar[index].engineHp, text: 'hp'.tr),
                                        carTool(image: Appcontent.gearbox, title: favo!.featureCar[index].carGear == '1' ? 'Automatic'.tr : 'Manual'.tr),
                                        carTool(image: Appcontent.petrol,title: '${favo!.featureCar[index].fuelType == '0' ?"Petrol".tr : favo!.featureCar[index].fuelType == '1' ?"Diesel".tr :favo!.featureCar[index].fuelType == '2' ? 'Electric'.tr : favo!.featureCar[index].fuelType == '3' ? 'CNG'.tr:'Petrol & CNG'.tr} '),
                                        carTool(image: Appcontent.seat, number: favo!.featureCar[index].totalSeat, text: 'Seats'.tr),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: notifire.getCarColor,
                            ),
                          ),
                        ) : carRecomendationShimmer(notifire);
                  },
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Appcontent.ematyState, height: 96),
                    SizedBox(height: 20),
                    Text('No favorite yet!'.tr, style: TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor)),
                    SizedBox(height: 10),
                    Text('It can be used to express that something is not someone Favorites'.tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff, color: greyScale), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  Widget carTool({required String image,  String? title, String? number, String? text}){
    return Row(
      children: [
        SizedBox(width: 10),
        Image.asset(image, height: 20, width: 20, color: notifire.getwhiteblackcolor),
        SizedBox(width: 4),
        Text(title?? '', style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
        RichText(text: TextSpan(
          children: [
            TextSpan(text: number,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: text,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            WidgetSpan(child: SizedBox(width: 8)),
          ],
        )),
      ],
    );
  }
}

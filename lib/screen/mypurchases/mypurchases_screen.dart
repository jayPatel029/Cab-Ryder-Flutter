// ignore_for_file: empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/bookhistory_modal.dart';
import 'package:carlink/screen/mypurchases/bookdetail_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/common.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/common_ematy.dart';

class MyPurchasesScreen extends StatefulWidget {
  const MyPurchasesScreen({super.key});

  @override
  State<MyPurchasesScreen> createState() => _MyPurchasesScreenState();
}

class _MyPurchasesScreenState extends State<MyPurchasesScreen> {
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
  }

  int inDex = 0;

  // Booked
  BookHistoryModal? bookHistory;
  bool isLoading = true;
  Future bHistory(uid, status) async {
    Map body = {
      "uid": uid,
      "status": status,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.bookHistory), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          bookHistory = bookHistoryModalFromJson(response.body);
          isLoading = false;
        });
      } else {}
    }catch(e){}
  }

  // History
  BookHistoryModal? bookHistory1;
  Future bHistory1(uid, status) async {
    Map body = {
      "uid": uid,
      "status": status,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.bookHistory), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          bookHistory1 = bookHistoryModalFromJson(response.body);
          isLoading = false;
        });
      } else {}
    }catch(e){}
  }
  List temp =[];
  var id;
  var currencies;
  Future getvalidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = jsonDecode(sharedPreferences.getString('UserLogin')!);
    currencies = jsonDecode(sharedPreferences.getString('bannerData')!);
    bHistory(id['id'], 'Booked');
    bHistory1(id['id'], 'Past');
  }

  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: notifire.getbgcolor,
        appBar: AppBar(
          backgroundColor: notifire.getbgcolor,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(12),
              child: Image.asset(Appcontent.back, color: notifire.getwhiteblackcolor),
            ),
          ),
          centerTitle: true,
          title: Text("My Booking".tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 18, color: notifire.getwhiteblackcolor)),
        ),
        body: isLoading ? loader() : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              TabBar(
                indicatorColor: onbordingBlue,
                  padding: const EdgeInsets.all(10),
                  indicator: BoxDecoration(
                    color: onbordingBlue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: notifire.getgreycolor,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontFamily: FontFamily.europaBold),
                  tabs: [
                    Tab(text: 'Booked'.tr),
                    Tab(text: 'History'.tr),
              ]),
              Expanded(
                child: TabBarView(
                    children: [
                      // Booked Data
                      bookHistory!.bookHistory.isEmpty ? ematy(title: 'Booked'.tr,color: notifire.getwhiteblackcolor) : ListView.builder(
                        itemCount: bookHistory?.bookHistory.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index2) {
                          return InkWell(
                            onTap: () {
                              Get.to(BookdetailScreen(id: bookHistory!.bookHistory[index2].bookId));
                            },
                            child: Container(
                              width: Get.size.width,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: notifire.getCarColor,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 204,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 204,
                                          width: Get.width,
                                          // margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            image: DecorationImage(image: NetworkImage('${Config.imgUrl}${bookHistory?.bookHistory[index2].carImg}'), fit: BoxFit.cover),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: const [0.6, 0.8, 1.5],
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
                                          left: 13,
                                          right: 10,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              blurTitle(title: bookHistory!.bookHistory[index2].carTitle,context: context),
                                              blurRating(rating: bookHistory!.bookHistory[index2].carRating, color: Colors.white, context: context),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 13,
                                          right: 13,
                                          bottom: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(bookHistory!.bookHistory[index2].carNumber, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                                Text('${currencies['currency']}${bookHistory!.bookHistory[index2].oTotal == "0" ? bookHistory!.bookHistory[index2].wallAmt : bookHistory!.bookHistory[index2].oTotal} / ${bookHistory!.bookHistory[index2].totalDayOrHr} ${bookHistory!.bookHistory[index2].priceType}', style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                carTools(image: Appcontent.engine,   number: bookHistory!.bookHistory[index2].engineHp, text: 'hp'.tr, color: notifire.getwhiteblackcolor),
                                                carTools(image: Appcontent.gearbox, title: bookHistory!.bookHistory[index2].engineHp == '1' ? 'Automatic'.tr : 'Manual'.tr, color: notifire.getwhiteblackcolor),
                                                carTools(image: Appcontent.petrol,title: bookHistory!.bookHistory[index2].fuelType == '0' ? 'Petrol'.tr : bookHistory!.bookHistory[index2].fuelType == '1' ? 'Diesel'.tr : bookHistory!.bookHistory[index2].fuelType == '2' ? 'Electric'.tr : bookHistory!.bookHistory[index2].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr, color: notifire.getwhiteblackcolor),
                                                carTools(image: Appcontent.seat,  number: bookHistory!.bookHistory[index2].totalSeat, text: 'Seats'.tr, color: notifire.getwhiteblackcolor),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Image.asset(Appcontent.location, height: 20,color: notifire.getwhiteblackcolor),
                                            const SizedBox(width: 8),
                                            Text(bookHistory!.bookHistory[index2].cityTitle, style:  TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor,fontSize: 13)),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Image.asset(Appcontent.calender, height: 20, color: notifire.getwhiteblackcolor),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text("${bookHistory!.bookHistory[index2].pickupDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${bookHistory!.bookHistory[index2].pickupDate.toString().split(" ").first} ${bookHistory!.bookHistory[index2].pickupTime}'))} To ${bookHistory!.bookHistory[index2].returnDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${bookHistory!.bookHistory[index2].returnDate.toString().split(" ").first} ${bookHistory!.bookHistory[index2].returnTime}'))}", style: TextStyle(fontSize: 13,fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor),overflow: TextOverflow.ellipsis)),
                                            const SizedBox(width: 8),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // History(Complete) Data
                      bookHistory1!.bookHistory.isEmpty ? ematy(title: 'History'.tr,color: notifire.getwhiteblackcolor) : ListView.builder(
                        itemCount: bookHistory1?.bookHistory.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index2) {
                          return InkWell(
                            onTap: () {
                              Get.to(BookdetailScreen(id: bookHistory1!.bookHistory[index2].bookId));
                            },
                            child: Container(
                              // height: 250,
                              width: Get.size.width,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: notifire.getCarColor,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 204,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 204,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            image: DecorationImage(image: NetworkImage('${Config.imgUrl}${bookHistory1?.bookHistory[index2].carImg}'), fit: BoxFit.cover),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: const [0.6, 0.8, 1.5],
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
                                          left: 13,
                                          right: 10,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              blurTitle(title: bookHistory1!.bookHistory[index2].carTitle,context: context),
                                              blurRating(rating: bookHistory1!.bookHistory[index2].carRating, color: Colors.white, context: context),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 13,
                                          right: 13,
                                          bottom: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(bookHistory1!.bookHistory[index2].carNumber, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                                Text('${currencies['currency']}${bookHistory1!.bookHistory[index2].oTotal == "0" ? bookHistory1!.bookHistory[index2].wallAmt : bookHistory1!.bookHistory[index2].oTotal} / ${bookHistory1!.bookHistory[index2].totalDayOrHr} ${bookHistory1!.bookHistory[index2].priceType}', style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                carTools(image: Appcontent.engine,   number: bookHistory1!.bookHistory[index2].engineHp, text: 'hp'.tr,color: notifire.getwhiteblackcolor),
                                                carTools(image: Appcontent.gearbox, title: bookHistory1!.bookHistory[index2].engineHp == '1' ? 'Automatic'.tr : 'Manual'.tr, color: notifire.getwhiteblackcolor),
                                                carTools(image: Appcontent.petrol,title: bookHistory1!.bookHistory[index2].fuelType == '0' ? 'Petrol'.tr : bookHistory1!.bookHistory[index2].fuelType == '1' ? 'Diesel'.tr : bookHistory1!.bookHistory[index2].fuelType == '2' ? 'Electric'.tr : bookHistory1!.bookHistory[index2].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr, color: notifire.getwhiteblackcolor),
                                                carTools(image: Appcontent.seat,  number: bookHistory1!.bookHistory[index2].totalSeat, text: 'Seats'.tr, color: notifire.getwhiteblackcolor),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Image.asset(Appcontent.location, height: 20,color: notifire.getwhiteblackcolor),
                                            const SizedBox(width: 8),
                                            Text(bookHistory1!.bookHistory[index2].cityTitle, style:  TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor,fontSize: 13)),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Image.asset(Appcontent.calender, height: 20,color: notifire.getwhiteblackcolor),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text("${bookHistory1!.bookHistory[index2].pickupDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${bookHistory1!.bookHistory[index2].pickupDate.toString().split(" ").first} ${bookHistory1!.bookHistory[index2].pickupTime}'))} To ${bookHistory1!.bookHistory[index2].returnDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${bookHistory1!.bookHistory[index2].returnDate.toString().split(" ").first} ${bookHistory1!.bookHistory[index2].returnTime}'))}", style: TextStyle(fontSize: 13,fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor),overflow: TextOverflow.ellipsis)),
                                            const SizedBox(width: 8),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
carTools({required String image,  String? title, String? number, String? text, Color? color}){
  return Row(
    children: [
      Image.asset(image, height: 20, width: 20, color: color),
      const SizedBox(width: 4),
      Text(title ??'', style: TextStyle(fontFamily: FontFamily.europaWoff, color: color, fontSize: 13)),
      RichText(text: TextSpan(
        children: [
          TextSpan(text: number,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: color, fontSize: 13)),
          const WidgetSpan(child: SizedBox(width: 5)),
          TextSpan(text: text,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: color, fontSize: 13)),
          const WidgetSpan(child: SizedBox(width: 7)),
        ],
      )),
    ],
  );
}
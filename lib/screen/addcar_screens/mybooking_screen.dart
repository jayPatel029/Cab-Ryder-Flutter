// ignore_for_file: empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/mybookhistory_modal.dart';
import 'package:carlink/screen/addcar_screens/mybookingdetail_screen.dart';
import 'package:carlink/screen/mypurchases/mypurchases_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/App_content.dart';
import '../../utils/Colors.dart';
import '../../utils/common_ematy.dart';
import '../../utils/common.dart';
import '../../utils/fontfameli_model.dart';

class MyBookScreen extends StatefulWidget {
  final String? uid;
  final String? dollarSign;
  const MyBookScreen({super.key, this.uid, this.dollarSign});

  @override
  State<MyBookScreen> createState() => _MyBookScreenState();
}
int currentIndex = 0;

class _MyBookScreenState extends State<MyBookScreen> {
  late ColorNotifire notifire;

  @override
  void initState() {
    getvalidate();
    super.initState();
  }

  // Booked
  MyBookingHistoryModal? myBookingHistoryModal;
  bool isLoading = true;
  Future bHistory(uid, status) async {
    Map body = {
      "uid": uid,
      "status": status,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.myBookHistory), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          myBookingHistoryModal = myBookingHistoryModalFromJson(response.body);
          isLoading = false;
        });
      } else {}
    }catch(e){}
  }

  // History
  MyBookingHistoryModal? myBookingHistoryModal1;
  Future bHistory1(uid, status) async {
    Map body = {
      "uid": uid,
      "status": status,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.myBookHistory), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          myBookingHistoryModal1 = myBookingHistoryModalFromJson(response.body);
          isLoading = false;
        });
      } else {}
    }catch(e){}
  }

  var id;
  var currencies;
  Future getvalidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = widget.uid == "0" ? "0" :  jsonDecode(sharedPreferences.getString('UserLogin')!);
    currencies = widget.uid == "0" ? "0" :  jsonDecode(sharedPreferences.getString('bannerData')!);
    bHistory(widget.uid == "0" ? "0" : id['id'], 'Booked');
    bHistory1(widget.uid == "0" ? "0" : id['id'], 'Past');
  }
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of(context, listen: true);
    return DefaultTabController(
      length: 2,
      initialIndex: currentIndex,
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
        body: isLoading ? loader() : Column(
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
                tabs:  [
                  Tab(text: 'Booked'.tr),
                  Tab(text: 'History'.tr),
                ]),
            Expanded(
              child: TabBarView(
                  children: [
                    // Booked Data
                    myBookingHistoryModal!.bookHistory.isEmpty ? ematy(title: 'Booked'.tr, color: notifire.getwhiteblackcolor) : ListView.builder(
                      itemCount: myBookingHistoryModal?.bookHistory.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index2) {
                        return InkWell(
                          onTap: () {
                            Get.to(MyBookingDetailScreen(bookId: myBookingHistoryModal!.bookHistory[index2].bookId, uid: widget.uid == "0" ? "0" : id['id'],  dollarSign: widget.dollarSign));
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
                                        // margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          image: DecorationImage(image: NetworkImage('${Config.imgUrl}${myBookingHistoryModal?.bookHistory[index2].carImg}'), fit: BoxFit.cover),
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
                                            blurTitle(title: myBookingHistoryModal!.bookHistory[index2].carTitle,context: context),
                                            blurRating(rating: myBookingHistoryModal!.bookHistory[index2].carRating, color: Colors.white, context: context),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: 13,
                                        right: 13,
                                        bottom: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(myBookingHistoryModal!.bookHistory[index2].carNumber, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                              Text('${widget.uid == "0" ? widget.dollarSign : currencies['currency']}${myBookingHistoryModal!.bookHistory[index2].carPrice} / ${myBookingHistoryModal!.bookHistory[index2].totalDayOrHr} ${myBookingHistoryModal!.bookHistory[index2].priceType}', style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, bottom: 10),
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
                                              carTools(image: Appcontent.engine,   number: myBookingHistoryModal!.bookHistory[index2].engineHp, text: 'hp'.tr, color: notifire.getwhiteblackcolor),
                                              carTools(image: Appcontent.gearbox, title: myBookingHistoryModal!.bookHistory[index2].engineHp == '1' ? 'Automatic'.tr : 'Manual'.tr, color: notifire.getwhiteblackcolor),
                                              carTools(image: Appcontent.petrol,title: myBookingHistoryModal!.bookHistory[index2].fuelType == '0' ? 'Petrol'.tr : myBookingHistoryModal!.bookHistory[index2].fuelType == '1' ? 'Diesel'.tr : myBookingHistoryModal!.bookHistory[index2].fuelType == '2' ? 'Electric'.tr : myBookingHistoryModal!.bookHistory[index2].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr, color: notifire.getwhiteblackcolor),
                                              carTools(image: Appcontent.seat,  number: myBookingHistoryModal!.bookHistory[index2].totalSeat, text: 'Seats'.tr, color: notifire.getwhiteblackcolor),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Image.asset(Appcontent.location, height: 20,width: 20,color: notifire.getwhiteblackcolor),
                                          const SizedBox(width: 8),
                                          Text(myBookingHistoryModal!.bookHistory[index2].cityTitle, style:  TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor,fontSize: 13)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Image.asset(Appcontent.calender, height: 20,width: 20,color: notifire.getwhiteblackcolor),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text("${myBookingHistoryModal!.bookHistory[index2].pickupDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${myBookingHistoryModal!.bookHistory[index2].pickupDate.toString().split(" ").first} ${myBookingHistoryModal!.bookHistory[index2].pickupTime}'))} To ${myBookingHistoryModal!.bookHistory[index2].returnDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${myBookingHistoryModal!.bookHistory[index2].returnDate.toString().split(" ").first} ${myBookingHistoryModal!.bookHistory[index2].returnTime}'))}", style: TextStyle(fontSize: 13,fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor),overflow: TextOverflow.ellipsis)),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
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
                    myBookingHistoryModal1!.bookHistory.isEmpty ? ematy(title: 'History'.tr, color:  notifire.getwhiteblackcolor) : ListView.builder(
                      itemCount: myBookingHistoryModal1?.bookHistory.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index2) {
                        return InkWell(
                          onTap: () {
                            Get.to(MyBookingDetailScreen(bookId: myBookingHistoryModal1!.bookHistory[index2].bookId, uid: widget.uid == "0" ? "0" : id['id'], dollarSign: widget.dollarSign));
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
                                        // margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          image: DecorationImage(image: NetworkImage('${Config.imgUrl}${myBookingHistoryModal1?.bookHistory[index2].carImg}'), fit: BoxFit.cover),
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
                                            blurTitle(title: myBookingHistoryModal1!.bookHistory[index2].carTitle,context: context),
                                            blurRating(rating: myBookingHistoryModal1!.bookHistory[index2].carRating, color: Colors.white, context: context),
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
                                              Text(myBookingHistoryModal1!.bookHistory[index2].carNumber, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                              Text('${widget.uid == "0" ? widget.dollarSign :currencies['currency']}${myBookingHistoryModal1!.bookHistory[index2].carPrice} / ${myBookingHistoryModal1!.bookHistory[index2].totalDayOrHr} ${myBookingHistoryModal1!.bookHistory[index2].priceType}', style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, bottom: 10),
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
                                              carTools(image: Appcontent.engine,   number: myBookingHistoryModal1!.bookHistory[index2].engineHp, text: 'hp'.tr, color: notifire.getwhiteblackcolor),
                                              carTools(image: Appcontent.gearbox, title: myBookingHistoryModal1!.bookHistory[index2].engineHp == '1' ? 'Automatic'.tr : 'Manual'.tr, color: notifire.getwhiteblackcolor),
                                              carTools(image: Appcontent.petrol,title: myBookingHistoryModal1!.bookHistory[index2].fuelType == '0' ? 'Petrol'.tr : myBookingHistoryModal1!.bookHistory[index2].fuelType == '1' ? 'Diesel'.tr : myBookingHistoryModal1!.bookHistory[index2].fuelType == '2' ? 'Electric'.tr : myBookingHistoryModal1!.bookHistory[index2].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr, color: notifire.getwhiteblackcolor),
                                              carTools(image: Appcontent.seat,  number: myBookingHistoryModal1!.bookHistory[index2].totalSeat, text: 'Seats'.tr, color: notifire.getwhiteblackcolor),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Image.asset(Appcontent.location, height: 20,width: 20,color: notifire.getwhiteblackcolor),
                                          const SizedBox(width: 8),
                                          Text(myBookingHistoryModal1!.bookHistory[index2].cityTitle, style:  TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor,fontSize: 13)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Image.asset(Appcontent.calender, height: 20,width: 20,color: notifire.getwhiteblackcolor),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text("${myBookingHistoryModal1!.bookHistory[index2].pickupDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${myBookingHistoryModal1!.bookHistory[index2].pickupDate.toString().split(" ").first} ${myBookingHistoryModal1!.bookHistory[index2].pickupTime}'))} To ${myBookingHistoryModal1!.bookHistory[index2].returnDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${myBookingHistoryModal1!.bookHistory[index2].returnDate.toString().split(" ").first} ${myBookingHistoryModal1!.bookHistory[index2].returnTime}'))}", style: TextStyle(fontSize: 13,fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor),overflow: TextOverflow.ellipsis)),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
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
    );
  }
}

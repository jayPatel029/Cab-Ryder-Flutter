// ignore_for_file: empty_catches, prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:convert';
import 'package:carlink/model/mybookdetail_modal.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/common.dart';
import 'package:carlink/utils/config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/favorite_controller.dart';
import '../../model/mybookhistory_modal.dart';
import '../../utils/App_content.dart';
import 'package:http/http.dart' as http;
import '../../utils/Colors.dart';
import '../../utils/fontfameli_model.dart';

class MyBookingDetailScreen extends StatefulWidget {
  final String? uid;
  final String bookId;
  final String? dollarSign;
  const MyBookingDetailScreen({super.key, required this.bookId, this.uid, this.dollarSign});

  @override
  State<MyBookingDetailScreen> createState() => _MyBookingDetailScreenState();
}

class _MyBookingDetailScreenState extends State<MyBookingDetailScreen> {
  int inDex =0;
  int _current = 0;
  List image=[];
  List temp=[];
  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    getvalidate();
    addCustomIcon();
    super.initState();
  }
  MyBookDetailModal? myBookDetailModal;
  bool isLoading = true;
  // Book Detail Api
  Future bDetail(uid, bId) async {
    Map body = {
      "uid": uid,
      "book_id": bId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.myBookDetails), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          myBookDetailModal = myBookDetailModalFromJson(response.body);
          image = myBookDetailModal!.bookDetails[inDex].carImg.toString().split("\$;");
          isLoading = false;
        });
        for(int i=0; i < myBookDetailModal!.bookDetails[0].exterPhoto.length; i++){
          listOfUrls.add("${Config.imgUrl}${myBookDetailModal!.bookDetails[0].exterPhoto[i]}");
          setState(() {});
        }
        for(int i=0; i < myBookDetailModal!.bookDetails[0].interPhoto.length; i++){
          listOfUrls1.add("${Config.imgUrl}${myBookDetailModal!.bookDetails[0].interPhoto[i]}");
          setState(() {});
        }
      } else {}
    }catch(e){}
  }

  Future complete(uid, bId) async {
    Map body = {
      "uid": uid,
      "book_id": bId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.completeBook), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        return data;
      } else{}
    } catch(e){}
  }
  MyBookingHistoryModal? myBookingHistoryModal;
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
  var id;
  var currencies;
  Future getvalidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = widget.uid == "0" ? "0" : jsonDecode(sharedPreferences.getString('UserLogin')!);
    currencies =widget.uid == "0" ? "0" : jsonDecode(sharedPreferences.getString('bannerData')!);
    bDetail(widget.uid == "0"? "0" : id['id'], widget.bookId);
  }
  late ColorNotifire notifire;
  late GoogleMapController mapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), Appcontent.mapPin).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    },
    );
  }
  Future<void> _refresh()async {
    Future.delayed(const Duration(seconds: 1),() {
      setState(() {
        bDetail(id['id'], widget.bookId);
      });
    },);
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  bool loading = false;
  OtpFieldController otpFieldController = OtpFieldController();
  String code = "";
  String code1 = "";
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of(context, listen: true);
    return RefreshIndicator(
      onRefresh: _refresh,
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
          title: Text("Booking Detail".tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 18, color: notifire.getwhiteblackcolor)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: isLoading ? const SizedBox() :   myBookDetailModal!.bookDetails[0].bookStatus == "Pending" ? Container(
          height: 110,
          decoration: BoxDecoration(
              color: notifire.getbgcolor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
          ),
          child: Column(
            children: [
              ListTile(
                leading: Image.asset(Appcontent.customerPickup),
                title: Text('Customer Pickup Pending'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 16)),
                subtitle: Text('Your car pickup is scheduled. Please have the car, documents, and key ready at your provided location'.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 14)),
              ),
            ],
          ),
        ) : myBookDetailModal!.bookDetails[0].bookStatus == "Pick_up" ?  Container(
          height: Get.height / 6,
          decoration: BoxDecoration(
              color: notifire.getbgcolor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
          ),
          child: Column(
            children: [
              ListTile(
                leading: Image.asset(Appcontent.customerPickup),
                title: Text('Relax, your car is coming to you shortly'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 16)),
                subtitle: RichText(text: TextSpan(
                  children: [
                    TextSpan(text: 'Great news! Your car pickup is complete. '.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 14)),
                    TextSpan(text: '[${myBookDetailModal?.bookDetails[0].customerName} - ${myBookDetailModal?.bookDetails[0].customerContact}] ', style: TextStyle(fontFamily: FontFamily.europaBold, color: onbordingBlue, fontSize: 14)),
                    TextSpan(text: 'will drop it off at your provided location by '.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 14)),
                    TextSpan(text: '${myBookDetailModal!.bookDetails[0].pickupDate.toString().split(" ").first} ${DateFormat('hh:mm a').format(DateTime.parse('${myBookDetailModal!.bookDetails[0].pickupDate.toString().split(" ").first} ${myBookDetailModal!.bookDetails[0].pickupTime}'))} - ${myBookDetailModal!.bookDetails[0].returnDate.toString().split(" ").first} ${DateFormat('hh:mm a').format(DateTime.parse('${myBookDetailModal!.bookDetails[0].returnDate.toString().split(" ").first} ${myBookDetailModal!.bookDetails[0].returnTime}'))}.', style: TextStyle(fontFamily: FontFamily.europaBold, color: onbordingBlue, fontSize: 14)),
                  ],
                )),
              ),
            ],
          ),
        ) : myBookDetailModal!.bookDetails[0].bookStatus == "Drop" ? Container(
          height: 155,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: notifire.getbgcolor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
          ),
          child: Column(
            children: [
              Text('Please inspect the car for any scratches, dents, or interior damage, collect the necessary documents from the customer, and then mark this booking as complete.'.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 14),textAlign: TextAlign.center),
              const SizedBox(height: 13),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      isDismissible: false,
                      isScrollControlled: true,
                      backgroundColor: notifire.getbgcolor,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.all(13),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(child: Image.asset(Appcontent.drop,height: 96)),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xffEEF2F6), width: 1),
                                    ),
                                    child: Center(
                                      child: ListTile(
                                        leading: Container(
                                          height: 48,
                                          width: 48,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Center(
                                            child: Image.asset(Appcontent.mappin1, height: 22, width: 22,),
                                          ),
                                        ),
                                        title: Text('Drop Location'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontWeight: FontWeight.w700, fontSize: 16, color: notifire.getwhiteblackcolor),),
                                        subtitle: Text(myBookDetailModal!.bookDetails[0].cityTitle, style: TextStyle(fontFamily: FontFamily.europaWoff, fontWeight: FontWeight.w700, fontSize: 16, color: greyScale1),),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    margin: const EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: GoogleMap(
                                        minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                                        gestureRecognizers: {
                                          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                                        },
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId('1'),
                                            position: LatLng(double.parse(myBookDetailModal!.bookDetails[0].pickLat), double.parse(myBookDetailModal!.bookDetails[0].pickLng)),
                                            icon: markerIcon,
                                          ),
                                        },
                                        initialCameraPosition:  CameraPosition(
                                          target: LatLng(double.parse(myBookDetailModal!.bookDetails[0].pickLat), double.parse(myBookDetailModal!.bookDetails[0].pickLng)), //initial position
                                          zoom: 15.0, //initial zoom level
                                        ),
                                        mapType: MapType.normal,
                                        myLocationEnabled: true,
                                        compassEnabled: true,
                                        zoomGesturesEnabled: true,
                                        tiltGesturesEnabled: true,
                                        zoomControlsEnabled: true,
                                        onMapCreated: (controller) {
                                          setState(() {
                                            mapController = controller;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  loading ? loader() : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(Get.width, 56),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      backgroundColor: onbordingBlue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        loading = true;
                                      });
                                      complete(widget.uid == "0"? "0" : id['id'], widget.bookId).then((value) {
                                        if(value["ResponseCode"] == "200"){
                                          bDetail(widget.uid == "0"? "0" : id['id'], widget.bookId);
                                          bHistory(widget.uid == "0"? "0" : id['id'], widget.bookId);
                                          setState(() {
                                            loading = false;
                                          });
                                          Get.back();
                                          Fluttertoast.showToast(msg: value['ResponseMsg']);
                                        } else{
                                          setState(() {
                                            loading = false;
                                          });
                                          Fluttertoast.showToast(msg: value['ResponseMsg']);
                                        }
                                      });
                                    },
                                    child:  Text('Complete your Booking'.tr, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                                  ),
                                  const SizedBox(height: 10),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      fixedSize: Size(Get.width, 56),
                                      side: BorderSide(color: greyScale),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),side: const BorderSide(color: Colors.black)),
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child:  Text('Cancel'.tr, style:  TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        );
                      });
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: onbordingBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:   Center(child: Text('Got your car? Tap here to complete your booking.'.tr, style: const TextStyle(color: Colors.white, fontFamily: FontFamily.europaBold))),
                ),
              ),
            ],
          ),
        ) : const SizedBox(),
        body: isLoading ? loader() : GetBuilder<BookdetailController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: myBookDetailModal?.bookDetails.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 245,
                        width: Get.size.width,
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
                                  image.length == 1 ? Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: Get.width,
                                        // margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(image: NetworkImage('${Config.imgUrl}${image[index]}'), fit: BoxFit.cover),
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
                                    ],
                                  ) : CarouselSlider.builder(
                                    carouselController: carouselController,
                                    itemCount: image.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: Get.width,
                                            // margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              image: DecorationImage(image: NetworkImage('${Config.imgUrl}${image[index]}'), fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
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
                                        ],
                                      );
                                    },
                                    options: CarouselOptions(
                                      viewportFraction: 1,
                                      initialPage: 0,
                                      aspectRatio: Get.width /23 /9,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 20,
                                    right: 20,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        blurTitle(title: myBookDetailModal!.bookDetails[index].carTitle,context: context),
                                        blurRating(rating: myBookDetailModal!.bookDetails[index].carRating, color: Colors.white, context: context),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    right: 20,
                                    bottom: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(myBookDetailModal!.bookDetails[index].carNumber, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                          image.length == 1 ? const SizedBox() :Center(
                                            child: SizedBox(
                                              height: 6,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: image.length,
                                                  itemBuilder: (context, index) {
                                                    return GestureDetector(
                                                      onTap: () => carouselController.animateToPage(index),
                                                      child: Container(
                                                        width: _current == index ? 24 : 6,
                                                        height: 6,
                                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: _current == index ? onbordingBlue : Colors.grey,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                          Text('${widget.uid == "0" ? widget.dollarSign :currencies['currency']}${myBookDetailModal!.bookDetails[index].oTotal == "0" ? myBookDetailModal!.bookDetails[index].wallAmt : myBookDetailModal!.bookDetails[index].oTotal} / ${myBookDetailModal!.bookDetails[index].totalDayOrHr} ${myBookDetailModal!.bookDetails[index].priceType}', style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    carTool(image: Appcontent.engine,  number: myBookDetailModal!.bookDetails[index].engineHp, text: 'hp'.tr),
                                    carTool(image: Appcontent.gearbox, title: myBookDetailModal!.bookDetails[index].engineHp == '1' ? 'Automatic'.tr : 'Manual'.tr),
                                    carTool(image: Appcontent.petrol,title: myBookDetailModal!.bookDetails[index].fuelType == '0' ? 'Petrol'.tr : myBookDetailModal!.bookDetails[index].fuelType == '1' ? 'Diesel'.tr : myBookDetailModal!.bookDetails[index].fuelType == '2' ? 'Electric'.tr : myBookDetailModal!.bookDetails[index].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr),
                                    carTool(image: Appcontent.seat, number: myBookDetailModal!.bookDetails[index].totalSeat, text: 'Seats'.tr),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text('Customer details'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            myBookDetailModal!.bookDetails[index].customerImg.isEmpty ? const CircleAvatar(backgroundImage: AssetImage(Appcontent.profile)) : CircleAvatar(backgroundImage: NetworkImage('${Config.imgUrl}${myBookDetailModal!.bookDetails[index].customerImg}')),
                            const SizedBox(width: 13),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(myBookDetailModal!.bookDetails[index].customerName, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                                Text(myBookDetailModal!.bookDetails[index].customerContact, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getgreycolor, fontSize: 13)),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () async {
                                _makePhoneCall(myBookDetailModal!.bookDetails[index].customerContact);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.20),
                                ),
                                child: Center(child: Icon(Icons.call, color: onbordingBlue, size: 23)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      myBookDetailModal?.bookDetails[index].bookStatus == "Pending" ? Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: greyScale.withOpacity(0.30)),
                          borderRadius:  BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Image.asset(Appcontent.otpImage, height: 48),
                            const SizedBox(width: 13),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('OTP(For pickup the car)'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          color: onbordingBlue,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:  Center(child: Text(myBookDetailModal!.bookDetails[index].pickOtp[0], style: const TextStyle(fontSize: 18,fontFamily: FontFamily.europaWoff, color: Colors.white))),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          color: onbordingBlue,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:  Center(child: Text(myBookDetailModal!.bookDetails[index].pickOtp[1], style: const TextStyle(fontSize: 18,fontFamily: FontFamily.europaWoff, color: Colors.white))),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          color: onbordingBlue,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:  Center(child: Text(myBookDetailModal!.bookDetails[index].pickOtp[2], style: const TextStyle(fontSize: 18,fontFamily: FontFamily.europaWoff, color: Colors.white))),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: onbordingBlue,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:  Center(child: Text(myBookDetailModal!.bookDetails[index].pickOtp[3], style: const TextStyle(fontSize: 18,fontFamily: FontFamily.europaWoff, color: Colors.white))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ) : myBookDetailModal?.bookDetails[index].bookStatus == "Pick_up" ?  Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: greyScale.withOpacity(0.30)),
                          borderRadius:  BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Image.asset(Appcontent.otpImage, height: 48),
                            const SizedBox(width: 13),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('OTP(For Drop the car)'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          color: onbordingBlue,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:  Center(child: Text(myBookDetailModal!.bookDetails[index].dropOtp[0], style: const TextStyle(fontSize: 18,fontFamily: FontFamily.europaWoff, color: Colors.white))),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          color: onbordingBlue,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:  Center(child: Text(myBookDetailModal!.bookDetails[index].dropOtp[1], style: const TextStyle(fontSize: 18,fontFamily: FontFamily.europaWoff, color: Colors.white))),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          color: onbordingBlue,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:  Center(child: Text(myBookDetailModal!.bookDetails[index].dropOtp[2], style: const TextStyle(fontSize: 18,fontFamily: FontFamily.europaWoff, color: Colors.white))),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: onbordingBlue,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:  Center(child: Text(myBookDetailModal!.bookDetails[index].dropOtp[3], style: const TextStyle(fontSize: 18,fontFamily: FontFamily.europaWoff, color: Colors.white))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ) : const SizedBox(),

                      const SizedBox(height: 10),
                      Text( 'Car Location'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 20)),
                      Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            markers: {
                              Marker(
                                markerId: const MarkerId('1'),
                                position: LatLng(double.parse(myBookDetailModal!.bookDetails[index].pickLat), double.parse(myBookDetailModal!.bookDetails[index].pickLng)),
                                icon: markerIcon,
                              ),
                            },
                            initialCameraPosition:  CameraPosition(target: LatLng(double.parse(myBookDetailModal!.bookDetails[index].pickLat), double.parse(myBookDetailModal!.bookDetails[index].pickLng)), zoom: 15.0),
                            mapType: MapType.normal,
                            myLocationEnabled: false,
                            zoomGesturesEnabled: true,
                            tiltGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            onMapCreated: (controller) {
                              setState(() {
                                mapController = controller;
                              });
                            },
                          ),
                        ),
                      ),
                      RichText(text: TextSpan(
                        children: [
                          WidgetSpan(child: Image.asset(Appcontent.location, height: 18, color: notifire.getwhiteblackcolor)),
                          const WidgetSpan(child: SizedBox(width: 10)),
                          TextSpan(text: myBookDetailModal!.bookDetails[index].cityTitle,style: TextStyle(color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
                        ],
                      )),
                      const SizedBox(height: 15),
                      Text('Detail'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      Row(
                        children: [
                          Image.asset(Appcontent.filetext, color: notifire.getwhiteblackcolor, height: 30),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Booking ID'.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 15)),
                              Text(myBookDetailModal!.bookDetails[index].bookId, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(Appcontent.calender, height: 30, color: notifire.getwhiteblackcolor),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pick-up'.tr, maxLines: 1, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 15, overflow: TextOverflow.ellipsis)),
                              Text('${myBookDetailModal!.bookDetails[index].pickupDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${myBookDetailModal!.bookDetails[index].pickupDate.toString().split(" ").first} ${myBookDetailModal!.bookDetails[index].pickupTime}'))}', maxLines: 1, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 13, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Drop-off'.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 15, overflow: TextOverflow.ellipsis)),
                              Text('${myBookDetailModal!.bookDetails[index].returnDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${myBookDetailModal!.bookDetails[index].returnDate.toString().split(" ").first} ${myBookDetailModal!.bookDetails[index].returnTime}'))}', style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 13, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const SizedBox(width: 13),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text('Payment information'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),

                      const SizedBox(height: 8),
                      listTile(title: '${'Car Price'.tr} (${myBookDetailModal!.bookDetails[index].bookType} driver)'.tr, subtitle: '${widget.uid == "0" ? widget.dollarSign :currencies['currency']}${myBookDetailModal!.bookDetails[index].carPrice}'),
                      listTile(title: 'Type'.tr, subtitle: '${myBookDetailModal!.bookDetails[index].totalDayOrHr} ${myBookDetailModal!.bookDetails[index].priceType}'),

                      listTile(title: 'Subtotal'.tr, subtitle: '${widget.uid == "0" ? widget.dollarSign :currencies['currency']}${myBookDetailModal!.bookDetails[index].subtotal}'),

                      myBookDetailModal!.bookDetails[index].couAmt == '0' ?const SizedBox() : listTile(title: 'Coupon Amount'.tr, subtitle: '${widget.uid == "0" ? widget.dollarSign :currencies['currency']}${myBookDetailModal!.bookDetails[index].couAmt}'),
                      myBookDetailModal!.bookDetails[index].wallAmt == '0' ?const SizedBox() :listTile(title: 'Wallet Amount'.tr, subtitle: '${widget.uid == "0" ? widget.dollarSign :currencies['currency']}${myBookDetailModal!.bookDetails[index].wallAmt}'),
                      myBookDetailModal!.bookDetails[index].transactionId =='0'?const SizedBox() :listTile(title: '${'Taxes & Fee'.tr} (${myBookDetailModal!.bookDetails[index].taxPer} %)', subtitle: '${widget.uid == "0" ? widget.dollarSign :currencies['currency']}${myBookDetailModal!.bookDetails[index].taxAmt}'.tr),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          height: 10,
                          color: greyScale,
                        ),
                      ),
                      myBookDetailModal!.bookDetails[index].transactionId =='0'?const SizedBox() : listTile(title: 'Total with taxes'.tr, subtitle: '${widget.uid == "0" ? widget.dollarSign :currencies['currency']}${myBookDetailModal!.bookDetails[index].oTotal}'),

                      Text('Payment Method'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      const SizedBox(height: 8),
                      myBookDetailModal!.bookDetails[index].transactionId == '0' ?   listTile(title: 'Payment Method Name'.tr, subtitle: "Wallet".tr) :   listTile(title: 'Payment Method Name'.tr, subtitle: myBookDetailModal!.bookDetails[index].paymentMethodName),
                      myBookDetailModal!.bookDetails[index].transactionId =='0'?const SizedBox() : listTile(title: 'Transaction ID'.tr, subtitle: myBookDetailModal!.bookDetails[index].transactionId),
                      const SizedBox(height: 8),

                      myBookDetailModal!.bookDetails[index].exterPhoto.isEmpty ?const SizedBox() :Text('Interior & Exterior Image'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      myBookDetailModal!.bookDetails[index].exterPhoto.isEmpty ?const SizedBox() :const SizedBox(height: 8),
                      myBookDetailModal!.bookDetails[index].exterPhoto.isEmpty ?const SizedBox() : GalleryImage(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                        childAspectRatio: 0.8,
                        imageRadius: 13,
                        closeWhenSwipeDown: true,
                        showAppBar: false,
                        imageUrls: listOfUrls,
                        numOfShowImages: listOfUrls.length,
                        titleGallery: 'Gallery'.tr,
                      ),
                      myBookDetailModal!.bookDetails[index].exterPhoto.isEmpty ?const SizedBox() :const SizedBox(height: 13),
                      myBookDetailModal!.bookDetails[index].interPhoto.isEmpty ?const SizedBox() :Text('ID Proof or Driving License Image'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      myBookDetailModal!.bookDetails[index].exterPhoto.isEmpty ?const SizedBox() :const SizedBox(height: 8),
                      myBookDetailModal!.bookDetails[index].interPhoto.isEmpty ?const SizedBox() : GalleryImage(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                        childAspectRatio: 0.8,
                        imageRadius: 13,
                        closeWhenSwipeDown: true,
                        showAppBar: false,
                        imageUrls: listOfUrls1,
                        numOfShowImages: listOfUrls1.length,
                        titleGallery: 'Gallery'.tr,
                      ),

                      myBookDetailModal!.bookDetails[index].bookStatus == "Completed" ?  const SizedBox(): myBookDetailModal!.bookDetails[index].bookStatus == "Cancelled" ? const SizedBox():const SizedBox(height: 150),
                    ],
                  );
                },),
            );
          },
        ),
      ),
    );
  }
  List<String> listOfUrls =[];
  List<String> listOfUrls1 =[];
  StreamController<Widget> overlayController = StreamController<Widget>.broadcast();
  Widget listTile({required String title, required String subtitle}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 15)),
          Text(subtitle, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15)),
        ],
      ),
    );
  }
  Widget carTool({required String image,  String? title,String? number, String? text}){
    return Row(
      children: [
        const SizedBox(width: 8),
        Image.asset(image, height: 20, width: 20,color: notifire.getwhiteblackcolor),
        const SizedBox(width: 4),
        Text(title ??'', style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
        RichText(text: TextSpan(
          children: [
            TextSpan(text: number,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            const WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: text,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            const WidgetSpan(child: SizedBox(width: 7)),
          ],
        )),
      ],
    );
  }
}

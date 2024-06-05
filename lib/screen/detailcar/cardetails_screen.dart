// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, unused_field, sized_box_for_whitespace, camel_case_types, empty_catches, unnecessary_null_comparison, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/carinfo_modal.dart';
import 'package:carlink/model/review_modal.dart';
import 'package:carlink/utils/common_ematy.dart';
import 'package:carlink/utils/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/controller/cardetails_controller.dart';
import 'package:carlink/screen/detailcar/detailsviewall_screen.dart';
import 'package:carlink/screen/detailcar/buycardetails_screen.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Custom_widget.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/common_sliverappbar.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/App_content.dart';

class CarDetailsScreen extends StatefulWidget {
  final String id;
  final String currency;
  const CarDetailsScreen({super.key, required this.id, required this.currency});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  CardetailsController cardetailsController = Get.find();

  @override
  void initState() {
    addCustomIcon();
    getvalidate();
    getdarkmodepreviousstate();
    super.initState();
  }

  late String finalId;
  late CarInfo info;
  bool loading = true;
  Future carInfo(uid) async {
    Map body = {
      "uid" : uid,
      "car_id" : widget.id,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.cInfo), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();

      if(response.statusCode == 200){
        setState(() {
          info = carInfoFromJson(response.body);
          loading = false;
          _onAddMarkerButtonPressed(double.parse(info.carinfo.pickLat), double.parse(info.carinfo.pickLng));
          getLocation();
          Map<String, dynamic> carData = {
            "id" : info.carinfo.id,
            "type_id" : info.carinfo.typeId,
            "city_id" : info.carinfo.cityId,
            "brand_id" : info.carinfo.brandId,
            "car_img" : Config.imgUrl+info.carinfo.carImg[0],
            "car_title" : info.carinfo.carTitle,
            "car_rating" : info.carinfo.carRating,
            "car_type_title" : info.carinfo.carTypeTitle,
            "car_rent_price" : info.carinfo.carRentPrice,
            "price_type" : info.carinfo.priceType,
            "car_rent_price_driver" : info.carinfo.carRentPriceDriver,
            "car_brand_title" : info.carinfo.carBrandTitle,
            "IS_FAVOURITE" : info.carinfo.isFavorite,
          };
          String encode = jsonEncode(carData);
          preferences.setString('carinfo', encode);
          for(int i=0; i<info.galleryImages.length; i++){
            listOfUrls.add(Config.imgUrl+info.galleryImages[i]);
          }
        });
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch(e){}
  }

  ReviewModal? reviewModal;
  Future rateList(carId) async {
    Map body = {
      "car_id" : carId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.rateList), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          reviewModal = reviewModalFromJson(response.body);
          loading = false;
        });
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch(e){}
  }
  Future getvalidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = jsonDecode(sharedPreferences.getString('UserLogin')!);
    carInfo(id['id']);
    rateList(widget.id);
  }
  var distance;
  double _totalDistance = 0;
  Future getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    distance = Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(info.carinfo.pickLat), double.parse(info.carinfo.pickLng));
    _totalDistance += distance;
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

  final controller = PageController(viewportFraction: 0.8, keepPage: true);


  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: notifire.getbgcolor,
        bottomNavigationBar: loading ? SizedBox() : Container(
          height: 70,
          width: Get.size.width,
          alignment: Alignment.center,
          color: notifire.getbgcolor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Price".tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: greyScale, fontSize: 14)),
                  SizedBox(height: 6),
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: '${widget.currency}${info.carinfo.carRentPrice} ', style: TextStyle(color: onbordingBlue, fontFamily: FontFamily.europaBold, fontSize: 20)),
                      TextSpan(text: '/${info.carinfo.priceType == '1' ? "hr".tr : "days".tr}', style: TextStyle(color: Colors.grey, fontFamily: FontFamily.europaWoff, fontSize: 15)),
                    ],
                  )),
                ],
              ),
              Spacer(),
              GestButton(
                height: 50,
                Width: 160,
                margin: EdgeInsets.all(8),
                buttoncolor: onbordingBlue,
                buttontext: "Book Now".tr,
                style: TextStyle(
                  fontFamily: FontFamily.europaBold,
                  color: WhiteColor,
                  fontSize: 15,
                ),
                onclick: () {
                  Get.to(BuyCarDetailsScreen(CarId: info.carinfo.id, price: '${widget.currency} ${info.carinfo.carRentPrice}', withDriver: '${widget.currency}${info.carinfo.carRentPriceDriver}', ptype: info.carinfo.priceType == '1' ? "hr" : "days", minHrs: info.carinfo.minHrs));
                },
              ),
            ],
          ),
        ),
        body: loading ? loader() : CollapsingAppBarPage(
          Id: widget.id,
          favorite: info.carinfo.isFavorite.toString(),
          carTitle: info.carinfo.carTitle,
          bodyCreator: (context) {
            return Column(
              children: [
                ListTile(
                  title: Text(info.carinfo.carTitle, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 18, color: notifire.getwhiteblackcolor)),
                  trailing: RichText(text: TextSpan(
                    children: [
                      TextSpan(text: '${widget.currency}${info.carinfo.carRentPrice} ', style: TextStyle(color: onbordingBlue, fontFamily: FontFamily.europaBold, fontSize: 20)),
                      TextSpan(text: '/${info.carinfo.priceType == '1' ? "hr".tr : "days".tr}', style: TextStyle(color: Colors.grey, fontFamily: FontFamily.europaWoff, fontSize: 15)),
                    ],
                  )),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      carType(image: Appcontent.engine, title: 'Engine displacement'.tr, subtitle: info.carinfo.engineHp),
                      carType(image: Appcontent.gearbox, title: 'Transmission type'.tr, subtitle: info.carinfo.carGear == '1' ? 'Automatic'.tr : 'Manual'.tr),
                      carType(image: Appcontent.petrol, title: 'Fuel type'.tr, subtitle: info.carinfo.fuelType == '0' ? 'Petrol'.tr : info.carinfo.fuelType == '1' ? 'Diesel'.tr : info.carinfo.fuelType == '2' ? 'Electric'.tr : info.carinfo.fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr),
                      carType(image: Appcontent.seat, title: 'Seats'.tr, subtitle: '${info.carinfo.totalSeat} ${'Seats'.tr}'.tr),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TabBar(
                  unselectedLabelColor: notifire.getgreycolor,
                  indicatorColor: onbordingBlue,
                  labelColor: onbordingBlue,
                  labelStyle: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15),
                  indicator: MD2Indicator(
                    indicatorSize: MD2IndicatorSize.normal,
                    indicatorHeight: 5,
                    indicatorColor: onbordingBlue,
                  ),
                  tabs: [
                    Tab(text: 'About'.tr),
                    Tab(text: 'Feature'.tr),
                    Tab(text: 'Gallery'.tr),
                    Tab(text: 'Review'.tr),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                      children: [
                        detailsWidget(),
                        featuresWidget(),
                        designWidget(),
                        reviewsWidget(),
                      ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), Appcontent.mapPin).then((icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  late GoogleMapController mapController;
  Set<Marker> markers = {};
  void _onAddMarkerButtonPressed(double? lat,long) {
    setState(() {
      markers.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(double.parse(lat.toString()), double.parse(long.toString())),
        icon: markerIcon,
      ));
    });
  }

  detailsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.carinfo.carDesc, style: TextStyle(fontFamily: FontFamily.europaWoff, fontSize: 14, color: greyScale1,),),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: notifire.getborderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  carTypeList(title: 'Car Number'.tr, brand: info.carinfo.carNumber),
                  SizedBox(height: 15),
                  carTypeList(title: 'Total KM'.tr, brand: info.carinfo.totalKm),
                  SizedBox(height: 15),
                  carTypeList(title: 'Car Brand'.tr, brand: info.carinfo.carBrandTitle),
                  SizedBox(height: 15),
                  carTypeList(title: 'Car Type'.tr, brand: info.carinfo.carTypeTitle),
                  SizedBox(height: 15),
                  carTypeList(title: 'Car AC'.tr, brand: info.carinfo.carAc == '1' ? 'AC' : 'Non-AC'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Car Location'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 16)),
                Text('Distance: ${_totalDistance != null ? _totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2) : 0} ${_totalDistance != null ? _totalDistance > 1000 ? 'KM' : 'meters' : 0}'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 16)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/map-pin.png", height: 20, width: 20, color: notifire.getwhiteblackcolor),
                const SizedBox(width: 15),
                Expanded(child: Text(info.carinfo.pickAddress, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 14))),
              ],
            ),
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GoogleMap(
                  markers: markers,
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                  },
                  initialCameraPosition: CameraPosition(target: LatLng(double.parse(info.carinfo.pickLat), double.parse(info.carinfo.pickLng)), zoom: 13),
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
          ],
        ),
      ),
    );
  }

  featuresWidget() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notable features'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 16, color: notifire.getwhiteblackcolor,),),
            Transform.translate(
              offset: Offset(0, -20),
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: info.carinfo.facilityImg.toString().split(",").length,
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.20),
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network("${Config.imgUrl}${info.carinfo.facilityImg.toString().split(",").elementAt(index)}"),
                          ),
                          SizedBox(width: 15),
                          Text(info.carinfo.carFacility.toString().split(",").elementAt(index), style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 14, color: notifire.getwhiteblackcolor,),),
                          Spacer(),
                          Text('Yes'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 14, color: Color(0xff22C55E))),
                        ],
                      ),
                    ],
                  );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<String> listOfUrls= [];

  designWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            info.galleryImages.isEmpty ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Appcontent.gallery, height: 96),
                  const SizedBox(height: 10),
                  Text('No Gallery Found!'.tr, style:  TextStyle(fontSize: 24, fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text('It can be used to express that something is not someone Gallery.'.tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.europaWoff, color: greyScale), textAlign: TextAlign.center),
                ],
              ),
            ) : GalleryImage(
              closeWhenSwipeDown: true,
              showAppBar: false,
              imageUrls: listOfUrls,
              numOfShowImages: listOfUrls.length,
              titleGallery: 'Gallery'.tr,
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  reviewsWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child:reviewModal!.reviewdata.isEmpty ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: review(title: 'Review'.tr, color: notifire.getwhiteblackcolor),
        ),
      ) :  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User review'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 18, fontWeight: FontWeight.w700, color: notifire.getwhiteblackcolor)),
            Transform.translate(
              offset: Offset(0, -25),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: reviewModal?.reviewdata.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: notifire.getblackwhitecolor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            reviewModal!.reviewdata[index].userImg.isEmpty ? CircleAvatar(
                              backgroundImage: AssetImage(Appcontent.profile),
                            ):CircleAvatar(backgroundImage: NetworkImage('${Config.imgUrl}${reviewModal?.reviewdata[index].userImg}')),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reviewModal!.reviewdata[index].userTitle, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 16, fontWeight: FontWeight.w700, color: notifire.getwhiteblackcolor)),
                                SizedBox(height: 8),
                                Text(reviewModal!.reviewdata[index].reviewDate.toString().split(" ").first, style: TextStyle(fontFamily: FontFamily.europaWoff, fontSize: 12, fontWeight: FontWeight.w500, color: greyScale)),
                              ],
                            ),
                            Spacer(),
                            Image.asset(Appcontent.star1, height: 15),
                            SizedBox(width: 6),
                            Text(reviewModal!.reviewdata[index].userRate, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, fontWeight: FontWeight.w700, color: notifire.getwhiteblackcolor)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(reviewModal!.reviewdata[index].userDesc, style: TextStyle(fontFamily: FontFamily.europaWoff, fontSize: 12, fontWeight: FontWeight.w500, color: greyScale1)),
                      ],
                    ),
                  );
              },),
            ),
          ],
        ),
      ),
    );
  }

  carType({required String image, required String title, required String subtitle}) {
    return Container(
      height: 114,
      width: 145,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: notifire.getborderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: notifire.getblackwhitecolor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset(image, color: notifire.getwhiteblackcolor)),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontFamily: FontFamily.europaWoff, fontSize: 11, color: notifire.getwhiteblackcolor)),
          SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor)),
        ],
      ),
    );
  }

  carTypeList({required String title, required String brand}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: FontFamily.europaWoff,
            fontSize: 14,
            color: greyScale1,
          ),
        ),
        Spacer(),
        Text(
          brand,
          style: TextStyle(
            fontFamily: FontFamily.europaBold,
            fontSize: 15,
            color: notifire.getwhiteblackcolor,
          ),
        ),
      ],
    );
  }
}

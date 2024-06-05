// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, empty_catches, avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:carlink/controller/location_controller.dart';
import 'package:carlink/model/homeData_modal.dart';
import 'package:carlink/screen/detailcar/brandwise_screen.dart';
import 'package:carlink/screen/detailcar/typewise_screen.dart';
import 'package:carlink/utils/common_ematy.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/controller/home_controller.dart';
import 'package:carlink/screen/availablecar/availablecar_screen.dart';
import 'package:carlink/screen/detailcar/cardetails_screen.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Custom_widget.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../utils/App_content.dart';
import '../availablecar/recommendation_screeen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
var lName;
var dId;
locationSave() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  lName = _prefs.getString('location');
  dId = _prefs.getString('lId');
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();
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
    controller = PageController();
    lController.dController = DateRangePickerController();
    getvalidate();
    locationSave();
    super.initState();
    homeController.changShimmer();
  }

  var dropdownvalue;

  int _current = 0;

  List temp =[];

  final CarouselController carouselController = CarouselController();
  final CarouselController carouselController1 = CarouselController();


  PageController controller = PageController();
  TextEditingController locationController = TextEditingController();


  late String finalId;
  late HomeBanner banner;
  bool loading = true;
  Future homeBanner(uid) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    List<Location> locations = await locationFromAddress("Surat");
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    print('Latitude --> $latitude Longitude --> $longitude Position --> $position');
    Map body = {
      "uid" : uid,
      "lats": locations[0].latitude,
      "longs": locations[0].longitude,
      "cityid": dId,
    };
    print(body);
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.homeData), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      print('HOME ==> ${response.body}');
      if(response.statusCode == 200){
        SharedPreferences shared = await SharedPreferences.getInstance();
        shared.setString('lats', locations[0].latitude.toString());
        shared.setString('longs', locations[0].longitude.toString());
        setState(() {
          banner = homeBannerFromJson(response.body);
          homeController.isLoading;
          loading = false;
        });

        for(int a = 0;a<banner.recommendCar.length;a++){
          temp.add(0);
        }
        Map<String, dynamic> taxs = {
          "tax" : banner.tax,
          "currency" : banner.currency,
        };
        String encodeMap = json.encode(taxs);
        shared.setString('bannerData', encodeMap);
      } else {}
    } catch(e){}
  }

  var id;
  Future getvalidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = jsonDecode(sharedPreferences.getString('UserLogin')!);
    print(id);
    homeBanner(id['id']);
  }
LocationController lController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifire.getbgcolor,
        leading: GestureDetector(
          onTap: () {
            lController.cityList().then((value) {
              lController.commonBottomSheet(context).then((value) {
                print(value);
                homeBanner(id['id']);
                locationSave();
                setState(() {});
              });
            });
          },
          child: Container(
            height: 45,
            width: 45,
            padding: EdgeInsets.all(8),
            child: Image.asset(Appcontent.location, height: 25, width: 25, color: notifire.getwhiteblackcolor),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: notifire.getborderColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        title: InkWell(
          onTap: () {
            lController.cityList().then((value) {
              lController.commonBottomSheet(context).then((value) {
                print(value);
                homeBanner(id['id']);
                locationSave();
                setState(() {});
              });
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Change Location".tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 12)),
              SizedBox(height: 4),
              Text(lName ?? "No Location".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15)),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(NotificationScreen()),
            child: Container(
              height: 45,
              width: 40,
              padding: EdgeInsets.all(8),
              child: Image.asset(Appcontent.notification1, height: 25, width: 25, color: notifire.getwhiteblackcolor),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: notifire.getborderColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: loading ? allHomeShimmer(): Column(
          children: [
            GetBuilder<LocationController>(
              builder: (lController) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            color: notifire.getbgcolor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             CarouselSlider.builder(
                                carouselController: carouselController,
                                itemCount: banner.banner.length,
                                itemBuilder: (context, index, realIndex) {
                                  return Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      image: DecorationImage(image: NetworkImage("${Config.imgUrl}${banner.banner[index].img}"),fit: BoxFit.fitWidth)
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                              ),
                              Center(
                                child: Transform.translate(
                                  offset: Offset(0, -7),
                                  child: SizedBox(
                                    height: 6,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: banner.banner.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () => carouselController.animateToPage(index),
                                            child: Container(
                                              width: _current == index ? 24 : 6,
                                              height: 6,
                                              margin: EdgeInsets.symmetric(horizontal: 2),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: _current == index ? onbordingBlue : Colors.grey,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                width: Get.size.width,
                                child: ListView.builder(
                                  itemCount: banner.cartypelist.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(TypeWiseScreen(typeId: banner.cartypelist[index].id, typeCar: banner.cartypelist[index].title));
                                      },
                                      child: Container(
                                        height: 55,
                                        margin: EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(left: 10, right: 15),
                                        child: Row(
                                          children: [
                                            Image.network("${Config.imgUrl}${banner.cartypelist[index].img}",height: 30,),
                                            SizedBox(width: 8),
                                            Text(banner.cartypelist[index].title, style: TextStyle(fontFamily: FontFamily.europaWoff, fontSize: 15, color: notifire.getwhiteblackcolor)),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: notifire.getborderColor),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Text("Featured Cars".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                                  Spacer(),
                                  banner.featureCar.isEmpty ? SizedBox() : TextButton(
                                      onPressed: () {
                                        Get.to(AvailablecarScreen(title: 'Featured Cars'.tr));
                                      },
                                      child: Text("View all".tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: greyScale1, fontSize: 15))),
                                ],
                              ),
                              SizedBox(
                                height: 330,
                                width: Get.size.width,
                                child:  banner.featureCar.isEmpty ? ematyCar(title: 'Featured Cars'.tr,colors: notifire.getwhiteblackcolor) :  ListView.builder(
                                  itemCount: banner.featureCar.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CarDetailsScreen(id: banner.featureCar[index].id, currency:  banner.currency,)));
                                      },
                                      child: Container(
                                        height: 330,
                                        width: 266,
                                        margin: EdgeInsets.only(right: 12),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Image.network("${Config.imgUrl}${banner.featureCar[index].carImg}", fit: BoxFit.cover),
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    stops: [0.6, 0.8, 1.5],
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black.withOpacity(0.9),
                                                      Colors.black.withOpacity(0.9),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 15,
                                                right: 20,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(20)),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                                            child: Image.asset(Appcontent.star1, height: 16),
                                                          ),
                                                          Text(banner.featureCar[index].carRating, style: TextStyle(fontFamily: FontFamily.europaWoff, color: Colors.white)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: SizedBox(
                                                  height: 140,
                                                  width: 240,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 16),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 12, top: 10),
                                                        child: Text(
                                                          banner.featureCar[index].carTitle,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            fontFamily: FontFamily.europaBold,
                                                            color: WhiteColor,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 12, top: 7),
                                                        child: Text(
                                                          banner.featureCar[index].carTypeTitle,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.europaWoff,
                                                            color: WhiteColor,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 12, top: 7),
                                                            child: Text(
                                                              "${banner.currency}${banner.featureCar[index].carRentPrice}",
                                                              style: TextStyle(
                                                                color: WhiteColor,
                                                                fontFamily: FontFamily.europaBold,
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 5, top: 10),
                                                            child: Text(
                                                              "/ ${banner.featureCar[index].priceType == '1' ? "hr".tr : "days".tr}",
                                                              style: TextStyle(
                                                                color: WhiteColor,
                                                                fontFamily: FontFamily.europaWoff,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 7),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              carTool1(image: Appcontent.engine,   number: banner.featureCar[index].engineHp, text: 'hp'.tr),
                                                              SizedBox(width: 6),
                                                              carTool1(image: Appcontent.gearbox,  title: banner.featureCar[index].carGear == '1' ? 'Automatic'.tr : 'Manual'.tr),
                                                              carTool1(image: Appcontent.petrol, title: banner.featureCar[index].fuelType == '0' ? 'Petrol'.tr : banner.featureCar[index].fuelType == '1' ? 'Diesel'.tr : banner.featureCar[index].fuelType == '2' ? 'Electric'.tr : banner.featureCar[index].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr),
                                                              carTool1(image: Appcontent.seat, number: banner.featureCar[index].totalSeat, text: 'Seats'.tr),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text("Top brands".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                              ),
                              SizedBox(
                                height: 120,
                                width: Get.size.width,
                                child: ListView.builder(
                                  itemCount: banner.carbrandlist.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(BrandWiseScreen(brandId: banner.carbrandlist[index].id, brandCar: banner.carbrandlist[index].title));
                                      },
                                      child: Container(
                                        width: index == 4 ? 110 : 93,
                                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.network("${Config.imgUrl}${banner.carbrandlist[index].img}",height: 40),
                                            SizedBox(height: 10),
                                            Text(banner.carbrandlist[index].title, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15,),)
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: notifire.getborderColor),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Row(
                                children: [
                                  Text("Car recommendation".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                                  Spacer(),
                                  banner.recommendCar.isEmpty ? SizedBox() : TextButton(
                                    onPressed: () {
                                      Get.to(recommendScreen(title: 'Car recommendation'.tr));
                                    },
                                    child: Text("View all".tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: greyScale1, fontSize: 15,),),),
                                ],
                              ),
                              banner.recommendCar.isEmpty ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: ematyCar(title: 'Car recommendation'.tr,colors: notifire.getwhiteblackcolor),
                              ) : ListView.builder(
                                itemCount: banner.recommendCar.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index2) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(CarDetailsScreen(id: banner.recommendCar[index2].id, currency: banner.currency));
                                    },
                                    child: Container(
                                      width: Get.size.width,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.only(bottom: 13),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 204,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                banner.recommendCar[index2].carImg.length == 1 ? Stack(
                                                  children: [
                                                    Container(
                                                      height: 204,
                                                      width: Get.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        image: DecorationImage(image: NetworkImage('${Config.imgUrl}${banner.recommendCar[index2].carImg[0]}'), fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                                                        gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          stops: [0.6, 0.8, 1.5],
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
                                                  carouselController: carouselController1,
                                                  itemCount: banner.recommendCar[index2].carImg.length,
                                                  itemBuilder: (context, index1, realIndex) {
                                                    return Stack(
                                                      children: [
                                                        Container(
                                                          height: 204,
                                                          width: Get.width,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20),
                                                            image: DecorationImage(image: NetworkImage('${Config.imgUrl}${banner.recommendCar[index2].carImg[index1]}'), fit: BoxFit.cover),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                                                            gradient: LinearGradient(
                                                              begin: Alignment.topCenter,
                                                              end: Alignment.bottomCenter,
                                                              stops: [0.6, 0.8, 1.5],
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
                                                    enableInfiniteScroll: true,
                                                    reverse: false,
                                                    aspectRatio: Get.width /23 /9,
                                                    enlargeCenterPage: true,
                                                    scrollDirection: Axis.horizontal,
                                                    onPageChanged: (index, reason) {
                                                      setState(() {
                                                        temp[index2] = index;
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
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(20)),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                            child: Text(banner.recommendCar[index2].carTitle, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 12, fontFamily: FontFamily.europaBold)),
                                                          ),
                                                        ),
                                                      ),
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(20)),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                                                  child: Image.asset(Appcontent.star1, height: 16),
                                                                ),
                                                                Text(banner.recommendCar[index2].carRating, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 12, fontFamily: FontFamily.europaBold)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
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
                                                        Text(banner.recommendCar[index2].carNumber, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                                        banner.recommendCar[index2].carImg.length == 1 ? SizedBox() : Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: banner.recommendCar[index2].carImg.asMap().entries.map((e) {
                                                            return InkWell(
                                                              onTap: () => carouselController1.animateToPage(e.key),
                                                              child: Container(
                                                                width: temp[index2] == e.key ? 24 : 6,
                                                                height: 6,
                                                                margin: EdgeInsets.symmetric( horizontal: 2),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                    color: temp[index2] == e.key
                                                                        ? onbordingBlue
                                                                        : Colors.grey
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        Text('${banner.currency}${banner.recommendCar[index2].carRentPrice} /${banner.recommendCar[index2].priceType == '1' ? 'hr'.tr : 'days'.tr}', style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          banner.recommendCar[index2].carImg.length == 1 ? SizedBox(height: 10) : SizedBox(height: 3,),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  carTool(image: Appcontent.engine,   number: banner.recommendCar[index2].engineHp, text: 'hp'.tr),
                                                  carTool(image: Appcontent.gearbox, title: banner.recommendCar[index2].engineHp == '1' ? 'Automatic'.tr : 'Manual'.tr),
                                                  carTool(image: Appcontent.petrol,title: banner.recommendCar[index2].fuelType == '0' ? 'Petrol'.tr : banner.recommendCar[index2].fuelType == '1' ? 'Diesel'.tr : banner.recommendCar[index2].fuelType == '2' ? 'Electric'.tr : banner.recommendCar[index2].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr),
                                                  carTool(image: Appcontent.seat,  number: banner.recommendCar[index2].totalSeat, text: 'Seats'.tr),
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
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
  allHomeShimmer(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: Get.width,
              margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10, right: 15),
              child: Shimmer.fromColors(
                baseColor: notifire.isDark ? Colors.black45 : Colors.grey.shade100,
                highlightColor: notifire.isDark ? Color(0xFF475569) : Color(0xFFeaeff4),
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      color: notifire.getblackwhitecolor,
                      borderRadius: BorderRadius.circular(13)
                  ),
                ),
              ),
            ),
            Container(
              height: 55,
              margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Shimmer.fromColors(
                baseColor: notifire.isDark ? Colors.black45 : Colors.grey.shade100,
                highlightColor: notifire.isDark ? Color(0xFF475569) : Color(0xFFeaeff4),
                enabled: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 55,
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: notifire.getborderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: notifire.getblackwhitecolor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 15,
                            width: 70,
                            decoration: BoxDecoration(
                              color: notifire.getblackwhitecolor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Text("Featured Cars".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
            Container(
              height: 330,
              width: Get.width,
              margin: EdgeInsets.only(top: 10),
              child: Shimmer.fromColors(
                baseColor: notifire.isDark ? Colors.black45 : Colors.grey.shade100,
                highlightColor: notifire.isDark ? Color(0xFF475569) : Color(0xFFeaeff4),
                child: ListView.builder(
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 330,
                      width: 266,
                      margin: EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.6, 0.8, 1.5],
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.5),
                                    Colors.black.withOpacity(0.5),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 20,
                              child: Container(
                                height: 30,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.80),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: SizedBox(
                                height: 140,
                                width: 240,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, top: 10),
                                      child: Container(
                                        height: 15,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: notifire.getblackwhitecolor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, top: 7),
                                      child: Container(
                                        height: 15,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: notifire.getblackwhitecolor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12, top: 7),
                                          child: Container(
                                            height: 15,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: notifire.getblackwhitecolor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 7),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7,top: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: notifire.getblackwhitecolor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            height: 20,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: notifire.getblackwhitecolor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: notifire.getblackwhitecolor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            height: 20,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: notifire.getblackwhitecolor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: notifire.getblackwhitecolor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            height: 20,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: notifire.getblackwhitecolor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: notifire.getblackwhitecolor)
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("Top brands".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
            ),
            SizedBox(
              height: 120,
              width: Get.size.width,
              child: ListView.builder(
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Container(
                    height: 120,
                    width: 93,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Shimmer.fromColors(
                      baseColor: notifire.isDark ? Colors.black45 : Colors.grey.shade100,
                      highlightColor: notifire.isDark ? Color(0xFF475569) : Color(0xFFeaeff4),
                      enabled: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: notifire.getblackwhitecolor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 15,
                            width: 70,
                            decoration: BoxDecoration(
                              color: notifire.getblackwhitecolor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: notifire.getborderColor),
                      borderRadius: BorderRadius.circular(20),
                      color: notifire.getblackwhitecolor,
                    ),
                  );
                },
              ),
            ),
            Text("Car recommendation".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
            carRecomendationShimmer(notifire),
          ],
        ),
      ),
    );
  }

  Widget carTool({required String image,  String? title, String? number, String? text}){
    return Row(
      children: [
        SizedBox(width: 8),
        Image.asset(image, height: 20, width: 20, color: notifire.getwhiteblackcolor),
        SizedBox(width: 4),
        Text(title ??'', style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
        RichText(text: TextSpan(
          children: [
            TextSpan(text: number,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: text,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            WidgetSpan(child: SizedBox(width: 3)),
          ],
        )),
      ],
    );
  }
  Widget carTool1({required String image, String? title, String? number, String? text}){
    return Row(
      children: [
        Image.asset(image, height: 15, width: 15, color: Colors.white),
        SizedBox(width: 4),
        Text(title ?? '', style: TextStyle(fontFamily: FontFamily.europaWoff, color: Colors.white, fontSize: 10)),
        RichText(text: TextSpan(
          children: [
            TextSpan(text: number,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: Colors.white, fontSize: 10)),
            WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: text,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: Colors.white, fontSize: 10)),
          ],
        )),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:convert';
import 'package:carlink/screen/bottombar/carinfo_screeen.dart';
import 'package:carlink/screen/bottombar/favorite_screen.dart';
import 'package:carlink/screen/bottombar/home_screen.dart';
import 'package:carlink/screen/bottombar/profile_screen.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../controller/location_controller.dart';
import '../../model/homeData_modal.dart';
import '../../utils/App_content.dart';
import 'explore_screen.dart';

class BottomBarScreen extends StatefulWidget {
  final String? userType;
  const BottomBarScreen({super.key, this.userType});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int currentIndex = 0;
  List<Widget> myChilders = [
    HomeScreen(),
    ExploreScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

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

  LocationController lController = Get.put(LocationController());
  locationSave() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    lName = _prefs.getString('location');
  }

  final DateRangePickerController _controller = DateRangePickerController();
  TextEditingController locationController = TextEditingController();

  late HomeBanner banner;
  bool load = true;
  Future homeBanner(uid, dId) async {
    List<Location> locations = await locationFromAddress(loName.toString());
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    print('Latitude --> $latitude Longitude --> $longitude');
    Map body = {
      "uid": uid,
      "lats": locations[0].latitude,
      "longs": locations[0].longitude,
      "cityid": dId,
    };
    try {
      var response = await http.post(Uri.parse(Config.baseUrl + Config.homeData), body: jsonEncode(body), headers: {
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        SharedPreferences shared = await SharedPreferences.getInstance();
        shared.setString('lats', locations[0].latitude.toString());
        shared.setString('longs', locations[0].longitude.toString());
        setState(() {
          banner = homeBannerFromJson(response.body);
          load = false;
        });
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool? isLogin;

  var loId;
  var loName;
  var id;


  setLocal() async {
    SharedPreferences lName = await SharedPreferences.getInstance();
    id = jsonDecode(lName.getString('UserLogin')!);
    loName = lName.getString('locationName');
    loId = lName.getString('lId');
    homeBanner(id['id'], loId);
  }

  @override
  void initState() {
    getdarkmodepreviousstate();
    setLocal();
    final DateTime today = DateTime.now();
    _controller.selectedRange =
        PickerDateRange(today, today.add(Duration(days: 3)));
    lController.dController = DateRangePickerController();
    getDataFromLocal().then((value) {
      if (isLogin!) {
        lController.cityList().then((value) {
          set();

          lController.commonBottomSheet(context).then((value) {
            setLocal();
            homeBanner(id['id'], loId);
            locationSave();
            setState(() {});
          });
        });
      } else {}
    });
    super.initState();
  }

  Future<void> _refresh()async {
    Future.delayed(const Duration(seconds: 1),() {
      setState(() {
        homeBanner(id['id'],loId);
      });
    },);
  }
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return RefreshIndicator(
      onRefresh: _refresh,
      color: onbordingBlue,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: notifire.getbgcolor,
        // extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: load ? SizedBox() : banner.showAddCar == "0" ? SizedBox() : FloatingActionButton(
          heroTag: null,
          elevation: 0,
          backgroundColor: onbordingBlue,
            onPressed: () {
              Get.to(CarInfoScreen());
            },
          child: Icon(Icons.add,size: 30),
        ),
        bottomNavigationBar: load ? SizedBox() : banner.showAddCar == "0" ? BottomNavigationBar(
          backgroundColor: notifire.getbgcolor,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: greyScale1,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontFamily: FontFamily.europaBold, fontSize: 12),
          fixedColor: onbordingBlue,
          unselectedLabelStyle: const TextStyle(fontFamily: FontFamily.europaWoff),
          currentIndex: currentIndex,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset("assets/homeBold.png", color: greyScale1, height: MediaQuery.of(context).size.height / 35),
              activeIcon: Image.asset("assets/homeBold.png", color: onbordingBlue, height: MediaQuery.of(context).size.height / 35),
              label: 'Home'.tr,
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/location-pin.png", height: MediaQuery.of(context).size.height / 35),
              activeIcon: Image.asset("assets/location-pin.png", color: onbordingBlue, height: MediaQuery.of(context).size.height / 35),
              label: 'Explore'.tr,
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/fevoriteBold.png", color: greyScale1, height: MediaQuery.of(context).size.height / 35),
              activeIcon: Image.asset("assets/fevoriteBold.png", color: onbordingBlue, height: MediaQuery.of(context).size.height / 35),
              label: 'Favorites'.tr,
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/profileBold.png", color: greyScale1, height: MediaQuery.of(context).size.height / 35),
              activeIcon: Image.asset("assets/profileBold.png", color: onbordingBlue, height: MediaQuery.of(context).size.height / 35),
              label: 'Profile'.tr,
            ),
          ],
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ) :  BottomAppBar(
          elevation: 0,
          color: notifire.getBottom,
          notchMargin:8,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap:() {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentIndex == 0 ? Image.asset(Appcontent.home, height: 24, width: 24,color: onbordingBlue) : Image.asset(Appcontent.home, height: 24, width: 24, color:  currentIndex == 0 ? onbordingBlue : greyScale1),
                        const SizedBox(height: 5,),
                        Text('Home'.tr, style: TextStyle(fontSize: 12, color: currentIndex == 0 ? onbordingBlue : greyScale1, fontFamily: FontFamily.europaBold),)
                      ],
                    )),
                GestureDetector(
                    onTap:() {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentIndex == 1 ? Image.asset(Appcontent.explore, height: 24, width: 24,color: onbordingBlue) : Image.asset(Appcontent.explore, height: 24, width: 24, color: currentIndex == 1 ? onbordingBlue : greyScale1),
                        const SizedBox(height: 5,),
                        Text('Explore'.tr, style: TextStyle(fontSize: 12,color: currentIndex == 1 ? onbordingBlue : greyScale1, fontFamily: FontFamily.europaBold),)
                      ],
                    )),
                const SizedBox(width: 15),
                GestureDetector(
                    onTap:() {
                      setState(() {
                        currentIndex = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentIndex == 2 ? Image.asset(Appcontent.bfavorite, height: 24, width: 24,color: onbordingBlue) : Image.asset(Appcontent.bfavorite, height: 24, width: 24, color: currentIndex == 2 ? onbordingBlue : greyScale1),
                        const SizedBox(height: 5,),
                        Text('Favorites'.tr, style: TextStyle(fontSize: 12,color: currentIndex == 2 ? onbordingBlue : greyScale1, fontFamily: FontFamily.europaBold),)
                      ],
                    )),
                GestureDetector(
                    onTap:() {
                      setState(() {
                        currentIndex = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentIndex == 3 ? Image.asset(Appcontent.bProfile, height: 24, width: 24, color: onbordingBlue) : Image.asset(Appcontent.bProfile, height: 24, width: 24, color: currentIndex == 3? onbordingBlue : greyScale1),
                        const SizedBox(height: 5,),
                        Text('Profile'.tr, style: TextStyle(fontSize: 12,color: currentIndex == 3 ? onbordingBlue : greyScale1, fontFamily: FontFamily.europaBold),)
                      ],
                    )),
              ],
            ),
          ),
        ),
        body: myChilders[currentIndex],
      ),
    );
  }

  Future getDataFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print(prefs.getBool("bottomsheet"));
      isLogin = prefs.getBool("bottomsheet") ?? true;
      print(isLogin);
    });
  }

  Future set() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("bottomsheet", false);
  }
}
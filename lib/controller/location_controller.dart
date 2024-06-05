// ignore_for_file: avoid_print, empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/utils/config.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../model/citylist_modal.dart';
import '../utils/App_content.dart';
import '../utils/Colors.dart';
import '../utils/Dark_lightmode.dart';
import '../utils/fontfameli_model.dart';

class LocationController extends GetxController implements GetxService {
  late DateRangePickerController dController;
  DateTime? sdate;
  DateTime? edate;

  TextEditingController locationController = TextEditingController();

  CityList? cities;
  bool isLoading = true;
  late ColorNotifire notifire;
  final _formKey = GlobalKey<FormState>();

  Future cityList() async {
    try {
      var response =
      await http.post(Uri.parse(Config.baseUrl + Config.city), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        cities = cityListFromJson(response.body);
        isLoading = false;
        print(cities);
        update();
        return data;
      } else {}
    } catch (e) {}
  }

  var dId;
  var id;
  setLocal() async {
    SharedPreferences lName = await SharedPreferences.getInstance();
    lName.setString('location', locationController.text);
    id = jsonDecode(lName.getString('UserLogin')!);
    dId = lName.getString('lId');
    homeBanner(id['id'], dId);
    update();
  }
  Future homeBanner(uid, cityId) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    List<Location> locations = await locationFromAddress(locationController.text);
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    print('Latitude --> $latitude Longitude --> $longitude Position --> $position');
    Map body = {
      "uid" : uid,
      "lats": locations[0].latitude,
      "longs": locations[0].longitude,
      "cityid": cityId,
    };
    print(body);
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.homeData), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        SharedPreferences shared = await SharedPreferences.getInstance();
        shared.setString('lats', locations[0].latitude.toString());
        shared.setString('longs', locations[0].longitude.toString());
      } else {}
    } catch(e){}
  }
  String dropId = "";

  GlobalKey<AutoCompleteTextFieldState<dynamic>> key1 = GlobalKey();

  Future<dynamic> commonBottomSheet(context) {
    notifire = Provider.of<ColorNotifire>(context, listen: false);
    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: notifire.getbgcolor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.2,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: PopScope(
              canPop: false,
              child: Scaffold(
                backgroundColor: notifire.getbgcolor,
                body: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Find Available Car".tr,
                                style: TextStyle(
                                    fontFamily: FontFamily.europaBold,
                                    color: notifire.getwhiteblackcolor,
                                    fontSize: 18)),
                            SizedBox(
                              height: 45,
                              child: Center(
                                child: AutoCompleteTextField(
                                  controller: locationController,
                                  clearOnSubmit: false,
                                  suggestions: cities?.citylist ?? [],
                                  style: TextStyle(
                                      color: notifire.getwhiteblackcolor,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          top: 30, left: 10),
                                      suffixIcon:  Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: Image(
                                            image:
                                            const AssetImage(Appcontent.location), color: notifire.getwhiteblackcolor),
                                      ),
                                      hintText: 'Search Location'.tr,
                                      hintStyle:
                                      TextStyle(color: notifire.getgreycolor),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: notifire.getborderColor),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      )),
                                  itemFilter: (item, query) {
                                    return item.title
                                        .toLowerCase()
                                        .contains(query.toLowerCase());
                                  },
                                  itemSorter: (a, b) {
                                    return a.title.compareTo(b.title);
                                  },
                                  itemSubmitted: (item) async {
                                    dropId = item.id;

                                    locationController.text = item.title;
                                    SharedPreferences preference =
                                    await SharedPreferences.getInstance();
                                    preference.setString('lId', item.id);
                                    preference.setString('locationName', item.title);
                                    update();
                                  },
                                  itemBuilder: (context, item) {
                                    return Container(
                                      color: notifire.getblackwhitecolor,
                                      padding: const EdgeInsets.all(20),
                                      child: Text(item.title,
                                          style: TextStyle(
                                              color:
                                              notifire.getwhiteblackcolor)),
                                    );
                                  },
                                  key: key1,
                                ),
                              ),
                            ),
                            Text('Select trip date'.tr,
                                style: TextStyle(
                                    fontFamily: FontFamily.europaBold,
                                    color: notifire.getwhiteblackcolor,
                                    fontSize: 18)),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        border: Border.all(
                                            color: Colors.grey.withOpacity(0.4)),
                                      ),
                                      child: SfDateRangePicker(
                                        enablePastDates: false,
                                        rangeSelectionColor:
                                        onbordingBlue.withOpacity(0.15),
                                        rangeTextStyle: TextStyle(
                                            color: notifire.getwhiteblackcolor),
                                        yearCellStyle:
                                        DateRangePickerYearCellStyle(
                                            textStyle: TextStyle(color: notifire.getwhiteblackcolor, fontSize: 15)),
                                        endRangeSelectionColor: onbordingBlue,
                                        startRangeSelectionColor: onbordingBlue,
                                        selectionMode:
                                        DateRangePickerSelectionMode.range,
                                        monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                          disabledDatesTextStyle: TextStyle(
                                              color: notifire.getgreycolor),
                                          todayCellDecoration: BoxDecoration(
                                            border:
                                            Border.all(color: onbordingBlue),
                                            shape: BoxShape.circle,
                                          ),
                                          blackoutDateTextStyle:
                                          const TextStyle(color: Colors.grey),
                                          textStyle: TextStyle(
                                              color: notifire.getwhiteblackcolor),
                                        ),
                                        headerStyle: DateRangePickerHeaderStyle(
                                            textStyle: TextStyle(
                                                color:
                                                notifire.getwhiteblackcolor,
                                                fontFamily: FontFamily.europaWoff)),
                                        todayHighlightColor:
                                        notifire.getwhiteblackcolor,
                                        // initialSelectedRange: PickerDateRange(
                                        //     DateTime.now().subtract(
                                        //         const Duration(days: 0)),
                                        //     DateTime.now()
                                        //         .add(const Duration(days: 0))),
                                        onSelectionChanged:
                                            (dateRangePickerSelectionChangedArgs) {
                                          setState(() {
                                            sdate =
                                                dateRangePickerSelectionChangedArgs
                                                    .value.startDate;
                                            edate =
                                                dateRangePickerSelectionChangedArgs
                                                    .value.endDate;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text("Time of Pick-up".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                      FontFamily.europaBold,
                                                      color: notifire
                                                          .getwhiteblackcolor,
                                                      fontSize: 18)),
                                              Container(
                                                height: 55,
                                                margin:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color:
                                                  notifire.getblackwhitecolor,
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                  border: Border.all(color:Colors.grey.withOpacity(0.4)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 15),
                                                    Text(
                                                        sdate != null
                                                            ? sdate
                                                            .toString()
                                                            .split(" ")
                                                            .first
                                                            : 'Pickup Date'.tr,
                                                        style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .europaWoff,
                                                            color: notifire
                                                                .getwhiteblackcolor)),
                                                    const Spacer(),
                                                    Image.asset(Appcontent.calender1, height: 25, color: notifire.getwhiteblackcolor),
                                                    const SizedBox(width: 5),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text("Time of Return".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                      FontFamily.europaBold,
                                                      color: notifire
                                                          .getwhiteblackcolor,
                                                      fontSize: 18)),
                                              Container(
                                                height: 55,
                                                margin:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color:
                                                  notifire.getblackwhitecolor,
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 15),
                                                    Text(
                                                        edate != null
                                                            ? edate
                                                            .toString()
                                                            .split(" ")
                                                            .first
                                                            : 'Drop Date'.tr,
                                                        style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .europaWoff,
                                                            color: notifire
                                                                .getwhiteblackcolor)),
                                                    const Spacer(),
                                                    Image.asset(Appcontent.calender1, height: 25, color: notifire.getwhiteblackcolor),
                                                    const SizedBox(width: 5),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                backgroundColor: onbordingBlue,
                                fixedSize: Size(Get.width, 50),
                              ),
                              onPressed: () async {
                                if (locationController.text.isEmpty &&
                                    sdate.toString() == "null" &&
                                    edate.toString() == "null") {
                                  Fluttertoast.showToast(
                                      msg: "You haven't selected dates.".tr);
                                } else if (locationController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "You haven't Enter Location".tr);
                                } else if (sdate.toString() == "null") {
                                  Fluttertoast.showToast(
                                      msg: "You haven't selected a pickup date.".tr);
                                } else if (edate.toString() == "null") {
                                  Fluttertoast.showToast(
                                      msg: "You haven't selected a drop date.".tr);
                                } else {
                                  try {
                                    List<Location> locations = await locationFromAddress(locationController.text);
                                    double latitude = locations[0].latitude;
                                    double longitude = locations[0].longitude;
                                    print('Latitude $latitude == Longitude $longitude');
                                    setLocal();
                                    cityList();
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    prefs.getBool('bottomsheet') ?? true;
                                    update();
                                    Get.back(result: "ssddsds");
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: "You haven't selected city address".tr);
                                  }
                                }
                              },
                              child: Text('Search'.tr,
                                  style: const TextStyle(
                                      fontFamily: FontFamily.europaBold,
                                      color: Colors.white,
                                      fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

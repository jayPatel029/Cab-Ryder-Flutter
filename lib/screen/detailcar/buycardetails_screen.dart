// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_brace_in_string_interps, avoid_print, unused_local_variable, curly_braces_in_flow_control_structures, deprecated_member_use, empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/bookrange_modal.dart';
import 'package:carlink/screen/detailcar/review_summery.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/common.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../utils/App_content.dart';
import 'package:http/http.dart' as http;

class BuyCarDetailsScreen extends StatefulWidget {
  final String CarId;
  final String price;
  final String withDriver;
  final String ptype;
  final String minHrs;

  const BuyCarDetailsScreen({super.key, required this.CarId, required this.price, required this.withDriver, required this.ptype, required this.minHrs});

  @override
  State<BuyCarDetailsScreen> createState() => _BuyCarDetailsScreenState();
}

class _BuyCarDetailsScreenState extends State<BuyCarDetailsScreen> {
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
    bookRange(widget.CarId);
    dController = DateRangePickerController();
    super.initState();
  }

  bool light = false;

  late DateRangePickerController dController;

  DateTime? sdate;
  DateTime? edate;


  TimeOfDay? selectTime;
  TimeOfDay? selectTime1;

  bool isDateInRange(DateTime checkDate, DateTime sdate, DateTime edate) {
    return checkDate.isAfter(sdate) && checkDate.isBefore(edate);
  }

  late BookRangeModal bookRangeModal;
  bool isLoading = true;

  Future bookRange(cId) async {
    Map body = {
      "car_id": cId,
    };
    print(body);
    try {
      var response = await http.post(Uri.parse(Config.baseUrl + Config.bookRange), body: jsonEncode(body), headers: {
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool('light', light);
        setState(() {
          bookRangeModal = bookRangeModalFromJson(response.body);
          isLoading = false;

          print("++++ + + + ++ + +++ + + ${response.body}");
        });
      } else {}
    } catch (e) {}
  }
  var multiple;


  List blockDate =[];
  date(){
    for (int i = 0; i < bookRangeModal.bookeddate.length; i++)
      for (int a = 0; a <= DateTime.parse(bookRangeModal.bookeddate[i].returnDate.toString()).difference(DateTime.parse(bookRangeModal.bookeddate[i].pickupDate.toString())).inDays; a++) {
        print(DateTime.parse(bookRangeModal.bookeddate[i].returnDate.toString()).add(Duration(days: a)));
      }
  }
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
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: notifire.getwhiteblackcolor)),
          centerTitle: true,
          title: Text('Book Car'.tr, style: TextStyle(fontSize: 18, color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: onbordingBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
              fixedSize: Size(Get.width, 56),
            ),
            onPressed: () {
              date();
              print('+ ++ ++ +++  ${widget.ptype}');
              if (sdate.toString() == "null" &&
                  edate.toString() == "null" &&
                  selectTime.toString() == "null" &&
                  selectTime1.toString() == "null") {
                Fluttertoast.showToast(msg: "You haven't selected dates.".tr);
                //Please choose a date that is not within an existing reservation period.
              } else if (sdate.toString() == "null") {
                Fluttertoast.showToast(
                    msg: "You haven't selected a pickup date.".tr);
              } else if (edate.toString() == "null") {
                Fluttertoast.showToast(
                    msg: "You haven't selected a drop date.".tr);
              } else if (selectTime.toString() == "null") {
                Fluttertoast.showToast(
                    msg: "You haven't selected a pick-up time.".tr);
              } else if (selectTime1.toString() == "null") {
                Fluttertoast.showToast(
                    msg: "You haven't selected a return time.".tr);
              } else if(sdate == edate){
                if(widget.ptype == 'hr'){
                  multiple =  60 * num.parse(widget.minHrs);
                  print('* ** *** ** $multiple');
                  final int durationInMinutes = selectTime1!.hour * 60 + selectTime1!.minute - (selectTime!.hour * 60 + selectTime!.minute);
                  print(durationInMinutes);

                  if (durationInMinutes < multiple) {
                    setState(() {
                      Fluttertoast.showToast(msg: '${'Minimum booking duration must be'.tr} ${widget.minHrs} ${'hours'.tr}.');
                    });
                    return;
                  } else{
                    DateTime date1 = DateTime.parse(
                        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime(
                          sdate!.year,
                          sdate!.month,
                          sdate!.day,
                          selectTime!.hour,
                          selectTime!.minute,
                        )));

                    DateTime date2 = DateTime.parse(
                        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime(
                            edate!.year,
                            edate!.month,
                            edate!.day,
                            selectTime1!.hour,
                            selectTime1!.minute)));

                    Duration diff = date2.difference(date1);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewSummery(
                                Picktime:
                                selectTime?.format(context) ?? "00:00",
                                returnTime:
                                selectTime1?.format(context) ?? "00:00",
                                toggle: light,
                                startDate: sdate.toString().split(" ").first,
                                endDate: edate.toString().split(" ").first,
                                hours: diff.inHours.toString(),
                                days: (diff.inDays +1).toString(),
                                sTime:
                                '${date1.hour}:${date1.minute}:${date1.second}',
                                eTime:
                                '${date2.hour}:${date2.minute}:${date2.second}')));
                  }
                } else if(widget.ptype == 'days'){
                  DateTime date1 = DateTime.parse(
                      DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime(
                        sdate!.year,
                        sdate!.month,
                        sdate!.day,
                        selectTime!.hour,
                        selectTime!.minute,
                      )));

                  DateTime date2 = DateTime.parse(
                      DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime(
                          edate!.year,
                          edate!.month,
                          edate!.day,
                          selectTime1!.hour,
                          selectTime1!.minute)));

                  Duration diff = date2.difference(date1);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewSummery(
                              Picktime:
                              selectTime?.format(context) ?? "00:00",
                              returnTime:
                              selectTime1?.format(context) ?? "00:00",
                              toggle: light,
                              startDate: sdate.toString().split(" ").first,
                              endDate: edate.toString().split(" ").first,
                              hours: diff.inHours.toString(),
                              days: (diff.inDays +1).toString(),
                              sTime:
                              '${date1.hour}:${date1.minute}:${date1.second}',
                              eTime:
                              '${date2.hour}:${date2.minute}:${date2.second}')));
                }
              } else {
                DateTime date1 = DateTime.parse(
                    DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime(
                  sdate!.year,
                  sdate!.month,
                  sdate!.day,
                  selectTime!.hour,
                  selectTime!.minute,
                )));

                DateTime date2 = DateTime.parse(
                    DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime(
                        edate!.year,
                        edate!.month,
                        edate!.day,
                        selectTime1!.hour,
                        selectTime1!.minute)));

                Duration diff = date2.difference(date1);
                print('DATE -> ${diff}');

                List condition = [];
                for (int a = 0; a < bookRangeModal.bookeddate.length; a++) {
                  DateTime blocsdate = DateTime(
                      int.parse(bookRangeModal.bookeddate[a].pickupDate.year
                          .toString()),
                      int.parse(bookRangeModal.bookeddate[a].pickupDate.month
                          .toString()),
                      int.parse(bookRangeModal.bookeddate[a].pickupDate.day
                          .toString()));
                  DateTime blocedate = DateTime(
                      int.parse(bookRangeModal.bookeddate[a].returnDate.year
                          .toString()),
                      int.parse(bookRangeModal.bookeddate[a].returnDate.month
                          .toString()),
                      int.parse(bookRangeModal.bookeddate[a].returnDate.day
                          .toString()));
                  // if (edate!.isAfter(blocedate1)) {

                  bool istur = isDateInRange(blocsdate, sdate!, edate!);
                  bool isture = isDateInRange(blocedate, sdate!, edate!);
                  if (isture == false && istur == false) {
                    condition.add(istur);
                    condition.add(isture);
                    // print("  A   A   A${istur}");
                    // print("  A   A   A${isture}");
                  } else {
                    condition.add(istur);
                    condition.add(isture);
                    // print("  M   M   M ${istur}");
                    // print("  M   M   M ${isture}");
                  }
                }
                if (condition.contains(true)) {
                  Fluttertoast.showToast(
                      msg:
                          'Please choose a date that is not within an existing reservation period.'.tr);
                } else {
                  if (sdate! == edate) {
                    bool ty = getTime(selectTime, selectTime1);
                    print(ty);
                    if (ty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewSummery(
                                  Picktime:
                                      selectTime?.format(context) ?? "00:00",
                                  returnTime:
                                      selectTime1?.format(context) ?? "00:00",
                                  toggle: light,
                                  startDate: sdate.toString().split(" ").first,
                                  endDate: edate.toString().split(" ").first,
                                  hours: diff.inHours.toString(),
                                  days: (diff.inDays +1).toString(),
                                  sTime:
                                      '${date1.hour}:${date1.minute}:${date1.second}',
                                  eTime:
                                      '${date2.hour}:${date2.minute}:${date2.second}')));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please select a valid time.");
                      selectTime = null;
                      selectTime1 = null;
                      setState(() {});
                    }
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewSummery(
                                Picktime:
                                    selectTime?.format(context) ?? "00:00",
                                returnTime:
                                    selectTime1?.format(context) ?? "00:00",
                                toggle: light,
                                startDate: sdate.toString().split(" ").first,
                                endDate: edate.toString().split(" ").first,
                                hours: diff.inHours.toString(),
                                days: (diff.inDays +1).toString(),
                                sTime:
                                    '${date1.hour}:${date1.minute}:${date1.second}',
                                eTime:
                                    '${date2.hour}:${date2.minute}:${date2.second}')));
                  }
                }
              }
            },
            child: Text("Let's Go".tr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: FontFamily.europaBold)),
          ),
        ),
        body: isLoading
            ? loader()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: notifire.getCarColor),
                        ),
                        child: ListTile(
                          title: Text('Book with driver'.tr,
                              style: TextStyle(
                                  color: notifire.getwhiteblackcolor,
                                  fontFamily: FontFamily.europaBold)),
                          subtitle: RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      "Don't have a driver? Book with the driver".tr,
                                  style: TextStyle(
                                      color: notifire.getgreycolor,
                                      fontFamily: FontFamily.europaWoff,
                                      fontSize: 15)),
                              light
                                  ? TextSpan(
                                      text:
                                          ' (${'${widget.withDriver}/${widget.ptype} Driver Fee'})'.tr,
                                      style: TextStyle(
                                          color: onbordingBlue,
                                          fontFamily: FontFamily.europaBold,
                                          fontSize: 15))
                                  : WidgetSpan(child: SizedBox()),
                            ],
                          )),
                          trailing: CupertinoSwitch(
                            activeColor: onbordingBlue,
                            value: light,
                            onChanged: (value) {
                              setState(() {
                                light = value;
                              });
                            },
                          ),
                        ),
                      ),

                      // Select Date
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: notifire.getCarColor),
                        ),
                        child: SfDateRangePicker(
                          controller: dController,
                          enablePastDates: false,
                          rangeSelectionColor: onbordingBlue.withOpacity(0.15),
                          rangeTextStyle: TextStyle(color: notifire.getwhiteblackcolor),
                          yearCellStyle: DateRangePickerYearCellStyle(
                              textStyle: TextStyle(
                                  color: notifire.getwhiteblackcolor)),
                          endRangeSelectionColor: onbordingBlue,
                          startRangeSelectionColor: onbordingBlue,
                          selectionMode: DateRangePickerSelectionMode.range,
                          monthCellStyle: DateRangePickerMonthCellStyle(
                            trailingDatesTextStyle: TextStyle(color: Colors.red),
                            disabledDatesTextStyle:
                                TextStyle(color: notifire.getgreycolor),
                            todayCellDecoration: BoxDecoration(
                              border: Border.all(color: onbordingBlue),
                              shape: BoxShape.circle,
                            ),
                            blackoutDateTextStyle: TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough),
                            textStyle:
                                TextStyle(color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaWoff),
                          ),
                          headerStyle: DateRangePickerHeaderStyle(
                              textStyle: TextStyle(
                                  color: notifire.getwhiteblackcolor,
                                  fontFamily: FontFamily.europaBold)),
                          todayHighlightColor: notifire.getwhiteblackcolor,
                          monthViewSettings: DateRangePickerMonthViewSettings(
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(textStyle: TextStyle(color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
                            blackoutDates: [
                              // for (int i = 0; i < bookRangeModal.bookeddate.length; i++)
                              //   if (DateTime.now().isBefore(DateTime(
                              //       int.parse(bookRangeModal.bookeddate[i].pickupDate.year.toString()),
                              //       int.parse(bookRangeModal.bookeddate[i].pickupDate.month.toString()),
                              //       int.parse(bookRangeModal.bookeddate[i].pickupDate.day.toString()))))
                              //
                              //     DateTime(
                              //         int.parse(bookRangeModal.bookeddate[i].pickupDate.year.toString()),
                              //         int.parse(bookRangeModal.bookeddate[i].pickupDate.month.toString()),
                              //         int.parse(bookRangeModal.bookeddate[i].pickupDate.day.toString())),
                              // for (int i = 0; i < bookRangeModal.bookeddate.length; i++)
                              //
                              //   if (DateTime.now().isBefore(DateTime(
                              //       int.parse(bookRangeModal.bookeddate[i].returnDate.year.toString()),
                              //       int.parse(bookRangeModal.bookeddate[i].returnDate.month.toString()),
                              //       int.parse(bookRangeModal.bookeddate[i].returnDate.day.toString()))))
                              //     DateTime(
                              //         int.parse(bookRangeModal.bookeddate[i].returnDate.year.toString()),
                              //         int.parse(bookRangeModal.bookeddate[i].returnDate.month.toString()),
                              //         int.parse(bookRangeModal.bookeddate[i].returnDate.day.toString())),
                              for (int i = 0; i < bookRangeModal.bookeddate.length; i++)
                                for (int a = 0; a <= DateTime.parse(bookRangeModal.bookeddate[i].returnDate.toString()).difference(DateTime.parse(bookRangeModal.bookeddate[i].pickupDate.toString())).inDays; a++)
                                    DateTime.parse(bookRangeModal.bookeddate[i].pickupDate.toString()).add(Duration(days: a)),
                            ],
                          ),
                          onSelectionChanged:
                              (dateRangePickerSelectionChangedArgs) {
                            setState(() {
                              sdate = dateRangePickerSelectionChangedArgs.value.startDate;
                              edate = dateRangePickerSelectionChangedArgs.value.endDate;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 10),
                      // PickUp and Drop Date
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date of Pick-up".tr,
                                    style: TextStyle(
                                        fontFamily: FontFamily.europaBold,
                                        color: notifire.getwhiteblackcolor,
                                        fontSize: 15)),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(color: notifire.getCarColor),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 15),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 3),
                                        child: sdate != null
                                            ? Text(
                                                sdate
                                                    .toString()
                                                    .split(" ")
                                                    .first,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.europaWoff,
                                                    color:
                                                        notifire
                                                            .getwhiteblackcolor))
                                            : Text('Pickup Date'.tr,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.europaWoff,
                                                    color: notifire
                                                        .getwhiteblackcolor)),
                                      ),
                                      Spacer(),
                                      Image.asset(Appcontent.calender1,
                                          height: 25,color: notifire.getwhiteblackcolor),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date of Return".tr,
                                    style: TextStyle(
                                        fontFamily: FontFamily.europaBold,
                                        color: notifire.getwhiteblackcolor,
                                        fontSize: 15)),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(color: notifire.getCarColor),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 15),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 3),
                                        child: edate != null
                                            ? Text(
                                                edate
                                                    .toString()
                                                    .split(" ")
                                                    .first,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.europaWoff,
                                                    color:
                                                        notifire
                                                            .getwhiteblackcolor))
                                            : Text('Drop Date'.tr,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.europaWoff,
                                                    color: notifire
                                                        .getwhiteblackcolor)),
                                      ),
                                      Spacer(),
                                      Image.asset(Appcontent.calender1,
                                          height: 25,color: notifire.getwhiteblackcolor),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // PickUp and Return Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time of Pick-up'.tr,
                                    style: TextStyle(
                                        fontFamily: FontFamily.europaBold,
                                        fontSize: 15,
                                        color: notifire.getwhiteblackcolor)),
                                SizedBox(height: Get.height / 60),
                                InkWell(
                                  onTap: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                      context: context,
                                      initialTime:
                                          selectTime ?? TimeOfDay.now(),
                                    );

                                    setState(() {
                                      selectTime = time;
                                    });
                                    if (sdate! == edate) {
                                      if (selectTime == selectTime1) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please select a different time.".tr);
                                        selectTime = null;
                                        selectTime1 = null;
                                        setState(() {});
                                      } else {
                                        bool ty =
                                            getTime(selectTime, selectTime1);

                                        if (ty) {
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please select a valid time.".tr);
                                          selectTime = null;
                                          selectTime1 = null;
                                          setState(() {});
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(color: notifire.getCarColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 3),
                                            child: Text(
                                                selectTime?.format(context) ??
                                                    "Pick-Up Time".tr,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.europaWoff,
                                                    fontSize: 15,
                                                    color: notifire
                                                        .getwhiteblackcolor)),
                                          ),
                                          Image.asset(Appcontent.timer,
                                              height: 30,color: notifire.getwhiteblackcolor),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time of Return'.tr,
                                    style: TextStyle(
                                        fontFamily: FontFamily.europaBold,
                                        fontSize: 15,
                                        color: notifire.getwhiteblackcolor)),
                                SizedBox(height: Get.height / 60),
                                InkWell(
                                  onTap: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                      context: context,
                                      initialTime:
                                          selectTime1 ?? TimeOfDay.now(),
                                    );
                                    setState(() {
                                      selectTime1 = time;
                                    });
                                    if (sdate! == edate) {
                                      if (selectTime == selectTime1) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please select a different time.".tr);
                                        selectTime = null;
                                        selectTime1 = null;
                                        setState(() {});
                                      } else {
                                        if (selectTime.isNull) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please select a valid date.".tr);
                                          selectTime = null;
                                          selectTime1 = null;
                                          setState(() {});
                                        } else {
                                          bool ty =
                                              getTime(selectTime, selectTime1);

                                          if (ty) {
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please select a valid time.");
                                            selectTime = null;
                                            selectTime1 = null;
                                            setState(() {});
                                          }
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(color: notifire.getCarColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: Text(
                                                selectTime1?.format(context) ??
                                                    "Return Time".tr,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.europaWoff,
                                                    fontSize: 15,
                                                    color: notifire
                                                        .getwhiteblackcolor)),
                                          ),
                                          Image.asset(Appcontent.timer,
                                              height: 30,color: notifire.getwhiteblackcolor),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

getTime(startTime, endTime) {
  bool result = false;
  int startTimeInt = (startTime.hour * 60 + startTime.minute) * 60;
  int EndTimeInt = (endTime.hour * 60 + endTime.minute) * 60;
  int dif = EndTimeInt - startTimeInt;

  if (EndTimeInt > startTimeInt) {
    result = true;
  } else {
    result = false;
  }
  return result;
}

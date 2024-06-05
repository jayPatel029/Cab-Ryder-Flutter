// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, empty_catches, prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:carlink/controller/favorite_controller.dart';
import 'package:carlink/screen/detailcar/cardetails_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/common.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/bookdetails_modal.dart';
import '../../utils/Dark_lightmode.dart';
import '../../utils/config.dart';
import '../../utils/fontfameli_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BookdetailScreen extends StatefulWidget {
  final String id;
  const BookdetailScreen({super.key, required this.id});

  @override
  State<BookdetailScreen> createState() => _BookdetailScreenState();
}

class _BookdetailScreenState extends State<BookdetailScreen> {
  late ColorNotifire notifire;
  late GoogleMapController mapController;

  BookDetailsModal? bookDetails;
  bool isLoading = true;
  List img =[];
  int inDex=0;

  // Book Detail Api
  Future bDetail(uid, bId) async {
    Map body = {
      "uid": uid,
      "book_id": bId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.bookDetail), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          bookDetails = bookDetailsModalFromJson(response.body);
          img = bookDetails!.bookDetails[inDex].carImg.toString().split("\$;");
          isLoading = false;
        });
        for(int i=0; i < bookDetails!.bookDetails[0].exterPhoto.length; i++){
          listOfUrls.add("${Config.imgUrl}${bookDetails!.bookDetails[0].exterPhoto[i]}");
          setState(() {});
        }
        for(int i=0; i < bookDetails!.bookDetails[0].interPhoto.length; i++){
          listOfUrls1.add("${Config.imgUrl}${bookDetails!.bookDetails[0].interPhoto[i]}");
          setState(() {});
        }
      } else {}
    }catch(e){}
  }
  Future verifyOtp(bid, uId, status, otp) async {

    Map body = {
      "book_id": bid,
      "uid": uId,
      "status": status,
      "otp": otp,
    };


    try{
      var response = await http.post(Uri.parse('${Config.baseUrl}${Config.otpVerify}'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        return data;
      }else {
      }
    }catch(e){
    }
  }
  var Id;
  var currencies;
  @override
  void initState() {
    addCustomIcon();
    validate();
    super.initState();
    bookdetailController.changeShimmer();
  }

  @override
  void dispose() {
    overlayController.close();
    super.dispose();
  }

  Future validate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Id = jsonDecode(sharedPreferences.getString('UserLogin')!);
    currencies = jsonDecode(sharedPreferences.getString('bannerData')!);
    sharedPreferences.setString('id', widget.id);
    bDetail(Id['id'], widget.id);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), Appcontent.mapPin).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    },
    );
  }

  Future pickup(uid, book, size, sizes) async {
    var headers = {
      'Cookie': 'PHPSESSID=du090smokg8284t6m11p7h38cl'
    };
    var request = http.MultipartRequest('POST', Uri.parse(Config.baseUrl+Config.pickUp));
    request.fields.addAll({
      'uid': uid,
      'book_id': book,
      'size': size,
      'sizes': sizes,
    });
    for(int a=0; a<image.length; a++){
      request.files.add(await http.MultipartFile.fromPath('carint$a', image[a]));
    }

    for(int b=0; b<image1.length; b++){
      request.files.add(await http.MultipartFile.fromPath('carext$b', image1[b]));
    }

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    else {
      return jsonDecode(await response.stream.bytesToString());
    }
  }

  TextEditingController commentController = TextEditingController();
  TextEditingController reason = TextEditingController();
  var rated;
  Future rate(uid, book, tRate, rText) async {
    Map body = {
      "uid": uid,
      "book_id": book,
      "total_rate": tRate,
      "rate_text": rText,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.rate), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        return data;
      } else {}
    }catch(e){}
  }
  Future drop(uid, book) async {
    Map body = {
      "uid": uid,
      "book_id": book,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.drop), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        return data;
      } else {}
    }catch(e){}
  }

  Future cancel(uid, book, reason) async {
    Map body = {
      "uid": uid,
      "book_id": book,
      "cancle_reason": reason,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.cancel), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        return data;
      } else {}
    }catch(e){}
  }

  List<String> image=[];
  List<String> image1=[];
  ImagePicker imagePicker =ImagePicker();
  ImagePicker imagePicker1 =ImagePicker();

  Future picker() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    if(file!=null){
      setState(() {
        image.add(file.path);
      });
    } else{
    }
  }
  Future picker1() async {
    XFile? file = await imagePicker1.pickImage(source: ImageSource.camera);
    if(file!=null){
      setState(() {
        image1.add(file.path);
      });
    }else{
    }
  }

  Future<void> _refresh()async {
    Future.delayed(const Duration(seconds: 1),() {
      setState(() {
        bDetail(Id['id'], widget.id);
      });
    },);
  }

  CarouselController carouselController = CarouselController();
  OtpFieldController otpFieldController = OtpFieldController();
  bool loading = false;
  int _current = 0;
  List temp =[];

  String code = "";
  var carId;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return RefreshIndicator(
      onRefresh: _refresh,
      color: onbordingBlue,
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
        floatingActionButton:isLoading ? SizedBox() :  Container(
          decoration: BoxDecoration(
              color: notifire.getbgcolor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bookDetails!.bookDetails[0].bookStatus == "Completed" ?SizedBox() : bookDetails!.bookDetails[0].bookStatus == "Pending" ?  Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(Get.width / 2.2, 50),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        backgroundColor: notifire.getbgcolor,
                        StatefulBuilder(builder: (context, setState) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Column(
                                children: [
                                  Center(child: Text('Cancel Booking Reason'.tr,style: TextStyle(fontSize: 20, fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor))),
                                  SizedBox(height: 13),
                                  TextField(
                                    style: TextStyle(color: notifire.getwhiteblackcolor),
                                    controller: reason,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: onbordingBlue)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: notifire.getborderColor),borderRadius: BorderRadius.circular(10)),
                                      border: OutlineInputBorder(),
                                      hintText: 'Cancel Reason'.tr,
                                      hintStyle: TextStyle(color: notifire.getwhiteblackcolor)
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(Get.width, 50),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        backgroundColor: onbordingBlue,
                                      ),
                                      onPressed: () {
                                        if(reason.text.isNotEmpty){
                                          cancel(Id['id'], widget.id, reason.text).then((value) {
                                            bDetail(Id['id'], widget.id);
                                            if(value['ResponseCode'] == "200"){
                                              Get.back();
                                              Fluttertoast.showToast(msg: value['ResponseMsg']);
                                            }else{
                                              Fluttertoast.showToast(msg: value['ResponseMsg']);
                                            }
                                          });
                                        } else{
                                          Fluttertoast.showToast(msg: 'Please some your text!!');
                                        }
                                      },
                                      child: Text('Submit'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        ),
                      );
                    },
                    child: Text('Cancel'.tr, style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: FontFamily.europaBold)),
                  ),
                ):SizedBox(),
                bookDetails!.bookDetails[0].bookStatus == "Pending" ?SizedBox(width: 5):SizedBox(),

                bookDetails!.bookDetails[0].bookStatus == "Completed" ?Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(Get.width, 50),
                      side: BorderSide(color: onbordingBlue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Get.to(CarDetailsScreen(id: carId, currency: currencies['currency']));
                    },
                    child: Text('Book again', style: TextStyle(fontSize: 15, color: onbordingBlue, fontFamily: FontFamily.europaBold)),
                  ),
                ):SizedBox(),
                bookDetails!.bookDetails[0].bookStatus == "Cancelled" ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(Get.width, 50),
                        side: BorderSide(color: onbordingBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        Get.to(CarDetailsScreen(id: carId, currency: currencies['currency']));
                      },
                      child: Text('Book again'.tr, style: TextStyle(fontSize: 15, color: onbordingBlue, fontFamily: FontFamily.europaBold)),
                    ),
                  ),
                ):SizedBox(),

                bookDetails!.bookDetails[0].bookStatus == "Pending" ?SizedBox(): bookDetails!.bookDetails[0].isRate == '0' ?SizedBox(width: 10):SizedBox(width: 10),

                if (bookDetails!.bookDetails[0].bookStatus == "Pending") Expanded(
                  child:   ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width, 50),
                      backgroundColor: onbordingBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        backgroundColor: notifire.getbgcolor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text('OTP for pickup the car'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 20)),
                                  SizedBox(height: 13),
                                  OTPTextField(
                                    controller: otpFieldController,
                                    length: 4,
                                    width: MediaQuery.of(context).size.width,
                                    otpFieldStyle: OtpFieldStyle(
                                      enabledBorderColor: greyScale,
                                    ),
                                    fieldWidth: 60,
                                    style: TextStyle(fontSize: 17,color: notifire.getwhiteblackcolor),
                                    keyboardType: TextInputType.number,
                                    textFieldAlignment: MainAxisAlignment.spaceEvenly,
                                    fieldStyle: FieldStyle.box,
                                    onChanged: (value) {
                                      setState(() {
                                        code = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 13),
                                  Text('Important: The car renter has a 4-digit OTP. Please verify this code with them before releasing the car.'.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: Colors.grey, fontSize: 16),textAlign: TextAlign.center),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(Get.width, 50),
                                      backgroundColor: onbordingBlue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    onPressed: () {
                                      verifyOtp(bookDetails!.bookDetails[0].bookId, Id['id'], 'Pickup', code).then((value) {
                                        if(value["ResponseCode"] == "200"){
                                          Get.back();
                                          showModalBottomSheet(
                                            backgroundColor: notifire.getbgcolor,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Scaffold(
                                                      backgroundColor: Colors.transparent,
                                                      bottomNavigationBar: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            fixedSize: Size(Get.width, 50),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                            backgroundColor: onbordingBlue,
                                                          ),
                                                          onPressed: () {
                                                            if(image.isNotEmpty && image1.isNotEmpty){
                                                              setState(() {
                                                                loading=true;
                                                              });
                                                              pickup(Id['id'], widget.id, image.length.toString(), image1.length.toString()).then((value) {
                                                                bDetail(Id['id'], widget.id);
                                                                rate(Id['id'], widget.id, rated,commentController.text);
                                                                if(value["ResponseCode"] == "200"){
                                                                  setState(() {
                                                                    loading=false;
                                                                  });
                                                                  Get.back();
                                                                  Fluttertoast.showToast(msg: value['ResponseMsg']);
                                                                } else{
                                                                  setState(() {
                                                                    loading=false;
                                                                  });
                                                                  Fluttertoast.showToast(msg: value['ResponseMsg']);
                                                                }
                                                              });
                                                            } else{
                                                              Fluttertoast.showToast(msg: 'Please Upload your image!!');
                                                            }
                                                          },
                                                          child: Text('Confirm Pick-up'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                                                        ),
                                                      ),
                                                      body: StatefulBuilder(builder: (context, setState) {
                                                        return Stack(
                                                          children: [
                                                            loading ? loader() : SizedBox(),
                                                            Padding(
                                                              padding: const EdgeInsets.all(13),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Center(child: Text('Pick Up'.tr,style: TextStyle(fontSize: 20, fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor))),
                                                                    Text('Car Interior & Exterior'.tr,style: TextStyle(fontSize: 20, fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor)),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        picker().then((value) {
                                                                          setState((){});
                                                                        });
                                                                      },
                                                                      child: Container(
                                                                        height: 50,
                                                                        margin: const EdgeInsets.symmetric(vertical: 15),
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          border: Border.all(color: onbordingBlue),
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: 22,
                                                                              width: 22,
                                                                              decoration: BoxDecoration(
                                                                                color: onbordingBlue,
                                                                                borderRadius: BorderRadius.circular(20),
                                                                              ),
                                                                              child: const Center(child: Icon(Icons.add, color: Colors.white, size: 18,)),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            Text('Upload Car Interior & Exterior'.tr, style: TextStyle(fontSize: 18, color: onbordingBlue, fontFamily: 'GilroyBold'),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    image.isEmpty ?Text('No Image Selected'.tr, style: TextStyle(color: notifire.getwhiteblackcolor)) :SizedBox(
                                                                      height: 164,
                                                                      child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemCount: image.length,
                                                                        itemBuilder: (context, index) {
                                                                          return Stack(
                                                                            clipBehavior: Clip.none,
                                                                            children: [
                                                                              Container(
                                                                                height: 300,
                                                                                width: 150,
                                                                                margin: EdgeInsets.only(right: 15),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    image: DecorationImage(image: FileImage(File(image[index])),fit: BoxFit.cover)
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                right: 5,
                                                                                top: -8,
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      image.removeAt(index);
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 26,
                                                                                    width: 26,
                                                                                    decoration: BoxDecoration(
                                                                                      color: onbordingBlue,
                                                                                      borderRadius: BorderRadius.circular(20),
                                                                                    ),
                                                                                    child: const Center(child: Icon(Icons.close, color: Colors.white, size: 18,)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },),
                                                                    ),
                                                                    SizedBox(height: 13),
                                                                    Text('ID Proof or Driving License'.tr,style: TextStyle(fontSize: 20, fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor)),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        picker1().then((value) {
                                                                          setState((){});
                                                                        });
                                                                      },
                                                                      child: Container(
                                                                        height: 50,
                                                                        margin: const EdgeInsets.symmetric(vertical: 15),
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          border: Border.all(color: onbordingBlue),
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: 22,
                                                                              width: 22,
                                                                              decoration: BoxDecoration(
                                                                                color: onbordingBlue,
                                                                                borderRadius: BorderRadius.circular(20),
                                                                              ),
                                                                              child: const Center(child: Icon(Icons.add, color: Colors.white, size: 18,)),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            Text('Upload ID Proof or Driving License'.tr, style: TextStyle(fontSize: 18, color: onbordingBlue, fontFamily: 'GilroyBold'),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    image1.isEmpty ?Text('No Image Selected'.tr, style: TextStyle(color: notifire.getwhiteblackcolor)) :SizedBox(
                                                                      height: 164,
                                                                      child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemCount: image1.length,
                                                                        itemBuilder: (context, index) {
                                                                          return Stack(
                                                                            clipBehavior: Clip.none,
                                                                            children: [
                                                                              Container(
                                                                                height: 300,
                                                                                width: 150,
                                                                                margin: EdgeInsets.only(right: 10),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    image: DecorationImage(image: FileImage(File(image1[index])),fit: BoxFit.cover)
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                right: 5,
                                                                                top: -8,
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      image1.removeAt(index);
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 26,
                                                                                    width: 26,
                                                                                    decoration: BoxDecoration(
                                                                                      color: onbordingBlue,
                                                                                      borderRadius: BorderRadius.circular(20),
                                                                                    ),
                                                                                    child: const Center(child: Icon(Icons.close, color: Colors.white, size: 18,)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                      ),
                                                    );
                                                  },
                                                );
                                              });
                                          Fluttertoast.showToast(msg: value["ResponseMsg"]);
                                        } else{
                                          Fluttertoast.showToast(msg: value["ResponseMsg"]);
                                        }
                                      });
                                    },
                                    child: Text( 'Pick Up'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      );
                    },
                    child: Text( 'Pick Up OTP'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                  ),
                ) else bookDetails!.bookDetails[0].bookStatus == "Pick_up" ?  Expanded(
                  child:   ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width, 50),
                      backgroundColor: onbordingBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        backgroundColor: notifire.getbgcolor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text('OTP for Drop the car'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 20)),
                                SizedBox(height: 13),
                                OTPTextField(
                                  controller: otpFieldController,
                                  length: 4,
                                  width: MediaQuery.of(context).size.width,
                                  fieldWidth: 60,
                                  style: TextStyle(fontSize: 17, color: notifire.getwhiteblackcolor),
                                  keyboardType: TextInputType.number,
                                  otpFieldStyle: OtpFieldStyle(
                                    enabledBorderColor: greyScale,
                                  ),
                                  textFieldAlignment: MainAxisAlignment.spaceEvenly,
                                  fieldStyle: FieldStyle.box,
                                  onChanged: (value) {
                                    setState(() {
                                      code = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 13),
                                Text('Important: The car renter has a 4-digit OTP. Please verify this code with them before releasing the car.' , style: TextStyle(fontFamily: FontFamily.europaWoff, color: Colors.grey, fontSize: 16),textAlign: TextAlign.center),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(Get.width, 50),
                                    backgroundColor: onbordingBlue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  ),
                                  onPressed: () {
                                    verifyOtp(bookDetails!.bookDetails[0].bookId, Id['id'], 'Drop', code).then((value) {
                                      if(value["ResponseCode"] == "200"){
                                        Get.back();
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            isDismissible: false,
                                            isScrollControlled: true,
                                            context: context,
                                            backgroundColor: notifire.getbgcolor,
                                            builder: (context) {
                                              return StatefulBuilder(builder: (context, setState) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(13),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Center(child: Image.asset(Appcontent.drop,height: 96)),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: 8),
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
                                                              subtitle: Text(bookDetails!.bookDetails[0].pickAddress, style: TextStyle(fontFamily: FontFamily.europaWoff, fontSize: 16, color: greyScale1),),
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
                                                              markers: {
                                                                Marker(
                                                                  markerId: MarkerId('1'),
                                                                  position: LatLng(double.parse(bookDetails!.bookDetails[0].pickLat), double.parse(bookDetails!.bookDetails[0].pickLng)),
                                                                  icon: markerIcon,
                                                                ),
                                                              },
                                                              initialCameraPosition:  CameraPosition(
                                                                target: LatLng(double.parse(bookDetails!.bookDetails[0].pickLat), double.parse(bookDetails!.bookDetails[0].pickLng)), //initial position
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
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            fixedSize: Size(Get.width, 56),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                            backgroundColor: onbordingBlue,
                                                          ),
                                                          onPressed: () {
                                                            drop(Id['id'], widget.id).then((value) {
                                                              bDetail(Id['id'], widget.id);
                                                              rate(Id['id'], widget.id, rated,commentController.text);
                                                              if(value["ResponseCode"] == "200"){
                                                                Get.back();
                                                                setState(() {});
                                                                Fluttertoast.showToast(msg: value['ResponseMsg']);
                                                              } else{
                                                                Fluttertoast.showToast(msg: value['ResponseMsg']);
                                                              }
                                                            });
                                                          },
                                                          child: Text('Confirm Drop-off'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                                                        ),
                                                        SizedBox(height: 10),
                                                        OutlinedButton(
                                                          style: OutlinedButton.styleFrom(
                                                            fixedSize: Size(Get.width, 56),
                                                            side: BorderSide(color: greyScale),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),side: BorderSide(color: greyScale)),
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text('Cancel'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              );
                                            });
                                        Fluttertoast.showToast(msg: value["ResponseMsg"]);
                                      } else{
                                        Fluttertoast.showToast(msg: value["ResponseMsg"]);
                                      }
                                    });
                                  },
                                  child: Text( 'Drop OTP'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text( 'Drop'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                  ),
                ) :SizedBox(),

                bookDetails!.bookDetails[0].bookStatus == "Completed" ? bookDetails!.bookDetails[0].isRate == '0' ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width / 2.2, 50),
                      backgroundColor: onbordingBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        backgroundColor: notifire.getbgcolor,
                        StatefulBuilder(builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.all(13),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(child: Text('Rate Your Rental Car'.tr,style: TextStyle(fontSize: 20, fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor))),
                                  SizedBox(height: 13),
                                  RatingBar.builder(
                                    initialRating: 1,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    unratedColor: greyScale,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemSize: 25,
                                    itemBuilder: (context, _) => Image.asset(Appcontent.star1),
                                    onRatingUpdate: (rating) {
                                      setState((){
                                        rated = rating;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 13),
                                  TextField(
                                    style: TextStyle(color: notifire.getwhiteblackcolor),
                                    controller: commentController,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: onbordingBlue)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: greyScale)),
                                      border: OutlineInputBorder(borderSide: BorderSide(color: notifire.getwhiteblackcolor)),
                                      hintText: 'Comment'.tr,
                                      hintStyle: TextStyle(color: notifire.getwhiteblackcolor)
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(Get.width, 50),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        backgroundColor: onbordingBlue,
                                      ),
                                      onPressed: () {
                                        if(commentController.text.isNotEmpty){
                                          rate(Id['id'], widget.id, rated, commentController.text).then((value) {
                                            if(value["ResponseCode"] == "200"){
                                              bDetail(Id['id'], widget.id);
                                              rate(Id['id'], widget.id, rated,commentController.text);
                                              Get.back();
                                              setState(() {});
                                              Fluttertoast.showToast(msg: value['ResponseMsg']);
                                            } else{
                                              Fluttertoast.showToast(msg: value['ResponseMsg']);
                                            }
                                          });
                                        } else {
                                          Fluttertoast.showToast(msg: 'Please some your text!!');
                                        }
                                      },
                                      child: Text('Submit'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white, fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        ),
                      );
                    },
                    child: Text('Rate Your Rental Car'.tr)) :SizedBox() : SizedBox(),
              ],
            ),
          ),
        ),
        body: isLoading ? loader() : GetBuilder<BookdetailController>(
          builder: (bookdetailController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: bookDetails?.bookDetails.length,
                itemBuilder: (context, index) {
                  carId = bookDetails?.bookDetails[index].carId;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        itemCount:bookDetails?.bookDetails.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index2) {
                          return Container(
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
                                      img.length == 1 ? Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: Get.width,
                                            // margin: EdgeInsets.only(right: 5, left: 5, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              image: DecorationImage(image: NetworkImage('${Config.imgUrl}${img[index]}'), fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
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
                                        itemCount: img.length,
                                        itemBuilder: (context, index, realIndex) {
                                          return Stack(
                                            children: [
                                              Container(
                                                height: 200,
                                                width: Get.width,
                                                // margin: EdgeInsets.only(right: 5, left: 5, top: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  image: DecorationImage(image: NetworkImage('${Config.imgUrl}${img[index]}'), fit: BoxFit.cover),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
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
                                            blurTitle(title: bookDetails!.bookDetails[index2].carTitle,context: context),
                                            blurRating(rating: bookDetails!.bookDetails[index2].carRating, color: Colors.white, context: context),
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
                                              Text(bookDetails!.bookDetails[index2].carNumber, style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                              img.length == 1 ? SizedBox() : Center(
                                                child: SizedBox(
                                                  height: 6,
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: img.length,
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
                                              Text('${currencies['currency']}${bookDetails!.bookDetails[index2].oTotal == "0" ? bookDetails!.bookDetails[index2].wallAmt : bookDetails!.bookDetails[index2].oTotal} / ${bookDetails!.bookDetails[index2].totalDayOrHr} ${bookDetails!.bookDetails[index2].priceType}', style: TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        carTool(image: Appcontent.engine, number: bookDetails!.bookDetails[index2].engineHp, text: 'hp'.tr),
                                        carTool(image: Appcontent.gearbox, title: bookDetails!.bookDetails[index2].engineHp == '1' ? 'Automatic'.tr : 'Manual'.tr),
                                        carTool(image: Appcontent.petrol,title: bookDetails!.bookDetails[index2].fuelType == '0' ? 'Petrol'.tr : bookDetails!.bookDetails[index2].fuelType == '1' ? 'Diesel'.tr : bookDetails!.bookDetails[index2].fuelType == '2' ? 'Electric'.tr : bookDetails!.bookDetails[index2].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr),
                                        carTool(image: Appcontent.seat, number: bookDetails!.bookDetails[index2].totalSeat, text: 'Seats'.tr),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10),
                      Text('Rent Partner'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            bookDetails!.bookDetails[index].ownerImg.isEmpty ? CircleAvatar(backgroundImage: AssetImage(Appcontent.profile)) : bookDetails!.bookDetails[index].ownerName == "admin" ? CircleAvatar(backgroundImage: AssetImage(Appcontent.appLogo)) : CircleAvatar(backgroundImage: NetworkImage('${Config.imgUrl}${bookDetails!.bookDetails[index].ownerImg}')),
                            SizedBox(width: 13),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bookDetails!.bookDetails[index].ownerName, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                                Text(bookDetails!.bookDetails[index].ownerContact, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getgreycolor, fontSize: 13)),
                              ],
                            ),
                            Spacer(),
                            InkWell(
                              onTap: ()  {
                                _makePhoneCall(bookDetails!.bookDetails[index].ownerContact);
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

                      SizedBox(height: 10),


                      bookDetails!.bookDetails[index].bookStatus == 'Cancelled' ?  Column(
                        children: [
                          Row(
                            children: [
                               Text('Cancel Status  :  '.tr, style: TextStyle(fontSize: 15, color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
                               Text(bookDetails!.bookDetails[index].bookStatus, style: TextStyle(fontSize: 15, color: onbordingBlue, fontFamily: FontFamily.europaBold)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Cancel Reason :  '.tr, style: TextStyle(fontSize: 15, color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold)),
                              Text(bookDetails!.bookDetails[index].cancleReason, style: TextStyle(fontSize: 15, color: onbordingBlue, fontFamily: FontFamily.europaBold)),
                            ],
                          ),
                        ],
                      ):SizedBox(),

                      SizedBox(height: 10),
                      Text( 'Car Location'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 20)),
                      Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            markers: {
                              Marker(
                                markerId: MarkerId('1'),
                                position: LatLng(double.parse(bookDetails!.bookDetails[index].pickLat), double.parse(bookDetails!.bookDetails[index].pickLng)),
                                icon: markerIcon,
                              ),
                            },
                            initialCameraPosition:  CameraPosition(target: LatLng(double.parse(bookDetails!.bookDetails[index].pickLat), double.parse(bookDetails!.bookDetails[index].pickLng)), zoom: 15.0),
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
                      Row(
                        children: [
                          Image.asset(Appcontent.location, height: 18, color: notifire.getwhiteblackcolor),
                          SizedBox(width: 10),
                          Expanded(child: Text(bookDetails!.bookDetails[index].pickAddress,style: TextStyle(color: notifire.getwhiteblackcolor, fontFamily: FontFamily.europaBold))),
                        ],
                      ),

                      SizedBox(height: 15),
                      Text('Detail'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      Row(
                        children: [
                          Image.asset(Appcontent.filetext, color: notifire.getwhiteblackcolor, height: 30),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Booking ID'.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 15)),
                              Text(bookDetails!.bookDetails[index].bookId, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(Appcontent.calender, height: 30, color: notifire.getwhiteblackcolor),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pick-up'.tr, maxLines: 1, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 15, overflow: TextOverflow.ellipsis)),
                              Text('${bookDetails!.bookDetails[index].pickupDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${bookDetails!.bookDetails[index].pickupDate.toString().split(" ").first} ${bookDetails!.bookDetails[index].pickupTime}'))}', maxLines: 1, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 13, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Drop-off'.tr, style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getgreycolor, fontSize: 15, overflow: TextOverflow.ellipsis)),
                              Text('${bookDetails!.bookDetails[index].returnDate.toString().split(" ").first} - ${DateFormat('hh:mm a').format(DateTime.parse('${bookDetails!.bookDetails[index].returnDate.toString().split(" ").first} ${bookDetails!.bookDetails[index].returnTime}'))}', style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 13, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          SizedBox(width: 13),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text('Payment information'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),

                      SizedBox(height: 8),
                      listTile(title: '${'Car Price'.tr} (${bookDetails!.bookDetails[index].bookType} driver)'.tr, subtitle: '${currencies['currency']}${bookDetails!.bookDetails[index].carPrice}'),
                      listTile(title: 'Type'.tr, subtitle: '${bookDetails!.bookDetails[index].totalDayOrHr} ${bookDetails!.bookDetails[index].priceType}'),

                      listTile(title: 'Subtotal'.tr, subtitle: '${currencies['currency']}${bookDetails!.bookDetails[index].subtotal}'),

                      bookDetails!.bookDetails[index].couAmt == '0' ?SizedBox() : listTile(title: 'Coupon Amount'.tr, subtitle: '${currencies['currency']}${bookDetails!.bookDetails[index].couAmt}'),
                      bookDetails!.bookDetails[index].wallAmt == '0' ?SizedBox() :listTile(title: 'Wallet Amount'.tr, subtitle: '${currencies['currency']}${bookDetails!.bookDetails[index].wallAmt}'),
                      listTile(title: '${'Taxes & Fee'.tr} (${bookDetails!.bookDetails[index].taxPer} %)'.tr, subtitle: '${currencies['currency']}${bookDetails!.bookDetails[index].taxAmt}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          height: 10,
                          color: greyScale,
                        ),
                      ),
                      bookDetails!.bookDetails[index].transactionId =='0'?SizedBox() : listTile(title: 'Total with taxes'.tr, subtitle: '${currencies['currency']}${bookDetails!.bookDetails[index].oTotal}'),

                      Text('Payment Method'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      SizedBox(height: 8),
                      bookDetails!.bookDetails[index].transactionId == '0' ?   listTile(title: 'Payment Method Name'.tr, subtitle: "Wallet".tr) :   listTile(title: 'Payment Method Name'.tr, subtitle: bookDetails!.bookDetails[index].paymentMethodName),
                      bookDetails!.bookDetails[index].transactionId =='0'?SizedBox() : listTile(title: 'Transaction ID'.tr, subtitle: bookDetails!.bookDetails[index].transactionId),


                      bookDetails!.bookDetails[index].exterPhoto.isEmpty ?SizedBox() :Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('Interior & Exterior Image'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      ),

                      bookDetails!.bookDetails[index].exterPhoto.isEmpty ?SizedBox() :GalleryImage(
                        padding: EdgeInsets.only(top: 13, bottom: 13, right: 10),
                        childAspectRatio: 0.8,
                        imageRadius: 13,
                        closeWhenSwipeDown: true,
                        showAppBar: false,
                        imageUrls: listOfUrls,
                        numOfShowImages: listOfUrls.length,
                        titleGallery: 'Gallery'.tr,
                      ),

                      bookDetails!.bookDetails[index].interPhoto.isEmpty ?SizedBox() :Text('ID Proof or Driving License'.tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor, fontSize: 18)),
                      bookDetails!.bookDetails[index].interPhoto.isEmpty ?SizedBox() :GalleryImage(
                        padding: EdgeInsets.only(top: 13, bottom: 13, right: 10),
                        childAspectRatio: 0.8,
                        imageRadius: 13,
                        closeWhenSwipeDown: true,
                        showAppBar: false,
                        imageUrls: listOfUrls1,
                        numOfShowImages: listOfUrls1.length,
                        titleGallery: 'Gallery'.tr,
                      ),

                      bookDetails?.bookDetails[index].bookStatus == "Drop" ? SizedBox() : SizedBox(height: 70),
                    ],
                  );
              },),
            );
          }
        ),
      ),
    );
  }
  List<String> listOfUrls =[];
  List<String> listOfUrls1 =[];
  BookdetailController bookdetailController =Get.put(BookdetailController());
  StreamController<Widget> overlayController = StreamController<Widget>.broadcast();
  int Index=0;
  exterior(){
    return Container(
      height: 200,
      width: Get.width,
      margin: EdgeInsets.only(right: 12),
      child: Shimmer.fromColors(
        baseColor: notifire.isDark ? Colors.black45 : Colors.grey.shade100,
        highlightColor: notifire.isDark ? Color(0xFF475569) : Color(0xFFeaeff4),
        child: ListView.builder(
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            Index=index;
            return Container(
              height: 330,
              width: 155,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
  interior(){
    return Container(
      height: 200,
      width: Get.width,
      margin: EdgeInsets.only(right: 12),
      child: Shimmer.fromColors(
        baseColor: notifire.isDark ? Colors.black45 : Colors.grey.shade100,
        highlightColor: notifire.isDark ? Color(0xFF475569) : Color(0xFFeaeff4),
        child: ListView.builder(
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              height: 200,
              width: 155,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
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
        SizedBox(width: 8),
        Image.asset(image, height: 20, width: 20, color: notifire.getwhiteblackcolor),
        SizedBox(width: 4),
        Text(title ??'', style: TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
        RichText(text: TextSpan(
          children: [
            TextSpan(text: number,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: text,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            const WidgetSpan(child: SizedBox(width: 9)),
          ],
        )),
      ],
    );
  }
}

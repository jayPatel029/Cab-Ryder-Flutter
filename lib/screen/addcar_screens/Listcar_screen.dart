// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/mycarlist_modal.dart';
import 'package:carlink/screen/addcar_screens/addcar_screen.dart';
import 'package:carlink/screen/addcar_screens/addcargallery_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/common_ematy.dart';
import 'package:carlink/utils/common.dart';
import 'package:carlink/utils/config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/fontfameli_model.dart';

class ListCarScreen extends StatefulWidget {
  final String? uid;
  const ListCarScreen({super.key, this.uid});

  @override
  State<ListCarScreen> createState() => _ListCarScreenState();
}

class _ListCarScreenState extends State<ListCarScreen> {
  late ColorNotifire notifire;
  @override
  void initState() {
    getvalidate();
    super.initState();
  }

  List image=[];
  List temp=[];
  MyCarListModal? myCarListModal;
  bool isLoading =true;
  Future listCar(uId) async {
    Map body ={
      "uid": uId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.carList),body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          myCarListModal = myCarListModalFromJson(response.body);
          isLoading =false;
        });
        for(int i=0; i<myCarListModal!.mycarlist.length; i++){
          temp.add(0);
        }
        var data = jsonDecode(response.body.toString());
        return data;
      } else{}
    } catch(e){
      debugPrint(e.toString());
    }
  }

  var id;
  Future getvalidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = widget.uid == "0" ? "0" : jsonDecode(sharedPreferences.getString('UserLogin')!);
    listCar(widget.uid == "0" ? "0" :id['id']);
  }

  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        backgroundColor: onbordingBlue,
        elevation: 0,
        centerTitle: true,
        title:  Text('My Car List'.tr, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
                onPressed: () {
                  button = true;
                  nameController.clear();
                  cNumberController.clear();
                  driverController.clear();
                  mobileController.clear();
                  ratingController.clear();
                  seatController.clear();
                  withoutRent.clear();
                  withRent.clear();
                  engineController.clear();
                  locationController.clear();
                  latController.clear();
                  lngController.clear();
                  totalKmController.clear();
                  descController.clear();
                  addressController.clear();
                  multiSelect1.clear();
                  multiSelect.clear();
                  minimumController.clear();
                  netImg.clear();
                  image.clear();
                  dropId = "";
                  ccode ="";
                  carStatus = null;
                  ac = null;
                  gear = null;
                  carType = null;
                  carBrand = null;
                  carPrice = null;
                  carFuel = null;
                  setState(() {});
                  Get.to(AddCarScreen(uid: widget.uid == "0" ? "0" : widget.uid));
                },
                child: Text('Add Car'.tr,style: TextStyle(fontFamily: FontFamily.europaBold,color: onbordingBlue))),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body:isLoading ? loader() : myCarListModal!.mycarlist.isEmpty ? ematyCar(title: 'My Car List'.tr,  colors: notifire.getwhiteblackcolor) : myCarListModal!.mycarlist.isEmpty ? ematyCar(title: 'My Car List'.tr,colors: notifire.getwhiteblackcolor) :  SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Text('List Of Car'.tr,style: TextStyle(color: notifire.getwhiteblackcolor,fontSize: 18,fontFamily: FontFamily.europaBold)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myCarListModal?.mycarlist.length,
                itemBuilder: (context, index) {
                image = myCarListModal!.mycarlist[index].carImg.toString().split("\$;");
                return Container(
                  // height: 250,
                  width: Get.size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  padding: const EdgeInsets.only(bottom: 10),
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
                                  height: 204,
                                  width: Get.width,
                                  margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(image: NetworkImage('${Config.imgUrl}${myCarListModal!.mycarlist[index].carImg}'), fit: BoxFit.cover),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
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
                              itemBuilder: (context, index1, realIndex) {
                                return Stack(
                                  children: [
                                    Container(
                                      height: 210,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(image: NetworkImage('${Config.imgUrl}${image[index1]}'), fit: BoxFit.cover),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                onPageChanged: (index2, reason) {
                                  setState(() {
                                    temp[index] = index2;
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              right: 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  blurRating(rating: myCarListModal!.mycarlist[index].carRating, color: Colors.white, context: context),
                                  Row(
                                    children: [
                                      // Car Gallery Add and Edit
                                      myCarListModal?.mycarlist[index].totalGallery == 0 ? InkWell(
                                        onTap: () {
                                          eButton = true;
                                          Get.to( AddCarGalleryScreen(title: 'Add Car ', uid: widget.uid,id: myCarListModal?.mycarlist[index].id, carTitle: myCarListModal?.mycarlist[index].carTitle))!.then((value) {
                                            setState(() {
                                              listCar(widget.uid == "0" ? "0" :id['id']);
                                            });
                                          });
                                        },
                                        child: blurTitle(title: 'Add Gallery'.tr,context: context),
                                      ) : InkWell(
                                        onTap: () {
                                          eButton = false;
                                          Get.to(AddCarGalleryScreen(title: 'Edit Car '.tr,id: myCarListModal?.mycarlist[index].id, carTitle: myCarListModal?.mycarlist[index].carTitle, uid: widget.uid))!.then((value) {
                                            setState(() {
                                              listCar(widget.uid == "0" ? "0" :id['id']);
                                            });
                                          });
                                        },
                                        child: blurTitle(title: 'Edit Gallery'.tr,context: context),
                                      ),
                                      // Car Edit
                                      InkWell(
                                        onTap: () {
                                          button = false;
                                          edit(carName: myCarListModal!.mycarlist[index].carTitle,carNumber: myCarListModal!.mycarlist[index].carNumber, status: myCarListModal!.mycarlist[index].carStatus, uploadImage: image, AC: myCarListModal!.mycarlist[index].carAc, driverName: myCarListModal!.mycarlist[index].driverName, countryCode: myCarListModal!.mycarlist[index].driverMobile.toString().split(" ").first, mobile: myCarListModal!.mycarlist[index].driverMobile.toString().split(" ").last, rating: myCarListModal!.mycarlist[index].carRating, seat: myCarListModal!.mycarlist[index].totalSeat, carGear: myCarListModal!.mycarlist[index].carGear,carFacility: myCarListModal!.mycarlist[index].carFacility, type: myCarListModal!.mycarlist[index].carType, brand: myCarListModal!.mycarlist[index].carBrand, location: myCarListModal!.mycarlist[index].carAvailable, without: myCarListModal!.mycarlist[index].carRentPrice, withrent: myCarListModal!.mycarlist[index].carRentPriceDriver, engine: myCarListModal!.mycarlist[index].engineHp, pType: myCarListModal!.mycarlist[index].priceType, fuel: myCarListModal!.mycarlist[index].fuelType, lat: myCarListModal!.mycarlist[index].pickLat, long: myCarListModal!.mycarlist[index].pickLng, totalKm: myCarListModal!.mycarlist[index].totalKm, desc: myCarListModal!.mycarlist[index].carDesc, address: myCarListModal!.mycarlist[index].pickAddress, minimum: myCarListModal!.mycarlist[index].minHrs);
                                          Get.to(AddCarScreen(id: index.toString(),uid: widget.uid, recordId: myCarListModal?.mycarlist[index].id, title: myCarListModal?.mycarlist[index].carTitle))!.then((value) {
                                            setState(() {
                                              listCar(widget.uid == "0" ? "0" :id['id']);
                                            });
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: blurTitle(title: 'Edit Car'.tr,context: context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 20,
                              right: 20,
                              bottom: 18,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(myCarListModal!.mycarlist[index].carTitle, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                  image.length == 1 ? const SizedBox() : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: image.asMap().entries.map((e) {
                                      return InkWell(
                                        onTap: () => carouselController.animateToPage(e.key),
                                        child: Container(
                                          width: temp[index] == e.key ? 24 : 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric( horizontal: 2),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: temp[index] == e.key
                                                  ? onbordingBlue
                                                  : Colors.grey
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Text(myCarListModal!.mycarlist[index].carNumber, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                carTool(image: Appcontent.engine, number: myCarListModal!.mycarlist[index].engineHp, text: 'hp'.tr),
                                carTool(image: Appcontent.gearbox, title:  myCarListModal!.mycarlist[index].carGear == '1' ? 'Automatic'.tr : 'Manual'.tr),
                                carTool(image: Appcontent.petrol,title: myCarListModal!.mycarlist[index].fuelType== '0' ? 'Petrol'.tr : myCarListModal!.mycarlist[index].fuelType == '1' ? 'Diesel'.tr : myCarListModal!.mycarlist[index].fuelType == '2' ? 'Electric'.tr :myCarListModal!.mycarlist[index].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr),
                                carTool(image: Appcontent.seat, number: myCarListModal!.mycarlist[index].totalSeat, text: 'Seats'.tr),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            }),
          ],
        ),
      ),
    );
  }
  Widget carTool({required String image,  String? title,String? number, String? text}){
    return Row(
      children: [
        Image.asset(image, height: 20, width: 20, color: notifire.getwhiteblackcolor),
        const SizedBox(width: 4),
        Text(title ??'', style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
        RichText(text: TextSpan(
          children: [
            TextSpan(text: number,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            const WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: text,style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
            const WidgetSpan(child: SizedBox(width: 6)),
          ],
        )),
      ],
    );
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables, empty_catches

import 'dart:convert';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/common.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/gallerylist_modal.dart';
import '../../model/mycarlist_modal.dart';
import '../../utils/Colors.dart';
import '../../utils/config.dart';
import '../../utils/fontfameli_model.dart';

class AddCarGalleryScreen extends StatefulWidget {
  final String title;
  final String? carTitle;
  final String? id;
  final String? uid;
  const AddCarGalleryScreen({super.key, required this.title, this.id, this.carTitle, this.uid});

  @override
  State<AddCarGalleryScreen> createState() => _AddCarGalleryScreenState();
}
bool eButton = false;
class _AddCarGalleryScreenState extends State<AddCarGalleryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isvalidate = false;


  var sender;
  var editId;

  List<String> image=[];
  List editImage=[];

  ImagePicker picker = ImagePicker();
  ImagePicker picker1 = ImagePicker();

  @override
  void initState() {
    getvalidate();
    super.initState();
  }


  Future addCar(carId, uid, size) async {
    var headers = {
      'Cookie': 'PHPSESSID=36pnj5phm83llglrqid2qnuquk'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Config.baseUrl}${Config.addGallery}'));
    request.fields.addAll({
      "car_id": carId,
      'uid': uid,
      'size': size,
    });
    for(int a=0; a<image.length; a++){
      request.files.add(await http.MultipartFile.fromPath('cargallery$a', image[a]));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      return data;
    }
    else {
      var data = jsonDecode(await response.stream.bytesToString());
      return data;
    }
  }
  Future editCar(uid, carId, recordId, img, size) async {
    var headers = {
      'Cookie': 'PHPSESSID=36pnj5phm83llglrqid2qnuquk'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Config.baseUrl}${Config.editGallery}'));
    request.fields.addAll({
      'uid': uid,
      "car_id": carId,
      "record_id": recordId,
      'imlist': img,
      'size': size,
    });
    for(int a=0; a<image.length; a++){
      request.files.add(await http.MultipartFile.fromPath('cargallery$a', image[a]));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      return data;
    }
    else {
      var data = jsonDecode(await response.stream.bytesToString());
      return data;
    }
  }

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
        var data = jsonDecode(response.body.toString());
        return data;
      } else{}
    } catch(e){}
  }

  GalleryListmodal? galleryListmodal;
  Future listGallery(uId, carId) async {
    Map body ={
      "uid": uId,
      "car_id": carId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.galleryList),body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      var data = jsonDecode(response.body.toString());
      if(response.statusCode == 200){
        setState(() {
          galleryListmodal = galleryListmodalFromJson(response.body);
          isLoading =false;
          editImage = galleryListmodal!.gallerylist[0].img.toString().split("\$;");
          editId = galleryListmodal?.gallerylist[0].id;
        });

        return data;
      } else{
        return data;
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }

  var id;

  Future getvalidate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = widget.uid == "0" ? "0" :  jsonDecode(sharedPreferences.getString('UserLogin')!);
    listGallery(widget.uid == "0" ? "0" :id['id'], widget.id);
  }
  bool load = false;
  late ColorNotifire notifire;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of(context,listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: eButton == true ?  ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: onbordingBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              fixedSize: Size(Get.width, 50)
          ),
          onPressed: () {
            if(_formKey.currentState!.validate() && image.isNotEmpty){
              addCar(widget.id, widget.uid == "0" ? "0": id['id'], image.length.toString()).then((value) {
                if(value['ResponseCode'] == "200"){
                  listCar(widget.uid == "0" ? "0": id['id']);
                  Get.back();
                  Fluttertoast.showToast(msg: value['ResponseMsg']);
                } else{
                  Fluttertoast.showToast(msg: value['ResponseMsg']);
                }
              });
            } else{
              Fluttertoast.showToast(msg: 'Please Pick your Image!!!');
            }
          },
          child:  Text('Add Car Gallery'.tr,style: const TextStyle(color: Colors.white,fontFamily: FontFamily.europaBold)),
        ) : load ? loader() : ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: onbordingBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              fixedSize: Size(Get.width, 50)
          ),
          onPressed: () {
            var size = editImage.length + image.length;
              if(size >= 1){
                setState(() {
                  load = true;
                });
                editCar(widget.uid == "0" ? "0": id['id'], widget.id, editId.toString(), editImage.isEmpty ? '0' : editImage.join("\$;"), image.length.toString()).then((value) {
                  if(value['ResponseCode'] == "200"){
                    listCar(widget.uid == "0" ? "0": id['id']);
                    setState(() {
                      load = false;
                    });
                    Get.back();
                    Fluttertoast.showToast(msg: value['ResponseMsg']);
                  } else{
                    Fluttertoast.showToast(msg: value['ResponseMsg']);
                  }
                });
              } else {
                Fluttertoast.showToast(msg: 'Please Pick your Image!!');
              }
          },
          child:  Text('Update Car Gallery'.tr,style: const TextStyle(color: Colors.white,fontFamily: FontFamily.europaBold)),
        ),
      ),
      appBar: AppBar(
        backgroundColor: onbordingBlue,
        elevation: 0,
        centerTitle: true,
        title:  Text('${'Car Edit'.tr} ${widget.carTitle}',style: const TextStyle(color: Colors.white,fontFamily: FontFamily.europaBold,fontSize: 18)),
      ),
      body: Form(
        key: _formKey,
        child:  Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Car Image'.tr,style:  TextStyle(color: notifire.getwhiteblackcolor,fontFamily: FontFamily.europaBold,fontSize: 18)),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: false,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(13))),
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Column(
                              children: [
                                 Text("From where do you want to take the photo?".tr, style: const TextStyle(fontFamily: FontFamily.europaBold, fontSize: 20, color: Colors.black),),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(fixedSize: const Size(100, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                        onPressed: ()  async {
                                          XFile? file = await picker1.pickImage(source: ImageSource.gallery);
                                          if(file!=null){
                                            setState(() {
                                              image.add(file.path);
                                            });
                                          }else{
                                            Fluttertoast.showToast(msg: 'image not selected!!'.tr);
                                          }
                                          Get.back();
                                        },
                                        child:  Text("Gallery".tr, style: const TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: Colors.black),),
                                      ),
                                    ),
                                    const SizedBox(width: 13),
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(fixedSize: const Size(100, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                        onPressed: ()  async {
                                          XFile? file = await picker.pickImage(source: ImageSource.camera);
                                          if(file!=null){
                                            setState(() {
                                              image.add(file.path);
                                            });
                                          } else{
                                            Fluttertoast.showToast(msg: 'image pick in not Camera!!'.tr);
                                          }
                                          Get.back();
                                        },
                                        child:  Text("Camera".tr, style: const TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: Colors.black),),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    margin: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                        border: Border.all(color: onbordingBlue),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child:  Center(child: Text("Choose Files".tr, style: TextStyle(color: onbordingBlue, fontFamily: FontFamily.europaBold),)),
                  ),
                ),
                isvalidate ?  Text('Please Pick your Image.'.tr,style: const TextStyle(color: Colors.red,fontSize: 13)) : const SizedBox(),
                Wrap(
                  spacing: 10.0,
                  children: [
                   for (int i=0; i <editImage.length; i++)  Stack(
                     clipBehavior: Clip.none,
                     children: [
                       Container(
                         height: 180,
                         width: 165,
                         margin: const EdgeInsets.only(bottom: 10),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             image: DecorationImage(image: NetworkImage('${Config.imgUrl}${editImage[i]}'),fit: BoxFit.cover)
                         ),
                       ),
                       Positioned(
                         right: -2,
                         top: -5,
                         child: GestureDetector(
                           onTap: () {
                             setState(() {
                               editImage.removeAt(i);
                             });
                           },
                           child: Container(
                             height: 26,
                             width: 26,
                             decoration: BoxDecoration(
                               color: onbordingBlue,
                               shape: BoxShape.circle,
                             ),
                             child: const Center(child: Icon(Icons.close, color: Colors.white, size: 18,)),
                           ),
                         ),
                       ),
                     ],
                   ),
                    for (int i=0; i <image.length; i++) Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 180,
                          width: 165,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(image: FileImage(File(image[i])),fit: BoxFit.cover)
                          ),
                        ),
                        Positioned(
                          right: -2,
                          top: -5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                image.removeAt(i);
                              });
                            },
                            child: Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                color: onbordingBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(child: Icon(Icons.close, color: Colors.white, size: 18,)),
                            ),
                          ),
                        ),
                      ],
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
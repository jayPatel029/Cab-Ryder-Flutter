// ignore_for_file: unused_import, unnecessary_import, depend_on_referenced_packages, camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:carlink/model/payoutlist_modal.dart';
import 'package:carlink/screen/bottombar/bottombar_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/common.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/withdraw_payout_controller.dart';
import '../../model/walletreport_modal.dart';
import '../../utils/fontfameli_model.dart';

List<String> payType = ["UPI", "BANK Transfer", "Paypal"];

class payout_screen extends StatefulWidget {
  final double earning;
  final String minimum;
  const payout_screen({super.key, required this.earning, required this.minimum});

  @override
  State<payout_screen> createState() => _payout_screenState();
}

class _payout_screenState extends State<payout_screen> {

  var daat;
  bool isloading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectType;

  PayOutController payOutController = Get.put(PayOutController());

  WalletReport? data;
  Future walletreport(String uid) async {

    Map body = {
      'uid' : uid,
    };

    print("+++ $body");

    try{
      var response = await http.post(Uri.parse('${Config.baseUrl}${Config.walletReport}'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          data = walletReportFromJson(response.body);
          isloading = false;
          print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${data!.wallet}');
        });
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }
  // RequestWithdraw? data1;

  Future request_withdraw(String uid) async {

    Map body = {
      'uid' : uid,
      "amt": payOutController.amount.text,
      "r_type": selectType,
      "acc_number": payOutController.accountNumber.text,
      "bank_name": payOutController.bankName.text,
      "acc_name": payOutController.accountHolderName.text,
      "ifsc_code": payOutController.ifscCode.text,
      "upi_id": payOutController.upi.text,
      "paypal_id": payOutController.emailId.text,
    };

    print("+++ $body");

    try{
      var response = await http.post(Uri.parse('${Config.baseUrl}${Config.requestWithdraw}'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        setState(() {
          // data1 = requestWithdrawFromJson(response.body);
          isloading = false;
          payout_api(user['id']);
        });
        return data;
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }


  // PayoutApi? data2;
  PayoutListModal? payoutListModal;
  Future payout_api(String uid) async {

    Map body = {
      'uid' : uid,
    };

    print("+++ $body");

    try{
      var response = await http.post(Uri.parse('${Config.baseUrl}${Config.payoutList}'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      if(response.statusCode == 200){
        setState(() {
          payoutListModal = payoutListModalFromJson(response.body);
          isloading = false;
        });
        var data = jsonDecode(response.body);
        return data;
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }

  var user;
  var currencies;

  getlocledata() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      user  = jsonDecode(_prefs.getString("UserLogin")!);
      currencies = jsonDecode(_prefs.getString('bannerData')!);
      print('+ ++ ++  $user');
      print('+ ++ ++  $currencies');
      walletreport(user['id']);
      payout_api(user['id']);
    });
  }

  // HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    getlocledata();
    super.initState();
  }

  late ColorNotifire notifier;

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getbgcolor,

      body: isloading ?  loader() : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 190,
                color: onbordingBlue,
                child:  Padding(
                  padding: const EdgeInsets.only(top: 55),
                  child: Padding(
                    padding:  const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.arrow_back,color: Colors.white)),
                        const SizedBox(width: 10,),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text('My earning'.tr,style: const TextStyle(color: Colors.white,fontSize: 18,fontFamily: FontFamily.europaBold),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: notifier.getbgcolor,
                    // border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading:  ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                              maxWidth: 60,
                              maxHeight: 60,
                            ),
                            child: Lottie.asset('assets/lottie/wallet.json')),
                        title: Transform.translate(offset: const Offset(-10, 0),child:  Text('TOTAL EARNING BALANCE'.tr,style: const TextStyle(color: Colors.grey,fontSize: 14, fontFamily: FontFamily.europaWoff))),
                        subtitle: Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${currencies['currency']} ${widget.earning.toStringAsFixed(2)}',style:  TextStyle(color: notifier.getwhiteblackcolor,fontFamily: FontFamily.europaBold,fontSize: 20),),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child:  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: onbordingBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            fixedSize: Size(Get.width, 46),
                          ),
                          onPressed: () {
                            payOutController.amount.clear();
                            selectType = null;
                            widget.earning < 10 ? Fluttertoast.showToast(msg: "No earnings, so you can't withdraw; limit is ${currencies['currency']}10."): requestSheet();
                          },
                          child:  Text("Withdraw Request".tr, style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: FontFamily.europaBold)),
                        ),
                      ),
                      const SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15,),

          Padding(
            padding: const EdgeInsets.only(left: 13,right: 13),
            child: Column(
              children: [
                payoutListModal!.payoutlist.isEmpty  ? const SizedBox() : Row(
                  children: [
                    Text('Transaction History'.tr,style: TextStyle(fontSize: 17,fontFamily: FontFamily.europaBold,color: notifier.getwhiteblackcolor),),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          payoutListModal!.payoutlist.isEmpty  ? const SizedBox() : Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width : 0,);
                },
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: payoutListModal?.payoutlist.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.bottomSheet(
                          isScrollControlled: true,
                          Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Container(
                              decoration:  BoxDecoration(
                                color: notifier.getblackwhitecolor,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Text('Payout id'.tr,style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaWoff)),
                                        const Spacer(),
                                        Text('${payoutListModal?.payoutlist[index].payoutId}',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaBold)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text('Amount'.tr,style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaWoff)),
                                        const Spacer(),
                                        Text('${currencies['currency']}${payoutListModal?.payoutlist[index].amt}',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaBold)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text('Pay by'.tr,style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaWoff)),
                                        const Spacer(),
                                        Text('${payoutListModal?.payoutlist[index].rType}',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontWeight: FontWeight.bold)),
                                        payoutListModal?.payoutlist[index].rType == "BANK Transfer" ?const SizedBox():Text('(${payoutListModal?.payoutlist[index].rType == "UPI" ? payoutListModal?.payoutlist[index].upiId : payoutListModal?.payoutlist[index].paypalId})',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaBold)),
                                      ],
                                    ),
                                    payoutListModal?.payoutlist[index].rType == "BANK Transfer" ?   Column(
                                      children: [
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text('Account Number'.tr,style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaWoff)),
                                            const Spacer(),
                                            Text('${payoutListModal?.payoutlist[index].accNumber}',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaBold)),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text('Bank Name'.tr,style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaWoff)),
                                            const Spacer(),
                                            Text('${payoutListModal?.payoutlist[index].bankName}',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaBold)),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text('Account Name'.tr,style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaWoff)),
                                            const Spacer(),
                                            Text('${payoutListModal?.payoutlist[index].accName}',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaBold)),
                                          ],
                                        ),
                                      ],
                                    ): const SizedBox(),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text('Request Date'.tr,style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaWoff)),
                                        const Spacer(),
                                        Text('${payoutListModal?.payoutlist[index].rDate}',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaBold)),
                                      ],
                                    ),
                                    payoutListModal!.payoutlist[index].status == 'completed' ?  Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text('Proof',style: TextStyle(color: notifier.getwhiteblackcolor,fontSize: 15,fontFamily: FontFamily.europaWoff)),
                                        ),
                                        const Spacer(),
                                        Image(image: NetworkImage('${Config.baseUrl}/${payoutListModal?.payoutlist[index].proof}'),height: 80,width: 80,),
                                      ],
                                    ) : const SizedBox(),
                                    const SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -25),
                      child: ListTile(
                        leading: payoutListModal!.payoutlist[index].status == 'completed' ? const Image(image: AssetImage(Appcontent.commplete),height: 40):const Image(image: AssetImage(Appcontent.padding),height: 40),
                        title: Transform.translate(offset: const Offset(-6, 0),child: Text(capitalize(payoutListModal!.payoutlist[index].status),style: TextStyle(fontFamily: FontFamily.europaBold,fontSize: 15,color: notifier.getwhiteblackcolor))),
                        subtitle: Transform.translate(offset: const Offset(-6, 0),child: Text(payoutListModal!.payoutlist[index].rDate.toString().split(" ").first,style: const TextStyle(fontSize: 14,color: Colors.grey, fontFamily: FontFamily.europaWoff))),
                        trailing: Transform.translate(
                          offset: const Offset(15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${currencies['currency']} ${payoutListModal!.payoutlist[index].amt}',style: const TextStyle(fontSize: 15,fontFamily: FontFamily.europaBold,color: Colors.green)),
                              Icon(Icons.keyboard_arrow_right,color: notifier.getwhiteblackcolor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<void> requestSheet() {
    return Get.bottomSheet(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Form(
          key: _formKey,
          child: Container(
            width: Get.size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Payout Request".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.europaBold,
                      color: notifier.getwhiteblackcolor,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${'Minimum amount'.tr}: ${currencies['currency']}${widget.minimum}".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.europaWoff,
                      color: notifier.getwhiteblackcolor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  textfield(
                    controller: payOutController.amount,
                    labelText: "Amount".tr,
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Amount'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Select Type".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.europaBold,
                        fontSize: 16,
                        color: notifier.getwhiteblackcolor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 50,
                    width: Get.size.width,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: DropdownButton(
                      dropdownColor: notifier.getbgcolor,
                      hint: Text(
                        "Select Type".tr,
                        style: const TextStyle(color: Colors.grey,fontFamily: FontFamily.europaWoff),
                      ),
                      value: selectType,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items:
                      payType.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: FontFamily.europaBold,
                              color: notifier.getwhiteblackcolor,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectType = value ?? "";
                        });
                      },
                    ),
                    decoration: BoxDecoration(
                      // color: notifier.textColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                    ),
                  ),
                  selectType == "UPI"
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "UPI".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.europaBold,
                            fontSize: 16,
                            color: notifier.getwhiteblackcolor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.upi,
                        labelText: "UPI".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter UPI'.tr;
                          }
                          return null;
                        },
                      )
                    ],
                  )
                      : selectType == "BANK Transfer"
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Account Number".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.europaBold,
                            fontSize: 16,
                            color: notifier.getwhiteblackcolor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.accountNumber,
                        labelText: "Account Number".tr,
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Account Number'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Bank Name".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.europaBold,
                            fontSize: 16,
                            color: notifier.getwhiteblackcolor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.bankName,
                        labelText: "Bank Name".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Bank Name'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Account Holder Name".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.europaBold,
                            fontSize: 16,
                            color: notifier.getwhiteblackcolor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller:
                        payOutController.accountHolderName,
                        labelText: "Account Holder Name".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Account Holder Name'
                                .tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "IFSC Code".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.europaBold,
                            fontSize: 16,
                            color: notifier.getwhiteblackcolor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.ifscCode,
                        labelText: "IFSC Code".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter IFSC Code'.tr;
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                      : selectType == "Paypal"
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Email ID".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.europaBold,
                            fontSize: 16,
                            color: notifier.getwhiteblackcolor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.emailId,
                        labelText: "Email Id".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Paypal id'.tr;
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                      : Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(fixedSize: const MaterialStatePropertyAll(Size(120, 40)),elevation: const MaterialStatePropertyAll(0),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),backgroundColor: const MaterialStatePropertyAll(Colors.transparent)),
                            onPressed: () {
                              Navigator.pop(context);
                              payOutController.amount.clear();
                              selectType = null;
                            },
                            child: Text('Cancel'.tr,style:  TextStyle(color: notifier.getwhiteblackcolor)),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(fixedSize: const MaterialStatePropertyAll(Size(120, 40)),elevation: const MaterialStatePropertyAll(0),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),backgroundColor:  MaterialStatePropertyAll(onbordingBlue)),
                            onPressed: () => {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (selectType != null) {
                                  request_withdraw(user['id']).then((value) {
                                    if(value["ResponseCode"] == "200"){
                                      payout_api(user['id']);
                                      payOutController.amount.clear();
                                      selectType = null;
                                      Get.back();
                                      Fluttertoast.showToast(msg: value['ResponseMsg']);
                                    } else{
                                      Fluttertoast.showToast(msg: value['ResponseMsg']);
                                    }
                                  }),
                                } else {
                                  Fluttertoast.showToast(msg: 'Please Select Type'.tr,timeInSecForIosWeb: 4),
                                }
                              }
                            },
                            child: Text('Proceed'.tr,style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: notifier.getbgcolor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        );
      }),
    );
  }


  textfield({String? type, labelText, prefixtext, suffix, Color? labelcolor, prefixcolor, floatingLabelColor, focusedBorderColor, TextDecoration? decoration, bool? readOnly, double? Width, int? max, TextEditingController? controller, TextInputType? textInputType, Function(String)? onChanged, String? Function(String?)? validator, Height}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: notifier.getwhiteblackcolor,
        keyboardType: textInputType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: max,
        readOnly: readOnly ?? false,

        style: TextStyle(
            fontFamily: FontFamily.europaWoff,
            color: notifier.getwhiteblackcolor,
            fontSize: 18),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          hintText: labelText,
          hintStyle: const TextStyle(
              color: Colors.grey, fontFamily: FontFamily.europaWoff, fontSize: 16),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff7D2AFF)),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:  BorderSide(color: Colors.grey.withOpacity(0.4)),
          ),
          border: OutlineInputBorder(
            borderSide:  BorderSide(color: Colors.grey.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }

}

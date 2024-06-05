// ignore_for_file: avoid_print, depend_on_referenced_packages, camel_case_types, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, sort_child_properties_last, unnecessary_const, use_build_context_synchronously, unnecessary_import, empty_catches
import 'dart:convert';
import 'package:carlink/model/walletUpdate_modal.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../model/pgatway_modal.dart';
import '../../model/walletreport_modal.dart';
import '../../payments/flutterwave.dart';
import '../../payments/inputformater.dart';
import '../../payments/mercadopago.dart';
import '../../payments/midtrans.dart';
import '../../payments/paymentcard.dart';
import '../../payments/paypalPayment.dart';
import '../../payments/paytmpayment.dart';
import '../../payments/razorpay_screen.dart';
import '../../payments/senangpay.dart';
import '../../payments/stripe_payment.dart';
import 'faq_screen.dart';

class My_Wallet extends StatefulWidget {

  const My_Wallet({super.key});

  @override
  State<My_Wallet> createState() => _My_WalletState();
}

class _My_WalletState extends State<My_Wallet> {
  String referenceId = "";
  WalletReport? data;

  bool isloading = true;




  // Wallet_Report Api

  Future Walletreport(String uid) async {

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

  WalletUpModal? wupdate;

  // Wallet Update Api
  Future WalletUpdateApi(String uid) async {

    Map body = {
      'uid' : uid,
      'wallet' : walletController.text,
    };

    print("+++ $body");
    try{
      var response = await http.post(Uri.parse('${Config.baseUrl}${Config.walletUp}'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){

        setState(() {
          wupdate = walletUpModalFromJson(response.body);
          // Get.close(2);
          Walletreport(uid);
        });

        showModalBottomSheet(
          isDismissible: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 330,
              decoration:  BoxDecoration(
                  color: notifire.getbgcolor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const CircleAvatar(radius: 35,backgroundColor: Color(0xff7D2AFF),child: Center(child: Icon(Icons.check,color: Colors.white,)),),
                  const SizedBox(height: 20,),
                  Text('Top up ${currencies['currency']}${walletController.text}.00',style:  const TextStyle(fontSize: 30,fontFamily: FontFamily.europaBold,color: Colors.black),),
                  const SizedBox(height: 5,),
                  Text('Successfully'.tr,style:  const TextStyle(fontSize: 30,fontFamily: FontFamily.europaBold,color: Colors.black),),
                  const SizedBox(height: 28,),
                  Text('${currencies['currency']}${walletController.text} has been added to your wallet',style: const TextStyle(fontSize: 15,fontFamily: FontFamily.europaWoff,color: Colors.grey),),
                  const SizedBox(height: 28,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style:  ButtonStyle(fixedSize: const MaterialStatePropertyAll(Size(0, 50)),backgroundColor: const MaterialStatePropertyAll(Colors.white),side: MaterialStatePropertyAll(BorderSide(color: onbordingBlue)),shape: const MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))))),
                            onPressed: () {
                              Get.back();
                            },
                            child:  Text('Done For Now'.tr,style:  TextStyle(color: onbordingBlue,fontFamily: FontFamily.europaBold)),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: ElevatedButton(
                            style:  ButtonStyle(fixedSize: const MaterialStatePropertyAll(Size(0, 50)),backgroundColor: MaterialStatePropertyAll(onbordingBlue),side: const MaterialStatePropertyAll(BorderSide(color: Colors.transparent)),shape: const MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))))),
                            onPressed: () {
                              Get.back();
                            },
                            child:  Text('Another Top Up'.tr,style:  const TextStyle(color: Colors.white,fontFamily: FontFamily.europaBold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }

  var uId;
  var currencies;

  getlocledata() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      uId  = jsonDecode(_prefs.getString("UserLogin")!);
      currencies = jsonDecode(_prefs.getString('bannerData')!);
      Walletreport(uId['id']);
      WalletUpdateApi(uId['id']);
      print(uId);
    });
  }

  @override
  void initState() {

    Payment();
    getlocledata();
    // walletController.text  = "100".tr;


    razorPayClass.initiateRazorPay(handlePaymentSuccess: handlePaymentSuccess, handlePaymentError: handlePaymentError, handleExternalWallet: handleExternalWallet);
    super.initState();
  }

  TextEditingController walletController = TextEditingController();

  late ColorNotifire notifire;

  // Razorpay Code

  RazorPayClass  razorPayClass = RazorPayClass();

  void handlePaymentSuccess(PaymentSuccessResponse response){
    WalletUpdateApi(uId['id']);

    Fluttertoast.showToast(msg: 'SUCCESS PAYMENT : ${response.paymentId}',timeInSecForIosWeb: 4);
  }
  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: 'ERROR HERE: ${response.code} - ${response.message}',timeInSecForIosWeb: 4);
  }
  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: 'EXTERNAL_WALLET IS: ${response.walletName}',timeInSecForIosWeb: 4);
  }



  @override
  void dispose() {
    razorPayClass.desposRazorPay();
    super.dispose();
  }
  int payment = -1;
  String selectedOption = '';
  String selectBoring = "";



  //Get Api Calling  Payment Gateway List Api
  late PGateway gPayment;

  Future Payment() async {
    try {
      var response =
      await http.post(Uri.parse(Config.baseUrl + Config.payment), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        setState(() {
          gPayment = pGatewayFromJson(response.body);
          isloading = false;
        });
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        backgroundColor: onbordingBlue,
        elevation: 0,
        centerTitle: true,
        title:  Text('Wallet'.tr,style: const TextStyle(color: Colors.white,fontSize: 18,fontFamily: FontFamily.europaBold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 17,right: 15),
            child: InkWell(
                onTap: () {
                  Get.to(const FaqScreen());
                },
                child:  Text("Faq's".tr,style: const TextStyle(color: Colors.white,fontFamily: FontFamily.europaWoff,fontSize: 15))),
          ),
        ],
      ),
      body: isloading ?  Center(child: CircularProgressIndicator(color: onbordingBlue),) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 120,
                color: onbordingBlue,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25,left: 20,right: 20),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: notifire.getbgcolor,
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
                            child: Lottie.asset(Appcontent.wallet)),
                        title: Transform.translate(offset: const Offset(-10, 0),child:  Text('TOTAL WALLET BALANCE'.tr,style: const TextStyle(color: Colors.grey,fontSize: 14,fontFamily: FontFamily.europaBold))),
                        subtitle:  Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${currencies['currency']} ${data?.wallet}',style:  TextStyle(color: notifire.getwhiteblackcolor,fontFamily: FontFamily.europaBold,fontSize: 20),),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15, bottom: 3),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: onbordingBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            fixedSize: Size(Get.width, 46),
                          ),
                          onPressed: () {
                            Get.bottomSheet(
                                isScrollControlled: true,
                                Padding(
                                  padding: const EdgeInsets.only(top: 150),
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: notifire.getbgcolor,
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                        ),
                                        child:  Padding(
                                          padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const SizedBox(height: 10,),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 6,right: 6),
                                                child: Text('Add Wallet Amount'.tr,style: TextStyle(color: notifire.getwhiteblackcolor,fontSize: 15,fontWeight: FontWeight.bold)),
                                              ),
                                              const SizedBox(height: 10,),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: SizedBox(
                                                  height: 45,
                                                  child: TextFormField(
                                                    controller: walletController,
                                                    cursorColor: Colors.black,
                                                    keyboardType: TextInputType.number,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.only(top: 15),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                          color: Colors.grey.withOpacity(0.4),
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                          color: Colors.grey.withOpacity(0.4),
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                          color: Colors.grey.withOpacity(0.4),
                                                        ),
                                                      ),
                                                      prefixIcon: const SizedBox(
                                                        height: 20,
                                                        child: Icon(Icons.wallet),
                                                      ),
                                                      hintText: "Enter Amount".tr,
                                                      hintStyle:  const TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10,),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 6,right: 6),
                                                child: Text('Select Payment Method'.tr,style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12)),
                                              ),
                                              Expanded(
                                                child: ListView.separated(
                                                    separatorBuilder: (context, index) {
                                                      return const SizedBox(width: 0);
                                                    },
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.vertical,
                                                    itemCount: gPayment.paymentdata.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            payment = index;
                                                          });
                                                          if(gPayment.paymentdata[payment].title == "Razorpay"){
                                                            razorPayClass.openCheckout(key: gPayment.paymentdata[0].attributes, amount: '${double.parse(walletController.text)}', number: '${uId['mobile']}', name: '${uId['email']}');
                                                            Get.back();
                                                          } else if(gPayment.paymentdata[payment].title == "Paypal"){
                                                            List ids = gPayment.paymentdata[1].attributes.toString().split(",");
                                                            print('++++++++++ids:------$ids');
                                                            paypalPayment(
                                                              context: context,
                                                              function: (e){
                                                              },
                                                              amt: walletController.text,
                                                              // clientId: from12.paymentdata[1].attributes.toString().split(",").first,
                                                              // secretKey: from12.paymentdata[1].attributes.toString().split(",").last,
                                                              clientId: ids[0],
                                                              secretKey: ids[1],
                                                            );
                                                          } else if(gPayment.paymentdata[payment].title == "Stripe"){
                                                            Get.back();
                                                            stripePayment();
                                                          } else if(gPayment.paymentdata[payment].title == "PayStack"){
                                                            Get.back();
                                                            Fluttertoast.showToast(msg: 'Not Valid'.tr);
                                                          } else if(gPayment.paymentdata[payment].title == "FlutterWave"){
                                                            Get.to(() => Flutterwave(
                                                              totalAmount: walletController.text,
                                                              email: uId['email'],
                                                            ))!
                                                                .then((otid) {
                                                              if (otid != null) {
                                                                Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                                              } else {
                                                                Get.back();
                                                              }
                                                            });
                                                          } else if(gPayment.paymentdata[payment].title == "Paytm"){
                                                            Get.to(() => PayTmPayment(
                                                                totalAmount: walletController.text,
                                                                uid: uId['id'],
                                                            ))!
                                                                .then((otid) {
                                                              if (otid != null) {
                                                                Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                                              } else {
                                                                Get.back();
                                                              }
                                                            });
                                                          } else if(gPayment.paymentdata[payment].title == "SenangPay"){
                                                            Get.to(SenangPay(
                                                                email: uId['email'],
                                                                totalAmount: walletController.text,
                                                                name: uId['name'],
                                                                phon: uId['mobile']))!
                                                                .then((otid) {
                                                              if (otid != null) {
                                                              } else {
                                                                Get.back();
                                                              }
                                                            });
                                                          } else if(gPayment.paymentdata[payment].title == "MercadoPago"){
                                                            Get.to(merpago(
                                                              totalAmount: walletController.text,
                                                            ))?.then((value) {
                                                              if(value != null){
                                                              } else {
                                                              }
                                                            });
                                                          } else if(gPayment.paymentdata[payment].title == "Payfast"){
                                                            Fluttertoast.showToast(msg: 'Not valid'.tr);
                                                          } else if(gPayment.paymentdata[payment].title == "Midtrans"){
                                                            Get.to(MidTrans(
                                                                email: uId['email'],
                                                                totalAmount: walletController.text,
                                                                mobilenumber: uId['mobile']))?.then((value) {
                                                              if(value != null){
                                                              } else {
                                                              }
                                                            });
                                                          } else if(gPayment.paymentdata[payment].title == "2checkout" || gPayment.paymentdata[payment].title == "Khalti Payment"){
                                                            Fluttertoast.showToast(msg: 'Not valid'.tr);
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 90,
                                                          margin: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 7),
                                                          padding: const EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: payment == index
                                                                    ? onbordingBlue
                                                                    : Colors.grey
                                                                    .withOpacity(0.4)),
                                                            borderRadius:
                                                            BorderRadius.circular(15),
                                                          ),
                                                          child: Center(
                                                            child: ListTile(
                                                              leading: Transform.translate(
                                                                offset: const Offset(-5, 0),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 60,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(15),
                                                                    border: Border.all(
                                                                        color: Colors.grey
                                                                            .withOpacity(
                                                                            0.4)),
                                                                  ),
                                                                  child: Image.network(
                                                                      "${Config.imgUrl}${gPayment.paymentdata[index].img}"),
                                                                ),
                                                              ),
                                                              title: Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    bottom: 4),
                                                                child: Text(
                                                                  gPayment.paymentdata[index].title,
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: notifire
                                                                          .getwhiteblackcolor),
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                              subtitle: Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    bottom: 4),
                                                                child: Text(
                                                                  gPayment
                                                                      .paymentdata[index]
                                                                      .subtitle,
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: notifire
                                                                          .getwhiteblackcolor),
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                              trailing: Radio(
                                                                value: payment == index
                                                                    ? true
                                                                    : false,
                                                                fillColor:
                                                                MaterialStatePropertyAll(
                                                                    onbordingBlue),
                                                                groupValue: true,
                                                                onChanged: (value) {
                                                                  payment = index;
                                                                  setState(() {
                                                                    // selectedOption = value.toString();
                                                                    // selectBoring = from12.paymentdata[index].img;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              const SizedBox(height: 0,),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ));
                          },
                          child:  Text("Top Up".tr, style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: FontFamily.europaBold)),
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
                data?.walletitem.isEmpty ?? true ? const SizedBox() : Row(
                  children: [
                    Text('Transaction History'.tr,style:  TextStyle(fontSize: 17,fontFamily: FontFamily.europaBold,color: notifire.getwhiteblackcolor),),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width : 0,);
                },
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: data?.walletitem.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Transform.translate(
                    offset: const Offset(0, -5),
                    child: ListTile(
                      leading: data!.walletitem[index].status == 'Debit' ?  Image.asset(Appcontent.minusWallet,height: 40): Image.asset(Appcontent.additionWallet,height: 40),
                      title: Transform.translate(offset: const Offset(-6, 0),child: Text(data!.walletitem[index].message,style: TextStyle(fontFamily: FontFamily.europaBold,fontSize: 15,color: notifire.getwhiteblackcolor))),
                      subtitle: Transform.translate(offset: const Offset(-6, 0),child: Text(data!.walletitem[index].status,style: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: FontFamily.europaWoff))),
                      trailing: Text('${data!.walletitem[index].status == 'Debit' ? '-' : "+"} ${currencies['currency']}${data!.walletitem[index].amt}',style: TextStyle(fontSize: 15,fontFamily: FontFamily.europaBold,color:  data!.walletitem[index].status == "Debit"  ? Colors.red : Colors.green)),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }



  textfield({String? type, labelText, prefixtext, suffix, Color? labelcolor, prefixcolor, floatingLabelColor, focusedBorderColor, TextDecoration? decoration, bool? readOnly, double? Width, int? max, TextEditingController? controller, TextInputType? textInputType, Function(String)? onChanged, String? Function(String?)? validator, Height}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: notifire.getwhiteblackcolor,
        keyboardType: textInputType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: max,
        readOnly: readOnly ?? false,

        style: TextStyle(
            color: notifire.getwhiteblackcolor,
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
            borderSide: const BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }


  var numberController = TextEditingController();

  void onCancel() {
    debugPrint('Cancelled');
  }

  Widget summery({required String title, required String subtitle}) {
    return Row(
      children: [
        Text(title,
            style: TextStyle(
                fontFamily: FontFamily.europaWoff,
                color: notifire.getgreycolor,
                fontSize: 15)),
        const Spacer(),
        Text(subtitle,
            style: TextStyle(
                fontFamily: FontFamily.europaWoff,
                color: notifire.getwhiteblackcolor,
                fontSize: 15)),
      ],
    );
  }
  final _formKey = GlobalKey<FormState>();
  var number = TextEditingController();
  final _paymentCard = PaymentCardCreated();
  var _autoValidateMode = AutovalidateMode.disabled;

  final _card = PaymentCardCreated();
  stripePayment() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: notifire.getbgcolor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Ink(
                    child: Column(
                      children: [
                        SizedBox(height: Get.height / 45),
                        Center(
                          child: Container(
                            height: Get.height / 85,
                            width: Get.width / 5,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4),
                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.03),
                              Text("Add Your payment information".tr,
                                  style:  TextStyle(
                                      color: notifire.getwhiteblackcolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.5)),
                              SizedBox(height: Get.height * 0.02),
                              Form(
                                key: _formKey,
                                autovalidateMode: _autoValidateMode,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      style:  TextStyle(color: notifire.getwhiteblackcolor),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(19),
                                        CardNumberInputFormatter()
                                      ],
                                      controller: number,
                                      onSaved: (String? value) {
                                        _paymentCard.number =
                                            CardUtils.getCleanedNumber(value!);

                                        CardTypee cardType =
                                        CardUtils.getCardTypeFrmNumber(
                                            _paymentCard.number.toString());
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      onChanged: (val) {
                                        CardTypee cardType =
                                        CardUtils.getCardTypeFrmNumber(val);
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      validator: CardUtils.validateCardNum,
                                      decoration: InputDecoration(
                                        prefixIcon: SizedBox(
                                          height: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 6,
                                            ),
                                            child: CardUtils.getCardIcon(_paymentCard.type,),
                                          ),
                                        ),
                                        focusedErrorBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        errorBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        enabledBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        focusedBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        hintText:
                                        "What number is written on card?".tr,
                                        hintStyle: const TextStyle(color: Colors.grey),
                                        labelStyle: const TextStyle(color: Colors.grey),
                                        labelText: "Number".tr,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: TextFormField(
                                            style:  TextStyle(color: notifire.getwhiteblackcolor),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            decoration: InputDecoration(
                                                prefixIcon: const SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 14),
                                                    child: Icon(Icons.credit_card,color: Color(0xff7D2AFF)),
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                errorBorder:  OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                enabledBorder:  OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                focusedBorder:  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey.withOpacity(0.4))),
                                                hintText: "Number behind the card".tr,
                                                hintStyle:
                                                const TextStyle(color: Colors.grey),
                                                labelStyle:
                                                const TextStyle(color: Colors.grey),
                                                labelText: 'CVV'),
                                            validator: CardUtils.validateCVV,
                                            keyboardType: TextInputType.number,
                                            onSaved: (value) {
                                              _paymentCard.cvv = int.parse(value!);
                                            },
                                          ),
                                        ),
                                        SizedBox(width: Get.width * 0.03),
                                        Flexible(
                                          flex: 4,
                                          child: TextFormField(
                                            style:  TextStyle(color: notifire.getwhiteblackcolor),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                              CardMonthInputFormatter()
                                            ],
                                            decoration: InputDecoration(
                                              prefixIcon: const SizedBox(
                                                height: 10,
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 14),
                                                  child: Icon(Icons.calendar_month,color: Color(0xff7D2AFF)),
                                                ),
                                              ),
                                              errorBorder:  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.withOpacity(0.4),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.withOpacity(0.4),
                                                ),
                                              ),
                                              enabledBorder:  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.withOpacity(0.4),
                                                ),
                                              ),
                                              focusedBorder:  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.withOpacity(0.4),
                                                ),
                                              ),
                                              hintText: 'MM/YY',
                                              hintStyle:  const TextStyle(color: Colors.grey),
                                              labelStyle: const TextStyle(color: Colors.grey),
                                              labelText: "Expiry Date".tr,
                                            ),
                                            validator: CardUtils.validateDate,
                                            keyboardType: TextInputType.number,
                                            onSaved: (value) {
                                              List<int> expiryDate =
                                              CardUtils.getExpiryDate(value!);
                                              _paymentCard.month = expiryDate[0];
                                              _paymentCard.year = expiryDate[1];
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.055),
                                    Container(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: Get.width,
                                        child: CupertinoButton(
                                          onPressed: () {
                                            _validateInputs();
                                          },
                                          color: const Color(0xff7D2AFF),
                                          child: Text(
                                            "Add ${currencies['currency']}${walletController.text}",
                                            style:  const TextStyle(fontSize: 17.0,color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Get.height * 0.065),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always;
      });

      Fluttertoast.showToast(msg: "Please fix the errors in red before submitting.".tr,timeInSecForIosWeb: 4);
    } else {
      var username = uId["name"] ?? "";

      var email = uId["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = walletController.text;
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        if (otid != null) {
        }
      });
      Fluttertoast.showToast(msg: "Payment card is valid".tr,timeInSecForIosWeb: 4);
    }
  }
}

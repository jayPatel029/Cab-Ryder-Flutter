// ignore_for_file: prefer_final_fields, unused_field, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, await_only_futures, avoid_print, prefer_const_constructors, avoid_unnecessary_containers, file_names
import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';


class MidTrans extends StatefulWidget {
  final String? email;
  final String? mobilenumber;
  final String? totalAmount;

  const MidTrans({this.email, this.totalAmount, this.mobilenumber});

  @override
  State<MidTrans> createState() => _MidTransState();
}

class _MidTransState extends State<MidTrans> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late WebViewController _controller;
  var progress;
  String? accessToken;
  String? payerID;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (_scaffoldKey.currentState == null) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                initialUrl:
                "${Config.pGateway}Midtrans/index.php?name=test&email=${widget.email}&phone=${widget.mobilenumber}&amt=${widget.totalAmount}",
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) async {
                  final uri = Uri.parse(request.url);
                  if (uri.queryParameters["transaction_status"] == null) {
                    print("${Config.pGateway}Midtrans/index.php?name=test&email=${widget.email}&phone=${widget.mobilenumber}&amt=${widget.totalAmount}",);
                    accessToken = uri.queryParameters["token"];
                  } else {
                    if (uri.queryParameters["status_code"] == "200") {
                      payerID = await uri.queryParameters["order_id"];
                      Get.back(result: payerID);
                    } else {
                      Get.back();
                      Fluttertoast.showToast(msg: "${uri.queryParameters["status"]}",);
                    }
                  }
                  return NavigationDecision.navigate;
                },
                gestureNavigationEnabled: true,
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onProgress: (val) {
                  progress = val;
                  setState(() {});
                },
              ),
              isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    SizedBox(
                      width: Get.width * 0.80,
                      child: Text(
                        'Please don`t press back until the transaction is complete'
                            .tr,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
              )
                  : Stack(),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}

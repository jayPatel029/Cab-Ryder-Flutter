// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../utils/config.dart';

class Flutterwave extends StatefulWidget {
  final String? name;
  final String? email;
  final String? totalAmount;
  const Flutterwave({super.key, this.name, this.email, this.totalAmount});

  @override
  State<Flutterwave> createState() => _FlutterwaveState();
}

class _FlutterwaveState extends State<Flutterwave> {
  final GlobalKey<ScaffoldState> _globalKey=GlobalKey();
  late WebViewController webViewController;
  var progress;
  String? accessToken;
  String? payerID;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    if (_globalKey.currentState == null) {
      print("Flutterwave ++++++++++++++++++++++----${Config.pGateway + "flutterwave/index.php?amt=${widget.totalAmount}&email=${widget.email}"}");
      return WillPopScope (
        onWillPop: () {
          return Future(() => true);
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                WebView(
                  initialUrl:
                  "${Config.pGateway + "flutterwave/index.php?amt=${widget.totalAmount}&email=${widget.email}"}",
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) async {
                    final uri = Uri.parse(request.url);
                    if (uri.queryParameters["status"] == null) {
                      accessToken = uri.queryParameters["token"];
                    } else {
                      if (uri.queryParameters["status"] == "successful") {
                        payerID = uri.queryParameters["transaction_id"];
                        Get.back(result: payerID);
                      } else {

                        Get.back();

                        Fluttertoast.showToast(msg: "${uri.queryParameters["status"]}",timeInSecForIosWeb: 4);
                      }
                    }
                    return NavigationDecision.navigate;
                  },
                  gestureNavigationEnabled: true,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onPageFinished: (finish) {
                    setState(() async {
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
                      const SizedBox(
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
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
                    : const Stack(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

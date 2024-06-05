// ignore_for_file: void_checks, deprecated_member_use

import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';


class SenangPay extends StatefulWidget {
  final String email;
  final String totalAmount;
  final String name;
  final String phon;

  const SenangPay(
      {super.key,
        required this.email,
        required this.totalAmount,
        required this.name,
        required this.phon});

  @override
  State<SenangPay> createState() => _SenangPayState();
}

class _SenangPayState extends State<SenangPay> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic progress;
  String? accessToken;
  String? payerID;
  bool isLoading = true;
  dynamic postdata;
  @override
  void initState() {
    super.initState();
    setState(() {
      final notificationId = UniqueKey().hashCode;
      postdata =
      "detail=Movers&amount=${widget.totalAmount}&order_id=$notificationId&name=${widget.name}&email=${widget.email}&phone=${widget.phon}";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_scaffoldKey.currentState == null) {
      return  WillPopScope(
        onWillPop: () async {
          return Future(() => true);
        },
        child: isLoading
            ? const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        )
            : Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                WebView(
                  initialUrl: "${Config.pGateway}result.php?$postdata",
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
                  onWebViewCreated: (controller) {},
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onProgress: (val) {
                    setState(() {
                      progress = val;
                    });
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
                ) : const Stack(),
              ],
            ),
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
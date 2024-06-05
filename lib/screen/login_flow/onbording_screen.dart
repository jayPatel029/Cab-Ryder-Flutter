// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_element, sort_child_properties_last
import 'package:carlink/screen/login_flow/login_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Custom_widget.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  int index = 0;

  PageController pageController = PageController();

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
    super.initState();
  }

  Widget _buildPageIndicator() {
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < 4; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != 4 - 1)
        // ignore: curly_braces_in_flow_control_structures
        row.children.add(const SizedBox(
          width: 10,
        ));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == this.index ? 30 : 8,
      height: index == this.index ? 7 : 8,
      decoration: BoxDecoration(
          color: index == this.index ? WhiteColor : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      body: Stack(
        children: [
          Container(
            height: Get.size.height,
            width: Get.size.width,
            color: BlackColor,
            child: PageView.builder(
              controller: pageController,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(index == 0 ? Appcontent.onbording1 : index == 1 ? Appcontent.onbording2 :index == 2? Appcontent.onbording3 : Appcontent.onbording4,), fit: BoxFit.cover ),
                  ),
                );
              },
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
            ),
          ),
          Positioned(
                  top: Get.size.height * 0.06,
                  left: 0,
                  right: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      _buildPageIndicator(),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(LoginScreen());
                        },
                        child: Text(
                          "Skip".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.europaWoff,
                            color: onbordingBlue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
          Positioned(
            top: Get.size.height * 0.13,
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      index == 0
                          ? "Explore, Book, Drive\nYour Journey Starts ".tr
                          : index == 1
                              ? "Drive with Confidence,\nAnytime, Anywhere".tr
                              : index == 2 ? "Where Every Mile\nFeels Like Home".tr : 'Your Journey Starts\nwith a Tap'.tr,
                      style: TextStyle(
                        fontFamily: FontFamily.europaBold,
                        color: WhiteColor,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      index == 0
                          ? "Your go-to platform for seamless car\nrentals"
                              .tr
                          : index == 1
                              ? "Unlock the convenience of renting a\ncar anytime, anywhere."
                                  .tr
                              : index == 2 ? "Discover our user-friendly platform\ndesigned to make renting a car".tr : "Whether it's for work or play, find the\nperfect vehicle to suit your needs".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.europaWoff,
                        color: greyScale,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                      children: [
                        GestButton(
                          height: 50,
                          Width: Get.size.width,
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                          buttoncolor: onbordingBlue,
                          buttontext: "Get Started".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.europaBold,
                            color: WhiteColor,
                            fontSize: 15,
                          ),
                          onclick: () {
                            Get.to(LoginScreen());
                          },
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}

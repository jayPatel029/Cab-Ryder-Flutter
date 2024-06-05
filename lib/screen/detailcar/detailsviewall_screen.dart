// ignore_for_file: prefer_const_constructors, unused_field, unnecessary_null_comparison, unnecessary_new, library_private_types_in_public_api

import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsViewAll extends StatefulWidget {
  const DetailsViewAll({super.key});

  @override
  State<DetailsViewAll> createState() => _DetailsViewAllState();
}

class _DetailsViewAllState extends State<DetailsViewAll>
    with TickerProviderStateMixin {
  TabController? _tabController;

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
    _tabController = TabController(length: 4, vsync: this);
    getdarkmodepreviousstate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
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
            padding: EdgeInsets.all(12),
            child: Image.asset(
              "assets/back.png",
              color: notifire.getwhiteblackcolor,
            ),
          ),
        ),
        title: Text(
          "Back to car details",
          style: TextStyle(
            fontFamily: FontFamily.europaBold,
            fontSize: 15,
            color: notifire.getwhiteblackcolor,
          ),
        ),
      ),
      body: SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: Column(
          children: [
            Container(
              color: notifire.getbgcolor,
              height: 50,
              child: TabBar(
                indicatorColor: onbordingBlue,
                controller: _tabController,
                unselectedLabelColor: notifire.getwhiteblackcolor,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.europaBold,
                  fontSize: 15,
                ),
                indicator: MD2Indicator(
                  indicatorSize: MD2IndicatorSize.full,
                  indicatorHeight: 5,
                  indicatorColor: onbordingBlue,
                ),
                labelColor: onbordingBlue,
                onTap: (value) {},
                tabs: [
                  Tab(
                    child: Text(
                      "Exterior".tr,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: FontFamily.europaWoff,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Interior".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.europaWoff,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Engine".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.europaWoff,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Tyres".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.europaWoff,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  exteriorWidget(),
                  exteriorWidget(),
                  exteriorWidget(),
                  exteriorWidget(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  exteriorWidget() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          height: Get.size.height * 0.25,
          width: Get.size.width,
          margin: EdgeInsets.all(10),
          child: Image.asset(
            "assets/Image.png",
            fit: BoxFit.fill,
          ),
        );
      },
    );
  }
}

class MD2Indicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final MD2IndicatorSize indicatorSize;

  const MD2Indicator({
    required this.indicatorHeight,
    required this.indicatorColor,
    required this.indicatorSize,
  });

  @override
  _MD2Painter createBoxPainter([VoidCallback? onChanged]) {
    return new _MD2Painter(this, onChanged!);
  }
}

enum MD2IndicatorSize {
  tiny,
  normal,
  full,
}

class _MD2Painter extends BoxPainter {
  final MD2Indicator decoration;

  _MD2Painter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    Rect? rect;
    if (decoration.indicatorSize == MD2IndicatorSize.full) {
      rect = Offset(offset.dx,
              (configuration.size!.height - decoration.indicatorHeight)) &
          Size(configuration.size!.width, decoration.indicatorHeight);
    } else if (decoration.indicatorSize == MD2IndicatorSize.normal) {
      rect = Offset(offset.dx + 6,
              (configuration.size!.height - decoration.indicatorHeight)) &
          Size(configuration.size!.width - 12, decoration.indicatorHeight);
    } else if (decoration.indicatorSize == MD2IndicatorSize.tiny) {
      rect = Offset(offset.dx + configuration.size!.width / 2 - 8,
              (configuration.size!.height - decoration.indicatorHeight)) &
          Size(16, decoration.indicatorHeight);
    }

    final Paint paint = Paint();
    paint.color = decoration.indicatorColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect!,
            topRight: Radius.circular(8), topLeft: Radius.circular(8)),
        paint);
  }
}

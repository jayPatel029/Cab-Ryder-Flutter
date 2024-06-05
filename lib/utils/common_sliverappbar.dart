// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'dart:ui';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../model/carinfo_modal.dart';
import 'fontfameli_model.dart';

typedef CollapsingAppBarBodyCreator = Widget Function(BuildContext context);

class CollapsingAppBarPage extends StatefulWidget {
  final String carTitle;
  final String Id;
  final String favorite;
  final CollapsingAppBarBodyCreator bodyCreator;
  const CollapsingAppBarPage({super.key, required this.bodyCreator, required this.carTitle, required this.Id, required this.favorite});

  @override
  _CollapsingAppBarPageState createState() => _CollapsingAppBarPageState();
}

class _CollapsingAppBarPageState extends State<CollapsingAppBarPage> with SingleTickerProviderStateMixin {
  static const _kExpandedHeight = 300.0;

  late ScrollController _scrollController;
  double offset = 0.0 ;

  @override
  void initState() {
    super.initState();
    validate();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          offset = _scrollController.offset;
        });
      });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
  final controller = PageController();

  late ColorNotifire notifire;
  bool isLike = false;

  Future favorite(uid, carId) async {
    Map body = {
      "uid": uid,
      "car_id": carId,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.uFav), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    }catch(e) {}
  }
  var userId;
  Future validate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = jsonDecode(sharedPreferences.getString('UserLogin')!);
    if(widget.favorite == "1"){
      isLike = true;
      setState(() {});
    }else{
      isLike = false;
      setState(() {});
    }
    carInfo(userId['id']);
  }

  late CarInfo info;
  bool loading = true;
  Future carInfo(uid) async {
    Map body = {
      "uid" : uid,
      "car_id" : widget.Id,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.cInfo), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          info = carInfoFromJson(response.body);
          loading = false;
        });
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch(e){}
  }
  late final AnimationController _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return  loading ? const SizedBox() : NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: _createSliverAppBar,
      body: widget.bodyCreator(context),
    );
  }

  List<Widget> _createSliverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    var collapsePercent = _getAppBarCollapsePercent();
    int rgb = ((1.0 - collapsePercent) * 255).round();
    Color color;
    if(rgb == 0){
      color = const Color.fromARGB(255, 255, 255, 255);
    } else if (rgb == 0.5){
      color = const Color.fromARGB(0, 0, 0, 0);
    }else{
      color = const Color.fromARGB(0, 0, 0, 0);
    }

    return <Widget>[
    SliverAppBar(
      backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        pinned: true,
        snap: false,
        floating: false,
        centerTitle: true,
        title: Text(widget.carTitle, style: TextStyle(color: color, fontSize: 18, fontFamily: FontFamily.europaWoff), overflow: TextOverflow.ellipsis),
        expandedHeight: Get.size.height * 0.43,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              favorite(userId['id'], widget.Id).then((value) {
                if(value["ResponseCode"] == "200") {
                  setState(() {
                    isLike = !isLike;
                  });
                  _controller.reverse().then((value) => _controller.forward());
                  Fluttertoast.showToast(msg: value['ResponseMsg']);
                } else{
                  Fluttertoast.showToast(msg: value['ResponseMsg']);
                }
              });
            },
            child: Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: ScaleTransition(scale: Tween(begin: 0.7,end: 1.0).animate(
                      CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
                      child: isLike ? Image.asset(Appcontent.favorite,color: widget.favorite == '1' ? Colors.red : Colors.red,) : Image.asset(Appcontent.favorite,color: greyScale),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: Get.size.width,
                alignment: Alignment.center,
                child: PageView.builder(
                  controller: controller,
                  itemCount: info.carinfo.carImg.length,
                  itemBuilder: (_, index) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          height: 500,
                            width: Get.width,
                            child: Image.network('${Config.imgUrl}${info.carinfo.carImg[index]}', fit: BoxFit.cover)),
                      ],
                    );
                  },
                ),
              ),

              info.carinfo.carImg.length == 1 ? const SizedBox() :Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: info.carinfo.carImg.length,
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      type: WormType.thinUnderground,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  double _getAppBarCollapsePercent() {
    if (!_scrollController.hasClients ){
      return 0.0;
    }
    return (offset / (_kExpandedHeight - kToolbarHeight)).clamp(0.0, 1.0);
  }
}
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController implements GetxService {
  bool isLoading = false;

  changShimmer() {
    Timer(Duration(seconds: 2), () {
      isLoading = true;
      update();
    });
  }
}

class ExploreController extends GetxController implements GetxService{
  bool load = false;

  shimmer(){
    Timer(Duration(seconds: 2), () {
      load =true;
      update();
    },);
  }
}
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:get/get.dart';

class FavoriteController extends GetxController implements GetxService {
  bool isLoading = false;

  changShimmer() {
    Timer(Duration(seconds: 4), () {
      isLoading = true;
      update();
    });
  }
}
// Bookdetail Controller
class BookdetailController extends GetxController implements GetxService{
  bool loading=false;

  changeShimmer(){
    Timer(Duration(seconds: 4), () {
      loading=true;
      update();
    });
  }
}
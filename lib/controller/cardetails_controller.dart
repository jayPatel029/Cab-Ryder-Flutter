import 'package:get/get.dart';

class CardetailsController extends GetxController implements GetxService {
  int currentIndex = 0;

  changeIndex({int? index}) {
    currentIndex = index ?? 0;
    update();
  }
}

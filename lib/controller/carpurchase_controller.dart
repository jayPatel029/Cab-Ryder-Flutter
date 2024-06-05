import 'package:get/get.dart';

class CarPurchaseController extends GetxController implements GetxService {
  int currentIndex = 0;

  changeIndexInYourPurchase({int? index}) {
    currentIndex = index ?? 0;
    update();
  }
}

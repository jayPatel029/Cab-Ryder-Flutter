import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController implements GetxService {
  TextEditingController name = TextEditingController();
  TextEditingController emali = TextEditingController();
  TextEditingController password = TextEditingController();

  bool showPassword = true;

  showOfPassword() {
    showPassword = !showPassword;
    update();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController implements GetxService {
  TextEditingController emali = TextEditingController();
  TextEditingController password = TextEditingController();

  bool showPassword = true;

  showOfPassword() {
    showPassword = !showPassword;
    update();
  }
}

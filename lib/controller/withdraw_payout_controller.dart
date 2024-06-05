
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayOutController extends GetxController implements GetxService {
  bool isLoading = false;

  TextEditingController amount = TextEditingController();
  TextEditingController upi = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountHolderName = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController emailId = TextEditingController();


  emptyDetails() {
    amount.text = "";
    accountNumber.text = "";
    bankName.text = "";
    accountHolderName.text = "";
    ifscCode.text = "";
    upi.text = "";
    emailId.text = "";
    update();
  }

}
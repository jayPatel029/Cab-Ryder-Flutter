// ignore_for_file: file_names, prefer_const_constructors
import 'package:carlink/utils/Colors.dart';
import 'package:flutter/material.dart';

class ColorNotifire with ChangeNotifier {
  bool isDark = false;
  set setIsDark(value) {
    isDark = value;
    notifyListeners();
  }

  get getIsDark => isDark;
  get getbgcolor => isDark ? darkmode : bgcolor; //background color
  get getboxcolor => isDark ? boxcolor : WhiteColor; //containar color
  get getlightblackcolor => isDark ? boxcolor : lightBlack;
  get getwhiteblackcolor => isDark ? WhiteColor : BlackColor; //text defultsystemicon imageicon color
  get getgreycolor => isDark ? greyColor : greyColor;
  get getwhitebluecolor => isDark ? WhiteColor : Darkblue;
  get getblackgreycolor => isDark ? lightBlack2 : greyColor;
  get getcardcolor => isDark ? darkmode : WhiteColor;
  get getgreywhite => isDark ? WhiteColor : greyColor;
  get getredcolor => isDark ? RedColor : RedColor2;
  get getprocolor => isDark ? yelloColor : yelloColor2;
  get getblackwhitecolor => isDark ? bmode : WhiteColor;
  get getlightblack => isDark ? lightBlack2 : lightBlack2;
  get getbuttonscolor => isDark ? lightgrey : lightgrey2;
  get getbuttoncolor => isDark ? greyColor : onoffColor;
  get getdarkbluecolor => isDark ? Darkblue : Darkblue;
  get getdarkscolor => isDark ? BlackColor : bgcolor;
  get getdarkwhitecolor => isDark ? WhiteColor : WhiteColor;
  get getblackblue => isDark ? blueColor : BlackColor;

  get getfevAndSearch => isDark ? darkmode : fevAndSearchColor;
  get getlightblackwhite => isDark ? BlackColor : fevAndSearchColor;

  get getborderColor => isDark ? Color(0xFF1B2537) : grey50;
  get getgreyscale => isDark ? Color(0xFF94A3B8) : Color(0xFF1B2537);
  get getsetting => isDark ? Color(0xff1B2537) : Color(0xffF8FAFC);

  get getCarColor => isDark ? Color(0xffF9F9F9).withOpacity(0.08) : Color(0xffF9F9F9);
  get getBottom => isDark ? Color(0xffF9F9F9).withOpacity(0.08) : bottomColor;
  get getBottom1 => isDark ? Colors.black : bottomColor;
}

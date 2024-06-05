// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleModel extends ChangeNotifier {
  Locale? _locale;
  final SharedPreferences _prefs;

  LocaleModel(this._prefs) {
    var selectedLocale = _prefs.getString("selectLocaleLanguage");
    if (selectedLocale != null) {
      _locale = Locale(selectedLocale.toString().split("_").first,selectedLocale.toString().split("_").last);
    }else{
      _locale = const Locale('en', 'US');
    }
  }

  Locale? get locale => _locale;

  void set(Locale? locale) {
    _locale = locale;
    _prefs.setString('selectLocaleLanguage', locale.toString());

    notifyListeners();
  }
}
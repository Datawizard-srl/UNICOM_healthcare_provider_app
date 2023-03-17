import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:unicom_healthcare/database/local_storage/user_preferences.dart';


class UserPreferencesNotifier extends ChangeNotifier {

  UserPreferencesNotifier();


  // SETTERS /////////////////////////////////////

  Future<void> setLocale(Locale language) async {
    await UserPreferences.setLocale(language);
    notifyListeners();
  }

  Future setLocaleFromString(String? localeString) async {
    if (localeString == null || localeString == ''){
      UserPreferences.setLocale(null);
    } else {
      UserPreferences.setLocale(localeFromString(localeString));
    }
    notifyListeners();
  }

  Future<void> setDarkMode(bool flag) async {
    UserPreferences.setDarkMode(flag);
    notifyListeners();
  }

  Future<void> setFontSize(int value) async {
    UserPreferences.setFontSize(value);
    notifyListeners();
  }
  
  Future<void> setCountryCode(String? value) async {
    UserPreferences.setCountry(value);
    notifyListeners();
  }


  // GETTERS /////////////////////////////////////

  Locale? getLocale() {
    return UserPreferences.getLocale();
  }

  String? getCountryCode(){
    return UserPreferences.getCountryCode();
  }


  // UTILS ///////////////////////////////////////

  static Locale localeFromStringSeparator(String localeString, String separator) {
    List<String> lan = localeString.split(separator);
    if (lan.length > 1) return Locale(lan[0], lan[1]);
    return Locale(lan[0]);
  }

  static Locale localeFromString(String localeString) {
    return localeFromStringSeparator(localeString, "_");
  }
}

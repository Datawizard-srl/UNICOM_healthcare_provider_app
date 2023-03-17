import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

import '../../models/user_preferences_model.dart';

class PreferencesKeys {
  static const String locale = 'locale';
  static const String languageSelected = 'languageSelected';
  static const String darkMode = 'darkMode'; 
  static const String fontSize = 'fontSize';
  static const String countryCode = 'countryCode';
}

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();

    if(getLocale() == null) {
      setLocale(UserPreferencesNotifier.localeFromStringSeparator(Platform.localeName, '-') ?? const Locale("en", "US"));
    }
    setLocaleSelected(_preferences.getBool(PreferencesKeys.languageSelected) ?? false);
    setDarkMode(_preferences.getBool(PreferencesKeys.darkMode) ?? false);
    setFontSize(_preferences.getInt(PreferencesKeys.fontSize) ?? 0);
  }

  
  // SETTERS ///////////////////////////////////
  
  static Future<bool> setLocale(Locale? locale) async {
    if (locale == null){
      return _preferences.setString(PreferencesKeys.locale, '');
    }
    return _preferences.setString(PreferencesKeys.locale, locale.toString());
  }

  static Future<bool> setLocaleSelected(bool flag){
    return _preferences.setBool(PreferencesKeys.languageSelected, flag);
  }

  static Future<bool> setDarkMode(bool flag) async {
    return _preferences.setBool(PreferencesKeys.darkMode, flag);
  }

  static Future<bool> setFontSize(int value) async {
    return _preferences.setInt(PreferencesKeys.fontSize, value);
  }

  static Future<bool> setCountry(String? countryCode) async {
    countryCode ??= '';
    return _preferences.setString(PreferencesKeys.countryCode, countryCode);
  }
  
  
  // GETTERS //////////////////////////////////

  static Locale? getLocale() {
    String? langCode = _preferences.getString(PreferencesKeys.locale);
    return langCode == null || langCode == '' ? null : UserPreferencesNotifier.localeFromString(langCode);
  }

  static bool isLocaleSelected(){
    return _preferences.getBool(PreferencesKeys.languageSelected)!;
  }
  
  static bool isDarkMode(){
    return _preferences.getBool(PreferencesKeys.darkMode)!;
  }

  static int getFontSize(){
    return _preferences.getInt(PreferencesKeys.fontSize)!;
  }

  static String? getCountryCode(){
    return _preferences.getString(PreferencesKeys.countryCode);
  }
}
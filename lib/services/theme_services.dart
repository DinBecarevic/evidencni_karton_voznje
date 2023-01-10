import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode)=>_box.write(_key, isDarkMode); //shrani temo v box boolean

  bool _loadThemeFromBox()=>_box.read(_key)??false;
  ThemeMode get theme=> _loadThemeFromBox()?ThemeMode.dark:ThemeMode.light;
  void switchTheme(){ //funkcija za spreminjanje teme
    Get.changeThemeMode(_loadThemeFromBox()?ThemeMode.light:ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());//shranjujemo boolean
  }
}
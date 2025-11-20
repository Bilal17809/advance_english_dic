import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemePreference(isDarkMode.value);
  }

  ThemeMode get currentTheme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
  }
}

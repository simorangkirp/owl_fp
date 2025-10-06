import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/dal/services/get.storage.dart';

class SettingController extends GetxController {
  final StorageService storage;

  SettingController({required this.storage});

  var isDark = false.obs;
  var currentLang = const Locale('en', 'US').obs;

  // daftar bahasa yang tersedia
  final languages = const [
    Locale('en'),
    Locale('id'),
  ];

  @override
  void onInit() {
    super.onInit();

    // load dari storage
    isDark.value = storage.isDarkmode;

    final langCode = storage.whatLang ?? 'en';
    currentLang.value = languages.firstWhere(
      (l) => l.languageCode == langCode,
      orElse: () => const Locale('en', 'US'),
    );

    // apply langsung saat start
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
    Get.updateLocale(currentLang.value);
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    storage.saveAppTheme(isDark.value);
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  void changeLang(String langCode) {
    final locale = languages.firstWhere(
      (loc) => loc.languageCode == langCode,
      orElse: () => const Locale('en'),
    );
    currentLang.value = locale;
    storage.saveAppLang(langCode);
    Get.updateLocale(locale);
  }

  // helper: kasih nama bahasa buat dropdown
  String getLangName(Locale locale) {
    switch (locale.languageCode) {
      case 'id':
        return 'Bahasa Indonesia';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }
}

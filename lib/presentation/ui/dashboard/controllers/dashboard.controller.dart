import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardMenuModel {
  String menuNm;
  String path;
  IconData menuIcon;
  DashboardMenuModel(this.menuNm, this.path, this.menuIcon);
}

class DashboardController extends GetxController {
  var menuItem = <DashboardMenuModel>[
    DashboardMenuModel(
      "Fingerprint",
      '/fingerprint',
      LucideIcons.fingerprint,
    ),
    DashboardMenuModel(
      "Ombrometer",
      '/dashboard',
      LucideIcons.milk,
    ),
    // DashboardMenuModel(
    //   "Setup",
    //   '/setup',
    //   Icons.settings,
    // ),
    // DashboardMenuModel(
    //   "About",
    //   '/about',
    //   Icons.info_outline,
    // ),
  ].obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardMenuModel {
  String? menuNm;
  Icon? menuIcon;
  DashboardMenuModel({menuNm, menuIcon});
}

class HomeController extends GetxController {
  var menuItem = <DashboardMenuModel>[
    DashboardMenuModel(
      menuNm: "Fingerprint",
      menuIcon: Icon(Icons.fingerprint),
    ),
    DashboardMenuModel(
      menuNm: "Ombrometer",
      menuIcon: Icon(Icons.three_g_mobiledata_rounded),
    ),
    DashboardMenuModel(
      menuNm: "Setup",
      menuIcon: Icon(Icons.settings),
    ),
    DashboardMenuModel(
      menuNm: "About",
      menuIcon: Icon(Icons.info_outline),
    ),
  ].obs;
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }
}

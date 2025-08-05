import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../domain/usecase/dashboard/master.list.usecase.dart';

class DashboardMenuModel {
  String menuNm;
  String path;
  IconData menuIcon;
  DashboardMenuModel(this.menuNm, this.path, this.menuIcon);
}

class DashboardController extends GetxController {
  final GetMasterHeaderUseCase _masterHeader;
  DashboardController(this._masterHeader);
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
  ].obs;

  var listMD = [].obs;

  Future<List<String>> getMasterHeader() async {
    var response = await _masterHeader.execute();
    return response;
  }

  @override
  void onInit() async {
    listMD.value = await getMasterHeader();
    super.onInit();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

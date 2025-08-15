import 'package:get/get.dart';

import '../../../../data/model/icon.menu.model.dart';
import '../../../../domain/usecase/dashboard/icon.menu.usecase.dart';
import '../../../../domain/usecase/dashboard/master.list.usecase.dart';

class DashboardController extends GetxController {
  final GetMasterHeaderUseCase _masterHeader;
  final GetIconMenuDashboardUsecase _iconmenuHeader;
  DashboardController(this._masterHeader, this._iconmenuHeader);
  var menuItem = <DashboardIconMenuModel>[].obs;

  var listMD = [].obs;

  Future<List<String>> getMasterHeader() async {
    var response = await _masterHeader.execute();
    return response;
  }

  Future<void> geticonMenu() async {
    var response = await _iconmenuHeader.execute();
    if (response != null && response.isNotEmpty) {
      menuItem.value = response;
    }
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

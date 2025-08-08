import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../domain/entity/karyawan.entity.dart';
import '../../../../domain/usecase/masterdata/find.karyawan.usecase.dart';

class MasterdataController extends GetxController {
  final FindKaryawanTupleUseCase _searchKaryawan;
  MasterdataController(this._searchKaryawan);
  // Variabels
  var title = "".obs;
  var karyawanlist = <KaryawanEntity>[].obs;

  // Text Controller
  var searchCtrl = TextEditingController();

  // Function List
  Future<List<KaryawanEntity>?> searchData() async {
    var res = await _searchKaryawan.execute(searchCtrl.text);
    if (res != null) {
      karyawanlist.value = res;
    }
    return res;
  }

  @override
  void onInit() {
    title.value = Get.arguments['args'] ?? "Undefined";
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

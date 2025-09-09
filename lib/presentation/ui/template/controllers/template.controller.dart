import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../domain/usecase/template/get.fptemp.usecase.dart';
import '../../../../domain/usecase/template/get.sn.usecase.dart';
import '../../../../domain/usecase/template/get.karyawan.usecase.dart';

class TemplateController extends GetxController {
  final GetSNListUsecase _getSNUsecase;
  final KaryawanFPTemplateUsecase _getTemplateUsecase;
  final GetKaryawanUseCase _getKaryawanUsecase;
  TemplateController(
    this._getSNUsecase,
    this._getTemplateUsecase,
    this._getKaryawanUsecase,
  );

  //* Viariabels *//
  //? Lists
  var listSN = <String>[].obs;
  var listKaryawan = <String>[].obs;
  var listTemplate = <String>[].obs;
  //? Strings
  var selectedKaryawan = ''.obs;
  var selectedSN = ''.obs;
  //? Boolean
  //? Text Controller
  var typeAheadTCtrl = TextEditingController();

  //* Function Lists *//
  Future<void> getSN() async {
    listSN.value = await _getSNUsecase.execute();
    listSN.forEach((element) {
      log(element);
    });
  }

  Future<void> getTemplate() async {
    listTemplate.value = await _getTemplateUsecase
        .execute({'sn': selectedSN, 'nama': selectedKaryawan});
    for (var element in listTemplate) {
      log(element);
    }
  }

  Future<void> getKaryawan() async {
    listKaryawan.value = await _getKaryawanUsecase.execute(selectedSN.value);
  }

  @override
  Future<void> onInit() async {
    await getSN();
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

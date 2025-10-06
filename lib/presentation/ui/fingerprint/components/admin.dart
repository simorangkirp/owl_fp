import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/domain/entity/karyawan.entity.dart';

import '../../../constant.dart';
import '../../common/app.typeahead.dart';
import '../controllers/bt.controller.dart';
import '../controllers/fingerprint.controller.dart';

class AdminComponent extends StatelessWidget {
  AdminComponent({super.key});
  final controller = Get.find<FingerprintController>();
  final btctrl = Get.find<BluetoothController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    var optCtrl = ScrollController();

    opendialog(int index) {
      return Get.dialog(
        Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.2.sh),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("auth".tr),
                SizedBox(height: 12.h),
                Text("inputPassword".tr),
                SizedBox(height: 8.h),
                TextField(
                  controller: controller.authDialogCtrl,
                  onChanged: (value) {
                    controller.authDialogArg = value;
                  },
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 42.h),
                  ),
                  onPressed: () {
                    Get.back();
                    controller
                        .adminOptSend(controller.admselectedMenuIndex.value);
                    // btctrl.devSend(controller.authDialogArg);
                  },
                  child: Text('send'.tr),
                ),
              ],
            ),
          ),
        ),
      );
    }

    gantinPinWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${"oldPin".tr}:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 8.h),
          TextFormField(
            onChanged: (value) {
              controller.oldpinCtrl.text = value;
            },
            controller: controller.oldpinCtrl,
            // controller: controller.urlCtrl,
            decoration: const InputDecoration(
                hintText: '******',
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ),
          SizedBox(height: 8.h),
          Text(
            "${"newPin".tr}:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 8.h),
          TextFormField(
            onChanged: (value) {
              controller.newpinCtrl.text = value;
            },
            controller: controller.newpinCtrl,
            // controller: controller.urlCtrl,
            decoration: const InputDecoration(
                hintText: '******',
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ),
          SizedBox(height: 8.h),
          Text(
            "${"confirmPin".tr}:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 8.h),
          TextFormField(
            onChanged: (value) {
              controller.confpinCtrl.text = value;
            },
            controller: controller.confpinCtrl,
            // controller: controller.urlCtrl,
            decoration: const InputDecoration(
                hintText: '******',
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ),
          SizedBox(height: 24.h),
        ],
      );
    }

    tambahAdmin() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${"chooseEmply".tr}:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 8.h),
          AppTypeAheadField<KaryawanEntity>(
            controller: controller.typeAheadController, // TextEditingController
            // labelText: 'Cari karyawan',
            hintText: 'findEmply'.tr,

            // ✅ harus return List<Karyawan>
            suggestionsCallback: (pattern) async {
              return controller.karyawanlist.where((item) {
                final name = item.namakaryawan ?? "Undefined";
                return name.toLowerCase().contains(pattern.toLowerCase());
              }).toList();
            },

            // render tiap item suggestion
            itemBuilder: (context, KaryawanEntity suggestion) {
              return ListTile(
                title: Text(suggestion.namakaryawan ?? ""),
              );
            },

            // saat dipilih
            onSuggestionSelected: (KaryawanEntity suggestion) {
              btctrl.selectedRegisterNm = suggestion.namakaryawan ?? "";
              btctrl.selectedRegisterNIK = suggestion.karyawanid ?? "";
              controller.typeAheadController.text =
                  suggestion.namakaryawan ?? "";
            },

            // opsional: builder jika tidak ada hasil
            noItemsFoundBuilder: (ctx) => Padding(
              padding: EdgeInsets.all(8),
              child: Text("${"notFound".tr}!"),
            ),
          ),
          SizedBox(height: 12.h),
          Text("addPriv".tr),
          const Divider(),
          ListView.builder(
            controller: optCtrl,
            shrinkWrap: true,
            itemCount: controller.listAdminOpt.length,
            itemBuilder: (context, index) {
              var data = controller.listAdminOpt[index];
              return Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: data.selected.value, // selalu pakai .value
                      onChanged: (val) {
                        data.selected.value = val ?? false;
                      },
                    ),
                  ),
                  Expanded(child: Text(data.value ?? "Undifined")),
                ],
              );
            },
          ),
          SizedBox(height: 12.h),
        ],
      );
    }

    hapusbyNik() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${"chooseEmply".tr}:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 8.h),
          AppTypeAheadField<KaryawanEntity>(
            controller: controller.typeAheadController, // TextEditingController
            // labelText: 'Cari karyawan',
            hintText: 'findEmply'.tr,

            // ✅ harus return List<Karyawan>
            suggestionsCallback: (pattern) async {
              return controller.karyawanlist.where((item) {
                final name = item.namakaryawan ?? "Undefined";
                return name.toLowerCase().contains(pattern.toLowerCase());
              }).toList();
            },

            // render tiap item suggestion
            itemBuilder: (context, KaryawanEntity suggestion) {
              return ListTile(
                title: Text(suggestion.namakaryawan ?? ""),
              );
            },

            // saat dipilih
            onSuggestionSelected: (KaryawanEntity suggestion) {
              btctrl.selectedRegisterNm = suggestion.namakaryawan ?? "";
              btctrl.selectedRegisterNIK = suggestion.karyawanid ?? "";
              controller.typeAheadController.text =
                  suggestion.namakaryawan ?? "";
            },

            // opsional: builder jika tidak ada hasil
            noItemsFoundBuilder: (ctx) => Padding(
              padding: EdgeInsets.all(8),
              child: Text("${"notFound".tr}!"),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text(
            "privilege".tr,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Divider(),
          SizedBox(height: 12.h),
          // Text("Pilih Menu"),
          // SizedBox(height: 8.h),
          Text("${"chsOpt".tr}:"),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            style: Theme.of(context).textTheme.labelMedium,
            decoration: InputDecoration(
              contentPadding: ConstPadding.ddBtnPadding,
              border: const OutlineInputBorder(),
            ),
            value: controller.adminDDOptList.first,
            items: controller.adminDDOptList
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(
                        option,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              controller.selectedAdmin.value = value ?? "";
              controller.admselectedMenuIndex.value =
                  controller.adminDDOptList.indexOf(value);
              log('${controller.adminDDOptList.indexOf(value)}');
            },
            validator: (value) {
              if (value == null) {
                return 'plSlcOpt'.tr;
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Obx(
            () => (controller.admselectedMenuIndex.value == 0)
                ? gantinPinWidget()
                : (controller.admselectedMenuIndex.value == 1)
                    ? tambahAdmin()
                    : hapusbyNik(),
          ),

          ElevatedButton(
            onPressed: () {
              opendialog(1);
            },
            child: Text('send'.tr),
          ),
        ],
      ),
    );
  }
}

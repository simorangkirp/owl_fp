import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/core/resources/utils.dart';
import 'package:owl_fp_newer/domain/entity/karyawan.entity.dart';
import 'package:owl_fp_newer/presentation/ui/common/dialog.dart';
import 'package:owl_fp_newer/presentation/ui/fingerprint/controllers/bt14_ctrl_controller.dart';

import '../../../constant.dart';
import '../../common/app.typeahead.dart';
import '../controllers/fingerprint.controller.dart';

class AdminComponent extends StatelessWidget {
  AdminComponent({super.key});

  final controller = Get.find<FingerprintController>();
  final btctrl = Get.find<Bt14CtrlController>();

  Future<void> _openDialog(int index) async {
    // 🔹 Jalankan pengecekan permission dulu
    await controller.checkPermission(() {
      // 🔹 Panggil dialog global
      showAuthDialog(
        obsecure: btctrl.isPwObscured,
        title: "auth".tr,
        message: "inputPassword".tr,
        controller: btctrl.authCtrl,
        onSubmit: () {
          final password = btctrl.authCtrl.text.trim();

          if (password.isEmpty) {
            showSnackBar("Password tidak boleh kosong!");
            return;
          }

          // 🔹 Jalankan fungsi utama
          btctrl.adminSelection(controller.admselectedMenuIndex.value);
        },
      );
    });
  }

  Widget _gantiPinWidget(TextTheme theme) {
    return Form(
      key: controller.formGPinKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${"oldPin".tr}:", style: theme.labelMedium),
          SizedBox(height: 8.h),
          TextFormField(
            controller: btctrl.oldpinCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: '******',
              hintStyle: TextStyle(fontStyle: FontStyle.italic),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kolom ini wajib di isi!';
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Text("${"newPin".tr}:", style: theme.labelMedium),
          SizedBox(height: 8.h),
          TextFormField(
            controller: btctrl.newpinCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: '******',
              hintStyle: TextStyle(fontStyle: FontStyle.italic),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kolom ini wajib di isi!';
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Text("${"confirmPin".tr}:", style: theme.labelMedium),
          SizedBox(height: 8.h),
          TextFormField(
            controller: btctrl.confpinCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: '******',
              hintStyle: TextStyle(fontStyle: FontStyle.italic),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kolom ini wajib di isi!';
              }
              return null;
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _tambahAdmin(TextTheme theme) {
    var optCtrl = ScrollController();

    return Form(
      key: controller.formAddAdminKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${"chooseEmply".tr}:", style: theme.labelMedium),
          SizedBox(height: 8.h),
          AppTypeAheadField<KaryawanEntity>(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kolom ini wajib di isi!';
              }
              return null;
            },
            controller: btctrl.typeAheadController,
            hintText: 'findEmply'.tr,
            suggestionsCallback: (pattern) async {
              return controller.karyawanlist.where((item) {
                final name = item.namakaryawan ?? "Undefined";
                return name.toLowerCase().contains(pattern.toLowerCase());
              }).toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion.namakaryawan ?? ""));
            },
            onSuggestionSelected: (suggestion) {
              btctrl.selectedRegisterNm = suggestion.namakaryawan ?? "";
              btctrl.selectedRegisterNIK = suggestion.karyawanid ?? "";
              btctrl.typeAheadController.text = suggestion.namakaryawan ?? "";
            },
            noItemsFoundBuilder: (ctx) => Padding(
              padding: const EdgeInsets.all(8),
              child: Text("${"notFound".tr}!"),
            ),
          ),
          SizedBox(height: 12.h),
          Text("addPriv".tr, style: theme.labelMedium),
          const Divider(),
          ListView.builder(
            controller: optCtrl,
            shrinkWrap: true,
            itemCount: btctrl.listAdminOpt.length,
            itemBuilder: (context, index) {
              var data = btctrl.listAdminOpt[index];
              return Row(
                children: [
                  Obx(() => Checkbox(
                        value: data.selected.value,
                        onChanged: (val) => data.selected.value = val ?? false,
                      )),
                  Expanded(child: Text(data.value ?? "Undefined")),
                ],
              );
            },
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _hapusByNik(TextTheme theme) {
    return Form(
      key: controller.formDeleteNikKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${"chooseEmply".tr}:", style: theme.labelMedium),
          SizedBox(height: 8.h),
          AppTypeAheadField<KaryawanEntity>(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kolom ini wajib di isi!';
              }
              return null;
            },
            controller: controller.typeAheadController,
            hintText: 'findEmply'.tr,
            suggestionsCallback: (pattern) async {
              return controller.karyawanlist.where((item) {
                final name = item.namakaryawan ?? "Undefined";
                return name.toLowerCase().contains(pattern.toLowerCase());
              }).toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion.namakaryawan ?? ""));
            },
            onSuggestionSelected: (suggestion) {
              btctrl.selectedRegisterNm = suggestion.namakaryawan ?? "";
              btctrl.selectedRegisterNIK = suggestion.karyawanid ?? "";
              controller.typeAheadController.text =
                  suggestion.namakaryawan ?? "";
            },
            noItemsFoundBuilder: (ctx) => Padding(
              padding: const EdgeInsets.all(8),
              child: Text("${"notFound".tr}!"),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text(
            "privilege".tr,
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Divider(),
          SizedBox(height: 12.h),
          Text("${"chsOpt".tr}:"),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            style: theme.labelMedium,
            decoration: InputDecoration(
              contentPadding: ConstPadding.ddBtnPadding,
              border: const OutlineInputBorder(),
            ),
            value: controller.adminDDOptList.first,
            items: controller.adminDDOptList
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (value) {
              controller.selectedAdmin.value = value ?? "";
              controller.admselectedMenuIndex.value =
                  controller.adminDDOptList.indexOf(value);
              log('Selected index: ${controller.admselectedMenuIndex.value}');
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'plSlcOpt'.tr;
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Obx(() {
            final index = controller.admselectedMenuIndex.value;
            if (index == 0) return _gantiPinWidget(theme);
            if (index == 1) return _tambahAdmin(theme);
            return _hapusByNik(theme);
          }),
          ElevatedButton(
            onPressed: () {
              final index = controller.admselectedMenuIndex.value;
              bool isValid = false;

              if (index == 0) {
                isValid = controller.formGPinKey.currentState?.validate() ??
                    false; // Ganti PIN tidak punya form
              } else if (index == 1) {
                isValid = controller.formAddAdminKey.currentState?.validate() ??
                    false;
              } else if (index == 2) {
                isValid =
                    controller.formDeleteNikKey.currentState?.validate() ??
                        false;
              }

              if (isValid) {
                _openDialog(index);
              }
            },
            child: Text('send'.tr),
          ),
        ],
      ),
    );
  }
}

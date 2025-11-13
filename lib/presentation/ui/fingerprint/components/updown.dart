import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/domain/entity/karyawan.entity.dart';
import 'package:owl_fp_newer/presentation/ui/common/dialog.dart';
import '../../../constant.dart';
import '../../common/app.typeahead.dart';
import '../controllers/bt.controller.dart';
import '../controllers/fingerprint.controller.dart';

class UpdownComponent extends StatelessWidget {
  UpdownComponent({super.key});
  final btCtrl = Get.find<BluetoothController>();
  final ctrl = Get.find<FingerprintController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ConstPadding.screenPadding,
      child: Form(
        key: ctrl.formUpdownKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          children: [
            Text(
              "undFinger".tr,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Divider(),
            SizedBox(height: 12.h),

            Text("${"chsOpt".tr}:"),
            SizedBox(height: 8.h),

            // Dropdown utama
            Obx(() => ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: double.infinity),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    style: Theme.of(context).textTheme.labelMedium,
                    decoration: InputDecoration(
                      contentPadding: ConstPadding.ddBtnPadding,
                      border: const OutlineInputBorder(),
                    ),
                    value: ctrl.selectedUpDown1.value.isEmpty
                        ? null
                        : ctrl.selectedUpDown1.value,
                    hint: Text('plSlcOpt'.tr),
                    items: ctrl.uploadDownloadList
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child:
                                  Text(option, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) {
                      ctrl.selectedUpDown1.value = value ?? "";
                      ctrl.undselectedMenuIndex.value =
                          ctrl.uploadDownloadList.indexOf(value);
                      log("Menu index: ${ctrl.undselectedMenuIndex.value}");
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'plSlcOpt'.tr;
                      }
                      return null;
                    },
                  ),
                )),

            SizedBox(height: 12.h),

            // AppTypeAheadField (custom validatable wrapper)
            Obx(() {
              if (ctrl.undselectedMenuIndex.value == 1) {
                return _ValidatedField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Kolom ini wajib diisi!';
                    }
                    return null;
                  },
                  builder: (onChanged) => AppTypeAheadField<KaryawanEntity>(
                    controller: ctrl.typeAheadController,
                    hintText: 'findEmply'.tr,
                    suggestionsCallback: (pattern) async {
                      return ctrl.karyawanlist.where((item) {
                        final name = item.namakaryawan ?? "Undefined";
                        return name
                            .toLowerCase()
                            .contains(pattern.toLowerCase());
                      }).toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion.namakaryawan ?? ""),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      btCtrl.selectedRegisterNm = suggestion.namakaryawan ?? "";
                      btCtrl.selectedRegisterNIK = suggestion.karyawanid ?? "";
                      ctrl.typeAheadController.text =
                          suggestion.namakaryawan ?? "";
                      onChanged(ctrl.typeAheadController.text);
                    },
                    noItemsFoundBuilder: (ctx) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text("${"notFound".tr}!"),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // SN dropdown
            Obx(() {
              if (ctrl.undselectedMenuIndex.value == 2) {
                return DropdownButtonFormField<String>(
                  style: Theme.of(context).textTheme.labelMedium,
                  decoration: InputDecoration(
                    contentPadding: ConstPadding.ddBtnPadding,
                    border: const OutlineInputBorder(),
                  ),
                  value: ctrl.selectedSN.value.isEmpty
                      ? null
                      : ctrl.selectedSN.value,
                  hint: Text('plSlcOpt'.tr),
                  items: ctrl.listSN
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child:
                                Text(option, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (value) {
                    ctrl.selectedSN.value = value ?? "";
                  },
                  validator: (value) {
                    if (ctrl.undselectedMenuIndex.value == 2 &&
                        (value == null || value.isEmpty)) {
                      return 'plSlcOpt'.tr;
                    }
                    return null;
                  },
                );
              }
              return const SizedBox.shrink();
            }),

            SizedBox(height: 24.h),

            ElevatedButton(
              onPressed: () async {
                final form = ctrl.formUpdownKey.currentState!;
                if (form.validate()) {
                  await ctrl.checkPermission(() {
                    showAuthDialog(
                      obsecure: ctrl.isPwObscured,
                      title: "Otentikasi Upload",
                      message: "Masukkan Password!",
                      controller: ctrl.authDialogCtrl,
                      onSubmit: () {
                        ctrl.authDialogCtrl.clear();
                        ctrl.uploadDownloadOptSend(
                            ctrl.undselectedMenuIndex.value);
                      },
                    );
                  });
                }
              },
              child: Text('send'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Wrapper kecil agar widget non-FormField (seperti TypeAhead) tetap bisa divalidasi
class _ValidatedField extends FormField<String> {
  _ValidatedField({
    required Widget Function(void Function(String?) onChanged) builder,
    super.validator, // ✅ gunakan super parameter
  }) : super(
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              builder(field.didChange),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
}

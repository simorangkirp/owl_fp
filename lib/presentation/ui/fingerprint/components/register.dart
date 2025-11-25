import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp_newer/domain/entity/karyawan.entity.dart';
import 'package:owl_fp_newer/presentation/ui/common/dialog.dart';

import '../../../constant.dart';
import '../../common/app.typeahead.dart';
import '../controllers/bt14_ctrl_controller.dart';
import '../controllers/fingerprint.controller.dart';

class RegisterComponent extends StatelessWidget {
  RegisterComponent({super.key});

  final btctrl = Get.find<Bt14CtrlController>();
  final controller = Get.find<FingerprintController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final indicator = Theme.of(context).tabBarTheme.indicator;
    Color borderColor = Colors.blue;

    if (indicator is UnderlineTabIndicator) {
      borderColor = indicator.borderSide.color;
    }

    Future<void> onOpenDialog(int index) async {
      await btctrl.checkPermission(() {
        showAuthDialog(
          obsecure: controller.isPwObscured,
          title: "auth".tr, // Otentikasi
          message: "inputPassword".tr, // Masukkan Password
          controller: btctrl.authCtrl,
          onSubmit: () async {
            await btctrl.regDelFinger(
              isRegister: index == 0 ? true : false, // false kalau hapus
              nik: btctrl.selectedRegisterNIK, // pakai variable dari controller
              name: btctrl.selectedRegisterNm, // pakai variable dari controller
            );
          },
        );
      });
    }

    // 🧱 UI utama
    return Padding(
      padding: ConstPadding.screenPadding,
      child: Form(
        key: controller.formRegisterKey, // 🔑 gunakan formKey dari controller
        child: ListView(
          children: [
            Text(
              "rndFinger".tr,
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Divider(),
            SizedBox(height: 12.h),

            /// 🔍 TypeAheadField dengan validator
            AppTypeAheadField<KaryawanEntity>(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kolom ini wajib diisi!';
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
                btctrl.selectedRegisterNIK = suggestion.nik ?? "";
                controller.typeAheadController.text =
                    suggestion.namakaryawan ?? "";
              },
              noItemsFoundBuilder: (ctx) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text("${"notFound".tr}!"),
              ),
            ),

            SizedBox(height: 12.h),

            /// 🔘 Tombol aksi
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(LucideIcons.userPlus2,
                      color: Colors.white, size: 18.sp),
                  label: Text('register'.tr),
                  onPressed: () {
                    // ✅ Validasi pakai controller.formKey
                    if (controller.formRegisterKey.currentState!.validate()) {
                      onOpenDialog(0);
                    }
                  },
                ),
                SizedBox(width: 8.w),
                ElevatedButton.icon(
                  icon: Icon(LucideIcons.trash2,
                      color: Colors.white, size: 18.sp),
                  label: Text('delete'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: borderColor,
                  ),
                  onPressed: () {
                    if (controller.formRegisterKey.currentState!.validate()) {
                      onOpenDialog(1);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/core/resources/utils.dart';
import 'package:owl_fp_newer/presentation/ui/common/app.textformfield.dart';
import 'package:owl_fp_newer/presentation/ui/common/dialog.dart';

import '../../../constant.dart';
import '../controllers/bt14_ctrl_controller.dart';
import '../controllers/fingerprint.controller.dart';

class SettingComponents extends StatelessWidget {
  SettingComponents({super.key});
  final controller = Get.find<FingerprintController>();
  final btctrl = Get.find<Bt14CtrlController>();

  @override
  Widget build(BuildContext context) {
    final formWifiKey = GlobalKey<FormState>();
    final formWUploadKey = GlobalKey<FormState>();
    final formCSecretKey = GlobalKey<FormState>();
    final formSAddressKey = GlobalKey<FormState>();
    final formDtimeKey = GlobalKey<FormState>();
    final formTDeleteKey = GlobalKey<FormState>();

    Future<void> opendialog(int index) async {
      // 🔹 Jalankan pengecekan permission dulu
      await btctrl.checkPermission(() {
        // 🔹 Tampilkan dialog global
        showAuthDialog(
          obsecure: controller.isPwObscured,
          title: "auth".tr,
          message: "inputPassword".tr,
          controller: controller.authDialogCtrl,
          onSubmit: () {
            final password = controller.authDialogCtrl.text.trim();

            if (password.isEmpty) {
              showSnackBar("Password tidak boleh kosong!");
              return;
            }

            controller.authDialogCtrl.clear();

            // Jalankan fungsi utama kamu
            btctrl.settings(password, controller.selectedSettingId.value);
          },
        );
      });
    }

    Widget wifi() {
      return Form(
        key: formWifiKey,
        child: Column(
          children: [
            TextFormField(
              controller: btctrl.ssidNm,
              decoration: const InputDecoration(
                hintText: 'SSID',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kolom ini wajib di isi!';
                }
                return null;
              },
            ),
            SizedBox(height: 8.h),
            AppPasswordField(
              controller: btctrl.ssidPw,
              isObscured: btctrl.isPwObscured, // ini RxBool di controllermu
              hintText: 'password'.tr,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kolom ini wajib di isi!';
                } else if (value.length < 8) {
                  return 'Password minimal 8 karakter';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {
                // ✅ cek validasi dulu
                if (formWifiKey.currentState!.validate()) {
                  // valid → baru jalanin logic
                  opendialog(0);
                }
              },
              child: Text('send'.tr),
            ),
          ],
        ),
      );
    }

    Widget tgljam() {
      return Form(
        key: formDtimeKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("chsHour".tr),
            SizedBox(height: 8.h),
            TextFormField(
              controller: btctrl.selectedtod,
              readOnly: true,
              onTap: () async {
                final TimeOfDay? timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: btctrl.tod,
                  initialEntryMode: TimePickerEntryMode.dial,
                );
                if (timeOfDay != null) {
                  btctrl.changeTod(timeOfDay);
                }
              },
              decoration: const InputDecoration(
                hintText: 'Pilih waktu',
              ),
              validator: (value) {
                log("Jam :$value");
                if (value == null || value.isEmpty || value == 'hh:ss') {
                  return 'Kolom ini wajib di isi!';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            Text("chsDt".tr),
            SizedBox(height: 8.h),
            TextFormField(
              controller: btctrl.selectedDt,
              readOnly: true,
              onTap: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: btctrl.dt,
                  firstDate: DateTime(1999),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  btctrl.changeDt(date);
                }
              },
              decoration: const InputDecoration(
                hintText: 'Pilih tanggal',
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value == 'dd/MM/yyyy') {
                  return 'Kolom ini wajib di isi!';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {
                // ✅ cek validasi dulu
                if (formDtimeKey.currentState!.validate()) {
                  // valid → baru jalanin logic
                  opendialog(4);
                }
              },
              child: Text('send'.tr),
            ),
          ],
        ),
      );
    }

    Widget waktuDelete() {
      return Form(
        key: formTDeleteKey,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: TextFormField(
                  controller: btctrl.waktuDeleteCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kolom ini wajib di isi!';
                    }
                    return null;
                  },
                )),
                SizedBox(width: 24.w),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: controller.timeOpt.first,
                      items: controller.timeOpt
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedTime.value = value ?? "";
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'plSlcOpt'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {
                // ✅ cek validasi dulu
                if (formTDeleteKey.currentState!.validate()) {
                  // valid → baru jalanin logic
                  // opendialog(4);
                }
              },
              child: Text('send'.tr),
            ),
          ],
        ),
      );
    }

    Widget defWg() {
      return Column(
        children: [
          TextField(),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {},
            child: Text('send'.tr),
          ),
        ],
      );
    }

    Widget serveruri() {
      return Form(
        key: formSAddressKey,
        child: Column(
          children: [
            TextFormField(
              controller: btctrl.alamatServerCtrl,
              decoration: const InputDecoration(
                hintText: 'Alamat Server',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kolom ini wajib di isi!';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {
                // ✅ cek validasi dulu
                if (formSAddressKey.currentState!.validate()) {
                  // valid → baru jalanin logic
                  opendialog(3);
                }
              },
              child: Text('send'.tr),
            ),
          ],
        ),
      );
    }

    Widget waktuUpload() {
      return Form(
        key: formWUploadKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: btctrl.waktuUploadCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Hanya angka 0-9
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kolom ini wajib di isi!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Text("minute".tr),
              ],
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {
                // ✅ cek validasi dulu
                if (formWUploadKey.currentState!.validate()) {
                  // valid → baru jalanin logic
                  opendialog(1);
                }
              },
              child: Text('send'.tr),
            ),
          ],
        ),
      );
    }

    Widget clientsecret() {
      return Form(
        key: formCSecretKey,
        child: Column(
          children: [
            TextFormField(
              controller: btctrl.clientIDCtrl,
              decoration: const InputDecoration(
                hintText: 'Client Secret',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kolom ini wajib di isi!';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {
                // ✅ cek validasi dulu
                if (formCSecretKey.currentState!.validate()) {
                  // valid → baru jalanin logic
                  opendialog(2);
                }
              },
              child: Text('send'.tr),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text(
            "setting".tr,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Divider(),
          SizedBox(height: 12.h),
          Text("chsOpt".tr),
          SizedBox(height: 8.h),
          Obx(
            () => DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: controller.optSetting.first.value,
              items: controller.optSetting
                  .map((option) => DropdownMenuItem(
                        value: option.value,
                        child: Text(option.value ?? ""),
                      ))
                  .toList(),
              onChanged: (value) {
                final selected = controller.optSetting
                    .firstWhereOrNull((element) => element.value == value);
                controller.selectedSettingId.value = selected?.no ?? 0;
                controller.selectedSetting.value = value ?? "";
                controller.selectedSettingId.value = selected?.no ?? 0;
              },
              validator: (value) {
                if (value == null) {
                  return 'plSlcOpt'.tr;
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => controller.selectedSettingId.value == 0
                ? wifi()
                : controller.selectedSettingId.value == 1
                    ? waktuUpload()
                    : controller.selectedSettingId.value == 2
                        ? clientsecret()
                        : controller.selectedSettingId.value == 3
                            ? serveruri()
                            : controller.selectedSettingId.value == 4
                                ? tgljam()
                                : controller.selectedSettingId.value == 5
                                    ? waktuDelete()
                                    : defWg(),
          ),
        ],
      ),
    );
  }
}

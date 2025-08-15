import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp/presentation/ui/fingerprint/controllers/bt.controller.dart';

import '../../../constant.dart';
import '../controllers/fingerprint.controller.dart';

class SettingComponents extends StatelessWidget {
  SettingComponents({super.key});
  final controller = Get.find<FingerprintController>();
  final btctrl = Get.find<BluetoothController>();

  @override
  Widget build(BuildContext context) {
    opendialog() {
      return Get.dialog(
        Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.2.sh),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Otentikasi"),
                SizedBox(height: 12.h),
                const Text("Masukkan Password!."),
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
                    controller.authDialogCtrl.clear();
                    Get.back();
                    btctrl.send(controller.authDialogArg,
                        controller.selectedSettingId.value);
                  },
                  child: const Text('Kirim'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget wifi() {
      return Column(
        children: [
          TextField(
            controller: btctrl.ssid,
            decoration: const InputDecoration(
              hintText: 'SSID',
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: btctrl.wPwd,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {
              opendialog();
            },
            child: const Text('Kirim'),
          ),
        ],
      );
    }

    Widget tgljam() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Pilih Tanggal"),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: controller.tod,
                initialEntryMode: TimePickerEntryMode.dial,
              );
              if (timeOfDay != null) {
                controller.changeTod(timeOfDay);
              }
            },
            child: Obx(
              () => Container(
                padding: EdgeInsets.all(12.w),
                child: Text(controller.selectedtod.value),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          const Text("Pilih Jam"),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () async {
              final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: controller.dt,
                  firstDate: DateTime(1999),
                  lastDate: DateTime(2100));
              if (date != null) {
                controller.changeDt(date);
              }
            },
            child: Obx(
              () => Container(
                padding: EdgeInsets.all(12.w),
                child: Text(controller.selectedDt.value),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {},
            child: const Text('Kirim'),
          ),
        ],
      );
    }

    Widget waktuDelete() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: btctrl.wdTCtrl,
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
                        return 'Please select an option';
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
            onPressed: () {},
            child: const Text('Kirim'),
          ),
        ],
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
            child: const Text('Kirim'),
          ),
        ],
      );
    }

    Widget serveruri() {
      return Column(
        children: [
          TextField(
            controller: btctrl.uriTCtrl,
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {
              opendialog();
            },
            child: const Text('Kirim'),
          ),
        ],
      );
    }

    Widget waktuUpload() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: btctrl.wUpload,
              )),
              SizedBox(width: 12.w),
              const Text("menit"),
            ],
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {
              opendialog();
            },
            child: const Text('Kirim'),
          ),
        ],
      );
    }

    Widget clientsecret() {
      return Column(
        children: [
          TextField(
            controller: btctrl.csTCtrl,
            decoration: const InputDecoration(
              hintText: 'Client Secret',
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {
              opendialog();
            },
            child: const Text('Kirim'),
          ),
        ],
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Setting"),
          Divider(),
          SizedBox(height: 12.h),
          Text("Pilih Menu"),
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
                  return 'Please select an option';
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

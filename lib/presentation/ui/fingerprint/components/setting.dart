import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/presentation/ui/common/container.ext.dart';

import '../../../constant.dart';
import '../controllers/bt14_ctrl_controller.dart';
import '../controllers/fingerprint.controller.dart';

class SettingComponents extends StatelessWidget {
  SettingComponents({super.key});
  final controller = Get.find<FingerprintController>();
  final btctrl = Get.find<Bt14CtrlController>();

  @override
  Widget build(BuildContext context) {
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
                    controller.authDialogCtrl.clear();
                    Get.back();
                    btctrl.settings(controller.authDialogArg,
                        controller.selectedSettingId.value);
                  },
                  child: Text('send'.tr),
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
            controller: btctrl.ssidNm,
            decoration: const InputDecoration(
              hintText: 'SSID',
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: btctrl.ssidPw,
            decoration: InputDecoration(
              hintText: 'password'.tr,
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {
              opendialog(0);
            },
            child: Text('send'.tr),
          ),
        ],
      );
    }

    Widget tgljam() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("chsHour".tr),
          SizedBox(height: 8.h),
          InkWell(
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
            child: Obx(
              () => Container(
                width: double.maxFinite,
                padding: context.outlinedButtonPadding,
                decoration: context.outlinedButtonBox,
                child: Text(
                  btctrl.selectedtod.value,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text("chsDt".tr),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () async {
              final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: btctrl.dt,
                  firstDate: DateTime(1999),
                  lastDate: DateTime(2100));
              if (date != null) {
                btctrl.changeDt(date);
              }
            },
            child: Obx(
              () => Container(
                width: double.maxFinite,
                padding: context.outlinedButtonPadding,
                decoration: context.outlinedButtonBox,
                child: Text(
                  btctrl.selectedDt.value,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {
              opendialog(4);
            },
            child: Text('send'.tr),
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
                controller: btctrl.waktuDeleteCtrl,
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
            onPressed: () {},
            child: Text('send'.tr),
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
            child: Text('send'.tr),
          ),
        ],
      );
    }

    Widget serveruri() {
      return Column(
        children: [
          TextField(
            controller: btctrl.alamatServerCtrl,
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 42.h),
            ),
            onPressed: () {
              opendialog(3);
            },
            child: Text('send'.tr),
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
                controller: btctrl.waktuUploadCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Hanya angka 0-9
                ],
              )),
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
              opendialog(1);
            },
            child: Text('send'.tr),
          ),
        ],
      );
    }

    Widget clientsecret() {
      return Column(
        children: [
          TextField(
            controller: btctrl.clientIDCtrl,
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
              opendialog(2);
            },
            child: Text('send'.tr),
          ),
        ],
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

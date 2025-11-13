import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp_newer/core/resources/utils.dart';
import 'package:owl_fp_newer/presentation/ui/common/dialog.dart';
import 'package:owl_fp_newer/presentation/ui/common/expandable.widget.dart';

import '../../../constant.dart';
import '../controllers/bt14_ctrl_controller.dart';
import '../controllers/fingerprint.controller.dart';

class DeviceInfoComponent extends StatelessWidget {
  DeviceInfoComponent({super.key});
  final btctrl = Get.find<Bt14CtrlController>();
  final controller = Get.find<FingerprintController>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Future<void> opendialog(int index) async {
      await controller.checkPermission(() {
        // 🔹 Panggil dialog global
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

            Get.back(); // Tutup dialog
            btctrl.authText = controller.authDialogCtrl.text;
            controller.authDialogCtrl.clear();

            if (index == 1) {
              btctrl.resetFactory();
            }
          },
        );
      });
    }

    resetLogAbsen() {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              controller.devinfResetMobile.value =
                  !controller.devinfResetMobile.value;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "resetMobileApp".tr,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Icon(LucideIcons.chevronDown),
              ],
            ),
          ),
          Obx(
            () => ExpandableWidget(
                expand: controller.devinfResetMobile.value,
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.h),
                      Icon(
                        LucideIcons.fingerprint,
                        size: 48.h,
                        // color: Colors.black.withAlpha((0.6 * 255).toInt()),
                        color: ConstColor.gTurquoise,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "resetMobileDialog".tr,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          opendialog(0);
                        },
                        child: Text('send'.tr),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      );
    }

    resetFP() {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              controller.devinfResetFp.value = !controller.devinfResetFp.value;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "resetFinger".tr,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Icon(LucideIcons.chevronDown),
              ],
            ),
          ),
          Obx(
            () => ExpandableWidget(
                expand: controller.devinfResetFp.value,
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.h),
                      Icon(
                        LucideIcons.cpu,
                        size: 48.h,
                        // color: Colors.black.withAlpha((0.6 * 255).toInt()),
                        color: ConstColor.gTurquoise,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "resetFingerDialog".tr,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          opendialog(1);
                        },
                        child: Text('send'.tr),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      );
    }

    downloadFirmware() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "downFirm".tr,
            style: theme.textTheme.labelLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          Icon(
            LucideIcons.arrowDownToLine,
            size: 12.h,
          ),
        ],
      );
    }

    /// ✅ Fungsi send template ke server
    sendTemplateToServer() {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              controller.devinfSendTmplt.value =
                  !controller.devinfSendTmplt.value;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "sendTemptoServer".tr,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const Icon(LucideIcons.chevronDown),
              ],
            ),
          ),
          Obx(
            () => ExpandableWidget(
              expand: controller.devinfSendTmplt.value,
              child: Form(
                key: controller.formKeySendTemplateKey,
                child: Column(
                  children: [
                    SizedBox(height: 4.h),
                    Icon(LucideIcons.uploadCloud,
                        size: 48.h, color: ConstColor.gTurquoise),
                    SizedBox(height: 8.h),
                    Text("sendTemptoServerDialog".tr,
                        textAlign: TextAlign.center),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            style: Theme.of(context).textTheme.labelMedium,
                            decoration: InputDecoration(
                              contentPadding: ConstPadding.ddBtnPadding,
                              border: const OutlineInputBorder(),
                            ),
                            value: controller.selectedSN.value.isEmpty
                                ? null
                                : controller.selectedSN.value,
                            items: controller.listSN
                                .map((option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(
                                        option,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              controller.selectedSN.value = value ?? "";
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'plSlcOpt'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: () {
                            final form =
                                controller.formKeySendTemplateKey.currentState;
                            if (form != null && form.validate()) {
                              // ✅ valid → lanjut
                              controller.uploadTempToServerDialog();
                            }
                          },
                          child: Text('send'.tr),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    deviceInfo() {
      return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "idMachine".tr,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "productNm".tr,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "softwareVer".tr,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "macAdr".tr,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Hardware",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Firmware",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  btctrl.deviceInfo?['sn'] ?? "-",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4.h),
                Text(
                  btctrl.deviceInfo?['name'] ?? "-",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4.h),
                Text(
                  btctrl.deviceInfo?['firmware'] ?? "-",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4.h),
                Text(
                  btctrl.deviceInfo?['mac'] ?? "-",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4.h),
                Text(
                  btctrl.deviceInfo?['hardware'] ?? "-",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4.h),
                Text(
                  btctrl.deviceInfo?['firmware'] ?? "-",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text(
            "deviceInfo".tr,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Divider(),
          SizedBox(height: 12.h),
          deviceInfo(),
          SizedBox(height: 12.h),
          downloadFirmware(),
          SizedBox(height: 12.h),
          sendTemplateToServer(),
          SizedBox(height: 12.h),
          resetFP(),
          SizedBox(height: 12.h),
          resetLogAbsen(),
        ],
      ),
    );
  }
}

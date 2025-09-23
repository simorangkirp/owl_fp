import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp_newer/presentation/ui/common/expandable.widget.dart';

import '../../../constant.dart';
import '../controllers/bt.controller.dart';
import '../controllers/fingerprint.controller.dart';

class DeviceInfoComponent extends StatelessWidget {
  DeviceInfoComponent({super.key});
  final btctrl = Get.find<BluetoothController>();
  final controller = Get.find<FingerprintController>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    opendialog(int index) {
      return Get.bottomSheet(
        Container(
          margin: EdgeInsets.symmetric(vertical: 0.1.sh, horizontal: 0.1.sw),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
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
                    if (index == 1) {
                      // btctrl.resetFactory(controller.authDialogArg);
                    }
                  },
                  child: const Text('Kirim'),
                ),
              ],
            ),
          ),
        ),
        isScrollControlled: true, // 👈 biar naik waktu keyboard muncul
      );
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
                  "Reset Aplikasi Mobile",
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
                        color: Colors.black.withOpacity(0.6),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Reset log absen akan menghapus seluruh\ndata absen di device fingerprint.",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Kirim'),
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
                  "Reset Fingerprint",
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
                        color: Colors.black.withOpacity(0.6),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Reset device akan menghapus seluruh data\ndan pengaturan device.\nAksi ini tidak dapat di batalkan.",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          opendialog(1);
                        },
                        child: Text('Kirim'),
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
            "Download Firmware",
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
                  "Kirim Template ke Server",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Icon(LucideIcons.chevronDown),
              ],
            ),
          ),
          Obx(
            () => ExpandableWidget(
              expand: controller.devinfSendTmplt.value,
              child: Column(
                children: [
                  SizedBox(height: 4.h),
                  Icon(
                    LucideIcons.uploadCloud,
                    size: 48.h,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Aksi ini akan mengirim seluruh data\ntemplate yang ada di aplikasi ke Server.",
                    textAlign: TextAlign.center,
                  ),
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
                          // value: ctrl.listSN.first,
                          value: null,
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
                            // ctrl.undselectedMenuIndex.value = ctrl.listSN.indexOf(value);
                            // log('${ctrl.listSN.indexOf(value)}');
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton(
                        onPressed: () {
                          controller.uploadTempToServerDialog();
                        },
                        child: Text('Kirim'),
                      ),
                    ],
                  ),
                ],
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
                  "ID Mesin",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Nama Produk",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Versi Software",
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Alamat MAC",
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
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Text(
          //         btctrl.deviceInfo?['sn'] ?? "-",
          //         style: theme.textTheme.labelLarge!
          //             .copyWith(fontWeight: FontWeight.w400),
          //       ),
          //       SizedBox(height: 4.h),
          //       Text(
          //         btctrl.deviceInfo?['name'] ?? "-",
          //         style: theme.textTheme.labelLarge!
          //             .copyWith(fontWeight: FontWeight.w400),
          //       ),
          //       SizedBox(height: 4.h),
          //       Text(
          //         btctrl.deviceInfo?['firmware'] ?? "-",
          //         style: theme.textTheme.labelLarge!
          //             .copyWith(fontWeight: FontWeight.w400),
          //       ),
          //       SizedBox(height: 4.h),
          //       Text(
          //         btctrl.deviceInfo?['mac'] ?? "-",
          //         style: theme.textTheme.labelLarge!
          //             .copyWith(fontWeight: FontWeight.w400),
          //       ),
          //       SizedBox(height: 4.h),
          //       Text(
          //         btctrl.deviceInfo?['hardware'] ?? "-",
          //         style: theme.textTheme.labelLarge!
          //             .copyWith(fontWeight: FontWeight.w400),
          //       ),
          //       SizedBox(height: 4.h),
          //       Text(
          //         btctrl.deviceInfo?['firmware'] ?? "-",
          //         style: theme.textTheme.labelLarge!
          //             .copyWith(fontWeight: FontWeight.w400),
          //       ),
          //       SizedBox(height: 4.h),
          //     ],
          //   ),
          // ),
        ],
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Informasi Perangkat"),
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

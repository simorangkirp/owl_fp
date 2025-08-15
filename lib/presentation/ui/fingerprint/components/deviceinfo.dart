import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp/data/dal/services/get.storage.dart';
import 'package:owl_fp/presentation/ui/common/expandable.widget.dart';

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
    var box = StorageService();

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
                        child: TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: controller.typeAheadController,
                            decoration: InputDecoration(
                              labelStyle: theme.textTheme.labelLarge,
                              labelText: 'Cari karyawan',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return controller.karyawanlist.where((item) {
                              var name = item.namakaryawan ?? "Undefined";
                              return name
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase());
                            });
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                                title: Text(suggestion.namakaryawan ?? ""));
                          },
                          onSuggestionSelected: (suggestion) {
                            btctrl.selectedRegisterNm =
                                suggestion.namakaryawan ?? "";
                            btctrl.selectedRegisterNIK = suggestion.nik ?? "";
                            controller.typeAheadController.text =
                                suggestion.namakaryawan ?? "";
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton(
                        onPressed: () {},
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

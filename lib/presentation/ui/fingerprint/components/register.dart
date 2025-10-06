import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../constant.dart';
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
    Color borderColor = Colors.blue; // fallback

    if (indicator is UnderlineTabIndicator) {
      borderColor = indicator.borderSide.color;
    }

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
                Text("auth".tr),
                SizedBox(height: 12.h),
                Text("inputPassword".tr),
                SizedBox(height: 8.h),
                TextField(
                  controller: btctrl.authCtrl,
                  onChanged: (value) {
                    btctrl.authText = value;
                  },
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 42.h),
                  ),
                  onPressed: () async {
                    Get.back();
                    await btctrl.regdelFinger(index);
                  },
                  child: Text('send'.tr),
                ),
              ],
            ),
          ),
        ),
        isScrollControlled: true, // 👈 biar naik waktu keyboard muncul
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text(
            "rndFinger".tr,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Divider(),
          SizedBox(height: 12.h),
          // Text("Pilih Karyawan:"),
          TypeAheadField(
            // builder untuk bikin TextField
            builder: (context, textController, focusNode) {
              return TextField(
                controller:
                    controller.typeAheadController, // pakai controller kamu
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelStyle: theme.labelLarge,
                  labelText: 'findEmply'.tr,
                  border: const OutlineInputBorder(),
                ),
              );
            },
            // ambil data suggestion
            suggestionsCallback: (pattern) async {
              return controller.karyawanlist.where((item) {
                var name = item.namakaryawan ?? "Undefined";
                return name.toLowerCase().contains(pattern.toLowerCase());
              }).toList();
            },
            // render suggestion item
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.namakaryawan ?? ""),
              );
            },
            // ketika suggestion dipilih
            onSelected: (suggestion) {
              btctrl.selectedRegisterNm = suggestion.namakaryawan ?? "";
              btctrl.selectedRegisterNIK = suggestion.nik ?? "";
              controller.typeAheadController.text =
                  suggestion.namakaryawan ?? "";
            },
          ),
          Visibility(
              visible: controller.typeAheadController.text.isNotEmpty,
              child: SizedBox(height: 8.h)),
          Visibility(
              visible: controller.typeAheadController.text.isNotEmpty,
              child: Text("Pattern")),
          Visibility(
              visible: controller.typeAheadController.text.isNotEmpty,
              child: SizedBox(height: 8.h)),
          Visibility(
            visible: controller.typeAheadController.text.isNotEmpty,
            child: Container(
              width: double.maxFinite,
              height: 0.3.sh,
              color: Colors.grey[200],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  opendialog(0);
                },
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.userPlus2,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      VerticalDivider(
                        color: Colors.white,
                        thickness: 1.w,
                      ),
                      // SizedBox(width: 8.w),
                      Text('register'.tr),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () {
                  opendialog(1);
                },
                style: ElevatedButton.styleFrom(backgroundColor: borderColor),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.trash2,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      VerticalDivider(
                        color: Colors.white,
                        thickness: 1.w,
                      ),
                      // SizedBox(width: 8.w),
                      Text('delete'.tr),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 12.h),
          // deleteByNikWidget(),
        ],
      ),
    );
  }
}

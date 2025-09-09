import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../controllers/bt.controller.dart';
import '../controllers/fingerprint.controller.dart';

class AdminComponent extends StatelessWidget {
  AdminComponent({super.key});
  final controller = Get.find<FingerprintController>();
  final btctrl = Get.find<BluetoothController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    var strCtrl = TextEditingController();
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
                    Get.back();
                    controller.tambahAdmin();
                    // btctrl.devSend(controller.authDialogArg);
                  },
                  child: const Text('Kirim'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Tambah Admin"),
          Divider(),
          SizedBox(height: 12.h),
          // Text("Pilih Menu"),
          // SizedBox(height: 8.h),
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller.typeAheadController,
              decoration: InputDecoration(
                labelStyle: theme.labelLarge,
                labelText: 'Cari karyawan',
                border: OutlineInputBorder(),
              ),
            ),
            suggestionsCallback: (pattern) {
              return controller.karyawanlist.where((item) {
                var name = item.namakaryawan ?? "Undefined";
                return name.toLowerCase().contains(pattern.toLowerCase());
              });
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
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              opendialog();
            },
            child: Text('Kirim'),
          ),
        ],
      ),
    );
  }
}

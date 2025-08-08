import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../controllers/bt.controller.dart';
import '../controllers/fingerprint.controller.dart';

class RegisterComponent extends StatelessWidget {
  RegisterComponent({super.key});
  final btctrl = Get.find<BluetoothController>();
  final controller = Get.find<FingerprintController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    opendialog() {
      return Get.dialog(
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Dialog(
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
                      btctrl.authCtrl.clear();
                      Get.back();
                    },
                    child: const Text('Kirim'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Registrasi Fingerprint"),
          Divider(),
          SizedBox(height: 12.h),
          // Text("Pilih Karyawan:"),
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
          ElevatedButton(
            onPressed: () {
              opendialog().then((value) async {
                btctrl.waitRegist();
                await btctrl.sendRegist();
              });
            },
            child: Text('Kirim'),
          ),
        ],
      ),
    );
  }
}

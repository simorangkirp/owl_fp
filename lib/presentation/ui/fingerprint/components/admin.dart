import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
    var optCtrl = ScrollController();
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
                    index == 1
                        ? controller.tambahAdmin(controller.authDialogArg)
                        : controller.gantiPIN();
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
          const Text("Tambah Admin"),
          const Divider(),
          SizedBox(height: 12.h),
          // Text("Pilih Menu"),
          // SizedBox(height: 8.h),
          TypeAheadField(
            // builder untuk bikin TextField
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelStyle: theme.labelLarge,
                  labelText: 'Cari karyawan',
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
              btctrl.selectedRegisterNIK = suggestion.karyawanid ?? "";
              controller.typeAheadController.text =
                  suggestion.namakaryawan ?? "";
            },
          ),
          SizedBox(height: 12.h),
          const Text("Tambah Hak Akses"),
          const Divider(),
          ListView.builder(
            controller: optCtrl,
            shrinkWrap: true,
            itemCount: controller.listAdminOpt.length,
            itemBuilder: (context, index) {
              var data = controller.listAdminOpt[index];
              return Row(
                children: [
                  Text(data.value ?? "Undifined"),
                  Obx(
                    () => Checkbox(
                      value: data.selected.value, // selalu pakai .value
                      onChanged: (val) {
                        data.selected.value = val ?? false;
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              opendialog(1);
            },
            child: const Text('Kirim'),
          ),
          SizedBox(height: 12.h),
          const Text("Ganti PIN"),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    controller.pinArg = value;
                  },
                  controller: controller.pinCtrl,
                  // controller: controller.urlCtrl,
                  decoration: const InputDecoration(
                      hintText: '******',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                      )),
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.pinCtrl.clear();
                  // controller.saveUrl();
                  opendialog(2);
                },
                icon: Icon(
                  LucideIcons.save,
                  color: ConstColor.gBlueGray,
                  size: 20.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.1.sh),
        ],
      ),
    );
  }
}

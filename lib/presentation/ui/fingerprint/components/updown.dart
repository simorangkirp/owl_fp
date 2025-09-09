import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../controllers/bt.controller.dart';
import '../controllers/fingerprint.controller.dart';

class UpdownComponent extends StatelessWidget {
  UpdownComponent({super.key});
  final btCtrl = Get.find<BluetoothController>();
  final ctrl = Get.find<FingerprintController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

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
                const Text("Otentikasi Upload"),
                SizedBox(height: 12.h),
                const Text("Masukkan Password!."),
                SizedBox(height: 8.h),
                TextField(
                  controller: ctrl.authDialogCtrl,
                  onChanged: (value) {
                    ctrl.authDialogArg = value;
                  },
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 42.h),
                  ),
                  onPressed: () {
                    ctrl.authDialogCtrl.clear();
                    Get.back();
                    ctrl.uploadDownloadOptSend(index);
                    // ctrl.insertTemplateLocal(ctrl.authDialogArg);
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
          const Text("Unduh & Kirim Template"),
          const Divider(),
          SizedBox(height: 12.h),
          const Text("Pilih Menu:"),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            style: Theme.of(context).textTheme.labelMedium,
            decoration: InputDecoration(
              contentPadding: ConstPadding.ddBtnPadding,
              border: const OutlineInputBorder(),
            ),
            value: ctrl.uploadDownloadList.first,
            items: ctrl.uploadDownloadList
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(
                        option,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              ctrl.selectedUpDown1.value = value ?? "";
              ctrl.undselectedMenuIndex.value =
                  ctrl.uploadDownloadList.indexOf(value);
              log('${ctrl.uploadDownloadList.indexOf(value)}');
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Obx(
            () => Visibility(
              visible: ctrl.undselectedMenuIndex.value == 1,
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: ctrl.typeAheadController,
                  decoration: InputDecoration(
                    labelStyle: theme.labelLarge,
                    labelText: 'Cari karyawan',
                    border: const OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return ctrl.karyawanlist.where((item) {
                    var name = item.namakaryawan ?? "Undefined";
                    return name.toLowerCase().contains(pattern.toLowerCase());
                  });
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion.namakaryawan ?? ""));
                },
                onSuggestionSelected: (suggestion) {
                  btCtrl.selectedRegisterNm = suggestion.namakaryawan ?? "";
                  btCtrl.selectedRegisterNIK = suggestion.nik ?? "";
                  ctrl.typeAheadController.text = suggestion.namakaryawan ?? "";
                },
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: ctrl.undselectedMenuIndex.value == 2,
              child: DropdownButtonFormField<String>(
                style: Theme.of(context).textTheme.labelMedium,
                decoration: InputDecoration(
                  contentPadding: ConstPadding.ddBtnPadding,
                  border: const OutlineInputBorder(),
                ),
                // value: ctrl.listSN.first,
                value: null,
                items: ctrl.listSN
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(
                            option,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  ctrl.selectedSN.value = value ?? "";
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
              // FutureBuilder(
              //   future: ctrl.getSNList(),
              //   builder: (context, snapshot) {
              //     return DropdownButtonFormField<String>(
              //       decoration: const InputDecoration(
              //         border: OutlineInputBorder(),
              //       ),
              //       value: null,
              //       items: ctrl.listSN
              //           .map((option) => DropdownMenuItem(
              //                 value: option,
              //                 child: Text(option),
              //               ))
              //           .toList(),
              //       onChanged: (value) {
              //         ctrl.selectedSN.value = value ?? "";
              //       },
              //       validator: (value) {
              //         if (value == null) {
              //           return 'Please select an option';
              //         }
              //         return null;
              //       },
              //     );
              //   },
              // ),
            ),
          ),
          // Obx(
          //   () => Visibility(
          //     visible: ctrl.undselectedMenuIndex.value == 2,
          //     child: DropdownButtonFormField<String>(
          //       style: Theme.of(context).textTheme.labelMedium,
          //       decoration: InputDecoration(
          //         contentPadding: ConstPadding.ddBtnPadding,
          //         border: const OutlineInputBorder(),
          //       ),
          //       value: ctrl.uploadDownloadList.first,
          //       items: ctrl.uploadDownloadList
          //           .map((option) => DropdownMenuItem(
          //                 value: option,
          //                 child: Text(
          //                   option,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ))
          //           .toList(),
          //       onChanged: (value) {
          //         ctrl.selectedUpDown1.value = value ?? "";
          //         ctrl.undselectedMenuIndex.value =
          //             ctrl.uploadDownloadList.indexOf(value);
          //       },
          //       validator: (value) {
          //         if (value == null) {
          //           return 'Please select an option';
          //         }
          //         return null;
          //       },
          //     ),
          //   ),
          // ),
          Obx(
            () => Visibility(
                visible: ctrl.undselectedMenuIndex.value != 0,
                child: SizedBox(
                  height: 24.h,
                )),
          ),
          ElevatedButton(
            onPressed: () {
              opendialog(ctrl.undselectedMenuIndex.value);
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }
}

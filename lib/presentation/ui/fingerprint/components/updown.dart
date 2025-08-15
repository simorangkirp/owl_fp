import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Unduh & Kirim Template"),
          Divider(),
          SizedBox(height: 12.h),
          Text("Pilih Menu:"),
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
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {},
            child: Text('Kirim'),
          ),
        ],
      ),
    );
  }
}

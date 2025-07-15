import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../controllers/fingerprint.controller.dart';

class SettingComponents extends StatelessWidget {
  SettingComponents({super.key});
  final controller = Get.find<FingerprintController>();

  @override
  Widget build(BuildContext context) {
    Widget defaultWg() {
      return Column(
        children: [
          Text("Pilih Tanggal"),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: controller.tod,
                initialEntryMode: TimePickerEntryMode.dial,
              );
              if (timeOfDay != null) {
                controller.changeTod(timeOfDay);
              }
            },
            child: Obx(
              () => Container(
                padding: EdgeInsets.all(12.w),
                child: Text(controller.selectedtod.value),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text("Pilih Jam"),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () async {
              final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: controller.dt,
                  firstDate: DateTime(1999),
                  lastDate: DateTime(2100));
              if (date != null) {
                controller.changeDt(date);
              }
            },
            child: Obx(
              () => Container(
                padding: EdgeInsets.all(12.w),
                child: Text(controller.selectedDt.value),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {},
            child: Text('Kirim'),
          ),
        ],
      );
    }

    Widget waktuDelete() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField()),
              SizedBox(width: 24.w),
              Expanded(
                child: DropdownButtonFormField<String>(
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
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () {},
            child: Text('Kirim'),
          ),
        ],
      );
    }

    Widget defWg() {
      return Column(
        children: [
          TextField(),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () {},
            child: Text('Kirim'),
          ),
        ],
      );
    }

    void timePicker() {
      // return null;
    }

    Widget waktuUpload() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField()),
              SizedBox(width: 12.w),
              Text("menit"),
            ],
          ),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () {},
            child: Text('Kirim'),
          ),
        ],
      );
    }

    Widget setupWifi() {
      return Column(
        children: [
          TextField(),
          SizedBox(height: 8.h),
          TextField(),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () {},
            child: Text('Kirim'),
          ),
        ],
      );
    }

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Setting"),
          Divider(),
          SizedBox(height: 12.h),
          Text("Pilih Menu"),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: controller.optSetting.first.nm,
            items: controller.optSetting
                .map((option) => DropdownMenuItem(
                      value: option.nm,
                      child: Text(option.nm),
                    ))
                .toList(),
            onChanged: (value) {
              controller.selectedSetting.value = value ?? "";
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          controller.selectedSettingId.value == 0
              ? defaultWg()
              : controller.selectedSettingId.value == 1
                  ? waktuUpload()
                  : controller.selectedSettingId.value == 6
                      ? waktuDelete()
                      : defWg(),
        ],
      ),
    );
  }
}

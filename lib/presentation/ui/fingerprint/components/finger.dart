import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../constant.dart';
import '../controllers/bt.controller.dart';
import '../controllers/fingerprint.controller.dart';

class FingerComponents extends StatelessWidget {
  FingerComponents({super.key});
  final controller = Get.find<BluetoothController>();
  final controller2 = Get.find<FingerprintController>();

  @override
  Widget build(BuildContext context) {
    var discoverdCtrl = ScrollController();
    var uiCtrl = ScrollController();
    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        controller: uiCtrl,
        children: [
          Text(
            "Connection Bluetooth",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Divider(),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                  child: FutureBuilder(
                future: controller2.getDropdownOptionList(),
                builder: (context, snapshot) {
                  return controller2.opt1.isEmpty
                      ? const SizedBox()
                      : DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: ConstPadding.ddBtnPadding,
                            border: const OutlineInputBorder(),
                          ),
                          value: controller2.opt1.first,
                          items: controller2.opt1
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            controller2.selectedOpt1.value = value ?? "";
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        );
                },
              )),
              SizedBox(width: 24.w),
              Obx(
                () => Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: ConstPadding.eleBtnPadding,
                    ),
                    onPressed: controller.isDiscovering.value
                        ? null
                        : controller.btStats,
                    child: Text(controller.isDiscovering.value
                        ? 'Scanning...'
                        : 'Start Scan'),
                  ),
                ),
              ),
            ],
          ),
          Obx(() => ListView(
                controller: discoverdCtrl,
                shrinkWrap: true,
                children: controller.discoveredDevices.map((result) {
                  final device = result.device;
                  return ListTile(
                    title: Text(device.name ?? "Unknown Device"),
                    subtitle: Text(device.address),
                    trailing: ElevatedButton(
                      child: Obx(() {
                        final isConnected =
                            controller.connectionStates[device.address] ??
                                false;
                        return Text(isConnected ? "Disconnect" : "Connect");
                      }),
                      onPressed: () {
                        controller.connectDialog();
                        controller.connectToDevice(device);
                      },
                    ),
                  );
                }).toList(),
              ))
        ],
      ),
    );
  }
}

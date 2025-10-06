import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../controllers/bt14_ctrl_controller.dart';
import '../controllers/fingerprint.controller.dart';

class FingerComponents extends StatelessWidget {
  FingerComponents({super.key});
  final controller = Get.find<Bt14CtrlController>();
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
            "btConnection".tr,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          const Divider(),
          SizedBox(height: 12.h),

          /// 🔹 Dropdown + Scan button
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
                                return 'plSlcOpt'.tr;
                              }
                              return null;
                            },
                          );
                  },
                ),
              ),
              SizedBox(width: 24.w),
              Obx(
                () => Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: ConstPadding.eleBtnPadding,
                    ),
                    onPressed: controller.isDiscovering.value
                        ? null
                        : controller.scanDevices,
                    child: Text(controller.isDiscovering.value
                        ? 'scanning'.tr
                        : 'stScan'.tr),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          /// 🔹 Daftar device ditemukan
          Obx(
            () => ListView.builder(
              controller: discoverdCtrl,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.devices.length,
              itemBuilder: (context, index) {
                final device = controller.devices[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.bluetooth),
                    title: Text(device.name == "" ? "Undifined" : device.name),
                    subtitle: Text(device.address),
                    trailing: Obx(() {
                      final isConnected = controller.isConnected.value &&
                          controller.selectedDevice?.address == device.address;
                      final connecting = controller.isConnecting.value;
                      return ElevatedButton(
                        onPressed: connecting
                            ? null // tombol disable sementara connect/disconnect berjalan
                            : () async {
                                controller.isConnecting.value = true;
                                if (isConnected) {
                                  // Panggil static disconnect
                                  await controller.disconnectDevice();
                                  controller.isConnected.value = false;
                                  controller.selectedDevice = null;
                                } else {
                                  controller.selectedDevice = device;
                                  await controller.connectDialog();
                                }
                                // Delay kecil sebelum tombol bisa ditekan lagi
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                controller.isConnecting.value = false;
                              },
                        child: Text(isConnected ? "Disconnect" : "Connect"),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

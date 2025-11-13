import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/domain/entity/bt.entity.dart';

import '../../../constant.dart';
import '../controllers/bt14_ctrl_controller.dart';
import '../controllers/fingerprint.controller.dart';

class FingerComponents extends StatelessWidget {
  const FingerComponents({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Bt14CtrlController>();
    final controller2 = Get.find<FingerprintController>();
    // var discoverdCtrl = ScrollController();
    // var uiCtrl = ScrollController();

    return Padding(
      padding: ConstPadding.screenPadding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller2.opt1.isEmpty) {
                      controller2.getDropdownOptionList();
                      return const Center(child: CircularProgressIndicator());
                    }

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: ConstPadding.ddBtnPadding,
                        border: const OutlineInputBorder(),
                      ),
                      value: controller2.selectedOpt1.value.isEmpty
                          ? controller2.opt1.first
                          : controller2.selectedOpt1.value,
                      items: controller2.opt1
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: controller.isDiscovering.value
                          ? null // ⛔ nonaktif saat scanning
                          : (value) {
                              controller2.selectedOpt1.value = value ?? "";
                              final idx = controller2.opt1.indexOf(value ?? "");

                              switch (idx) {
                                case 0: // 🔵 Bonded devices (termasuk OWL yang bonded, tanpa duplikat)
                                  final merged = [
                                    ...controller.bondedDevices,
                                    ...controller.owlDevices.where(
                                      (owl) => controller.bondedDevices.every(
                                        (b) => b.address != owl.address,
                                      ),
                                    ),
                                  ];

                                  controller.devices.assignAll(
                                    merged.map(
                                      (d) => BluetoothDeviceEntity(
                                        name: d.name,
                                        address: d.address,
                                        bonded: true,
                                      ),
                                    ),
                                  );
                                  break;

                                case 1: // 🟡 Unbonded devices
                                  controller.devices.assignAll(
                                    controller.unBondedDevices.map(
                                      (d) => BluetoothDeviceEntity(
                                        name: d.name,
                                        address: d.address,
                                        bonded: false,
                                      ),
                                    ),
                                  );
                                  break;

                                case 2: // 🟢 OWL devices (baik bonded/unbonded)
                                  controller.devices.assignAll(
                                    controller.owlDevices.map((d) {
                                      final isBonded = controller.bondedDevices
                                          .any((b) => b.address == d.address);
                                      return BluetoothDeviceEntity(
                                        name: d.name,
                                        address: d.address,
                                        bonded: isBonded,
                                      );
                                    }),
                                  );
                                  break;

                                default:
                                  controller.devices.clear();
                              }
                            },
                    );
                  }),
                ),
                SizedBox(width: 24.w),
                Obx(() => Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: ConstPadding.eleBtnPadding,
                        ),
                        onPressed: controller.isDiscovering.value
                            ? null
                            : controller.startDiscoverSequence,
                        child: Text(controller.isDiscovering.value
                            ? 'scanning'.tr
                            : 'stScan'.tr),
                      ),
                    )),
              ],
            ),
            SizedBox(height: 20.h),
            Obx(() {
              // Pilih daftar device berdasarkan dropdown
              List<BluetoothDeviceEntity> displayedDevices;

              final idx =
                  controller2.opt1.indexOf(controller2.selectedOpt1.value);

              switch (idx) {
                case 0:
                  displayedDevices = controller.bondedDevices;
                  break;
                case 1:
                  displayedDevices = controller.unBondedDevices;
                  break;
                case 2:
                  displayedDevices = controller.owlDevices;
                  break;
                default:
                  displayedDevices = controller.devices;
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedDevices.length,
                itemBuilder: (context, index) {
                  final device = displayedDevices[index];

                  final isConnected = controller.isConnected.value &&
                      controller.selectedDevice.value?.address ==
                          device.address;
                  final connecting = controller.isConnecting.value;

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.bluetooth, size: 16.r),
                          SizedBox(width: 18.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name.isEmpty
                                      ? "Undefined"
                                      : device.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  device.address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          ElevatedButton(
                            onPressed: connecting ||
                                    controller.isDiscovering.value
                                ? null
                                : () async {
                                    controller.isConnecting.value = true;
                                    if (isConnected) {
                                      await controller.disconnectDevice();
                                      controller.isConnected.value = false;
                                      controller.selectedDevice.value = null;
                                    } else {
                                      controller.selectedDevice.value = device;
                                      await controller.connectDialog();
                                    }
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));
                                    controller.isConnecting.value = false;
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 8.h),
                              minimumSize: Size(90.w, 36.h),
                            ),
                            child: Text(
                              isConnected ? "Disconnect" : "Connect",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }
}

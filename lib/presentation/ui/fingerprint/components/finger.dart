import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
                          ? ""
                          : controller2.selectedOpt1.value,
                      items: [
                        const DropdownMenuItem(
                          value: "",
                          child: Text(""),
                        ),
                        ...controller2.opt1.map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        ),
                      ],
                      onChanged: controller.isDiscovering.value
                          ? null
                          : (value) {
                              controller2.selectedOpt1.value = value ?? "";
                              controller.getDisplayDevices();
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
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.displayedDevices.length,
                itemBuilder: (context, index) {
                  final device = controller.displayedDevices[index];

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

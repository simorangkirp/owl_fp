import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:owl_fp_newer/presentation/constant.dart';

import 'controllers/about.controller.dart';

class AboutScreen extends StatelessWidget {
  final controller = Get.find<AboutController>();
  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appbarAboutApp'.tr),
      ),
      body: Padding(
        padding: ConstPadding.screenPadding,
        child: Column(
          children: [
            SizedBox(height: 32.h),
            Image.asset(
              "assets/image/owl.logo.png",
              height: 72.h,
            ),
            SizedBox(height: 32.h),
            const Text("OWL Plantation System"),
            Obx(() => Text(
                  "App Version: ${controller.version}",
                )),
            Obx(() => Text(
                  "Build Number: ${controller.buildNumber}",
                )),
            SizedBox(height: 32.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {
                controller.getAppVer();
              },
              child: Text('ltsVer'.tr),
            ),
            const Spacer(),
            const Text(
              "Copyright 2025 OWL Plantation System\nAll rights reserved",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:owl_fp/presentation/constant.dart';

import 'controllers/about.controller.dart';

class AboutScreen extends GetView<AboutController> {
  const AboutScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
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
            Text("OWL Plantation System"),
            Text("Versi 1.0.0"),
            Text("Build 2"),
            SizedBox(height: 32.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {},
              child: const Text('Cek Versi Terbaru'),
            ),
            Spacer(),
            Text(
              "Copyright 2025 OWL Plantation System\nAll rights reserved",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

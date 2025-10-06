import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp_newer/presentation/constant.dart';
import 'package:owl_fp_newer/presentation/ui/common/expandable.widget.dart';

import 'controllers/change_user.controller.dart';

class ChangeUserScreen extends GetView<ChangeUserController> {
  const ChangeUserScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appbarChgUser'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: ConstPadding.screenPadding,
        child: ListView(
          children: [
            Text("username".tr),
            SizedBox(height: 8.h),
            TextFormField(
              onChanged: (value) {
                if (controller.pwCtrl.text.isNotEmpty &&
                    controller.unCtrl.text.isNotEmpty) {
                  controller.enaBtn.value = true;
                }
              },
              controller: controller.unCtrl,
              decoration: const InputDecoration(
                hintText: 'owl.admin',
              ),
            ),
            SizedBox(height: 12.h),
            Text("password".tr),
            SizedBox(height: 8.h),
            Obx(
              () => TextFormField(
                onChanged: (value) {
                  if (controller.pwCtrl.text.isNotEmpty &&
                      controller.unCtrl.text.isNotEmpty) {
                    controller.enaBtn.value = true;
                  }
                },
                controller: controller.pwCtrl,
                obscureText: controller.isObs.value,
                decoration: InputDecoration(
                    hintText: '******',
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.isObs.value = !controller.isObs.value;
                        },
                        icon: Icon(controller.isObs.value
                            ? LucideIcons.eye
                            : LucideIcons.eyeOff))),
              ),
            ),
            SizedBox(height: 12.h),
            Obx(
              () => ExpandableWidget(
                expand: controller.isShown.value,
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: controller.urlCtrl,
                      decoration: const InputDecoration(
                          hintText: 'http://',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          )),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                controller.isShown.value = !controller.isShown.value;
              },
              child: const Text(
                "IP Server",
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 24.h),
            Obx(
              () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: !controller.enaBtn.value
                          ? ConstColor.dCharcoal
                          : null,
                      backgroundColor: !controller.enaBtn.value
                          ? ConstColor.dPlatinum
                          : null,
                      fixedSize: Size(double.maxFinite, 42.h)),
                  onPressed: () {
                    if (controller.enaBtn.value) {
                      controller.onChangeUser();
                      // await controller.onLogin().then((value) async {
                      //   await controller.getProfileApi();
                      // });
                    }
                  },
                  child: Text(
                    "signIn".tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ConstColor.gCultured,
                        ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

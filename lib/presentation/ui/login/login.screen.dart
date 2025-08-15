import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../constant.dart';
import 'controllers/login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('LoginScreen'),
        //   centerTitle: true,
        // ),
        body: SafeArea(
      child: Padding(
        padding: ConstPadding.screenPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: controller.isShown.value ? 0.1.sh : 0.12.sh),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 80.w,
                  height: 80.w,
                  child: GestureDetector(
                    onTap: controller.displayUrl,
                    child: Image.asset(
                      ConstPath.owlIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'OWL Fingerprint',
                  style: theme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: ConstColor.lBerBlue,
                  ),
                ),
              ),
              SizedBox(height: 0.06.sh),
              Text(
                'Nama Pengguna',
                style: theme.labelMedium,
              ),
              SizedBox(height: 4.h),
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
              SizedBox(height: 16.h),
              Text(
                'Sandi',
                style: theme.labelMedium,
              ),
              SizedBox(height: 4.h),
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
              Obx(
                () => Visibility(
                    visible: controller.isShown.value,
                    child: SizedBox(height: 16.h)),
              ),
              Obx(() => AnimatedOpacity(
                  opacity: controller.isShown.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: !controller.isShown.value,
                    child: Visibility(
                      visible: controller.isShown.value,
                      child: Text(
                        'Alamat Server',
                        style: theme.labelMedium,
                      ),
                    ),
                  ))),
              Obx(
                () => Visibility(
                    visible: controller.isShown.value,
                    child: SizedBox(height: 4.h)),
              ),
              Obx(
                () => AnimatedOpacity(
                  opacity: controller.isShown.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: !controller.isShown.value,
                    child: Visibility(
                      visible: controller.isShown.value,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: controller.urlCtrl,
                                decoration: const InputDecoration(
                                    hintText: 'http://',
                                    hintStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    )),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            IconButton(
                              onPressed: () {
                                controller.saveUrl();
                              },
                              icon: Icon(
                                LucideIcons.check,
                                color: ConstColor.gGreen,
                                size: 20.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
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
                    onPressed: () async {
                      if (controller.enaBtn.value) {
                        controller.loginDialog();
                        await controller.onLogin().then((value) async {
                          await controller.getProfileApi();
                        });
                      }
                    },
                    child: Text(
                      "Masuk",
                      style: theme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ConstColor.gCultured,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

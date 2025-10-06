import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp_newer/presentation/constant.dart';

import '../common/expandable.widget.dart';
import 'controllers/profile.controller.dart';
import 'controllers/setting.controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final controller = Get.find<ProfileController>();
  final settingCtrl = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    profileInfo() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${"username".tr}:", style: theme.labelMedium),
          SizedBox(height: 4.h),
          Text(
            controller.users.value?.name ?? "-",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Divider(
            thickness: 2.w,
          ),
          SizedBox(height: 8.h),
          Text(
            "${"location".tr}:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 4.h),
          Text(
            controller.users.value?.lokasitugas ?? "-",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Divider(
            thickness: 2.w,
          ),
          SizedBox(height: 8.h),
          Text(
            "${"username".tr}:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 4.h),
          Text(
            controller.users.value?.bagian ?? "-",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Divider(
            thickness: 2.w,
          ),
          SizedBox(height: 8.h),
          Text(
            "${"unitnsub".tr}:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 4.h),
          Text(
            controller.users.value?.jabatan ?? "-",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Divider(
            thickness: 2.w,
          ),
          SizedBox(height: 8.h),
          Text(
            "IP Server:",
            style: theme.labelMedium,
          ),
          SizedBox(height: 4.h),
          Obx(
            () => Text(
              controller.ip.value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Divider(
            thickness: 2.w,
          ),
        ],
      );
    }

    profileWidget() {
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            height: 64.w,
            width: 64.w,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.users.value?.name ?? "-",
                style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4.h),
              InkWell(
                onTap: () {
                  Get.toNamed('/change-user');
                },
                child: Text("chOthrUser".tr,
                    style: theme.labelMedium
                        ?.copyWith(color: ConstColor.gPacificBlue)),
              ),
            ],
          ),
        ],
      );
    }

    settingWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "setting".tr,
            style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              controller.confirmDialog();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "masterdataSync".tr,
                  style: theme.labelLarge,
                ),
                Icon(Icons.chevron_right_rounded)
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Divider(
            thickness: 2.w,
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              // Get.toNamed('/language');
              controller.openLang.value = !controller.openLang.value;
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "language".tr,
                  style: theme.labelLarge,
                ),
                Obx(
                  () => Icon(
                      controller.openLang.value
                          ? LucideIcons.chevronUp
                          : LucideIcons.chevronDown,
                      size: 18.h),
                ),
              ],
            ),
          ),
          Obx(
            () => ExpandableWidget(
                expand: controller.openLang.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    Text("${"selectLang".tr}:"),
                    SizedBox(height: 4.h),
                    DropdownButtonFormField<Locale>(
                      value: settingCtrl.currentLang.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: settingCtrl.languages
                          .map(
                            (locale) => DropdownMenuItem(
                              value: locale,
                              child: Text(settingCtrl.getLangName(locale)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          settingCtrl.changeLang(value.languageCode);
                        }
                      },
                    ),
                  ],
                )),
          ),
          SizedBox(height: 4.h),
          Divider(
            thickness: 2.w,
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              // Get.toNamed('/theme');
              controller.openTheme.value = !controller.openTheme.value;
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "theme".tr,
                  style: theme.labelLarge,
                ),
                Obx(
                  () => Icon(
                      controller.openTheme.value
                          ? LucideIcons.chevronUp
                          : LucideIcons.chevronDown,
                      size: 18.h),
                ),
              ],
            ),
          ),
          Obx(
            () => ExpandableWidget(
                expand: controller.openTheme.value,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Text("darkmode".tr),
                        Spacer(),
                        Obx(
                          () => Switch(
                            value: settingCtrl.isDark.value,
                            onChanged: (value) => settingCtrl.toggleTheme(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          SizedBox(height: 4.h),
          Divider(
            thickness: 2.w,
          ),
        ],
      );
    }

    othersWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "others".tr,
            style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              Get.toNamed('/about');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "aboutApp".tr,
                  style: theme.labelLarge,
                ),
                Icon(Icons.chevron_right_rounded)
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Divider(
            thickness: 2.w,
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              Get.toNamed('/help');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "help".tr,
                  style: theme.labelLarge,
                ),
                Icon(Icons.chevron_right_rounded)
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Divider(
            thickness: 2.w,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('appbarProfile'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: ConstPadding.screenPadding,
        child: ListView(
          children: [
            profileWidget(),
            SizedBox(height: 12.h),
            profileInfo(),
            SizedBox(height: 16.h),
            settingWidget(),
            SizedBox(height: 16.h),
            othersWidget(),
            SizedBox(height: 16.h),
            OutlinedButton(
              onPressed: () {
                controller.logOut();
              },
              child: Text(
                "signOut".tr,
                style: theme.titleLarge,
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:owl_fp/presentation/constant.dart';

import 'controllers/profile.controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ProfileScreen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: ConstPadding.screenPadding,
        child: ListView(
          children: [
            Row(
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
                      "Nama Pengguna",
                      style: theme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4.h),
                    Text("Ubah pengguna lain",
                        style: theme.labelMedium
                            ?.copyWith(color: ConstColor.gBlueGray)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text("Nama Pengguna:", style: theme.labelMedium),
            SizedBox(height: 4.h),
            Text(
              "Nama Pengguna",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Divider(
              thickness: 2.w,
            ),
            SizedBox(height: 8.h),
            Text(
              "Lokasi:",
              style: theme.labelMedium,
            ),
            SizedBox(height: 4.h),
            Text(
              "Nama Pengguna",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Divider(
              thickness: 2.w,
            ),
            SizedBox(height: 8.h),
            Text(
              "Unit & Bagian:",
              style: theme.labelMedium,
            ),
            SizedBox(height: 4.h),
            Text(
              "Nama Pengguna",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Divider(
              thickness: 2.w,
            ),
            SizedBox(height: 8.h),
            Text(
              "Jabatan:",
              style: theme.labelMedium,
            ),
            SizedBox(height: 4.h),
            Text(
              "Nama Pengguna",
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
            Text(
              "Nama Pengguna",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Divider(
              thickness: 2.w,
            ),
            SizedBox(height: 16.h),
            Text(
              "Pengaturan",
              style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sinkronisasi Master Data",
                  style: theme.labelLarge,
                ),
                Icon(Icons.chevron_right_rounded)
              ],
            ),
            SizedBox(height: 4.h),
            Divider(
              thickness: 2.w,
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                Get.toNamed('/language');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bahasa",
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
                Get.toNamed('/theme');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tema",
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
            SizedBox(height: 16.h),
            Text(
              "Info Lainnya",
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
                    "Tentang Aplikasi",
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
                    "Bantuan",
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
            SizedBox(height: 16.h),
            OutlinedButton(
              onPressed: () {},
              child: Text(
                "Keluar",
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

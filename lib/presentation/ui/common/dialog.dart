import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/presentation/ui/common/app.textformfield.dart';

/// Widget global untuk menampilkan dialog otentikasi password.
///
/// Bisa dipakai seperti ini:
/// ```dart
/// showAuthDialog(
///   title: "Otentikasi Upload",
///   message: "Masukkan Password!",
///   controller: myTextController,
///   onSubmit: () {
///     // aksi setelah password dimasukkan
///   },
/// );
/// ```
Future<void> showAuthDialog({
  required String title,
  required String message,
  required TextEditingController controller,
  required RxBool obsecure,
  required VoidCallback onSubmit,
}) {
  return Get.bottomSheet(
    Container(
      margin: EdgeInsets.symmetric(vertical: 0.1.sh, horizontal: 0.1.sw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Get.theme.scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Get.textTheme.titleMedium),
            SizedBox(height: 12.h),
            Text(message, style: Get.textTheme.bodyMedium),
            SizedBox(height: 8.h),
            AppPasswordField(
              controller: controller,
              isObscured: obsecure, // ini RxBool di controllermu
              hintText: 'password'.tr,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kolom ini wajib di isi!';
                } else if (value.length < 8) {
                  return 'Password minimal 8 karakter';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 42.h),
              ),
              onPressed: () {
                Get.back(); // Tutup dialog
                onSubmit(); // Jalankan callback
              },
              child: const Text('Kirim'),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/sampletext.controller.dart';

class SampletextScreen extends GetView<SampletextController> {
  const SampletextScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample text'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Text(
            "Font Roboto",
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Font Inter",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Font Poppins",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Font Oswald",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Font Nunito",
            style: GoogleFonts.nunito(
              textStyle: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Font Playfair Display",
            style: GoogleFonts.playfairDisplay(
              textStyle: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Font Firasans",
            style: GoogleFonts.firaSans(
              textStyle: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Font Outfit",
            style: GoogleFonts.outfit(
              textStyle: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text('DisplayLarge (H1)', style: theme.displayLarge),
          Text('DisplayMedium (H2)', style: theme.displayMedium),
          Text('DisplaySmall (H3)', style: theme.displaySmall),
          Divider(),
          Text('HeadlineLarge (H4)', style: theme.headlineLarge),
          Text('HeadlineMedium (H5)', style: theme.headlineMedium),
          Text('HeadlineSmall (H6)', style: theme.headlineSmall),
          Divider(),
          Text('TitleLarge', style: theme.titleLarge),
          Text('TitleMedium', style: theme.titleMedium),
          Text('TitleSmall', style: theme.titleSmall),
          Divider(),
          Text('BodyLarge', style: theme.bodyLarge),
          Text('BodyMedium', style: theme.bodyMedium),
          Text('BodySmall', style: theme.bodySmall),
          Divider(),
          Text('LabelLarge', style: theme.labelLarge),
          Text('LabelMedium', style: theme.labelMedium),
          Text('LabelSmall', style: theme.labelSmall),
        ],
      ),
    );
  }
}

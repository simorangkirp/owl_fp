import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owl_fp/presentation/constant.dart';

class AppTheme {
  static final light = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ConstColor.lCrulean, // warna latar
        foregroundColor: ConstColor.gCultured, // warna teks/icon
        padding: ConstPadding.eleBtnPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          // fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ConstColor.lCrulean, // warna teks/icon
        side: BorderSide(color: ConstColor.lCrulean, width: 1.5.w),
        padding: ConstPadding.eleBtnPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          // fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    ),
    scaffoldBackgroundColor: ConstColor.lCream,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: ConstColor.lBerBlue),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ConstColor.gCultured,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.w)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: ConstColor.lNPBlue)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstColor.lCrulean, width: 2.w)),
      labelStyle: GoogleFonts.poppins(fontSize: 10.sp),
      contentPadding: ConstPadding.ddBtnPadding,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ConstColor.lBerBlue,
      selectedItemColor: ConstColor.lCream,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(size: 24.h),
      unselectedIconTheme: IconThemeData(size: 20.h),
      selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.normal),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(),
      displayMedium: GoogleFonts.poppins(),
      displaySmall: GoogleFonts.poppins(),
      headlineLarge: GoogleFonts.poppins(),
      headlineMedium: GoogleFonts.poppins(),
      headlineSmall: GoogleFonts.poppins(),
      titleLarge: GoogleFonts.poppins(),
      titleMedium: GoogleFonts.poppins(),
      titleSmall: GoogleFonts.poppins(),
      bodyLarge: GoogleFonts.poppins(),
      bodyMedium: GoogleFonts.poppins(),
      bodySmall: GoogleFonts.poppins(),
      labelLarge: GoogleFonts.poppins(),
      labelMedium: GoogleFonts.poppins(
          textStyle: const TextStyle(overflow: TextOverflow.ellipsis)),
      labelSmall: GoogleFonts.poppins(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ConstColor.lBerBlue,
      foregroundColor: ConstColor.lCream, // warna teks & icon
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: ConstColor.lCream,
      ),
      iconTheme: IconThemeData(
        color: ConstColor.lCream,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: ConstColor.gCultured,
      unselectedLabelColor: Colors.grey,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14.sp,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: ConstColor.lRed, width: 3.w),
        insets: EdgeInsets.symmetric(horizontal: 16.w),
      ),
    ),
  );

  static final dark = ThemeData(
    scaffoldBackgroundColor: ConstColor.dCharcoal,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: ConstColor.dPlatinum, brightness: Brightness.dark),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ConstColor.gCultured,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.w)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstColor.dPlatinum)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstColor.dVerdigris, width: 2.w)),
      labelStyle: GoogleFonts.poppins(fontSize: 10.sp),
      contentPadding: ConstPadding.ddBtnPadding,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(),
      displayMedium: GoogleFonts.poppins(),
      displaySmall: GoogleFonts.poppins(),
      headlineLarge: GoogleFonts.poppins(),
      headlineMedium: GoogleFonts.poppins(),
      headlineSmall: GoogleFonts.poppins(),
      titleLarge: GoogleFonts.poppins(),
      titleMedium: GoogleFonts.poppins(),
      titleSmall: GoogleFonts.poppins(),
      bodyLarge: GoogleFonts.poppins(),
      bodyMedium: GoogleFonts.poppins(),
      bodySmall: GoogleFonts.poppins(),
      labelLarge: GoogleFonts.poppins(),
      labelMedium: GoogleFonts.poppins(),
      labelSmall: GoogleFonts.poppins(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ConstColor.dRichblack,
      foregroundColor: ConstColor.dPlatinum, // warna teks & icon
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: ConstColor.dPlatinum,
      ),
      iconTheme: IconThemeData(
        color: ConstColor.dPlatinum,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: ConstColor.gCultured,
      unselectedLabelColor: Colors.grey,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14.sp,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: ConstColor.dRed, width: 3.w),
        insets: EdgeInsets.symmetric(horizontal: 16.w),
      ),
    ),
  );
}

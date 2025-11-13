import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owl_fp_newer/presentation/constant.dart';

class AppTheme {
  // =========================
  // 🌞 LIGHT THEME
  // =========================
  static ThemeData buildLightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: ConstColor.lCream,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ConstColor.lBerBlue,
        brightness: Brightness.light,
        tertiary: ConstColor.lCream,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ConstColor.lCrulean,
          foregroundColor: ConstColor.gCultured,
          padding: ConstPadding.eleBtnPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: ConstColor.gCultured,
          foregroundColor: ConstColor.lCrulean,
          side: BorderSide(color: ConstColor.lCrulean, width: 1.5.w),
          padding: ConstPadding.eleBtnPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // InputField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ConstColor.gCultured,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstColor.lNPBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstColor.lCrulean, width: 2.w),
        ),
        labelStyle: GoogleFonts.poppins(fontSize: 10.sp),
        contentPadding: ConstPadding.ddBtnPadding,
      ),

      // BottomNavigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ConstColor.lBerBlue,
        selectedItemColor: ConstColor.lCream,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(size: 24.h),
        unselectedIconTheme: IconThemeData(size: 20.h),
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.normal,
          fontSize: 11.sp,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // TextTheme
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme.apply(fontSizeFactor: 1.sp),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: ConstColor.lBerBlue,
        foregroundColor: ConstColor.lCream,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: ConstColor.lCream,
        ),
        iconTheme: IconThemeData(
          color: ConstColor.lCream,
          size: 22.h,
        ),
      ),

      // TabBar
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
  }

  // =========================
  // 🌙 DARK THEME
  // =========================
  static ThemeData buildDarkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: ConstColor.dCharcoal,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ConstColor.dPlatinum,
        brightness: Brightness.dark,
        tertiary: ConstColor.dRichblack,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ConstColor.dVerdigris,
          foregroundColor: ConstColor.gCultured,
          padding: ConstPadding.eleBtnPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: ConstColor.dVerdigris,
          foregroundColor: ConstColor.dCharcoal,
          side: BorderSide(color: ConstColor.dCharcoal, width: 1.5.w),
          padding: ConstPadding.eleBtnPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: GoogleFonts.poppins(fontSize: 14.sp),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ConstColor.dRichblack,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstColor.dPlatinum),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstColor.dVerdigris, width: 2.w),
        ),
        labelStyle: GoogleFonts.poppins(fontSize: 10.sp),
        contentPadding: ConstPadding.ddBtnPadding,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ConstColor.dRichblack,
        selectedItemColor: ConstColor.dPlatinum,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(size: 24.h),
        unselectedIconTheme: IconThemeData(size: 20.h),
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.normal,
          fontSize: 11.sp,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme.apply(fontSizeFactor: 1.sp),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ConstColor.dRichblack,
        foregroundColor: ConstColor.dPlatinum,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: ConstColor.dPlatinum,
        ),
        iconTheme: IconThemeData(
          color: ConstColor.dPlatinum,
          size: 22.h,
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
}

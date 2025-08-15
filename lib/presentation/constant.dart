import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConstPadding {
  static var screenPadding =
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
  static var listcontentPadding = EdgeInsets.symmetric(horizontal: 16.w);
  static var ddBtnPadding =
      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w);
  static var eleBtnPadding =
      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w);
}

class ConstColor {
  // Light Theme Colors
  static var lRed = const Color(0xffE63946);
  static var lCream = const Color(0xffF1FAEE);
  static var lNPBlue = const Color(0xffA8DADC);
  static var lCrulean = const Color(0xff457B9D);
  static var lBerBlue = const Color(0xff1D3557);

  // Dark Theme Colors
  static var dRed = const Color(0xffB22234);
  static var dPlatinum = const Color(0xffE5E5E5);
  static var dVerdigris = const Color(0xff5FA8A4);
  static var dCharcoal = const Color(0xff2D3A45);
  static var dRichblack = const Color(0xff121A25);

  // Global Colors
  static var gCultured = const Color(0xffF5F5F5);
  static var gBlueGray = const Color(0xff607D8B);
  static var gGreen = const Color(0xff388E3C);
}

class ConstPath {
  static const owlIcon = 'assets/image/owl.logo.png';
}

class DBConstant {
  static const String tblUser = 'user';
  static const String tblMasterHeader = 'masterheader';
  static const String tblDDList = 'ddlistmenu';
  static const String tblDashMenuIcon = 'dashboardmenuicon';
  static const String tblKaryawan = 'karyawan';
  static const String tblFPKaryawan = 'fp_karyawan';
}

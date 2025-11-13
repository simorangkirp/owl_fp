import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ✅ Padding Constants (pakai getter supaya ScreenUtil sudah ter-init)
class ConstPadding {
  static EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);

  static EdgeInsets get listcontentPadding =>
      EdgeInsets.symmetric(horizontal: 16.w);

  static EdgeInsets get ddBtnPadding =>
      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w);

  static EdgeInsets get eleBtnPadding =>
      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w);
}

/// ✅ Color Constants (nggak pakai ScreenUtil, jadi tetap aman)
class ConstColor {
  // Light Theme Colors
  static const lRed = Color(0xffE63946);
  static const lCream = Color(0xffF1FAEE);
  static const lNPBlue = Color(0xffA8DADC);
  static const lCrulean = Color(0xff457B9D);
  static const lBerBlue = Color(0xff1D3557);

  // Dark Theme Colors
  static const dRed = Color(0xffB22234);
  static const dPlatinum = Color(0xffE5E5E5);
  static const dVerdigris = Color(0xff5FA8A4);
  static const dCharcoal = Color(0xff2D3A45);
  static const dRichblack = Color(0xff121A25);

  // Global Colors
  static const gCultured = Color(0xffF5F5F5);
  static const gBlueGray = Color(0xff607D8B);
  static const gGreen = Color(0xff388E3C);
  static const gTurquoise = Color(0xff00BFA6);
  static const gPrussianBlue = Color(0xff003566);
  static const gPacificBlue = Color(0xff00b4d8);
}

/// ✅ Asset Path Constants
class ConstPath {
  static const owlIcon = 'assets/image/owl.logo.png';
}

/// ✅ Database Table Constants
class DBConstant {
  static const String tblUser = 'user';
  static const String tblMasterHeader = 'masterheader';
  static const String tblDDList = 'ddlistmenu';
  static const String tblDashMenuIcon = 'dashboardmenuicon';
  static const String tblKaryawan = 'karyawan';
  static const String tblFPKaryawan = 'fp_karyawan';
  static const String tblUserAccess = 'user_access';
  static const String tblMasterAccess = 'mst_access';
  static const String tblLogMstSync = 'log_mstsync';
}

/// ✅ Log Constants
class LogConstant {
  static const String mstKaryawan = 'Mst Karyawan';
}

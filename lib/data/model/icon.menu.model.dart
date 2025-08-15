import 'package:flutter/material.dart';

class DashboardIconMenuModel {
  String? menuNm;
  String? path;
  int? iconIndex;
  IconData? menuIcon;

  DashboardIconMenuModel({
    this.menuNm,
    this.path,
    this.menuIcon,
    this.iconIndex,
  });

  // Serialize ke Map buat disimpan ke DB
  Map<String, dynamic> toMap() {
    return {
      'menuNm': menuNm,
      'path': path,
      'iconIndex': iconIndex,
      'iconCodePoint': menuIcon?.codePoint,
      'iconFontFamily': menuIcon?.fontFamily,
      'iconFontPackage': menuIcon?.fontPackage,
      'iconMatchTextDirection': menuIcon?.matchTextDirection == true ? 1 : 0,
    };
  }

  // Deserialize dari Map DB
  factory DashboardIconMenuModel.fromMap(Map<String, dynamic> map) {
    return DashboardIconMenuModel(
      menuNm: map['menuNm'],
      path: map['path'],
      iconIndex: map['iconIndex'],
      menuIcon: map['iconCodePoint'] != null
          ? IconData(
              map['iconCodePoint'],
              fontFamily: map['iconFontFamily'],
              fontPackage: map['iconFontPackage'],
              matchTextDirection: map['iconMatchTextDirection'] == 1,
            )
          : null,
    );
  }
}

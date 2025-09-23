import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // contoh: ganti sesuai lib ikon lo

class DashboardIconMenuModel {
  String? menuNm;
  String? path;
  int? iconIndex;

  DashboardIconMenuModel({
    this.menuNm,
    this.path,
    this.iconIndex,
  });

  // Getter buat ambil IconData dari index (konstanta, biar aman di release)
  IconData get menuIcon {
    switch (iconIndex) {
      case 1:
        return LucideIcons.fingerprint;
      case 2:
        return LucideIcons.milk;
      case 3:
        return LucideIcons.clipboardList;
      default:
        return LucideIcons.loader; // fallback icon bawaan
    }
  }

  // Serialize ke Map buat disimpan ke DB
  Map<String, dynamic> toMap() {
    return {
      'menuNm': menuNm,
      'path': path,
      'iconIndex': iconIndex,
    };
  }

  // Deserialize dari Map DB
  factory DashboardIconMenuModel.fromMap(Map<String, dynamic> map) {
    return DashboardIconMenuModel(
      menuNm: map['menuNm'],
      path: map['path'],
      iconIndex: map['iconIndex'],
    );
  }
}

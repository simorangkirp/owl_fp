// Konversi IconData -> Map (biar bisa disimpan di DB)
import 'package:flutter/material.dart';

Map<String, dynamic> iconDataToMap(IconData icon) {
  return {
    'codePoint': icon.codePoint,
    'fontFamily': icon.fontFamily,
    'fontPackage': icon.fontPackage,
    'matchTextDirection': icon.matchTextDirection ? 1 : 0,
  };
}

// Konversi Map -> IconData (biar bisa dipakai di widget)
IconData mapToIconData(Map<String, dynamic> map) {
  return IconData(
    map['codePoint'],
    fontFamily: map['fontFamily'],
    fontPackage: map['fontPackage'],
    matchTextDirection: map['matchTextDirection'] == 1,
  );
}

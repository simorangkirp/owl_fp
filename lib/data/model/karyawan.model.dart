import 'package:equatable/equatable.dart';
import 'package:owl_fp/domain/entity/karyawan.entity.dart';

class KaryawanModel extends Equatable {
  const KaryawanModel({
    required this.karyawanid,
    required this.nik,
    required this.lokasitugas,
    required this.subbagian,
    required this.namakaryawan,
    required this.tipekaryawan,
    required this.namajabatan,
    required this.kodejabatan,
    required this.tanggalkeluar,
  });

  final String? karyawanid;
  final String? nik;
  final String? lokasitugas;
  final String? subbagian;
  final String? namakaryawan;
  final String? tipekaryawan;
  final String? namajabatan;
  final String? kodejabatan;
  final String? tanggalkeluar;

  KaryawanModel copyWith({
    String? karyawanid,
    String? nik,
    String? lokasitugas,
    String? subbagian,
    String? namakaryawan,
    String? tipekaryawan,
    String? namajabatan,
    String? kodejabatan,
    String? tanggalkeluar,
  }) {
    return KaryawanModel(
      karyawanid: karyawanid ?? this.karyawanid,
      nik: nik ?? this.nik,
      lokasitugas: lokasitugas ?? this.lokasitugas,
      subbagian: subbagian ?? this.subbagian,
      namakaryawan: namakaryawan ?? this.namakaryawan,
      tipekaryawan: tipekaryawan ?? this.tipekaryawan,
      namajabatan: namajabatan ?? this.namajabatan,
      kodejabatan: kodejabatan ?? this.kodejabatan,
      tanggalkeluar: tanggalkeluar ?? this.tanggalkeluar,
    );
  }

  factory KaryawanModel.fromJson(Map<String, dynamic> json) {
    return KaryawanModel(
      karyawanid: json["karyawanid"],
      nik: json["nik"],
      lokasitugas: json["lokasitugas"],
      subbagian: json["subbagian"],
      namakaryawan: json["namakaryawan"],
      tipekaryawan: json["tipekaryawan"],
      namajabatan: json["namajabatan"],
      kodejabatan: json["kodejabatan"],
      tanggalkeluar: json["tanggalkeluar"],
    );
  }

  Map<String, dynamic> toJson() => {
        "karyawanid": karyawanid,
        "nik": nik,
        "lokasitugas": lokasitugas,
        "subbagian": subbagian,
        "namakaryawan": namakaryawan,
        "tipekaryawan": tipekaryawan,
        "namajabatan": namajabatan,
        "kodejabatan": kodejabatan,
        "tanggalkeluar": tanggalkeluar,
      };

  Map<String, dynamic> toTable() => {
        "karyawanid": karyawanid ?? "",
        "nik": nik ?? "",
        "lokasitugas": lokasitugas ?? "",
        "subbagian": subbagian ?? "",
        "namakaryawan": namakaryawan ?? "",
        "tipekaryawan": tipekaryawan ?? "",
        "namajabatan": namajabatan ?? "",
        "kodejabatan": kodejabatan ?? "",
        "tanggalkeluar": tanggalkeluar ?? "",
      };

  KaryawanEntity toEntity() => KaryawanEntity(
      karyawanid: karyawanid,
      nik: nik,
      lokasitugas: lokasitugas,
      subbagian: subbagian,
      namakaryawan: namakaryawan,
      tipekaryawan: tipekaryawan,
      namajabatan: namajabatan,
      kodejabatan: kodejabatan,
      tanggalkeluar: tanggalkeluar);

  @override
  List<Object?> get props => [
        karyawanid,
        nik,
        lokasitugas,
        subbagian,
        namakaryawan,
        tipekaryawan,
        namajabatan,
        kodejabatan,
        tanggalkeluar,
      ];
}

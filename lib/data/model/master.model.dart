import 'package:equatable/equatable.dart';

import 'karyawan.model.dart';

class MasterModel extends Equatable {
  const MasterModel({
    required this.karyawan,
  });

  final List<KaryawanModel> karyawan;

  MasterModel copyWith({
    List<KaryawanModel>? karyawan,
  }) {
    return MasterModel(
      karyawan: karyawan ?? this.karyawan,
    );
  }

  factory MasterModel.fromJson(Map<String, dynamic> json) {
    return MasterModel(
      karyawan: json["karyawan"] == null
          ? []
          : List<KaryawanModel>.from(
              json["karyawan"]!.map((x) => KaryawanModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "karyawan": karyawan.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        karyawan,
      ];
}

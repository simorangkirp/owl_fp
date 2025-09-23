import 'package:equatable/equatable.dart';

import '../../domain/entity/template.entity.dart';

class TemplateModel extends Equatable {
  const TemplateModel({
    required this.id,
    required this.sn,
    required this.sensor,
    required this.idF,
    required this.nik,
    required this.nama,
    required this.template,
  });

  final int? id;
  final String? sn;
  final String? sensor;
  final String? idF;
  final String? nik;
  final String? nama;
  final String? template;

  TemplateModel copyWith({
    int? id,
    String? sn,
    String? sensor,
    String? idF,
    String? nik,
    String? nama,
    String? template,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      sn: sn ?? this.sn,
      sensor: sensor ?? this.sensor,
      idF: idF ?? this.idF,
      nik: nik ?? this.nik,
      nama: nama ?? this.nama,
      template: template ?? this.template,
    );
  }

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json["id"],
      sn: json["sn"],
      sensor: json["sensor"],
      idF: json["idF"],
      nik: json["nik"],
      nama: json["nama"],
      template: json["template"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "sn": sn,
        "sensor": sensor,
        "idF": idF,
        "nik": nik,
        "nama": nama,
        "template": template,
      };

  Map<String, dynamic> toTable() => {
        "id": id ?? "",
        "sn": sn ?? "",
        "sensor": sensor ?? "",
        "idF": idF ?? "",
        "nik": nik ?? "",
        "nama": nama ?? "",
        "template": template ?? "",
      };

  TemplateEntity toEntity() => TemplateEntity(
      id: id,
      sn: sn,
      sensor: sensor,
      idF: idF,
      nik: nik,
      nama: nama,
      template: template);

  @override
  List<Object?> get props => [
        id,
        nik,
        sn,
        sensor,
        idF,
        nama,
        template,
      ];
}

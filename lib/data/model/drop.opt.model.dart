import 'package:equatable/equatable.dart';
import 'package:owl_fp/domain/entity/dropopt.entity.dart';

class DropOptionModel extends Equatable {
  const DropOptionModel({
    required this.no,
    required this.key,
    required this.value,
    required this.menu,
    required this.submenu,
  });
  final int? no;
  final String? key;
  final String? value;
  final String? menu;
  final String? submenu;

  DropOptionModel copyWith({
    int? no,
    String? key,
    String? value,
    String? menu,
    String? submenu,
  }) {
    return DropOptionModel(
      no: no ?? this.no,
      key: key ?? this.key,
      value: value ?? this.value,
      menu: menu ?? this.menu,
      submenu: submenu ?? this.submenu,
    );
  }

  factory DropOptionModel.fromJson(Map<String, dynamic> json) {
    return DropOptionModel(
      no: json["no"],
      key: json["nik"],
      value: json["value"],
      menu: json["menu"],
      submenu: json["submenu"],
    );
  }

  Map<String, dynamic> toJson() => {
        "no": no,
        "key": key,
        "value": value,
        "menu": menu,
        "submenu": submenu,
      };

  Map<String, dynamic> toTable() => {
        "no": no ?? "",
        "key": key ?? "",
        "value": value ?? "",
        "menu": menu ?? "",
        "submenu": submenu ?? "",
      };

  DropOptionEntity toEntity() => DropOptionEntity(
        no: no,
        key: key,
        value: value,
        menu: menu,
        submenu: submenu,
      );
  @override
  List<Object?> get props => [
        no,
        key,
        value,
        menu,
        submenu,
      ];
}

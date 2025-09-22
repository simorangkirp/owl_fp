import 'package:get/get.dart';

class MstAdminModel {
  String? key;
  String? value;
  RxBool selected; // jangan nullable, biar ga ribet

  MstAdminModel({
    this.key,
    this.value,
    RxBool? selected,
  }) : selected = selected ?? false.obs; // default false

  // Deserialize dari Map DB
  factory MstAdminModel.fromMap(Map<String, dynamic> map) {
    return MstAdminModel(
      key: map['key'],
      value: map['value'],
      selected: false.obs, // pakai RxBool, bukan bool
    );
  }

  // (optional) Serialize ke Map DB
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'selected': selected.value ? 1 : 0, // simpan bool ke int (0/1)
    };
  }
}

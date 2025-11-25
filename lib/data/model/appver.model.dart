import 'package:owl_fp_newer/domain/entity/about.entity.dart';

class AppVerModel {
  final String appVersion;
  final String buildNumber;
  final String appId;
  final String appName;
  final String url;
  final String desc;
  final String kodeOrg;

  AppVerModel({
    required this.appVersion,
    required this.buildNumber,
    required this.appId,
    required this.appName,
    required this.url,
    required this.desc,
    required this.kodeOrg,
  });

  factory AppVerModel.fromJson(Map<String, dynamic> json) {
    return AppVerModel(
      appVersion: json["app_version"] ?? "",
      buildNumber: json["build_number"] ?? "",
      appId: json["appid"] ?? "",
      appName: json["app_name"] ?? "",
      url: json["url"] ?? "",
      desc: json["desc"] ?? "",
      kodeOrg: json["kodeorg"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "app_version": appVersion,
      "build_number": buildNumber,
      "appid": appId,
      "app_name": appName,
      "url": url,
      "desc": desc,
      "kodeorg": kodeOrg,
    };
  }

  /// Convert ke entity (dipakai domain layer)
  AppVerEntity toEntity() => AppVerEntity(
        appVersion: appVersion,
        buildNumber: buildNumber,
        appId: appId,
        appName: appName,
        url: url,
        desc: desc,
        kodeOrg: kodeOrg,
      );
}

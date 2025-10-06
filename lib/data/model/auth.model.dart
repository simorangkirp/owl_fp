import 'package:owl_fp_newer/domain/entity/auth.entity.dart';

class LoginModel extends LoginEntty {
  LoginModel({
    required super.id,
    required super.name,
    required super.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      token: json['token'] ?? '',
    );
  }
}

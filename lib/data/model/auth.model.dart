import 'package:owl_fp/domain/entity/auth.entity.dart';

class LoginModel extends LoginEntty {
  LoginModel({
    required String id,
    required String name,
    required String token,
  }) : super(id: id, name: name, token: token);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      token: json['token'] ?? '',
    );
  }
}

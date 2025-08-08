import 'package:owl_fp/core/resources/data.state.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<DataState> getProfile();
}

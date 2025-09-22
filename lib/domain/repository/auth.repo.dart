import 'package:owl_fp/core/resources/data.state.dart';

abstract class AuthRepository {
  Future<DataState> login(String uname, String password);
  Future<DataState> getProfile();
  Future<DataState> onLoginMasterDataRepo();
}

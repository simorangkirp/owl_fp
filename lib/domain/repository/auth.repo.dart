import 'package:owl_fp_newer/core/resources/data.state.dart';

abstract class AuthRepository {
  Future<DataState> login(String uname, String password);
  Future<DataState> getProfile();
  Future<DataState> onLoginMasterDataRepo();
}

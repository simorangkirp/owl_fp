import 'package:owl_fp/domain/repository/template.repository.dart';

import '../../services/localstorage/template.db.dart';

class TemplateRepoImpl implements TemplateRepository {
  final TemplateLocalDataSource localDataSource;

  TemplateRepoImpl(this.localDataSource);

  @override
  Future<List<String>> getSnList() async {
    return await localDataSource.getSn();
  }

  @override
  Future<List<String>> getKaryawanFingerList(args) async {
    return await localDataSource.getTemplateFP(args);
  }

  @override
  Future<List<String>> getKaryawanList(args) async {
    return await localDataSource.getKaryawan(args);
  }
}

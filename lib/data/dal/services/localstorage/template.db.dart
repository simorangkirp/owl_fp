import 'db/template.dbservice.dart';

abstract class TemplateLocalDataSource {
  Future<List<String>> getSn();
  Future<List<String>> getTemplateFP(query);
  Future<List<String>> getKaryawan(args);
}

class TemplateLocalDataSourceImpl extends TemplateLocalDataSource {
  final TemplateDBHelper databaseHelper;
  TemplateLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<String>> getSn() async {
    return await databaseHelper.querySN();
  }

  @override
  Future<List<String>> getTemplateFP(query) async {
    return await databaseHelper.queryTemplFP(query);
  }

  @override
  Future<List<String>> getKaryawan(args) async {
    return await databaseHelper.queryKaryawan(args);
  }
}

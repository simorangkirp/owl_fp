abstract class TemplateRepository {
  Future<List<String>> getSnList();
  Future<List<String>> getKaryawanList(String args);
  Future<List<String>> getKaryawanFingerList(Map<String, dynamic> args);
}

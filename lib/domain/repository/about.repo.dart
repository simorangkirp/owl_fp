import 'package:owl_fp_newer/core/resources/data.state.dart';

abstract class AboutRepository {
  Future<DataState> getVersion();
  Future<DataState> downloadLatestVersion();
}

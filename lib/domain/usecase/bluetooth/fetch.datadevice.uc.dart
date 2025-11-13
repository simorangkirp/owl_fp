import 'package:owl_fp_newer/domain/repository/bt.repo.dart';

class FetchDeviceDataUseCase {
  final BluetoothRepository repository;

  FetchDeviceDataUseCase(this.repository);

  Future<void> call() async {
    await repository.fetchDeviceData();
  }
}

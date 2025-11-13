import 'package:owl_fp_newer/domain/repository/bt.repo.dart';

class DisconnectDeviceUseCase {
  final BluetoothRepository repo;
  DisconnectDeviceUseCase(this.repo);

  Future<void> call() async {
    await repo.disconnectDevice();
  }
}

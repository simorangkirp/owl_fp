import 'package:owl_fp_newer/domain/entity/bt.entity.dart';
import 'package:owl_fp_newer/domain/repository/bt.repo.dart';

class ScanDevicesUseCase {
  final BluetoothRepository repository;

  ScanDevicesUseCase(this.repository);

  Stream<BluetoothDeviceEntity> execute() {
    return repository.startDiscovery();
  }

  Future<void> cancel() async {
    await repository.cancelDiscovery();
  }

  Future<void> checkPermission(Function() onGranted) async {
    await repository.checkPermission(onGranted);
  }
}

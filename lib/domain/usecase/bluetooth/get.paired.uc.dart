import 'package:owl_fp_newer/domain/entity/bt.entity.dart';
import 'package:owl_fp_newer/domain/repository/bt.repo.dart';

class GetPairedDevicesUseCase {
  final BluetoothRepository repository;

  GetPairedDevicesUseCase(this.repository);

  Future<List<BluetoothDeviceEntity>> call() async {
    return await repository.getPairedDevices();
  }
}

import 'package:owl_fp_newer/domain/entity/bt.entity.dart';
import 'package:owl_fp_newer/domain/repository/bt.repo.dart';

class FetchInitValueUseCase {
  final BluetoothRepository repository;

  FetchInitValueUseCase(this.repository);

  Future<void> execute(BluetoothDeviceEntity device) async {
    // 2️⃣ Kirim handshake
    await repository.fetchInitValue();
  }
}

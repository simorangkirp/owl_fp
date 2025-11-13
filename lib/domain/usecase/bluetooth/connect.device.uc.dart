import 'package:owl_fp_newer/domain/entity/bt.entity.dart';
import 'package:owl_fp_newer/domain/repository/bt.repo.dart';

class ConnectDeviceUseCase {
  final BluetoothRepository repository;

  ConnectDeviceUseCase(this.repository);

  Future<void> execute(BluetoothDeviceEntity device) async {
    // 1️⃣ Coba connect ke perangkat
    final ok = await repository.connectDevice(device);
    if (!ok) throw Exception("Gagal menghubungkan perangkat.");

    // 2️⃣ Kirim handshake
    await repository.sendHandshake();

    // 3️⃣ Tunggu balasan handshake
    final success = await repository.waitForHandshake(timeout: 5);
    if (!success) throw Exception("Handshake timeout, tidak ada respons.");

    // 4️⃣ Fetch data tambahan dari device (opsional)
    await repository.fetchDeviceData();
  }
}

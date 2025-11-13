import 'package:owl_fp_newer/domain/repository/bt.repo.dart';

class InitBluetoothListenersUseCase {
  final BluetoothRepository repository;

  InitBluetoothListenersUseCase(this.repository);

  Future<void> execute({
    required Function(String state)? onStateChanged,
    required Function(String conn)? onConnectionChanged,
    required Function(String data)? onDataReceived,
  }) async {
    await repository.initListeners(
      onStateChanged: onStateChanged,
      onConnectionChanged: onConnectionChanged,
      onDataReceived: onDataReceived,
    );
  }
}

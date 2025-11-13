import 'package:get/get.dart';
import 'package:owl_fp_newer/data/dal/daos/bluetooth/bt.repoimpl.dart';
import 'package:owl_fp_newer/data/dal/services/bluetooth/bt.datasource.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/connect.device.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/disconnect.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/get.paired.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/init.listener.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/process.parser.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/scan.devices.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/send.command.uc.dart';
import 'package:owl_fp_newer/presentation/ui/fingerprint/controllers/bt14_ctrl_controller.dart';

class Bt14CtrlBinding extends Bindings {
  @override
  void dependencies() {
    // --- DataSource ---
    Get.lazyPut(() => BluetoothDataSource());

    // --- Repository ---
    Get.lazyPut(() => BluetoothRepositoryImpl(Get.find<BluetoothDataSource>()));

    // --- UseCases ---
    Get.lazyPut(() => ScanDevicesUseCase(Get.find<BluetoothRepositoryImpl>()));
    Get.lazyPut(() => SendCommandUseCase(Get.find<BluetoothRepositoryImpl>()));
    Get.lazyPut(
        () => DisconnectDeviceUseCase(Get.find<BluetoothRepositoryImpl>()));
    Get.lazyPut(
        () => ConnectDeviceUseCase(Get.find<BluetoothRepositoryImpl>()));
    Get.lazyPut(() =>
        InitBluetoothListenersUseCase(Get.find<BluetoothRepositoryImpl>()));
    Get.lazyPut(() => ProcessBluetoothBufferUseCase());
    Get.lazyPut(
        () => GetPairedDevicesUseCase(Get.find<BluetoothRepositoryImpl>()));

    // --- Controller ---
    Get.lazyPut<Bt14CtrlController>(
      () => Bt14CtrlController(
        Get.find<ScanDevicesUseCase>(),
        Get.find<ConnectDeviceUseCase>(),
        Get.find<InitBluetoothListenersUseCase>(),
        Get.find<ProcessBluetoothBufferUseCase>(),
        Get.find<GetPairedDevicesUseCase>(),
        Get.find<SendCommandUseCase>(),
        Get.find<DisconnectDeviceUseCase>(),
      ),
    );
  }
}

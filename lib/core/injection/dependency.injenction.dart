import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:owl_fp/data/dio/dio.client.dart';
import 'package:owl_fp/presentation/ui/dashboard/controllers/dashboard.controller.dart';
import 'package:owl_fp/presentation/ui/profile/controllers/profile.controller.dart';

import '../../data/dal/daos/auth/auth.repoimpl.dart';
import '../../data/dal/services/apis/login.api.dart';
import '../../presentation/ui/fingerprint/controllers/bt.controller.dart';
import '../../data/dal/services/db.helper.dart';
import '../../presentation/theme/btm.navbar.ctrl.dart';
import '../../presentation/theme/controller.dart';
import '../../data/dal/services/get.storage.dart';

class DependecyInjection {
  static Future<void> init() async {
    Get.put(StorageService());
    final storage = Get.find<StorageService>();

    ///-----------
    /// Utils
    /// ----------
    Get.put<Dio>(Dio());
    Get.put(DioClient(storage.bUrl ?? ""));
    Get.put<BluetoothController>(BluetoothController());
    Get.put<DatabaseHelper>(DatabaseHelper());
    Get.put<ThemeController>(ThemeController());
    Get.put<BottomNavController>(BottomNavController());
    Get.put<DashboardController>(DashboardController());
    Get.put<ProfileController>(ProfileController());

    ///-----------
    /// LocalData
    /// ----------

    ///-----------
    /// RemoteData
    /// ----------
    Get.put(AuthRemoteDataSourceImpl(dioClient: Get.find<DioClient>()));

    ///-----------
    /// Repository
    /// ----------
    Get.put(AuthRepositoryImpl(Get.find<AuthRemoteDataSourceImpl>()));
  }
}

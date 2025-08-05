import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:owl_fp/data/dio/dio.client.dart';

import '../../data/dal/daos/auth/auth.repoimpl.dart';
import '../../data/dal/daos/dashboard/dashboard.repoimpl.dart';
import '../../data/dal/daos/masterdata/master.repoimpl.dart';
import '../../data/dal/daos/profile/profile.repoimpl.dart';
import '../../data/dal/services/apis/login.api.dart';
import '../../data/dal/services/apis/master.api.dart';
import '../../data/dal/services/apis/profile.api.dart';
import '../../data/dal/services/db/auth.db.dart';
import '../../data/dal/services/db/dashboard.db.dart';
import '../../data/dal/services/db/master.db.dart';
import '../../data/dal/services/db/profile.db.dart';
import '../../domain/usecase/dashboard/master.list.usecase.dart';
import '../../presentation/ui/dashboard/controllers/dashboard.controller.dart';
import '../../presentation/ui/fingerprint/controllers/bt.controller.dart';
import '../../data/dal/services/db.helper.dart';
import '../../presentation/theme/btm.navbar.ctrl.dart';
import '../../presentation/theme/controller.dart';
import '../../data/dal/services/get.storage.dart';

class DependecyInjection {
  static Future<void> init() async {
    Get.put(StorageService());
    final storage = Get.find<StorageService>();

    // Get.lazyPut(() => GetUserUseCase(Get.find<ProfileRepositoryImpl>()));

    ///-----------
    /// Utils
    /// ----------
    Get.put<Dio>(Dio());
    Get.put(DioClient(storage.bUrl ?? ""));
    Get.put<BluetoothController>(BluetoothController());
    Get.put<DatabaseHelper>(DatabaseHelper());
    Get.put<ThemeController>(ThemeController());

    ///-----------
    /// LocalData
    /// ----------
    Get.put<AuthLocalDataSourceImpl>(
      AuthLocalDataSourceImpl(
        databaseHelper: Get.find<DatabaseHelper>(),
      ),
    );
    Get.put<DashboardLocalDataSourceImpl>(
      DashboardLocalDataSourceImpl(
        databaseHelper: Get.find<DatabaseHelper>(),
      ),
    );
    Get.put<ProfileLocalDataSourceImpl>(
      ProfileLocalDataSourceImpl(
        databaseHelper: Get.find<DatabaseHelper>(),
      ),
    );
    Get.put<MasterLocalDataSourceImpl>(
      MasterLocalDataSourceImpl(
        databaseHelper: Get.find<DatabaseHelper>(),
      ),
    );

    ///-----------
    /// RemoteData
    /// ----------
    Get.put(AuthRemoteDataSourceImpl(dioClient: Get.find<DioClient>()));
    Get.put(ProfileRemoteDataSourceImpl(dioClient: Get.find<DioClient>()));
    Get.put(MasterRemoteDataSourceImpl(dioClient: Get.find<DioClient>()));

    ///-----------
    /// Repository
    /// ----------
    Get.put(AuthRepositoryImpl(Get.find<AuthRemoteDataSourceImpl>(),
        Get.find<AuthLocalDataSourceImpl>()));
    Get.put(DashboardRepoImpl(
      Get.find<DashboardLocalDataSourceImpl>(),
    ));
    Get.put(ProfileRepositoryImpl(Get.find<ProfileRemoteDataSourceImpl>(),
        Get.find<ProfileLocalDataSourceImpl>()));
    Get.put(MasterRepositoryImpl(Get.find<MasterRemoteDataSourceImpl>(),
        Get.find<MasterLocalDataSourceImpl>()));

    ///-----------
    /// Usecase
    /// ----------
    Get.put(GetMasterHeaderUseCase(Get.find<DashboardRepoImpl>()));

    ///-----------
    /// Others
    /// ----------
    Get.put<BottomNavController>(BottomNavController());
    Get.put<DashboardController>(DashboardController(
      Get.find<GetMasterHeaderUseCase>(),
    ));
  }
}

// lib/core/di/dependency_injection.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';

// -- datasources
import 'package:owl_fp_newer/data/dal/services/apis/about.api.dart';
import 'package:owl_fp_newer/data/dal/services/apis/drop.opt.api.dart';
import 'package:owl_fp_newer/data/dal/services/apis/login.api.dart';
import 'package:owl_fp_newer/data/dal/services/apis/master.api.dart';
import 'package:owl_fp_newer/data/dal/services/apis/profile.api.dart';
import 'package:owl_fp_newer/data/dal/services/localstorage/auth.db.dart';
import 'package:owl_fp_newer/data/dal/services/localstorage/dashboard.db.dart';
import 'package:owl_fp_newer/data/dal/services/localstorage/db/dashboard.dbservice.dart';
import 'package:owl_fp_newer/data/dal/services/localstorage/db/dropopt.dbservice.dart';
import 'package:owl_fp_newer/data/dal/services/localstorage/db/karyawan.dbservice.dart';
import 'package:owl_fp_newer/data/dal/services/localstorage/db/template.dbservice.dart';
import 'package:owl_fp_newer/data/dal/services/localstorage/db/user.dbservice.dart';

// -- dio client
import 'package:owl_fp_newer/data/dio/dio.client.dart';

// -- repo impls
import 'package:owl_fp_newer/data/dal/daos/about/about.repoimpl.dart';
import 'package:owl_fp_newer/domain/usecase/about/download.apk.uc.dart';
import 'package:owl_fp_newer/domain/usecase/about/get.apkver.uc.dart';
import '../../data/dal/daos/auth/auth.repoimpl.dart';
import '../../data/dal/daos/dashboard/dashboard.repoimpl.dart';
import '../../data/dal/daos/fingerprint/fp.repoimpl.dart';
import '../../data/dal/daos/masterdata/master.repoimpl.dart';
import '../../data/dal/daos/profile/profile.repoimpl.dart';
import '../../data/dal/daos/template/template.repoimpl.dart';

// -- local/remote datasources
import '../../data/dal/services/localstorage/drop.opt.db.dart';
import '../../data/dal/services/localstorage/master.db.dart';
import '../../data/dal/services/localstorage/profile.db.dart';
import '../../data/dal/services/localstorage/template.db.dart';

// -- usecases
import '../../domain/usecase/auth/get.master.data.dart';
import '../../domain/usecase/auth/login.usecase.dart';
import '../../domain/usecase/auth/profile.usecase.dart';
import '../../domain/usecase/dashboard/icon.menu.usecase.dart';
import '../../domain/usecase/dashboard/master.list.usecase.dart';

// -- others
import '../../data/dal/services/get.storage.dart';
import '../../data/dal/services/db.helper.dart';
import '../../presentation/theme/controller.dart';
import '../../presentation/theme/btm.navbar.ctrl.dart';
import '../../presentation/ui/dashboard/controllers/dashboard.controller.dart';
import '../../presentation/ui/login/controllers/login.controller.dart';
import '../../presentation/ui/profile/controllers/setting.controller.dart';
import 'package:owl_fp_newer/core/services/permission.service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // --- Core / singletons (permanent) ---
    Get.put<StorageService>(StorageService.instance, permanent: true);

    // Dio + network client (permanent)
    Get.put<Dio>(Dio(), permanent: true);
    Get.put<DioClient>(DioClient(Get.find<StorageService>().bUrl ?? ""),
        permanent: true);

    // Utilities & services
    Get.put<PermissionService>(PermissionService(), permanent: true);
    Get.put<DatabaseHelper>(DatabaseHelper(), permanent: true);

    // DB helpers (permanent)
    Get.put<UserDBHelper>(UserDBHelper(), permanent: true);
    Get.put<DropOptDBHelper>(DropOptDBHelper(), permanent: true);
    Get.put<DashboardDBHelper>(DashboardDBHelper(), permanent: true);
    Get.put<KaryawanDBHelper>(KaryawanDBHelper(), permanent: true);
    Get.put<TemplateDBHelper>(TemplateDBHelper(), permanent: true);

    // Theme controllers (permanent)
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<BottomNavController>(BottomNavController(), permanent: true);

    // --- Local datasources (permanent) ---
    Get.put<AuthLocalDataSourceImpl>(
      AuthLocalDataSourceImpl(databaseHelper: Get.find<UserDBHelper>()),
      permanent: true,
    );
    Get.put<DropOptLocalDataSourceImpl>(
      DropOptLocalDataSourceImpl(databaseHelper: Get.find<DropOptDBHelper>()),
      permanent: true,
    );
    Get.put<DashboardLocalDataSourceImpl>(
      DashboardLocalDataSourceImpl(
          databaseHelper: Get.find<DashboardDBHelper>()),
      permanent: true,
    );
    Get.put<ProfileLocalDataSourceImpl>(
      ProfileLocalDataSourceImpl(databaseHelper: Get.find<UserDBHelper>()),
      permanent: true,
    );
    Get.put<MasterLocalDataSourceImpl>(
      MasterLocalDataSourceImpl(databaseHelper: Get.find<KaryawanDBHelper>()),
      permanent: true,
    );
    Get.put<TemplateLocalDataSourceImpl>(
      TemplateLocalDataSourceImpl(databaseHelper: Get.find<TemplateDBHelper>()),
      permanent: true,
    );

    // --- Remote datasources (permanent) ---
    Get.put<AuthRemoteDataSourceImpl>(
        AuthRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
        permanent: true);
    Get.put<AboutRemoteDataSourceImpl>(
        AboutRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
        permanent: true);
    Get.put<DropOptRemoteDataSourceImpl>(
        DropOptRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
        permanent: true);
    Get.put<ProfileRemoteDataSourceImpl>(
        ProfileRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
        permanent: true);
    Get.put<MasterRemoteDataSourceImpl>(
        MasterRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
        permanent: true);

    // --- Repositories (permanent) ---
    Get.put<AboutRepoImpl>(AboutRepoImpl(Get.find<AboutRemoteDataSourceImpl>()),
        permanent: true);
    Get.put<AuthRepositoryImpl>(
        AuthRepositoryImpl(Get.find<AuthRemoteDataSourceImpl>(),
            Get.find<AuthLocalDataSourceImpl>()),
        permanent: true);
    Get.put<DashboardRepoImpl>(
        DashboardRepoImpl(Get.find<DashboardLocalDataSourceImpl>()),
        permanent: true);
    Get.put<ProfileRepositoryImpl>(
        ProfileRepositoryImpl(Get.find<ProfileRemoteDataSourceImpl>(),
            Get.find<ProfileLocalDataSourceImpl>()),
        permanent: true);
    Get.put<MasterRepositoryImpl>(
        MasterRepositoryImpl(Get.find<MasterRemoteDataSourceImpl>(),
            Get.find<MasterLocalDataSourceImpl>()),
        permanent: true);
    Get.put<FingerprintRepoImpl>(
        FingerprintRepoImpl(Get.find<DropOptRemoteDataSourceImpl>(),
            Get.find<DropOptLocalDataSourceImpl>()),
        permanent: true);
    Get.put<TemplateRepoImpl>(
        TemplateRepoImpl(Get.find<TemplateLocalDataSourceImpl>()),
        permanent: true);

    // --- Usecases (permanent) ---
    Get.put(GetAppVersionUseCase(Get.find<AboutRepoImpl>()));
    Get.put(DownloadLatestVerUseCase(Get.find<AboutRepoImpl>()));
    Get.put<GetMasterHeaderUseCase>(
        GetMasterHeaderUseCase(Get.find<DashboardRepoImpl>()),
        permanent: true);
    Get.put<GetIconMenuDashboardUsecase>(
        GetIconMenuDashboardUsecase(Get.find<DashboardRepoImpl>()),
        permanent: true);
    Get.put<LoginUseCase>(LoginUseCase(Get.find<AuthRepositoryImpl>()),
        permanent: true);
    Get.put<ProfileUseCase>(ProfileUseCase(Get.find<AuthRepositoryImpl>()),
        permanent: true);
    Get.put<OnLoginMasterData>(
        OnLoginMasterData(Get.find<AuthRepositoryImpl>()),
        permanent: true);

    // --- Controllers global yang memang perlu singletons ---
    Get.put<DashboardController>(
      DashboardController(
        Get.find<GetMasterHeaderUseCase>(),
        Get.find<GetIconMenuDashboardUsecase>(),
      ),
      permanent: true,
    );

    Get.put<LoginController>(
      LoginController(Get.find<LoginUseCase>(), Get.find<ProfileUseCase>(),
          Get.find<OnLoginMasterData>()),
      permanent: true,
    );

    Get.put<SettingController>(
      SettingController(storage: Get.find<StorageService>()),
      permanent: true,
    );

    // NOTE:
    // Page-level controllers (AboutController, BTController, etc.) should be registered in their own Bindings
    // so they are created/disposed together with the page lifecycle.
  }
}

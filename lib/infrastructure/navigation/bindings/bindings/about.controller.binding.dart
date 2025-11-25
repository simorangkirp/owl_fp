// lib/presentation/ui/about/about.binding.dart
import 'package:get/get.dart';
// import 'package:owl_fp_newer/domain/usecase/about/download.apk.uc.dart';
import 'package:owl_fp_newer/domain/usecase/about/get.apkver.uc.dart';
import 'package:owl_fp_newer/presentation/ui/about/controllers/about.controller.dart';

class AboutControllerBinding extends Bindings {
  @override
  void dependencies() {
    // Karena GetAppVersionUseCase dan AboutRepoImpl sudah didaftarkan global (permanent)
    // kita cukup mendaftarkan controller saja di binding page.
    Get.lazyPut<AboutController>(
        () => AboutController(
              Get.find<GetAppVersionUseCase>(),
              // Get.find<DownloadLatestVerUseCase>(),
            ),
        fenix: true);
    // fenix: true -> jika dihapus, dan kemudian dibutuhkan lagi, instance dapat dibuat ulang.
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/injection/dependency.injenction.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'presentation/theme/app.theme.dart';
import 'presentation/theme/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initialRoute = await Routes.initialRoute;
  log("Initialize Dependency Injection");
  await GetStorage.init(); // Init Get Storage
  log("Get Storage Initialized!");
  await DependecyInjection.init(); // Init Dependency Injection
  log("Dependency Injection Initialized!");
  log("Initialize Get Storage");
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  Main(this.initialRoute, {super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.theme,
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          getPages: Nav.routes,
          unknownRoute: GetPage(
            name: '/404',
            page: () => Scaffold(
              body: Center(
                child: Text(
                  "Halaman tidak ditemukan",
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
